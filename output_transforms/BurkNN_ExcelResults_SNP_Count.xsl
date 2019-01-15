<?xml version="1.0"?>

<!--
    Document   : BurkNN_ExcelResults_SNP_Count.xsl
    Created on : August 27, 2015, 11:20 AM
    Author     : Matthew Enright
    Description:
        Transform xml to excel xml for user friendly viewing of information (based on Jim Schupp's Burk spreadsheet format)
        SNP Count/Species Targets output results 
-->

<xsl:stylesheet
  version="1.0"
  xmlns="urn:schemas-microsoft-com:office:spreadsheet"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:user="urn:my-scripts"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:x="urn:schemas-microsoft-com:office:excel"
  xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
  

  <xsl:output method="xml" encoding="utf-8" indent="yes" />


  <xsl:template match="/">
      
    <Workbook
      xmlns="urn:schemas-microsoft-com:office:spreadsheet"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
      xmlns:html="http://www.w3.org/TR/REC-html40">
        
        <Styles>
                <Style ss:ID="Default" ss:Name="Normal">
                        <Alignment ss:Vertical="Bottom" />
                        <Borders />
                        <Font />
                        <Interior />
                        <NumberFormat />
                        <Protection />
                </Style>
                <Style ss:ID="s21">
                        <Font ss:Size="22" ss:Bold="1" />
                </Style>
                <Style ss:ID="s22">
                        <Borders>
                            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
                       </Borders>
                        <Font ss:Size="12" ss:Bold="1" />
                </Style>
                <Style ss:ID="s23">
                        <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:Rotate="-90" ss:WrapText="1"/>
                        <Borders>
                            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
                       </Borders>
                        <Font ss:Size="11" ss:Bold="1" />
                </Style>
                <Style ss:ID="s24">
                        <Font ss:Size="12" ss:Bold="0" />
                </Style>
                <Style ss:ID="s25" ss:Name="Percent">
                        <NumberFormat ss:Format="0%"/>
                </Style>
                <Style ss:ID="s26">
                        <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
                       ss:Bold="1"/>
                </Style>
        </Styles>
        
        <xsl:variable
                name="snps"
                select="10"/>

        <!-- shorten worksheet name in case of long names to avoid error when opening in excel -->
        <Worksheet ss:Name="{substring(//analysis/@run_name, 0, 27)}...">
            
                <Table>
                        <Column ss:AutoFitWidth="0" ss:Width="210" />

                        <Row>
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                        </Row>
                        <Row ss:AutoFitHeight="0" ss:Height="18">
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                
                                <!-- merge cell across based on assays -->
                                <Cell ss:StyleID="s22" ss:MergeAcross="12">
                                        <Data ss:Type="String">SNP Count/Species Targets				
                                        </Data>
                                </Cell>                                                               
                        </Row>
                        <Row ss:AutoFitHeight="0" ss:Height="120">
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Sample Name					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Target SNPs Flag (><xsl:value-of select="$snps"/> snps)					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bp targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bp/m targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bm targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bt targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bh targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">B264 targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bo targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">B175 targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bv targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bu targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Bc targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">vir targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">MLST targets					
                                        </Data>
                                </Cell>
                        </Row>
                        
                    <xsl:for-each select="//analysis/sample">
                            
                        <Row>
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="@name" />
                                        </Data>
                                </Cell>
                                
                                <xsl:choose>
                                    <xsl:when test="count(assay[not(contains(@name, 'Bpm_MLST')) and not(contains(@name, 'Bvir'))]/amplicon/snp) &gt; $snps">

                                        <Cell ss:StyleID="s26">
                                                <Data ss:Type="Number">1</Data>
                                        </Cell>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        
                                        <Cell ss:StyleID="s26">
                                                <Data ss:Type="Number">0</Data>
                                        </Cell>
                                        
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                                <!-- For each sample, count the number of SNPs for each assay/species-->
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bp_')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bpm_C')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bm_')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'thai')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'HUMPTY')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'MSMB264')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'OK')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'MSMB175')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'vietnam')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'ubon')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'cepacia')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bvir')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bpm_MLST')]/amplicon/snp)" />
                                        </Data>
                                </Cell>
                          
                        </Row>
                        
                    </xsl:for-each>
                       
                </Table>
                
        </Worksheet>

    </Workbook>
                                
  </xsl:template>

</xsl:stylesheet>
