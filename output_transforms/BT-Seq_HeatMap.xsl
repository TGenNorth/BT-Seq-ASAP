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
                }:q
                .table-header-rotated th.norotate {
                  padding: 10px 40px;
                  vertical-align: bottom;
                }
                .table-header-rotated td.noborder {
                  text-align: center;
                  padding: 10px 5px;
                  border: 0px;
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
                  -webkit-transform: translate(15px, 81px) rotate(315deg);
                      -ms-transform: translate(15px, 81px) rotate(315deg);
                          transform: translate(15px, 81px) rotate(315deg);
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
	    	<th class="rotate"><div><span><em>B. pseudomallei</em> Positives</span></div></th>
	    	<th class="rotate"><div><span><em>Bp/Bm</em> Positives</span></div></th>
	    	<th class="rotate"><div><span><em>B. mallei</em> Positives</span></div></th>
	    	<th class="rotate"><div><span><em>Bp/Bm</em> Near Neighbor Positives</span></div></th>
                <th></th>
	    	<th class="rotate"><div><span>Positive Sequencing Control 1</span></div></th>
                <th></th>
	    	<th class="rotate"><div><span><em>B. anthracis</em> Positives</span></div></th>
	    	<th class="rotate"><div><span><em>Ba</em> Near Neighbor Positives</span></div></th>
                <th></th>
	    	<th class="rotate"><div><span><em>F. tularensis</em> Positives</span></div></th>
	    	<th class="rotate"><div><span><em>Ft</em> Near Neighbor Positives</span></div></th>
                <th></th>
	    	<th class="rotate"><div><span><em>Y. pestis</em> Positives</span></div></th>
	    	<th class="rotate"><div><span><em>Yp</em> Near Neighbor Positives</span></div></th>
                <th></th>
	    	<th class="rotate"><div><span>Positive Sequencing Control 2</span></div></th>
                </tr>
                <tr>
	    	<th class="norotate">Sample</th>
	    	<td class="norotate" colspan="4" align="center"><em>Burkholderia</em></td> 
                <td class="noborder"></td>
                <td class="norotate">+/-</td>
                <td class="noborder"></td>
	    	<td class="norotate" colspan="2" align="center"><em>B. anthracis</em></td>                
                <td class="noborder"></td>
	    	<td class="norotate" colspan="2" align="center"><em>F. tularensis</em></td>                
                <td class="noborder"></td>
	    	<td class="norotate" colspan="2" align="center"><em>Y. pestis</em></td>                
                <td class="noborder"></td>
                <td class="norotate">+/-</td>
	    	</tr>
                <xsl:for-each select="sample">
                <xsl:variable name="TOTAL_READS" select="@mapped_reads + @unmapped_reads"/>
                <xsl:variable name="DEPTH_FILTER" select="@depth_filter"/>
                <xsl:variable name="PROP_FILTER" select="@proportion_filter * 100"/>
                <xsl:variable name="MUT_DEPTH" select="@mutation_depth_filter"/>            
	    	<xsl:variable name="count_bp">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Burkholderia pseudomallei') and not(contains(significance, ' mallei')) and not(contains(significance, 'complex'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Burkholderia pseudomallei') and not(contains(significance, ' mallei')) and not(contains(significance, 'complex'))]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bpbm">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Burkholderia pseudomallei or mallei')]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Burkholderia pseudomallei or mallei')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bm">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Burkholderia mallei')]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Burkholderia mallei')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bpbmnn">
                    <xsl:value-of select="count(./assay/amplicon/snp[contains(significance, 'Burkholderia cepacia complex')]//significance[not(@flag)]) + count(./assay[@type = 'gene variant']/amplicon[not(contains(significance, 'mallei'))]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ba">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Bacillus anthracis') and not(contains(significance, 'plasmid'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Bacillus anthracis')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bann">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Bacillus cereus')]//significance[not(@flag)]) + count(./assay[contains(@name, 'Ba_NN')]/amplicon//snp[@name != 'unknown' and @depth &gt;= $DEPTH_FILTER and not(significance)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ft">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Francisella tularensis') and not(contains(significance, 'novicida'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Francisella tularensis') and not(contains(significance, 'Strain'))]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ftnn">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'novicida') or contains(significance, 'noatunensis') or contains(significance, 'philomiragia')]//significance[not(@flag)]) + count(./assay[contains(@name, 'Ft_NN')]/amplicon//snp[@name != 'unknown' and @depth &gt;= $DEPTH_FILTER and not(significance)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_yp">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Yersinia pestis') and not(contains(significance, 'pla'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Yersinia pestis')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ypnn">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Yersinia enterolytica')]//significance[not(@flag)]) + count(./assay[contains(@name, 'Yp_NN')]/amplicon//snp[@name != 'unknown' and @depth &gt;= $DEPTH_FILTER and not(significance)])"/>
                </xsl:variable>
                <xsl:variable name="color_bp"><xsl:value-of select="concat(substring('#000', 1, (($count_bp div 5) &lt; 0.8) *4), substring('#FFF', 1, (($count_bp div 5) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_bpbm"><xsl:value-of select="concat(substring('#000', 1, (($count_bpbm div 5) &lt; 0.8) *4), substring('#FFF', 1, (($count_bpbm div 5) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_bm"><xsl:value-of select="concat(substring('#000', 1, (($count_bm div 2) &lt; 0.8) *4), substring('#FFF', 1, (($count_bm div 2) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_bpbmnn"><xsl:value-of select="concat(substring('#000', 1, (($count_bpbmnn div 3) &lt; 0.8) *4), substring('#FFF', 1, (($count_bpbmnn div 3) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_ba"><xsl:value-of select="concat(substring('#000', 1, (($count_ba div 16) &lt; 0.8) *4), substring('#FFF', 1, (($count_ba div 16) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_bann"><xsl:value-of select="concat(substring('#000', 1, (($count_bann div 12) &lt; 0.8) *4), substring('#FFF', 1, (($count_bann div 12) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_ft"><xsl:value-of select="concat(substring('#000', 1, (($count_ft div 5) &lt; 0.8) *4), substring('#FFF', 1, (($count_ft div 5) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_ftnn"><xsl:value-of select="concat(substring('#000', 1, (($count_ftnn div 8) &lt; 0.8) *4), substring('#FFF', 1, (($count_ftnn div 8) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_yp"><xsl:value-of select="concat(substring('#000', 1, (($count_yp div 8) &lt; 0.8) *4), substring('#FFF', 1, (($count_yp div 8) &gt;= 0.8) *4))"/></xsl:variable>
                <xsl:variable name="color_ypnn"><xsl:value-of select="concat(substring('#000', 1, (($count_ypnn div 7) &lt; 0.8) *4), substring('#FFF', 1, (($count_ypnn div 7) &gt;= 0.8) *4))"/></xsl:variable>
                    <tr>
                    <td class="norotate" nowrap="true"><a href="{/analysis/@run_name}/{./@name}.html"><xsl:value-of select="@name"/></a></td>
                    <td class="norotate" style="background: hsl(0, 100%, {(1 - ($count_bp div 5)) * 70 + 30}%); color: {$color_bp}"><xsl:value-of select="$count_bp"/>/5</td>
                    <td class="norotate" style="background: hsl(0, 100%, {(1 - ($count_bpbm div 5)) * 70 + 30}%); color: {$color_bpbm}"><xsl:value-of select="$count_bpbm"/>/5</td>
                    <td class="norotate" style="background: hsl(0, 100%, {(1 - ($count_bm div 2)) * 70 + 30}%); color: {$color_bm}"><xsl:value-of select="$count_bm"/>/2</td>
                    <td class="norotate" style="background: hsl(240, 100%, {(1 - ($count_bpbmnn div 3)) * 70 + 30}%); color: {$color_bpbmnn}"><xsl:value-of select="$count_bpbmnn"/>/3</td>
                    <td class="noborder"></td>
                    <td><xsl:choose><xsl:when test="./assay[@name = 'IPSC-1']/amplicon/@reads &gt; $MUT_DEPTH">+</xsl:when><xsl:otherwise>-</xsl:otherwise></xsl:choose></td>
                    <td class="noborder"></td>
                    <td class="norotate" style="background: hsl(0, 100%, {(1 - ($count_ba div 16)) * 70 + 30}%); color: {$color_ba}"><xsl:value-of select="$count_ba"/>/16</td>
                    <td class="norotate" style="background: hsl(240, 100%, {(1 - ($count_bann div 12)) * 70 + 30}%); color: {$color_bann}"><xsl:value-of select="$count_bann"/>/12</td>                    
                    <td class="noborder"></td>
                    <td class="norotate" style="background: hsl(0, 100%, {(1 - ($count_ft div 5)) * 70 + 30}%); color: {$color_ft}"><xsl:value-of select="$count_ft"/>/5</td>
                    <td class="norotate" style="background: hsl(240, 100%, {(1 - ($count_ftnn div 8)) * 70 + 30}%); color: {$color_ftnn}"><xsl:value-of select="$count_ftnn"/>/8</td>
                    <td class="noborder"></td>
                    <td class="norotate" style="background: hsl(0, 100%, {(1 - ($count_yp div 8)) * 70 + 30}%); color: {$color_yp}"><xsl:value-of select="$count_yp"/>/8</td>
                    <td class="norotate" style="background: hsl(240, 100%, {(1 - ($count_ypnn div 7)) * 70 + 30}%); color: {$color_ypnn}"><xsl:value-of select="$count_ypnn"/>/7</td>
                    <td class="noborder"></td>
                    <td><xsl:choose><xsl:when test="./assay[@name = 'IPSC-2']/amplicon/@reads &gt; $MUT_DEPTH">+</xsl:when><xsl:otherwise>-</xsl:otherwise></xsl:choose></td>
                    </tr>
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </table>
        </body>
        </html>
    </xsl:template>
    
    <xsl:template match="sample">
	<exsl:document method="html" href="{/analysis/@run_name}/{@name}.html">
	    <html>
	    <head>
	    	<title>BT-Seq Results for Sample: <xsl:value-of select="@name"/></title>
	    	<style>
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
            <xsl:variable name="TOTAL_READS" select="@mapped_reads + @unmapped_reads"/>
            <xsl:variable name="DEPTH_FILTER" select="@depth_filter"/>
            <xsl:variable name="PROP_FILTER" select="@proportion_filter * 100"/>
            <xsl:variable name="MUT_DEPTH" select="@mutation_depth_filter"/>            
	    <body>
	        <center><h1>BT-Seq Results for Sample: <xsl:value-of select="@name"/></h1></center>
                <table border="0">
                <tr>
                <th>Alignment statistics</th>
                <th>Analysis parameters</th>
                </tr>
                <tr>
	        <td style="padding-left: 20">Total reads: <xsl:value-of select="$TOTAL_READS"/></td>
                <td style="padding-left: 20">Depth filter: <xsl:value-of select="$DEPTH_FILTER"/>x</td>
                </tr>
                <tr>
	        <td style="padding-left: 20">Mapped reads: <xsl:value-of select="@mapped_reads"/></td>
                <td style="padding-left: 20">Breadth filter: <xsl:value-of select="@breadth_filter * 100"/>%</td>
                </tr>
                <tr>
	        <td style="padding-left: 20">Unmapped reads: <xsl:value-of select="@unmapped_reads"/></td>
                <td style="padding-left: 20">Proportion filter: <xsl:value-of select="$PROP_FILTER"/>%</td>
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
	    	<xsl:variable name="count_bp">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Burkholderia pseudomallei') and not(contains(significance, ' mallei')) and not(contains(significance, 'complex'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Burkholderia pseudomallei') and not(contains(significance, ' mallei')) and not(contains(significance, 'complex'))]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bpbm">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Burkholderia pseudomallei or mallei')]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Burkholderia pseudomallei or mallei')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bm">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Burkholderia mallei')]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Burkholderia mallei')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bpbmnn">
                    <xsl:value-of select="count(./assay/amplicon/snp[contains(significance, 'Burkholderia cepacia complex')]//significance[not(@flag)]) + count(./assay[@type = 'gene variant']/amplicon[not(contains(significance, 'mallei'))]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ba">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Bacillus anthracis') and not(contains(significance, 'plasmid'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Bacillus anthracis')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_bann">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Bacillus cereus')]//significance[not(@flag)]) + count(./assay[contains(@name, 'Ba_NN')]/amplicon//snp[@name != 'unknown' and @depth &gt;= $DEPTH_FILTER and not(significance)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ft">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Francisella tularensis') and not(contains(significance, 'novicida'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Francisella tularensis') and not(contains(significance, 'Strain'))]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ftnn">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'novicida') or contains(significance, 'noatunensis') or contains(significance, 'philomiragia')]//significance[not(@flag)]) + count(./assay[contains(@name, 'Ft_NN')]/amplicon//snp[@name != 'unknown' and @depth &gt;= $DEPTH_FILTER and not(significance)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_yp">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Yersinia pestis') and not(contains(significance, 'pla'))]//significance[not(@flag)]) + count(./assay/amplicon/snp[contains(significance, 'Yersinia pestis')]//significance[not(@flag)])"/>
                </xsl:variable>
	    	<xsl:variable name="count_ypnn">
                    <xsl:value-of select="count(./assay/amplicon[contains(significance, 'Yersinia enterolytica')]//significance[not(@flag)]) + count(./assay[contains(@name, 'Yp_NN')]/amplicon//snp[@name != 'unknown' and @depth &gt;= $DEPTH_FILTER and not(significance)])"/>
                </xsl:variable>
	    	<h4>Assays positive for <em>Burkholderia pseudomallei</em>: <xsl:value-of select="$count_bp"/>/5</h4>
	    	<h4>Assays positive for <em>Burkholderia pseudomallei or mallei</em>: <xsl:value-of select="$count_bpbm"/>/5</h4>
	    	<h4>Assays positive for <em>Burkholderia mallei</em>: <xsl:value-of select="$count_bm"/>/2</h4>
	    	<h4>Assays positive for <em>Burkholderia pseudomallei or mallei</em> near neighbors: <xsl:value-of select="$count_bpbmnn"/>/3</h4>
	    	<h4>Assays positive for <em>Bacillus anthracis</em>: <xsl:value-of select="$count_ba"/>/16</h4>
	    	<h4>Assays positive for <em>Bacillus anthracis</em> near neighbors: <xsl:value-of select="$count_bann"/>/12</h4>
	    	<h4>Assays positive for <em>Francisella tularensis</em>: <xsl:value-of select="$count_ft"/>/5</h4>
	    	<h4>Assays positive for <em>Francisella tularensis</em> near neighbors: <xsl:value-of select="$count_ftnn"/>/8</h4>
	    	<h4>Assays positive for <em>Yersinia pestis</em>: <xsl:value-of select="$count_yp"/>/8</h4>
	    	<h4>Assays positive for <em>Yersinia pestis</em> near neighbors: <xsl:value-of select="$count_ypnn"/>/7</h4>
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
	    		    <tr>
	    		        <td><xsl:value-of select="@name"/></td>
	    		        <td><xsl:value-of select='sum(.//amplicon/@reads)'/></td>
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
			    		            <xsl:if test="significance and ./snp_call/@percent &gt; $PROP_FILTER">
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
	    	<h3>Antibiotic resistance assays for sample: <xsl:value-of select="@name"/></h3>
	    	<table border="2" width="100%">
	    		<tr>
	    		<th>Assay Name</th>
	    		<th>Average Read Depth</th>
	    		<th>Coverage Breadth</th>
	    		<th>Significance</th>
	    		<th>SNPs found</th>
	    		</tr>
                        <tbody valign="top">
	    		<xsl:for-each select="assay">
	    		    <xsl:if test="@function = 'resistance type' and .//significance/text()">
                            <xsl:variable name="best_amp">
                            <xsl:for-each select="amplicon">
                                <xsl:sort select="breadth" data-type="number" order="descending"/>
                                <xsl:sort select="@reads" data-type="number" order="descending"/>
                                <xsl:if test="position()=1"><xsl:copy-of select="./*"/></xsl:if>
                            </xsl:for-each>
                            </xsl:variable>
	    		    <tr>
	    		        <td><xsl:value-of select="@name"/></td>
	    		        <td><xsl:value-of select='sum(.//amplicon/@reads)'/></td>
                                <xsl:choose>
                                <xsl:when test='.//amplicon/breadth'>                                
	    		        <td><xsl:value-of select='format-number(exsl:node-set($best_amp)/breadth, "##.##")'/>%</td>
                                </xsl:when><xsl:otherwise><td>0%</td></xsl:otherwise></xsl:choose> 
                                <xsl:choose>
	    		            <xsl:when test="@type = 'presence/absence'">
	    		                <td><xsl:if test="amplicon/significance[text()]"><xsl:value-of select="amplicon/significance"/><xsl:if test="amplicon/significance/@flag"> (<xsl:value-of select="amplicon/significance/@flag"/>)</xsl:if></xsl:if></td>
	    		            </xsl:when>
	    		            <xsl:when test="@type = 'SNP'">
			    		        <td><xsl:for-each select="amplicon/snp">
			    		            <xsl:if test="significance and ./snp_call/@percent &gt;= $PROP_FILTER">
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
	    	<h3>Virulence assays for sample: <xsl:value-of select="@name"/></h3>
	    	<table border="2" width="100%">
	    		<tr>
	    		<th>Assay Name</th>
	    		<th>Average Read Depth</th>
	    		<th>Coverage Breadth</th>
	    		<th>Significance</th>
	    		<th>SNPs found</th>
	    		</tr>
                        <tbody valign="top">
	    		<xsl:for-each select="assay">
	    		    <!--<xsl:if test="@function = 'virulence factor' and .//significance/text()">-->
	    		    <xsl:if test="@function = 'virulence factor'">
                            <xsl:variable name="best_amp">
                            <xsl:for-each select="amplicon">
                                <xsl:sort select="breadth" data-type="number" order="descending"/>
                                <xsl:sort select="@reads" data-type="number" order="descending"/>
                                <xsl:if test="position()=1"><xsl:copy-of select="./*"/></xsl:if>
                            </xsl:for-each>
                            </xsl:variable>
	    		    <tr>
	    		        <td><xsl:value-of select="@name"/></td>
	    		        <td><xsl:value-of select='sum(.//amplicon/@reads)'/></td>
                                <xsl:choose>
                                <xsl:when test='.//amplicon/breadth'>                                
	    		        <td><xsl:value-of select='format-number(exsl:node-set($best_amp)/breadth, "##.##")'/>%</td>
                                </xsl:when><xsl:otherwise><td>0%</td></xsl:otherwise></xsl:choose>                                
	    		        <xsl:choose>
	    		            <xsl:when test="@type = 'presence/absence'">
	    		                <td><xsl:if test="amplicon/significance[text()]"><xsl:value-of select="amplicon/significance"/><xsl:if test="amplicon/significance/@flag"> (<xsl:value-of select="amplicon/significance/@flag"/>)</xsl:if></xsl:if></td>    		                
	    		            </xsl:when>
	    		            <xsl:when test="@type = 'SNP'">
			    		        <td><xsl:for-each select="amplicon/snp">
			    		            <xsl:if test="significance and ./snp_call/@percent &gt;= $PROP_FILTER">
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
<!--                <table width="100%">
                <tr>
                <td align="center"><img src="../web_resources/NAU_Acronym_primary-281_3514-300x213.png" height="82" width="115"/></td>
                <td align="center"><img src="../web_resources/195px-Seal_of_the_United_States_Department_of_Homeland_Security.svg.png" height="150" width="150"/></td>
                <td align="center"><img src="../web_resources/TGen-North-Logo_Email-Signature.png" height="82" width="180"/></td>
                </tr>
                </table>-->
                <br />
	    </body>
	    </html>
	</exsl:document>
    </xsl:template>
</xsl:stylesheet>
