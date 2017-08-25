<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
<xsl:output method="text"/>
<xsl:template match="/sample">
<exsl:document method="html" href="{/analysis/@run_name}/{@name}_presence-absence.tsv">
<xsl:text/>Assay Name<xsl:text>&#x9;</xsl:text>#Reads<xsl:text>&#x9;</xsl:text>Coverage Breadth<xsl:text>&#x9;</xsl:text>Significance<xsl:text>&#xa;</xsl:text>
<xsl:for-each select="assay[@type='presence/absence']">
<xsl:value-of select="@name"/><xsl:text>&#x9;</xsl:text><xsl:value-of select="amplicon/@reads"/><xsl:text>&#x9;</xsl:text><xsl:value-of select="amplicon/breadth"/>%<xsl:text>&#x9;</xsl:text><xsl:value-of select="amplicon/significance"/><xsl:text>&#xa;</xsl:text>
</xsl:for-each> 
<xsl:text/>
</exsl:document>
<exsl:document method="html" href="{/analysis/@run_name}/{@name}_SNP.tsv">
<xsl:text/>Assay Name<xsl:text>&#x9;</xsl:text>#Reads<xsl:text>&#x9;</xsl:text>Coverage Breadth<xsl:text>&#x9;</xsl:text>SNP Proportion<xsl:text>&#x9;</xsl:text>Significance<xsl:text>&#xa;</xsl:text>
<xsl:for-each select="assay[@type='SNP']">
<xsl:value-of select="@name"/><xsl:text>&#x9;</xsl:text><xsl:value-of select="amplicon/@reads"/><xsl:text>&#x9;</xsl:text><xsl:value-of select="amplicon/breadth"/>%<xsl:text>&#x9;</xsl:text><xsl:value-of select='format-number(amplicon/snp/snp_call/@percent, "##.##")'/>%<xsl:text>&#x9;</xsl:text><xsl:value-of select="amplicon/snp/significance"/><xsl:text>&#xa;</xsl:text>
</xsl:for-each>
<xsl:text/>
</exsl:document>
</xsl:template>
</xsl:stylesheet>
