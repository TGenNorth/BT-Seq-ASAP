#!/usr/bin/env python3
# encoding: utf-8
'''
asap.analyzeAmplicons -- Align and interpret amplicon sequencing reads

asap.analyzeAmplicons

@author:     Darrin Lemmer

@copyright:  2015,2019 TGen North. All rights reserved.

@license:    ACADEMIC AND RESEARCH LICENSE -- see ../LICENSE

@contact:    dlemmer@tgen.org
'''

import sys
import os
import re
import argparse
import logging
import skbio
import pkg_resources

from asap import dispatcher
from asap import bamProcessor
from asap import assayInfo
from asap import __version__
__all__ = []
__date__ = '2015-06-04'
__updated__ = '2019-01-15'


DEBUG = 1
TESTRUN = 0
PROFILE = 0

class CLIError(Exception):
    '''Generic exception to raise and log different fatal errors.'''
    def __init__(self, msg):
        super(CLIError).__init__(type(self))
        self.msg = "E: %s" % msg
    def __str__(self):
        return self.msg
    def __unicode__(self):
        return self.msg

def main(argv=None): # IGNORE:C0111
    '''Command line options.'''

    if argv is None:
        argv = sys.argv
    else:
        sys.argv.extend(argv)

    program_name = os.path.basename(sys.argv[0])
    program_version = "v%s" % __version__
    program_build_date = str(__updated__)
    program_version_message = '%%(prog)s %s (%s)' % (program_version, program_build_date)
    if __name__ == '__main__':
        program_shortdesc = __import__('__main__').__doc__.split("\n")[1]
    else:
        program_shortdesc = __doc__.split("\n")[1]
    #program_shortdesc = __import__('__main__').__doc__.split("\n")[1]
    program_license = '''%s

  Created by TGen North on %s.
  Copyright 2015 TGen North. All rights reserved.

  Available for academic and research use only under a license
  from The Translational Genomics Research Institute (TGen)
  that is free for non-commercial use.

  Distributed on an "AS IS" basis without warranties
  or conditions of any kind, either express or implied.

  ***You are running the most current development version,
  use at your own risk***

USAGE
''' % (program_shortdesc, str(__date__))

    try:
        # Setup argument parser
        parser = argparse.ArgumentParser(description=program_license, formatter_class=argparse.RawDescriptionHelpFormatter)
        required_group = parser.add_argument_group("required arguments")
        required_group.add_argument("-n", "--name", required=True, help="name for this run. [REQUIRED]")
        required_group.add_argument("-j", "--json", metavar="FILE", required=True, type=argparse.FileType('r'), help="JSON file of assay descriptions. [REQUIRED]")
        reads_bams_group = required_group.add_mutually_exclusive_group(required=True)
        reads_bams_group.add_argument("-r", "--read-dir", dest="rdir", metavar="DIR", help="directory of read files to analyze.")
        reads_bams_group.add_argument("--bam-dir", dest="bdir", metavar="DIR", help="directory of bam files to analyze.")
        optional_group = parser.add_argument_group("optional arguments")
        optional_group.add_argument("-o", "--out-dir", dest="odir", metavar="DIR", help="directory to write output files to. [default: `pwd`]")
        optional_group.add_argument("-s", "--submitter", dest="job_manager", default="SLURM", help="cluster job submitter to use (PBS, SLURM, SGE, none). [default: SLURM]")
        optional_group.add_argument("--submitter-args", dest="sargs", metavar="ARGS", help="additional arguments to pass to the job submitter, enclosed in \"\".")
        optional_group.add_argument("--smor", action="store_true", default=False, help="perform SMOR analysis with overlapping reads. [default: False]")
        optional_group.add_argument("-w", "--whole-genome", action="store_true", dest="wholegenome", default=False, help="JSON file uses a whole genome reference, so don't write out the consensus, depth, and proportion arrays for each sample")
        optional_group.add_argument("--allele-output-threshold", dest="allele_min_reads", default=8, type=int, help="cutoff of # of reads below which allels for amino acids and nucleotide alleles will not be output [default: 8]")
        optional_group.add_argument("--remove-dups", action="store_true", dest="remove_dups", default=False, help="remove duplicate reads (ony makes sense for WGS or WMTS data. [default: False]")
        trim_group = parser.add_argument_group("read trimming options")
        on_off_group = trim_group.add_mutually_exclusive_group()
        on_off_group.add_argument("--trim", default="bbduk", help="perform adapter trimming on reads. [default: bbduk]. NOTE: cannot trim-primers if not using bbduk")
        on_off_group.add_argument("--no-trim", dest="trim", action="store_false", help="do not perform adapter trimming.")
        trim_group.add_argument("--adapter-sequences", dest="adapters",default=pkg_resources.resource_filename(__name__,'illumina_adapters_all.fasta'),help="location of the adapter sequence file to use for trimming. [default: <ASAP install dir>/asap/illumina_adapters_all.fasta]")
        trim_group.add_argument("--trim-primers", dest="primers", default=False, help="location of primer file to use for primer trimming. NOTE: Not possible if not using bbduk")
        trim_group.add_argument("-q", "--qual", nargs="?", const="SLIDINGWINDOW:5:20", help="perform quality trimming [default: False], optional parameter can be used to customize quality trimming parameters to trimmomatic. [default: SLIDINGWINDOW:5:20]")
        trim_group.add_argument("-l", "--minlen", metavar="LEN", default=80, type=int, help="minimum read length to keep after trimming. [default: 80]")
        align_group = parser.add_argument_group("read mapping options")
        align_group.add_argument("-a", "--aligner", default="bowtie2", help="aligner to use for read mapping, supports bowtie2, novoalign, and bwa. [default: bowtie2]")
        align_group.add_argument("--aligner-args", dest="aargs", metavar="ARGS", default='', help="additional arguments to pass to the aligner, enclosed in \"\".")
        align_group.add_argument("-d", "--depth", default=100, type=int, help="minimum read depth required to consider a position covered. [default: 100]")
        align_group.add_argument("-b", "--breadth", default=0.8, type=float, help="minimum breadth of coverage required to consider an amplicon as present. [default: 0.8]")
        align_group.add_argument("-p", "--proportion", type=float, help="minimum proportion required to call a mutation at a given locus. [default: 0.1]") #Don't explicitly set default because I need to be certain whether user set the value
        align_group.add_argument("-m", "--mutation-depth", dest="mutdepth", default=5, type=int, help="minimum number of reads required to call a mutation at a given locus. [default: 5]")
        align_group.add_argument("-i", "--identity", dest="percid", default=0, type=float, help="minimum percent identity required to align a read to a reference amplicon sequence. [default: 0]")
        parser.add_argument("-V", "--version", action="version", version=program_version_message)
        parser.add_argument("-D", "--debug", action="store_true", default=False, help="turn on debugging mode")
        # Process arguments
        args = parser.parse_args()

        run_name = args.name
        json_filename = dispatcher.expandPath(args.json.name)
        read_dir = args.rdir
        bam_dir = args.bdir
        out_dir = args.odir
        trim = args.trim
        if args.primers == False:
            primer_seqs = args.primers
        else:
            primer_seqs = dispatcher.expandPath(args.primers)
        qual = args.qual
        minlen = args.minlen
        aligner = args.aligner
        aligner_args = args.aargs
        depth = args.depth
        breadth = args.breadth
        proportion = args.proportion
        percid = args.percid
        mutdepth = args.mutdepth
        adapters = dispatcher.expandPath(args.adapters)
        dispatcher.job_manager = args.job_manager.upper()
        dispatcher.job_manager_args = args.sargs
        smor = args.smor
        allele_min_reads = args.allele_min_reads
        debug = args.debug
        wholegenome = args.wholegenome
        remove_dups = args.remove_dups

        if smor:
            if proportion:
                bamProcessor.smartSMOR = False #Turn off smartSMOR if user explicitely sets proportion flag
            else:
                proportion = 0.001 #Set SMOR default
        else:
            proportion = proportion or 0.1 #Set default if user did not specify

        if primer_seqs != False and trim != "bbduk":
            response = input(
                "\nPrimer trimming requested using a trimmer other than bbduk, this is not supported functionality.\nContinue using %s as a trimmer without primer trimming [N]? " % trim)
            if not re.match('^[Yy]',response):
                print("Operation cancelled!")
                quit()

        if not out_dir:
            out_dir = os.getcwd()
        if not (read_dir or bam_dir):
            read_dir = os.getcwd()

        out_dir = dispatcher.expandPath(out_dir)
        if read_dir:
            read_dir = dispatcher.expandPath(read_dir)
        if bam_dir:
            bam_dir = dispatcher.expandPath(bam_dir)

        if os.path.exists(out_dir):
            response = input(
                "\nOutput folder %s already exists!\nFiles in it may be overwritten!\nShould we continue anyway [N]? " % out_dir)
            if not re.match('^[Yy]', response):
                print("Operation cancelled!")
                quit()
        else:
            os.makedirs(out_dir)

        logfile = os.path.join(out_dir, "asap.log")
        logging.basicConfig(level=logging.DEBUG,
                            format='%(asctime)s %(levelname)-8s %(message)s',
                            datefmt='%m/%d/%Y %H:%M:%S',
                            filename=logfile,
                            filemode='w')

        logging.info("Combining reads in %s and JSON file: %s for run: %s. Trim=%s Qual=%s" % (read_dir, json_filename, run_name, trim, qual))
        assay_list = assayInfo.parseJSON(args.json)

        bam_list = []
        output_files = []
        final_jobs = []
        xml_dir = os.path.join(out_dir, "xml")
        if not os.path.exists(xml_dir):
            os.makedirs(xml_dir)

        if bam_dir:
            bam_list = dispatcher.findBams(bam_dir)

        if read_dir:
            #reference = assayInfo.generateReference(assay_list)
            ref_fasta = os.path.join(out_dir, "reference.fasta")
            skbio.io.registry.write(assayInfo.generateReference(assay_list), 'fasta', ref_fasta)

            index_job = dispatcher.indexFasta(ref_fasta, aligner)
            read_list = dispatcher.findReads(read_dir)
            for read in read_list:
                if (not read.reads):
                    #TODO: write out appropriate xml for samples with empty read files so they show up in results
                    continue
                if trim != False: #if trimming has not been turned off by --no-trim
                    trimmed_reads = dispatcher.trimAdapters(*read, outdir=out_dir, adapters=adapters, quality=qual, minlen=minlen, dependency=index_job, trimmer=trim, primers=primer_seqs)
                    (bam_file, job_id) = dispatcher.alignReadsToReference(trimmed_reads.sample, trimmed_reads.reads, ref_fasta, out_dir, jobid=trimmed_reads.jobid, aligner=aligner, args=aligner_args, remove_dups=remove_dups)
                else: #if trimming has been turned off go straight to aligning
                    (bam_file, job_id) = dispatcher.alignReadsToReference(read.sample, read.reads, ref_fasta, out_dir, jobid=index_job, aligner=aligner, args=aligner_args, remove_dups=remove_dups)
                bam_list.append((read.sample, bam_file, job_id))
            if trim == "bbduk":
                f = open(out_dir+"/trimmed/STATS/info.txt", "w+")
                f.write("If run with paired reads the stats information for each pair is in [read_pair_name]*R1*STATS, if run with single reads the stats information for the single read is in [read_name]*R1*STATS. _primers if is the stats for trimming primers, no _primers if stats for trimming adapters")
                f.close()
        for sample, bam, job in bam_list:
            (xml_file, job_id) = dispatcher.processBam(sample, json_filename, bam, xml_dir, job, depth, breadth, proportion, percid, mutdepth, smor, wholegenome, debug, allele_min_reads)
            output_files.append(xml_file)
            final_jobs.append(job_id)

        (final_output, job) = dispatcher.combineOutputFiles(run_name, xml_dir, out_dir, final_jobs)
        print("All jobs are submitted, the final job id is: %s. Output will be in %s when ready." % (job, final_output))

        return 0
    except KeyboardInterrupt:
        ### handle keyboard interrupt ###
        return 0
    except Exception as e:
        if DEBUG or TESTRUN:
            raise(e)
        indent = len(program_name) * " "
        sys.stderr.write(program_name + ": " + repr(e) + "\n")
        sys.stderr.write(indent + "  for help use --help")
        return 2

if __name__ == "__main__":
    if DEBUG:
        pass
    if TESTRUN:
        import doctest
        doctest.testmod()
    if PROFILE:
        import cProfile
        import pstats
        profile_filename = 'asap.analyzeAmplicons_profile.txt'
        cProfile.run('main()', profile_filename)
        statsfile = open("profile_stats.txt", "wb")
        p = pstats.Stats(profile_filename, stream=statsfile)
        stats = p.strip_dirs().sort_stats('cumulative')
        stats.print_stats()
        statsfile.close()
        sys.exit(0)
    sys.exit(main())
