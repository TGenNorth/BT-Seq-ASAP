<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
    <xsl:output method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/analysis">    
        <html>
        <head>
            <title>Run Summary for: <xsl:value-of select="@run_name"/></title>
            <style>
				.table-header-rotated {
				  border-collapse: collapse;
				}
				.table-header-rotated td.rotate {
				  width: 30px;
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
				  border: 1px solid #ccc;
				}
				.table-header-rotated th.rotate {
				  height: 140px;
				  white-space: nowrap;
				}
				.table-header-rotated th.rotate > div {
				  -webkit-transform: translate(25px, 51px) rotate(315deg);
				      -ms-transform: translate(25px, 51px) rotate(315deg);
				          transform: translate(25px, 51px) rotate(315deg);
				  width: 30px;
				}
				.table-header-rotated th.rotate > div > span {
				  border-bottom: 1px solid #ccc;
				  padding: 5px 10px;
				}
				.table-header-rotated th.row-header {
				  padding: 0 10px;
				  border-bottom: 1px solid #ccc;
				}            
            </style>
        </head>
        <body>
        	<center><h1>ASAP Run Summary for: <xsl:value-of select="@run_name"/></h1></center>
	        <br/>
            <table class="table-header-rotated">
	    		<tr>
	    		<th class="norotate">Sample</th>
	    		<th class="rotate"><div><span><em>Staphylococcus aureus</em> Confirmed</span></div></th>
	    		<th class="rotate"><div><span>MRSA Confirmed</span></div></th>
	    		<th class="norotate">Lineage</th>
	    		<th class="rotate"><div><span>Vancomycin Resistance</span></div></th>
	    		<th class="rotate"><div><span>Rifampin Resistance</span></div></th>
	    		<th class="rotate"><div><span>Lincosamide Resistance</span></div></th>
	    		<th class="rotate"><div><span>Aminoglycoside Resistance</span></div></th>
	    		<th class="rotate"><div><span>B-lactam Resistance</span></div></th>
	    		<th class="rotate"><div><span>Macrolide Resistance</span></div></th>
	    		<th class="rotate"><div><span>Tetracycline Resistance</span></div></th>
	    		<th class="rotate"><div><span>Linezolid Resistance</span></div></th>
	    		</tr>
                <xsl:for-each select="sample">
                    <tr>
                        <td class="norotate"><a href="{/analysis/@run_name}/{./@name}.html"><xsl:value-of select="@name"/></a></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='Staphylococcus aureus Confirmed'"><img src="check.png" style="width:30px;height:30px;"/></xsl:when><xsl:otherwise><img src="cross.png" style="width:30px;height:30px;"/></xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='MRSA Confirmed'"><img src="check.png" style="width:30px;height:30px;"/></xsl:when><xsl:otherwise><img src="cross.png" style="width:30px;height:30px;"/></xsl:otherwise></xsl:choose></td>
                        <td class="norotate"><xsl:choose>
                        <xsl:when test=".//significance[not(@flag)]='Strain type CC5'">CC5</xsl:when>
                        <xsl:when test=".//significance[not(@flag)]='Strain type CC8'">CC8
                            <xsl:choose>
                                <xsl:when test=".//significance[not(@flag)]='Strain type ST239'"> -> ST239</xsl:when>
                                <xsl:when test=".//significance[not(@flag)]='Strain type Archaic Iberian'"> -> Archaic Iberian</xsl:when>
                                <xsl:when test=".//significance[not(@flag)]='Strain type True Iberian'"> -> True Iberian</xsl:when>
                                <xsl:when test=".//significance[not(@flag)]='Strain type USA300 or USA500'"> -> USA300 or USA500
                                    <xsl:if test=".//significance[not(@flag)]='Strain type USA300'"> -> USA300</xsl:if>                                  
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise><em>Undetermined</em></xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='VISA-Vancomycin intermediate resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='Rifampin resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='Lincosamide resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='Aminoglycoside resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='B-lactam resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='Macrolide resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='Tetracycline resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                        <td class="rotate" align="center"><xsl:choose><xsl:when test=".//significance[not(@flag)]='Linezolid resistance'"><font color="red">R</font></xsl:when><xsl:otherwise>S</xsl:otherwise></xsl:choose></td>
                    </tr>
                </xsl:for-each>
            </table>
        </body>
        </html>
	</xsl:template>
</xsl:stylesheet>
