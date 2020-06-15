.. |copy|   unicode:: U+000A9 .. COPYRIGHT SIGN

Amplicon Sequencing Analysis Pipeline (ASAP) for BT-Seq
=======================================================

OVERVIEW:
---------
This is a customized version of the Amplicon Sequencing Analysis Pipeline (ASAP) for the BT-Seq project. ASAP is a highly customizable, automated way to examine amplicon sequencing data. For the full version, see https://github.com/TGenNorth/ASAP.

INSTALLATION:
-------------


USAGE:
------
BT-Seq-ASAP is run in two steps. The first step is analyzing the sequencing data, and the second step is generating reports to see the results.

**1) Running the Analysis**

``analyzeAmplicons -n <RUN_NAME> -j <ASAP_INSTALL_PATH>/assay_data/BT-Seq_all_assays.json -r <DIRECTORY_OF_READ_FILES> -o <OUTPUT_DIRECTORY> <other options>``

``<RUN_NAME>`` can be whatever you want, the final output file will be: ``<OUTPUT_DIRECTORY>/<RUN_NAME>_analysis.xml``

This final output file is gets passed into the next command.

For more information about the analyzeAmplicons command, see the full `ASAP documentation <ABOUT.rst>`_.

**2) Formatting Output**

``formatOutput -s <ASAP_INSTALL_PATH>/output_transforms/BT-Seq_HeatMap.xsl -x <XML_OUTPUT_FILE> -o <MAIN_OUTPUT_HTML_FILE>``

This will generate all the html files for the overview report, which you can open directly in your web browser. Every file will be linked from ``<MAIN_OUTPUT_HTML_FILE>``. ``<XML_OUTPUT_FILE>`` is the final output of step 1.

If there are any positives that you want to explore in more depth, you can rerun the ``formatOutput`` command with one of the target-specific transforms as the ``-s`` argument, and specify a different ``<MAIN_OUTPUT_HTML_FILE>`` so it doesn't overwrite the previous one.

``<ASAP_INSTALL_PATH>/output_transforms/BT-Seq_Ba_results.xsl`` for *Bacillus antracis* results
``<ASAP_INSTALL_PATH>/output_transforms/BT-Seq_Bp_results.xsl`` for *Burkholderia pseudomallei* and *mallei* results
``<ASAP_INSTALL_PATH>/output_transforms/BT-Seq_Ft_results.xsl`` for *Francisella tularensis* results
``<ASAP_INSTALL_PATH>/output_transforms/BT-Seq_Yp_results.xsl`` for *Yersinia pestis* results


LICENSE:
--------

Copyright |copy| The Translational Genomics Research Institute See the
included "LICENSE" document.
