<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
    <xsl:output method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/analysis">
<!--     <exsl:document method="html" href="{@run_name}.html"> -->
        <html>
        <head>
            <title>Run Summary for: <xsl:value-of select="@run_name"/></title>
        </head>
        <body>
        	<center><h1>TB Clinical ASAP Run Summary for: <xsl:value-of select="@run_name"/></h1></center>
	        <br />
            <table border="1" width="100%">
	    		<tr>
	    		<th>Sample</th>
	    		<xsl:for-each select="sample[position()&lt;=1]">
	    		<xsl:for-each select="assay">
	    		    <th><xsl:value-of select='@name'/></th>
	    		</xsl:for-each>
	    		</xsl:for-each>
	    		</tr>
                <xsl:for-each select="sample">
                    <tr>
                        <td><a href="{/analysis/@run_name}/{./@name}.html"><xsl:value-of select="@name"/></a></td>
			    		<xsl:for-each select="assay">
			    		    <td align="center"><xsl:for-each select="amplicon">
			    		        <xsl:choose>
			    		            <xsl:when test="snp/significance/@flag"><em><xsl:value-of select="significance/@flag"/></em></xsl:when>
			    		            <xsl:when test="snp/significance">
			    		                <xsl:for-each select="snp">
			    		                    <xsl:if test="significance"><xsl:value-of select="@name"/> (<xsl:value-of select='format-number(snp_call/@percent, "##.##")'/>%)<br/></xsl:if>
			    		                </xsl:for-each>
			    		            </xsl:when>
			    		            <xsl:otherwise><em>none</em></xsl:otherwise>
			    		        </xsl:choose>
			    		    </xsl:for-each></td>
			    		</xsl:for-each>
                    </tr>
                </xsl:for-each>
            </table>
	    	<em>Percentages indicate the percentage of the sample containing that mutation</em>
        </body>
        </html>
<!--         </exsl:document> -->
	</xsl:template>
	<xsl:template match="sample">
<!--     <xsl:for-each select="sample"> -->
	<exsl:document method="html" href="{/analysis/@run_name}/{@name}.html">
	    <html>
	    <head>
	    	<title>Clinical Results for Sample: <xsl:value-of select="@name"/></title>
	    </head>
	    <body>
	        <center><h1>TB Clinical ASAP Results for Sample: <xsl:value-of select="@name"/></h1></center>
	        <br />
	    	<table border="2" rules="rows">
	    	    <tr><th colspan="2">Clinical Summary for Sample: <xsl:value-of select="@name"/></th></tr>
	    	    <xsl:for-each select=".//significance">
	    		    <tr>
	    		    <td><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text></td>
	    		    <td><xsl:value-of select="."/></td>
	    		    </tr>
	    		</xsl:for-each>
	    	</table>
	    	<br />
	    	<br />
	    	<h3>Resistance Mutations Present in Sample: <xsl:value-of select="@name"/></h3>
	    	<table border="2" width="100%">
	    		<tr>
	    		<th>Gene Target:</th>
	    		<xsl:for-each select="assay">
	    		    <th><xsl:value-of select="@name"/></th>
	    		</xsl:for-each>
	    		</tr>
	    		<tr>
	    		<th>Mutations:</th>
	    		<xsl:for-each select="assay">
	    		    <td align="center"><xsl:for-each select="amplicon">
	    		        <xsl:choose>
	    		            <xsl:when test="snp/significance">
	    		                <xsl:for-each select="snp">
	    		                    <xsl:if test="significance"><xsl:value-of select="@name"/> (<xsl:value-of select='format-number(snp_call/@percent, "##.##")'/>%)<br/></xsl:if>
	    		                </xsl:for-each>
	    		            </xsl:when>
	    		            <xsl:otherwise><em>none</em></xsl:otherwise>
	    		        </xsl:choose>
	    		    </xsl:for-each></td>
	    		</xsl:for-each>
	    		</tr>
	    	</table>
	    	<em>Percentages indicate the percentage of the sample containing that mutation</em>
	    </body>
	    </html>
	</exsl:document>
<!-- 	</xsl:for-each> -->
    </xsl:template>
</xsl:stylesheet>
