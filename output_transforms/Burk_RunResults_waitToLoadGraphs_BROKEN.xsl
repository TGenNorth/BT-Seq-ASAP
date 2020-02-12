<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:asap="http://pathogen.tgen.org/ASAP/functions" xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/strings" extension-element-prefixes="exsl str">
    <xsl:import href="http://exslt.org/str/functions/replace/str.replace.function.xsl"/>
    <xsl:output method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>

<!-- Burk Run Summary -->
    <xsl:template match="/analysis">
        <html>
        <head>
            <title>ASAP Run Summary for: <xsl:value-of select="@run_name"/></title>
            <style type="text/css">
                .table-header-rotated {
                  border-collapse: collapse;
                }
                .table-header-rotated td.rotate {
                  width: 45px;
                }
                .table-header-rotated td.norotate {
                  text-align: left;
                  white-space: nowrap;
                }
                .table-header-rotated th.norotate {
                  padding: 10px 40px;
                  vertical-align: bottom;
                }
                .table-header-rotated td {
                  text-align: center;
                  padding: 10px 5px;
                  border: 2px solid #aaa;
                }
                .table-header-rotated th.rotate {
                  height: 140px;
                  white-space: nowrap;
                }
                .table-header-rotated th.rotate <xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text> div {
                  -webkit-transform: translate(40px, 51px) rotate(315deg);
                      -ms-transform: translate(40px, 51px) rotate(315deg);
                          transform: translate(40px, 51px) rotate(315deg);
                  width: 30px;
                }
                .table-header-rotated th.rotate <xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text> div <xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text> span {
                  border-bottom: 2px solid #aaa;
                  padding: 5px 10px;
                }
                .table-header-rotated th.row-header {
                  padding: 0 10px;
                  border-bottom: 2px solid #aaa;
                }
                .table-column-locked {
                  border-collapse:separate;
                  border-top: 1px solid black;
                  border-spacing: 0px;
                }
                .div-table-column-locked {
                  overflow-x: scroll;
                  margin-left: 30em;
                  overflow-y: visible;
                  padding-bottom: 1px;
                }
                .table-column-locked td, .table-column-locked th {
                  margin: 0;
                  border: 1px solid black;
                  border-top-width: 0px;
                  white-space: nowrap;
                }
                .table-column-locked th.headcol {
                  position: absolute;
                  width: 29em;
                  left: 20px;
                  top: auto;
                  border-right: 2px solid black;
                  border-top-width: 1px;
                  margin-top: -1px;
                }            
                .table-column-locked th.headcol2 {
                  position: absolute;
                  width: 29em;
                  left: 20px;
                  top: auto;
                  border-right: 2px solid black;
                  border-top-width: 1px;
                  margin-top: -1px;
                  padding-bottom: 37px;
                }            
            </style>
        </head>
        <body>
            <center><h1>ASAP Run Summary for: <xsl:value-of select="@run_name"/></h1></center>
            <br />
            <br />
                <div class="div-table-column-locked"><table class="table-column-locked">
                <tr>
                <th class="headcol">Sample</th>
                <xsl:for-each select="sample[1]/assay">
                    <xsl:variable name="current_assay" select="./@name"/>
                    <xsl:choose>
                        <xsl:when test="@type = 'SNP'">
                        <xsl:for-each select="asap:distinct-values(//assay[@name=current()/@name]//amplicon//snp/@name[. != 'unknown' and . != 'position of interest'])">
                            <th nowrap="true"><xsl:value-of select="$current_assay"/>--<xsl:value-of select="."/></th>
                        </xsl:for-each>
                        <xsl:if test="not(//assay[@name=$current_assay]//amplicon//snp)"><!-- assay not present --><th nowrap="true"><xsl:value-of select="$current_assay"/></th></xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <th nowrap="true">
                                <xsl:value-of select="@name"/>
                            </th>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                </tr>
                <xsl:for-each select="sample">
                    <xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
                    <th class="headcol2"><a href="{/analysis/@run_name}/{./@name}.html"><xsl:value-of select="@name"/></a></th>
                    <xsl:for-each select="assay">
                    <xsl:choose>
                        <xsl:when test="@type = 'SNP'">
                            <xsl:choose>
                            <xsl:when test="amplicon//snp[not(@name='unknown')]">
                            <xsl:for-each select="amplicon//snp[not(@name='unknown')]">
                                <xsl:choose>
                                <xsl:when test="./significance/@flag"><td nowrap="true"><em><xsl:value-of select=".//significance/@flag"/></em></td></xsl:when>
                                <xsl:otherwise>
                                <td nowrap="true">
                                <xsl:value-of select="snp_call/@count"/>/<xsl:value-of select="@depth"/>(<xsl:value-of select='format-number(snp_call/@percent, "##.##")'/>%)
                                </td>
                                </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                            <xsl:variable name="flag_message" select=".//significance/@flag"/>
                            <xsl:for-each select="asap:distinct-values(//assay[@name=current()/@name]//amplicon//snp/@name[. != 'unknown' and . != 'position of interest'])">
                                <td nowrap="true"><em><xsl:value-of select="$flag_message"/></em></td>
                            </xsl:for-each>
                            </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="@type = 'presence/absence'">
                            <xsl:choose>
                            <xsl:when test=".//significance/@flag"><td nowrap="true"><em><xsl:value-of select=".//significance/@flag"/></em></td></xsl:when>
                            <xsl:otherwise><td nowrap="true"><xsl:value-of select="amplicon/@reads"/></td></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="@type = 'gene variant'">
                            <td nowrap="true">
                            <xsl:for-each select="amplicon">
                                <xsl:value-of select="@variant"/>: <xsl:value-of select="@reads"/><br/>
                            </xsl:for-each>
                            </td>
                        </xsl:when>
                        <xsl:otherwise><td><xsl:value-of select="@name"/></td></xsl:otherwise>
                    </xsl:choose>
                    </xsl:for-each>
                    <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                </xsl:for-each>
            </table></div>
            <br />
            <br />
        </body>
        </html>
    </xsl:template>

    <xsl:template match="sample">
        <exsl:document method="html" href="{/analysis/@run_name}/{@name}.html">
            <html>
            <head>
                <title>ASAP Results for Sample: <xsl:value-of select="@name"/></title>
            <xsl:text disable-output-escaping="yes"><![CDATA[<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.0/Chart.min.js"></script>]]></xsl:text>
                <style>
                    .ampGraph {
                        position: fixed;
                        top: 0;
                        right: 0;
                        bottom: 0;
                        left: 0;
                        background: rgba(80,80,80,0.8);
                        z-index: 99999;
                        opacity: 0;
                        -webkit-transition: opacity 400ms ease-in;
                        -moz-transition: opacity 400ms ease-in;
                        transition: opacity 400ms ease-in;
                        pointer-events: none;
                    }
                    .ampGraph:target {
                        opacity:1;
                        pointer-events: auto;
                }
                .ampGraph <xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text> div {
                    width: 95vw;
                    height: 60vh;
                    position: relative;
                    margin: 10% auto;
                    padding: 5px 20px 13px 20px;
                    border-radius: 10px;
                    background: #fff;
                    background: -moz-linear-gradient(#fff, #999);
                    background: -webkit-linear-gradient(#fff, #999);
                    background: -o-linear-gradient(#fff, #999);
                    }
                .close {
                    background: #606061;
                    color: #FFFFFF;
                    line-height: 25px;
                    position: absolute;
                    right: -12px;
                    text-align: center;
                    top: -10px;
                    width: 24px;
                    text-decoration: none;
                    font-weight: bold;
                    -webkit-border-radius: 12px;
                    -moz-border-radius: 12px;
                    border-radius: 12px;
                    -moz-box-shadow: 1px 1px 3px #000;
                    -webkit-box-shadow: 1px 1px 3px #000;
                    box-shadow: 1px 1px 3px #000;
                }
                .close:hover { background: #00d9ff; }
                .ampCanvas {
                    overflow-x: auto;
                }
                </style>
            </head>
            <body>
                <center><h1>ASAP Results for Sample: <xsl:value-of select="@name"/></h1></center>
                <br />
                Total reads: <xsl:value-of select="@mapped_reads + @unmapped_reads + @unassigned_reads"/><br/>
                Mapped reads: <xsl:value-of select="@mapped_reads"/><br/>
                Unmapped reads: <xsl:value-of select="@unmapped_reads + @unassigned_reads"/><br/>
                <br/>
                <table border="2" rules="rows">
                    <tr><th colspan="2">Clinical Summary for Sample: <xsl:value-of select="@name"/></th></tr>
                    <xsl:for-each select=".//significance">
                    <xsl:if test="not(./@flag)">
                            <tr>
                                <td><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text></td>
                                <td><xsl:value-of select="."/></td>
                            </tr>
                    </xsl:if>
                    </xsl:for-each>
                </table>
                <br />
                <br />
                <h3>Presence/absence assays present in sample: <xsl:value-of select="@name"/></h3>
                <table border="2" width="100%">
                        <tr>
                        <th>Assay Name</th>
                        <th># of Reads</th>
                        <th>Coverage Breadth</th>
                        <th>Significance</th>
                        <th>SNPs found(% reads containing SNP)</th>
                        </tr>
                        <xsl:for-each select="assay">
                            <xsl:if test="@type = 'presence/absence' and amplicon/@reads &gt; 0">
                            <xsl:call-template name="amplicon-graph"></xsl:call-template>
                            <tr>
                                <td><a href="#{@name}-graph" onclick="render_{str:replace(str:replace(@name, '+', '_'), '-', '_')}()"><xsl:value-of select="@name"/></a></td>
                                <td><xsl:value-of select="amplicon/@reads"/></td>
                                <td><xsl:value-of select='format-number(amplicon/breadth, "##.##")'/>%</td>
                                <td><xsl:value-of select="amplicon/significance"/><xsl:if test="amplicon/significance/@flag"> (<xsl:value-of select="amplicon/significance/@flag"/>)</xsl:if></td>
                                <td><xsl:for-each select="amplicon/snp">
                                    <xsl:value-of select="@position"/><xsl:value-of select="@reference"/>-><xsl:value-of select="snp_call"/>(<xsl:value-of select='format-number(snp_call/@percent, "##.##")'/>%)<br/>
                                </xsl:for-each></td>
                            </tr>
                            </xsl:if>
                        </xsl:for-each>
                </table>
                <br />
                <h3>SNP assays for sample: <xsl:value-of select="@name"/></h3>
                <table border="2" width="100%">
                        <tr>
                        <th>Assay Name</th>
                        <th># of Reads</th>
                        <th>Coverage Breadth</th>
                        <th>Known SNPs(% reads containing SNP) - Significance</th>
                        <th>Other SNPs found(% reads containing SNP)</th>
                        </tr>
                        <xsl:for-each select="assay">
                            <xsl:if test="@type = 'SNP' or @type = 'mixed'">
                            <xsl:call-template name="amplicon-graph"></xsl:call-template>
                            <tr>
                                <td><a href="#{@name}-graph" onclick="render_{str:replace(str:replace(@name, '+', '_'), '-', '_')}()"><xsl:value-of select="@name"/></a></td>
                                <td><xsl:value-of select="amplicon/@reads"/></td>
                                <xsl:if test="amplicon/@reads &gt; 0">
                                    <td><xsl:value-of select='format-number(amplicon/breadth, "##.##")'/>%</td>
                                    <td><xsl:for-each select="amplicon/snp">
                                        <xsl:if test="./@name != 'unknown'">
                                            <xsl:value-of select="./@position"/><xsl:value-of select="./@reference"/>-><xsl:value-of select="./snp_call"/>(<xsl:value-of select='format-number(./snp_call/@percent, "##.##")'/>%)
                                            - <xsl:value-of select="significance"/><xsl:if test="significance/@flag">(<xsl:value-of select="significance/@flag"/>)</xsl:if>
                                            <br/>
                                        </xsl:if>
                                    </xsl:for-each></td>
                                    <td><xsl:for-each select="amplicon/snp">
                                        <xsl:if test="./@name = 'unknown'">
                                            <xsl:value-of select="@position"/><xsl:value-of select="@reference"/>-><xsl:value-of select="snp_call"/>(<xsl:value-of select='format-number(snp_call/@percent, "##.##")'/>%)<br/>
                                        </xsl:if>
                                    </xsl:for-each></td>
                                </xsl:if>
                            </tr>
                            </xsl:if>
                        </xsl:for-each>
                </table>
                <br />
                <h3>Region of Interest assays for sample: <xsl:value-of select="@name"/></h3>
                <table border="2" width="100%">
                        <tr>
                        <th>Assay Name</th>
                        <th># of Reads</th>
                        <th>Coverage Breadth</th>
                        <th>Region - Reference - Most common sequence (% reads containing seq) - Significance (# of aa changes)</th>
                        <th>SNPs found(% reads containing SNP)</th>
                        </tr>
                        <xsl:for-each select="assay">
                            <xsl:if test="@type = 'ROI' or @type = 'mixed' and amplicon/region_of_interest">
                            <xsl:call-template name="amplicon-graph"></xsl:call-template>
                            <tr>
                                <td><a href="#{@name}-graph" onclick="render_{str:replace(str:replace(@name, '+', '_'), '-', '_')}()"><xsl:value-of select="@name"/></a></td>
                                <td><xsl:value-of select="amplicon/@reads"/></td>
                                <xsl:if test="amplicon/@reads &gt; 0">
                                    <td><xsl:value-of select='format-number(amplicon/breadth, "##.##")'/>%</td>
                                    <td><xsl:for-each select="amplicon/region_of_interest">
                                        <xsl:value-of select="@region"/> - <xsl:value-of select="@reference"/> - <xsl:value-of select="amino_acid_sequence"/>(<xsl:value-of select='format-number(amino_acid_sequence/@percent, "##.##")'/>%)
                                        - <xsl:value-of select="significance"/>(<xsl:value-of select="significance/@changes"/>)
                                        <br/>
                                    </xsl:for-each></td>
                                    <td><xsl:for-each select="amplicon/snp">
                                        <xsl:value-of select="@position"/><xsl:value-of select="@reference"/>-><xsl:value-of select="snp_call"/>(<xsl:value-of select='format-number(snp_call/@percent, "##.##")'/>%)<br/>
                                    </xsl:for-each></td>
                                </xsl:if>
                            </tr>
                            </xsl:if>
                        </xsl:for-each>
                </table>
                <br />
                <h3>Gene Variant assays for sample: <xsl:value-of select="@name"/></h3>
                <table border="2" width="100%">
                        <tr>
                        <th>Assay Name</th>
                        <th>Gene variant - # of Reads - Coverage breadth - Significance</th>
                        </tr>
                        <xsl:for-each select="assay">
                            <xsl:if test="@type = 'gene variant'">
                            <tr>
                                <td><xsl:value-of select="@name"/></td>
                                <td><xsl:for-each select="amplicon">
                                    <xsl:sort select="@reads" data-type="number" order="descending"/>
                                    <xsl:if test="@reads &gt; 0">
                                        <xsl:value-of select="@variant"/> - <strong><xsl:value-of select="@reads"/></strong> - <xsl:value-of select='format-number(breadth, "##.##")'/>%
                                        <xsl:if test="significance">
                                            - <xsl:value-of select="significance"/><xsl:if test="significance/@flag"> (<xsl:value-of select="significance/@flag"/>)</xsl:if>
                                        </xsl:if>
                                <br />
                                    </xsl:if>
                                </xsl:for-each></td>
                            </tr>
                            </xsl:if>
                        </xsl:for-each>
                </table>
            </body>
            </html>
        </exsl:document>
    </xsl:template>
    
    <xsl:template name="amplicon-graph">
        <div id="{@name}-graph" class="ampGraph">
            <div>
                <a href="#close" title="Close" class="close">X</a>
                <h2>Amplicon Graph</h2>
            <canvas id="{@name}-canvas" height="90vh" class="ampCanvas"></canvas>
            <script>
	       function render_<xsl:value-of select="str:replace(str:replace(@name, '+', '_'), '-', '_')"/>() {
                var ctx_<xsl:value-of select="str:replace(str:replace(@name, '+', '_'), '-', '_')"/> = document.getElementById("<xsl:value-of select="@name"/>-canvas").getContext("2d");
                var chart_<xsl:value-of select="str:replace(str:replace(@name, '+', '_'), '-', '_')"/> = new Chart(ctx_<xsl:value-of select="str:replace(str:replace(@name, '+', '_'), '-', '_')"/>, {
                                    type: 'bar',
                    data: {
                        labels: "<xsl:value-of select="amplicon/consensus_sequence"/>".split(""),
                        datasets: [{
                        type: 'line',
                                            label: 'Consensus Proportion',
                            yAxisID: 'proportion',
                            data: [<xsl:value-of select="amplicon/proportions"/>],
                            borderColor: "#5F9EA0",
                            borderWidth: 5,
                            fill: false,
                            pointRadius: 0,
                            pointHoverRadius: 3,
                            pointHoverBorderColor: "#B22222",
                        },
                        {
                        type: 'bar',
                            label: 'Read Depth',
                            yAxisID: 'depth',
                            data: [<xsl:value-of select="amplicon/depths"/>],
                            backgroundColor: "#FFDEAD",
                            borderColor: "#DEB887",
                            borderWidth: 1,
                            hoverBorderColor: "#B22222",
                        }]
                    },
                    options: {
                    responsive: true,
                    hover: {
                        mode: 'label'
                    },
                    tooltips: {
                        mode: 'label'
                    },
                        scales: {
                            yAxes: [{
                                id: "depth",
                                position: "left",
                                ticks: {
                                    beginAtZero: true
                                },
                            },
                            {
                                id: "proportion",
                                position: "right",
                                ticks: {
                                    beginAtZero: true
                                },
                            }],
                            xAxes: [{
                                gridLines: {
                                display: false
                                },
                                    categoryPercentage: 1.0,
                                }]
                        }
                    }
                });
		}
            </script>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
