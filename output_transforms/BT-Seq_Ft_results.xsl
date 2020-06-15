<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/strings" xmlns:re="http://exslt.org/regular-expressions" extension-element-prefixes="exsl str re">
    <xsl:import href="http://exslt.org/str/functions/replace/str.replace.function.xsl"/>
    <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/analysis">
        <html>
        <head>
            <title>Run Summary for: <xsl:value-of select="@run_name"/></title>
            <style type="text/css">
                .table-header-rotated {
                  border-collapse: collapse;
                }
                .table-header-rotated td.rotate {
                  width: 45px;
                }
                .table-header-rotated td.norotate {
                  text-align: center;
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
                  height: 200px;
                  white-space: nowrap;
                }
                .table-header-rotated th.rotate <xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text> div {
                  -webkit-transform: translate(37px, 81px) rotate(315deg);
                      -ms-transform: translate(37px, 81px) rotate(315deg);
                          transform: translate(37px, 81px) rotate(315deg);
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
            <center><h1>BT-Seq ASAP Run Summary for: <xsl:value-of select="@run_name"/></h1></center>
	    <br/>
            <table class="table-header-rotated">
	        <tr>
	    	<th class="norotate"></th>
	    	<th class="norotate"></th>
	    	<xsl:for-each select="sample[1]">
	    	    <xsl:for-each select="assay">
	    	        <th class="rotate"><div><span><xsl:value-of select='@name'/></span></div></th>
	    	    </xsl:for-each>
	    	</xsl:for-each>
	    	</tr>
	        <tr>
	    	<td class="norotate">Sample</td>
	    	<td class="norotate">Ft Positives</td>
	    	<td class="norotate" colspan="5" align="center"><em>Francisella tularensis</em></td>
	    	<td class="norotate" colspan="5" align="center">Other Francisella spp.</td>
	    	<td class="norotate" colspan="4" align="center">Ft typing</td>
                </tr>
                <xsl:for-each select="sample">
	    	<xsl:variable name="count_ft">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Francisella tularensis') and not(contains(significance, 'novicida'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Francisella tularensis') and not(contains(significance, 'Strain'))]//significance[not(@flag)])"/>
                </xsl:variable>
                    <tr>
                    <td class="norotate" nowrap="true"><a href="{/analysis/@run_name}/{./@name}.html"><xsl:value-of select="@name"/></a></td>
                    <td class="norotate"><xsl:value-of select="$count_ft"/>/5</td>
		    <xsl:for-each select="assay">
		        <td class="rotate" align="center">
			<xsl:choose>
			<xsl:when test="@type = 'SNP'">
                            <xsl:choose>
                            <xsl:when test="amplicon/@reads &gt;= 100 and amplicon//snp[@name != 'unknown']/snp_call/@percent &gt;= 10">
                                <xsl:choose>
                                <xsl:when test="position() &lt;= 5">Ft</xsl:when>
                                <xsl:when test="position() &gt;= 6 and position() &lt;=10">NN</xsl:when>
                                <xsl:when test="position() = 11">FtA1</xsl:when>
                                <xsl:when test="position() = 12">FtA2</xsl:when>
                                <xsl:when test="position() = 13">FtB</xsl:when>
                                <xsl:when test="position() = 14">FtA</xsl:when>
                                <xsl:otherwise>+</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                            </xsl:choose>
			</xsl:when>
			<xsl:otherwise>
                            <xsl:choose>
                            <xsl:when test="amplicon/@reads &gt;= 100">
                                <xsl:choose>
                                <xsl:when test="position() &lt;= 5">Ft</xsl:when>
                                <xsl:when test="position() &gt;= 6 and position() &lt;=10">NN</xsl:when>
                                <xsl:when test="position() = 11">FtA1</xsl:when>
                                <xsl:when test="position() = 12">FtA2</xsl:when>
                                <xsl:when test="position() = 13">FtB</xsl:when>
                                <xsl:when test="position() = 14">FtA</xsl:when>
                                <xsl:otherwise>+</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
			</xsl:choose>
			</td>
		    </xsl:for-each>
                    </tr>
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </table>
        </body>
        </html>
    </xsl:template>
    
    <xsl:template name="amplicon-graph">
        <div id="{@name}-graph" class="ampGraph">
            <div>
                <a href="#close" title="Close" class="close">X</a>
                <h2><xsl:value-of select="@name"/> Coverage Graph</h2>
			<canvas id="{@name}-canvas" height="90vh" class="ampCanvas"></canvas>
                            <xsl:variable name="best_amp">
                            <xsl:for-each select="amplicon">
                                <xsl:sort select="breadth" data-type="number" order="descending"/>
                                <xsl:sort select="@reads" data-type="number" order="descending"/>
                                <xsl:if test="position()=1"><xsl:copy-of select="./*"/></xsl:if>
                            </xsl:for-each>
                            </xsl:variable>
			<script>
				var ctx_<xsl:value-of select="str:replace(str:replace(@name, '+', '_'), '-', '_')"/> = document.getElementById("<xsl:value-of select="@name"/>-canvas").getContext("2d");
				var chart_<xsl:value-of select="str:replace(str:replace(@name, '+', '_'), '-', '_')"/> = new Chart(ctx_<xsl:value-of select="str:replace(str:replace(@name, '+', '_'), '-', '_')"/>, {
                                    type: 'bar',
				    data: {
				        labels: "<xsl:value-of select="exsl:node-set($best_amp)/consensus_sequence"/>".split(""),
				        datasets: [{
					    type: 'line',
                                            label: 'Consensus Proportion',
				            yAxisID: 'proportion',
				            data: [<xsl:value-of select="exsl:node-set($best_amp)/proportions"/>],
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
				            data: [<xsl:value-of select="exsl:node-set($best_amp)/depths"/>],
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
				            	id: "proportion",
				            	position: "left",
				                ticks: {
				                    beginAtZero: true
				                },
				            },
				            {
				            	id: "depth",
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
		    </script>
            </div>
        </div>
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
		    .snpCell{
                height:15px;
                overflow:hidden;
                text-overflow:ellipsis
            }
            .snpCell:hover{
                height:auto;
                width:auto;
            }
	    	</style>
	    </head>
	    <body>
	        <center><h1>BT-Seq Results for Sample: <xsl:value-of select="@name"/></h1></center>
                <table border="0">
                <tr>
                <th>Alignment statistics</th>
                <th>Analysis parameters</th>
                </tr>
                <tr>
	        <td style="padding-left: 20">Total reads: <xsl:value-of select="@mapped_reads + @unmapped_reads + @unassigned_reads"/></td>
                <td style="padding-left: 20">Depth filter: <xsl:value-of select="@depth_filter"/>x</td>
                </tr>
                <tr>
	        <td style="padding-left: 20">Mapped reads: <xsl:value-of select="@mapped_reads"/></td>
                <td style="padding-left: 20">Breadth filter: <xsl:value-of select="@breadth_filter * 100"/>%</td>
                </tr>
                <tr>
	        <td style="padding-left: 20">Unmapped reads: <xsl:value-of select="@unmapped_reads + @unassigned_reads"/></td>
                <td style="padding-left: 20">Proportion filter: <xsl:value-of select="@proportion_filter * 100"/>%</td>
                </tr>
                <tr>
                <td style="padding-left: 20">Aligner used: bowtie2</td>
                </tr>
                </table>
	        <br/>
    	    <xsl:variable name="pre_map">
    	    <xsl:for-each select=".//significance">
                <xsl:if test="not(./@flag)">
                    <entry key="{.}"><xsl:value-of select="ancestor::assay/@name"/></entry>
                </xsl:if>
            </xsl:for-each>
            </xsl:variable>
    	    <xsl:variable name="clinical_map">
    	    <xsl:for-each select="exsl:node-set($pre_map)/entry[not(@key=preceding-sibling::entry/@key)]">
                <xsl:variable name="message" select="@key"/>
                <result message="{$message}">
                <xsl:for-each select="exsl:node-set($pre_map)/entry[@key=$message]">
                    <evidence value="{.}"/>
                </xsl:for-each>
                </result>
            </xsl:for-each>
            </xsl:variable>
	    	<h3>Positive assays for sample: <xsl:value-of select="@name"/></h3>
	    	<table border="2" rules="rows" cellpadding="5">
                <xsl:for-each select="exsl:node-set($clinical_map)/result">
    		    <tr>
    		        <td><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text></td>
    		        <td><xsl:value-of select="@message"/> <!--(<xsl:for-each select="evidence[not(@value=preceding-sibling::evidence/@value)]"><xsl:value-of select="@value"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>)--></td>
    		    </tr>
    		    </xsl:for-each>
	    	</table>
	    	<br />
	    	<xsl:variable name="count_ft">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Francisella tularensis') and not(contains(significance, 'novicida'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Francisella tularensis') and not(contains(significance, 'Strain'))]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<h4>Assays positive for <em>Francisella tularensis</em>: <xsl:value-of select="$count_ft"/>/5</h4>
	    	<br />
	    	<br />
	    	<h3>Species and strain identification assays for sample: <xsl:value-of select="@name"/></h3>
	    	<table border="2" width="100%">
	    		<tr>
	    		<th>Assay Name</th>
	    		<th>Read Depth</th>
	    		<th>Coverage Breadth</th>
	    		<th>Significance</th>
	    		<th>SNPs found</th>
	    		</tr>
                        <tbody valign="top">
	    		<xsl:for-each select="assay">
	    		    <xsl:if test="(@function = 'species ID' or @function = 'strain ID')"><!--and (exsl:node-set($best_amp)/@reads &gt; 0)--> 
                            <xsl:variable name="best_amp">
                            <xsl:for-each select="amplicon">
                                <xsl:sort select="breadth" data-type="number" order="descending"/>
                                <xsl:sort select="@reads" data-type="number" order="descending"/>
                                <xsl:if test="position()=1"><xsl:copy-of select="./*"/></xsl:if>
                            </xsl:for-each>
                            </xsl:variable>
	    		    <xsl:call-template name="amplicon-graph"></xsl:call-template>
	    		    <tr>
	    		        <td><a href="#{@name}-graph"><xsl:value-of select="@name"/></a></td>
	    		        <td><xsl:value-of select='amplicon/@reads'/></td>
                                <xsl:choose>
                                <xsl:when test='amplicon/breadth'>
	    		        <td><xsl:value-of select='format-number(exsl:node-set($best_amp)/breadth, "##.##")'/>%</td>
                                </xsl:when><xsl:otherwise><td>0%</td></xsl:otherwise></xsl:choose>
	    		        <xsl:choose>
	    		            <xsl:when test="@type = 'presence/absence'">
	    		                <td><xsl:if test="amplicon/significance[text()]"><xsl:value-of select="amplicon/significance"/><xsl:if test="amplicon/significance/@flag"> (<xsl:value-of select="amplicon/significance/@flag"/>)</xsl:if></xsl:if></td>
	    		            </xsl:when>
	    		            <xsl:when test="@type = 'SNP'">
			    		        <td><xsl:for-each select="amplicon/snp">
			    		            <!--<xsl:if test="significance and ./@name != 'unknown'">-->
			    		            <xsl:if test="significance and ./snp_call/@percent &gt; 10">
			    		                <xsl:value-of select="./@position"/><xsl:value-of select="./@reference"/>-><xsl:value-of select="./snp_call"/>(<xsl:value-of select='format-number(./snp_call/@percent, "##.##")'/>%)
			    		                - <xsl:value-of select="significance"/><xsl:if test="significance/@flag">(<xsl:value-of select="significance/@flag"/>)</xsl:if>
			    		                <br/>
			    		            </xsl:if>
			    		        </xsl:for-each></td>
	    		            </xsl:when>
	    		            <xsl:when test="@type = 'ROI'">
			    		        <td><xsl:for-each select="amplicon/region_of_interest">
			    		            <xsl:if test="significance">
			    		            <xsl:value-of select="@region"/> - <xsl:value-of select="@reference"/> - <xsl:value-of select="amino_acid_sequence"/>(<xsl:value-of select='format-number(amino_acid_sequence/@percent, "##.##")'/>%)
		    		                - <xsl:value-of select="significance"/>(<xsl:value-of select="significance/@changes"/>)
			    		            <br/>
			    		            </xsl:if>
			    		        </xsl:for-each></td>
	    		            </xsl:when>
                                    <xsl:when test="@type = 'gene variant'">
                                        <td><xsl:for-each select="amplicon">
                                            <xsl:sort select="breadth" data-type="number" order="descending"/>
                                            <xsl:sort select="@reads" data-type="number" order="descending"/>
	    		                    <xsl:if test="breadth &gt; 0">
	    		                        <xsl:value-of select="@variant"/> - <strong><xsl:value-of select="@reads"/></strong> - <xsl:value-of select='format-number(breadth, "##.##")'/>%
	    		                    <xsl:if test="significance">
	    		                        - <xsl:value-of select="significance"/><xsl:if test="significance/@flag"> (<xsl:value-of select="significance/@flag"/>)</xsl:if>
	    		                    </xsl:if>
                                            <br />
		    		            </xsl:if>
		    		        </xsl:for-each></td>
                                    </xsl:when>
                                    <xsl:otherwise><td></td></xsl:otherwise>
	    		        </xsl:choose>
	    		        <td><xsl:if test="exsl:node-set($best_amp)/snp"><div class="snpCell">details...<br/><xsl:for-each select="exsl:node-set($best_amp)/snp">
	    		            <xsl:value-of select="@position"/><xsl:value-of select="@reference"/>-><xsl:value-of select="snp_call"/>(<xsl:value-of select='format-number(snp_call/@percent, "##.##")'/>%)<br/>
	    		        </xsl:for-each></div></xsl:if></td>
	    		    </tr>
	    		    </xsl:if>
	    		</xsl:for-each>
                        </tbody>
	    	</table>
	    	<br />
                <!--<table width="100%">
                <tr>
                <td align="center"><img src="../web_resources/NAU_Acronym_primary-281_3514-300x213.png" height="82" width="115"/></td>
                <td align="center"><img src="../web_resources/195px-Seal_of_the_United_States_Department_of_Homeland_Security.svg.png" height="150" width="150"/></td>
                <td align="center"><img src="../web_resources/TGen-North-Logo_Email-Signature.png" height="82" width="180"/></td>
                </tr>
                </table>
                <br />-->
	    </body>
	    </html>
	</exsl:document>
    </xsl:template>
</xsl:stylesheet>
