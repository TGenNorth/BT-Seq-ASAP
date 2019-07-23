#!/usr/bin/env python3
# encoding: utf-8



from lxml import etree as ET
import copy
import sys
import os
import argparse
from collections import defaultdict

def main(argv=None):
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("-x", "--xml", required=True, help="Already reformatted ASAP output XML file. [REQUIRED]")
    parser.add_argument("-o","--output", required=True, help="file to write new XML to. [REQUIRED]")
    args = parser.parse_args()
    out_file = args.output

    tree = ET.parse(args.xml)
    root = tree.getroot()
    
    #get the sequences, counts, and sample counts for each assay for assay-specific output
    all_dicts = defaultdict(defaultdict)
    for assay in root:
        if assay.get('type') == 'mixed':
            currentAssayDict = defaultdict(list)
            for sample in assay:
                for allele in sample.iter('allele_sequence'):
                    if currentAssayDict[allele.text] == []:
                        li = [0, 0]
                        li[0] += int(allele.get('count'))
                        li[1] += 1
                        li.append([sample.get('name'), allele.get('count'), allele.get('percent')]) 
                        currentAssayDict[allele.text] = li
                    else:
                        lis = currentAssayDict[allele.text]
                        lis[0] += int(allele.get('count'))
                        lis[1] += 1
                        lis.append([sample.get('name'), allele.get('count'), allele.get('percent')])
                        currentAssayDict[allele.text] = lis
            all_dicts[assay.get('name')] = currentAssayDict

    #write out this info to xml tree
    assay_counts_node = ET.SubElement(root, 'assay_counts')
    for dict in all_dicts.items():
        assay_node = ET.SubElement(assay_counts_node, 'assay')
        assay_node.set('name', dict[0])
        for allele in dict[1]:
            allele_node = ET.SubElement(assay_node, 'allele')
            allele_node.set('sequence',allele)
            allele_node.set('read_count', str(dict[1][allele][0]))
            allele_node.set('sample_count', str(dict[1][allele][1]))
            allele_node.set('hash', str(hash(allele)))
    

    #create a portion of xml for each allele's info
    for dict in all_dicts.items():
        for allele in dict[1]:
            allele_node = ET.SubElement(root, "allele_occurences")
            allele_node.set('sequence', allele)
            allele_node.set('hash', str(hash(allele)))
            for li in range(2, len(dict[1][allele])):
                sample_node = ET.SubElement(allele_node, "sample")
                sample_node.set('name', dict[1][allele][li][0])
                sample_node.set('count', dict[1][allele][li][1])
                sample_node.set('percent', dict[1][allele][li][2])
               
    tree.write(out_file, pretty_print=True)
if __name__ == "__main__":
    main()
