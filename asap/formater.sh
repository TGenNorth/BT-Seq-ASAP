#!/bin/sh

#$1 name of .xml from asap


export PYTHONHASHSEED=1

formatOutputName=$(echo "$1" | sed 's/_analysis.xml/.html/g')

reformatedName=$(echo "$1" | sed 's/.xml/_Reformated.xml/g')

reReformatedName=$(echo $reformatedName | sed 's/.xml/_2.xml/g')

formatOutput -s $2  -x $1 -o ./$formatOutputName 
reformatXML -x $1

assay_specific_alleles -x $reformatedName -o $reReformatedName

formatOutput -s $3 -x $reReformatedName



