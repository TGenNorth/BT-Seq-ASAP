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
import argparse
import asap.dispatcher as dispatcher

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
        parser.add_argument("-n", "--name", action="store", required=True, help="name for this run. [REQUIRED]")
        parser.add_argument("-j", "--json", action="store", required=True, type=argparse.FileType('r'), help="JSON file of assay descriptions. [REQUIRED]")
        parser.add_argument("-d", "--dir", action="store", default=".", help="directory of read files to analyze. [default: `pwd`]")
        trim_group = parser.add_mutually_exclusive_group()
        trim_group.add_argument("--trim", action="store_true", default=True, help="perform adapter trimming on reads. [default]")
        trim_group.add_argument("--no-trim", dest="trim", action="store_false", help="do not perform adapter trimming.")
        parser.add_argument('-V', '--version', action='version', version=program_version_message)
     
        # Process arguments
        args = parser.parse_args()

        run_name = args.name
        json_fp = args.json
        read_dir = args.dir
        trim = args.trim
        
        print("Combining reads in %s and JSON file: %s for run: %s. Trim=%s" % (read_dir, json_fp, run_name, trim))
        
        read_list = dispatcher.find_reads(read_dir)
        if trim:
            for read in read_list:
                dispatcher.trim_adapters(*read)
                    

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