#!/bin/sh

#$1 name of .xml from asap
#$2 path to first output transform
#$3 path to second output transform

export PYTHONHASHSEED=1

formatOutputName=$(echo "$1" | sed 's/_analysis.xml/.html/g')

reformatedName=$(echo "$1" | sed 's/.xml/_Reformated.xml/g')

reReformatedName=$(echo $reformatedName | sed 's/.xml/_2.xml/g')

formatOutput -s $2  -x $1 -o ./$formatOutputName 

echo "first output transform done"

reformatXML -x $1

echo "reformatting done"

assay_specific_alleles -x $reformatedName -o $reReformatedName

echo "re-reformatting done"

formatOutput -s $3 -x $reReformatedName

echo "done"

