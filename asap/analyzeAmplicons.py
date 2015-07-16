#!/usr/bin/env python3
# encoding: utf-8
'''
asap.analyzeAmplicons -- Align and interpret amplicon sequencing reads

asap.analyzeAmplicons 

@author:     Darrin Lemmer

@copyright:  2015 TGen North. All rights reserved.

@license:    ACADEMIC AND RESEARCH LICENSE -- see ../LICENSE

@contact:    dlemmer@tgen.org
'''

import sys
import os
import re
import argparse
import logging

import asap.dispatcher as dispatcher
import asap.assayInfo as assayInfo

__all__ = []
__version__ = 0.1
__date__ = '2015-06-04'
__updated__ = '2015-06-04'

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
    program_shortdesc = __import__('__main__').__doc__.split("\n")[1]
    program_license = '''%s

  Created by TGen North on %s.
  Copyright 2015 TGen North. All rights reserved.

  Available for academic and research use only under a license
  from The Translational Genomics Research Institute (TGen)
  that is free for non-commercial use.

  Distributed on an "AS IS" basis without warranties
  or conditions of any kind, either express or implied.

USAGE
''' % (program_shortdesc, str(__date__))

    try:
        # Setup argument parser
        parser = argparse.ArgumentParser(description=program_license, formatter_class=argparse.RawDescriptionHelpFormatter)
        required_group = parser.add_argument_group("required arguments")
        required_group.add_argument("-n", "--name", required=True, help="name for this run. [REQUIRED]")
        required_group.add_argument("-j", "--json", required=True, help="JSON file of assay descriptions. [REQUIRED]")
        optional_group = parser.add_argument_group("optional arguments")
        optional_group.add_argument("-r", "--read-dir", dest="rdir", metavar="DIR", help="directory of read files to analyze. [default: `pwd`]")
        optional_group.add_argument("-o", "--out-dir", dest="wdir", metavar="DIR", help="directory to write output files to. [default: `pwd`]")
        trim_group = parser.add_argument_group("read trimming options")
        on_off_group = trim_group.add_mutually_exclusive_group()
        on_off_group.add_argument("--trim", action="store_true", default=True, help="perform adapter trimming on reads. [default: True]")
        on_off_group.add_argument("--no-trim", dest="trim", action="store_false", help="do not perform adapter trimming.")
        trim_group.add_argument("-q", "--qual", nargs="?", const="SLIDINGWINDOW:5:20", help="perform quality trimming [default: False], optional parameter can be used to customize quality trimming parameters to trimmomatic. [default: SLIDINGWINDOW:5:20]")
        trim_group.add_argument("-m", "--minlen", nargs=1, metavar="LEN", default=80, type=int, help="minimum read length to keep after trimming. [default: 80]")
        align_group = parser.add_argument_group("read mapping options")
        align_group.add_argument("-a", "--aligner", nargs=1, default="bwa", help="aligner to use for read mapping. [default: bwa (mem)]")
        align_group.add_argument("--aligner-args", dest="aargs", metavar="ARGS", nargs=1, help="additional arguments to pass to the aligner, enclosed in \"\".")
        parser.add_argument("-V", "--version", action="version", version=program_version_message)
     
        # Process arguments
        args = parser.parse_args()

        run_name = args.name
        json_fp = args.json
        read_dir = args.rdir
        out_dir = args.wdir
        trim = args.trim
        qual = args.qual
        minlen = args.minlen
        aligner = args.aligner
        aligner_args = args.aargs
        
        if not read_dir:
            read_dir = os.getcwd()
        if not out_dir:
            out_dir = os.getcwd()
        
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
        
        logging.info("Combining reads in %s and JSON file: %s for run: %s. Trim=%s Qual=%s" % (read_dir, json_fp, run_name, trim, qual))
        
        assay_list = assayInfo.parseJSON(json_fp)
        
        reference = assayInfo.generateReference(assay_list)
        ref_fasta = os.path.join(out_dir, "reference.fasta")
        reference.write(ref_fasta, 'fasta')          
        
        read_list = dispatcher.findReads(read_dir)
        #trimmed_reads = []
        if trim:
            for read in read_list:
                trimmed_reads = dispatcher.trimAdapters(*read, quality=qual, minlen=minlen)
                dispatcher.alignReadsToReference(trimmed_reads.sample, trimmed_reads.reads, ref_fasta, out_dir, jobid=trimmed_reads.jobid, aligner=aligner, args=aligner_args)
        else:            
            dispatcher.alignReadsToReference(read_list.sample, read_list.reads, ref_fasta, out_dir, aligner=aligner, args=aligner_args)        
                

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