<?xml version="1.0"?>

<!--
    Document   : TB_ExcelResults.xsl
    Created on : July 28, 2015, 11:20 AM
    Author     : Matthew Enright
    Description:
        Transform xml to excel xml for user friendly viewing of information (based on Jim Schupp's Burk spreadsheet format)
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
                        <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:Rotate="-90"/>
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
        </Styles>
        
        <!-- assays variable used to count number of different assays in analysis. count() --> 
        
        <xsl:variable
                name="assays"
                select="(count(//analysis/sample/assay) div count(//analysis/sample))-1"/>

        <!-- shorten worksheet name in case of long names to avoid error when opening in excel -->
        <Worksheet ss:Name="{substring(//analysis/@run_name, 0, 27)}...">
            
                <Table>
                        <Column ss:AutoFitWidth="0" ss:Width="210" />
                        <Column ss:AutoFitWidth="0" ss:Width="130" />
                        <Column ss:AutoFitWidth="0" ss:Width="130" />
                        <Column ss:AutoFitWidth="0" ss:Width="90" />

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
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                
                                <!-- merge cell across based on assays variable value -->
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$assays}">
                                        <Data ss:Type="String">Read Counts					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$assays}">
                                        <Data ss:Type="String">SNPs					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$assays}">
                                        <Data ss:Type="String">Breadth					
                                        </Data>
                                </Cell>
                        </Row>
                        <Row ss:AutoFitHeight="0" ss:Height="120">
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Sample Name					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Total Reads					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Mapped Reads					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Total SNPs					
                                        </Data>
                                </Cell>
                                
                <!-- create cell for each different assay. position() used to prevent repeat for every sample. 
                     for-each repeated 3 times for Reads, SNPs, & Breadth -->          
                <xsl:for-each select="//sample[position()=1]/assay">
                    
                                
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">
                                            <xsl:value-of select="@name" />				
                                        </Data>
                                </Cell>
                                
                </xsl:for-each>
                
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                
                <xsl:for-each select="//sample[position()=1]/assay">
                    
                                
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">
                                            <xsl:value-of select="@name" />				
                                        </Data>
                                </Cell>
                                
                </xsl:for-each>
                
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                
                <xsl:for-each select="//sample[position()=1]/assay">
                    
                                
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">
                                            <xsl:value-of select="@name" />				
                                        </Data>
                                </Cell>
                                
                </xsl:for-each>
                
                        </Row>
                        
                <xsl:for-each select="//analysis/sample">
                            
                        <Row ss:AutoFitHeight="0" ss:Height="18">
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="@name" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="@mapped_reads + @unmapped_reads + @unassigned_reads" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="@mapped_reads" />
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="count(assay/amplicon/snp)" />
                                        </Data>
                                </Cell>
                                
                    <xsl:for-each select="assay">
                        
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="amplicon/@reads" />
                                        </Data>
                                </Cell>
                                
                    </xsl:for-each>
                    
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                    
                    <xsl:for-each select="assay"> 
                                   
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="count(amplicon/snp)" /> 
                                        </Data>
                                </Cell>
                                
                    </xsl:for-each>
                    
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                    
                    <xsl:for-each select="assay">            
                                
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <!-- Round breadth to whole number -->
                                            <xsl:value-of select="format-number(amplicon/breadth, '##')" />
                                        </Data>
                                </Cell>
                                
                    </xsl:for-each>
                    
                        </Row>
                    
                </xsl:for-each>
                                                   
                </Table>
                
        </Worksheet>

    </Workbook>

</xsl:template>

</xsl:stylesheet>