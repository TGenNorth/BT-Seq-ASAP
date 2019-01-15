<?xml version="1.0"?>

<!--
    Document   : BurkNN_ExcelResults_Target_Coverage.xsl
    Created on : July 28, 2015, 11:20 AM
    Author     : Matthew Enright
    Description:
        Transform xml to excel xml for user friendly viewing of information (based on Jim Schupp's Burk spreadsheet format)
        Target Coverage Output Results
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
                <Style ss:ID="s26">
                        <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
                       ss:Bold="1"/>
                </Style>
                <Style ss:ID="s27">
                        <Alignment ss:Horizontal="Center"/>
                        <Borders>
                            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
                            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
                       </Borders>
                        <Font ss:Size="11" ss:Bold="1" />
                </Style>
        </Styles>
        
        <!-- assays variable used to count number of different assays in analysis. count() --> 
        
        <xsl:variable
                name="assays"
                select="(count(//analysis/sample/assay) div count(//analysis/sample))-1"/>
        
        <xsl:variable
                name="coverage"
                select="75"/>
        
        <xsl:variable
                name="bp"
                select="(count(//analysis/sample[position()=1]/assay[contains(@name, 'Bp_')]))-1"/>

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
                                
                                <!-- merge cell across based on assays variable value -->
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$assays}">
                                        <Data ss:Type="String">Target Coverage 					
                                        </Data>
                                </Cell>
                        </Row>
                        <Row ss:AutoFitHeight="0" ss:Height="18">
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Target ID
                                        </Data>
                                </Cell>
                                <!-- Increment target id for each species -->
                                <xsl:for-each select="//sample[position()=1]/assay">
                                    
                                    <xsl:variable name="i" select="position()-1" />
                   
                                    <Cell ss:StyleID="s27">
                                            <Data ss:Type="String">
                                                <xsl:value-of select="$i"/>				
                                            </Data>
                                    </Cell>
                                
                                </xsl:for-each>
                        </Row>
    <!--                    <Row ss:AutoFitHeight="0" ss:Height="18">
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                <Cell>
                                        <Data ss:Type="String">
                                        </Data>
                                </Cell>
                                
                                <Cell ss:StyleID="s22" ss:MergeAcross="1">
                                        <Data ss:Type="String">IPSC 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Pseudomallei Only 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Pseudomallei/Mallei 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Mallei 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Thailandensis 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Humptydoo 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">264 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Oklahomensis 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">175 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Vietnamiensis 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Ubonensis 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Cep 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">Virulence Genes 					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="{$bp}">
                                        <Data ss:Type="String">MLST 					
                                        </Data>
                                </Cell>
                                  
                        </Row>
    -->    
                        <Row ss:AutoFitHeight="0" ss:Height="120">
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Sample Name					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">Target Coverage Flag (&lt;<xsl:value-of select="$coverage"/>%)					
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
                                
                        </Row>
              
         
                <xsl:for-each select="//analysis/sample">
                            
                        <Row ss:AutoFitHeight="0" ss:Height="18">
                                <Cell>
                                        <Data ss:Type="String"> 
                                            <xsl:value-of select="@name" />
                                        </Data>
                                </Cell>
                                
                                <xsl:choose>
                                    <xsl:when test="count(assay[not(contains(@name, 'Bpm_MLST')) and not(contains(@name, 'Bvir'))]/amplicon[breadth != 0 and breadth &lt; 75]) &gt; 0">

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