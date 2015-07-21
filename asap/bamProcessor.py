#!/usr/bin/env python3
# encoding: utf-8
'''
asap.bamProcessor -- Process BAM alignment files with an AssayInfo JSON file and generate XML for the results

asap.bamProcessor 

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

import pysam
from collections import Counter
from xml.etree import ElementTree

import asap.dispatcher as dispatcher
import asap.assayInfo as assayInfo

__all__ = []
__version__ = 0.1
__date__ = '2015-07-16'
__updated__ = '2015-07-16'

DEBUG = 1
TESTRUN = 0
PROFILE = 0

def _write_parameters(node, data):
    for k, v in data.items():
        subnode = ElementTree.SubElement(node, k)
        subnode.text = v
    return node

def _process_pileup(pileup, amplicon):
    pileup_dict = {}
    snp_dict = _create_snp_dict(amplicon)
    consensus_seq = ""
    snp_list = []
    for pileupcolumn in pileup:
        #print("\ncoverage at base %s = %s" % (pileupcolumn.pos, pileupcolumn.n))
        position = pileupcolumn.pos+1
        base_counter = Counter()
        for pileupread in pileupcolumn.pileups:
            if pileupread.is_del:
                base_counter.update("-")
            else:
                base_counter.update(pileupread.alignment.query_sequence[pileupread.query_position])
#                    print ('\tbase in read %s = %s' % (pileupread.alignment.query_name, pileupread.alignment.query_sequence[pileupread.query_position]))
        #print(base_counter)
        alignment_call = base_counter.most_common(1)[0][0]
        #reference_call = chr(reference[pileupcolumn.pos])
        reference_call = amplicon.sequence[pileupcolumn.pos]
        consensus_seq += alignment_call
        if position in snp_dict:
            snp = {'type':'position of interest', 'position':str(position), 'depth':str(pileupcolumn.n), 'reference':reference_call, 'variant':snp_dict[position][1], 'basecalls':base_counter}
            snp_list.append(snp)
            #print("Found position of interest %d, reference: %s, distribution:%s" % (position, snp_dict[position][0], base_counter))
        elif alignment_call != reference_call:
            snp = {'type':'unknown', 'position':str(position), 'depth':str(pileupcolumn.n), 'reference':reference_call, 'variant':alignment_call, 'basecalls':base_counter}
            snp_list.append(snp)
            #print("SNP found at position %d: %s->%s" % (position, reference_call, alignment_call))
    
    pileup_dict['consensus_sequence'] = consensus_seq
    pileup_dict['SNPs'] = snp_list
    return pileup_dict 

def _write_xml(root, xml_file):
    from xml.dom import minidom
#    dom = minidom.parseString(str(ElementTree.tostring(root, 'utf-8')))
    output = open(xml_file, 'w')
#    output.write(dom.toprettyxml(indent="    "))
    print(str(ElementTree.tostring(root, 'utf-8')))
    output.close()
    return xml_file

def _create_snp_dict(amplicon):
    snp_dict = {}
    for snp in amplicon.SNPs:
        snp_dict[snp.position] = (snp.reference, snp.variant)
    return snp_dict

def _add_snp_node(parent, snp):
    snp_attributes = {k:snp[k] for k in ('type', 'position', 'depth', 'reference')}
    snp_node = ElementTree.SubElement(parent, 'snp', snp_attributes)
    base_counter = snp['basecalls']
    snpcall = snp['variant']
    depth = int(snp['depth'])
    snpcount = base_counter[snpcall]
    snpcall_node = ElementTree.SubElement(snp_node, 'snp_call', {'count':str(snpcount), 'percent':str(snpcount/depth*100)})
    snpcall_node.text = snpcall
    dist_node = ElementTree.SubElement(snp_node, 'base_distribution', {k:str(v) for k,v in base_counter.items()})
    #print(ElementTree.tostring(snp_node))
    return snp_node

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

USAGE
''' % (program_shortdesc, str(__date__))

    try:
        # Setup argument parser
        parser = argparse.ArgumentParser(description=program_license, formatter_class=argparse.RawDescriptionHelpFormatter)
        required_group = parser.add_argument_group("required arguments")
        required_group.add_argument("-j", "--json", metavar="FILE", required=True, help="JSON file of assay descriptions. [REQUIRED]")
        required_group.add_argument("-b", "--bam", metavar="FILE", required=True, help="BAM file to analyze. [REQUIRED]")
        #required_group.add_argument("-r", "--ref", metavar="FILE", required=True, help="reference fasta file, should already be indexed. [REQUIRED]")
        #parser.add_argument("-o", "--out-dir", dest="odir", metavar="DIR", help="directory to write output files to. [default: `pwd`]")
        required_group.add_argument("-o", "--out", metavar="FILE", required=True, help="XML file to write output to. [REQUIRED]")
        #parser.add_argument("-n", "--name", help="sample name, if not provided it will be derived from BAM file")
        parser.add_argument("-V", "--version", action="version", version=program_version_message)
     
        # Process arguments
        args = parser.parse_args()

        json_fp = args.json
        bam_fp = args.bam
        out_fp = args.out
        #ref_fp = args.ref
        #out_dir = args.odir
        #if not out_dir:
        #    out_dir = os.getcwd()
       
        #out_dir = dispatcher.expandPath(out_dir)
        #if not os.path.exists(out_dir):
        #    os.makedirs(out_dir)

        assay_list = assayInfo.parseJSON(json_fp)
        samdata = pysam.AlignmentFile(bam_fp, "rb")
        #reference = pysam.FastaFile(ref_fp)
        
        sample_dict = {}
        sample_dict['name'] = samdata.header['RG'][0]['ID']
        sample_dict['mapped_reads'] = str(samdata.mapped)
        sample_dict['unmapped_reads'] = str(samdata.unmapped)
        sample_node = ElementTree.Element("sample", sample_dict)

        #out_fp = os.path.join(out_dir, sample_dict['name']+".xml")
        
        for assay in assay_list:
            assay_dict = {}
            assay_dict['name'] = assay.name
            assay_dict['type'] = assay.assay_type
            assay_node = ElementTree.SubElement(sample_node, "assay", assay_dict)
            ref_name = assay.name
            for amplicon in assay.target.amplicons:
                ref_name = ref_name + "_%s" % amplicon.variant_name if amplicon.variant_name else ref_name
                amplicon_dict = {}
                amplicon_dict['reads'] = str(samdata.count(ref_name))
                amplicon_node = ElementTree.SubElement(assay_node, "amplicon", amplicon_dict)
                pileup = samdata.pileup(ref_name)
                #ref = reference.fetch(ref_name)
                amplicon_data = _process_pileup(pileup, amplicon)
                for snp in amplicon_data['SNPs']:
                    _add_snp_node(amplicon_node, snp)
                    # This would be helpful, but count_coverage is broken in python3
                    #print(samdata.count_coverage(ref_name, snp.position-1, snp.position))
                del amplicon_data['SNPs']
                _write_parameters(amplicon_node, amplicon_data)
        
#        samdata.count_coverage("eis", 1100, 1101)

        samdata.close()
        _write_xml(sample_node, out_fp)

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
