<?xml version="1.0"?>

<!--
    Document   : BurkNN_ExcelResults_SpeciesPresence.xsl
    Created on : August 25, 2015, 11:20 AM
    Author     : Matthew Enright
    Description:
        Transform xml to excel xml for user friendly viewing of information (based on Jim Schupp's Burk spreadsheet format)
        Species Presence/Absence output results 
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
                <Style ss:ID="s25" ss:Name="Percent">
                        <NumberFormat ss:Format="0%"/>
                </Style>
                <Style ss:ID="s26">
                        <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
                       ss:Bold="1"/>
                </Style>
        </Styles>
        
        <!-- assays variable used to count number of different assays in analysis. count() --> 
        
    <!--    <xsl:variable
                name="assays"
                select="(count(//analysis/sample/assay) div count(//analysis/sample))-1"/>  -->
        
        <xsl:variable
                name="reads"
                select="10"/>

        <!-- shorten worksheet name in case of long names to avoid error when opening in excel -->
        <Worksheet ss:Name="{substring(//analysis/@run_name, 0, 27)}...">
            
                <Table>
                        <Column ss:AutoFitWidth="0" ss:Width="210" />
                        <Column ss:AutoFitWidth="0" ss:Width="110" />
                        <Column ss:AutoFitWidth="0" ss:Width="110" />

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
                                                            
                                <!-- merge cell across based on assays -->
                                <Cell ss:StyleID="s22" ss:MergeAcross="19">
                                        <Data ss:Type="String">Species Presence/Absence	(><xsl:value-of select="$reads"/> reads)				
                                        </Data>
                                </Cell>
                        </Row>
                        <Row ss:AutoFitHeight="0" ss:Height="120">
                                <Cell ss:StyleID="s22">
                                        <Data ss:Type="String">Sample Name					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s22" ss:MergeAcross="1">
                                        <Data ss:Type="String">Species/Mixture (&gt; 50%)					
                                        </Data>
                                </Cell>
                                                           
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">IPSC-1 success = 1				
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">IPSC-2 success = 1					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bp targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bp/m targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bm targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bt all targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bt all targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bt small targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bh targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% B264 targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bo targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bo-like targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% B175 targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bv targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bu all targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bu large targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bu small targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% Bc targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% vir targets					
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s23">
                                        <Data ss:Type="String">% MLST targets					
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
                                <Cell>
                                    
                                    <xsl:choose>
                                    <xsl:when test="(count(assay[contains(@name, 'Bp_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bp_')])) &gt; .5">

                                        <Data ss:Type="String">pseudomallei
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'Bpm_C')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bpm_C')])) &gt; .5">

                                        <Data ss:Type="String">pseudomallei/mallei
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'Bm_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bm_')])) &gt; .5">

                                        <Data ss:Type="String">mallei
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'thai_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'thai_')])) &gt; .5">

                                        <Data ss:Type="String">thailandensis
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'HUMPTY')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'HUMPTY')])) &gt; .5">

                                        <Data ss:Type="String">humptydoo
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'MSMB264')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'MSMB264')])) &gt; .5">

                                        <Data ss:Type="String">264
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'OK_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'OK_')])) &gt; .5">

                                        <Data ss:Type="String">oklahomensis
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'MSMB175')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'MSMB175')])) &gt; .5">

                                        <Data ss:Type="String">175
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'vietnam')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'vietnam')])) &gt; .5">

                                        <Data ss:Type="String">vietnamiensis
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'ubon_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'ubon_')])) &gt; .5">

                                        <Data ss:Type="String">ubonensis
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'cepacia_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'cepacia_')])) &gt; .5">

                                        <Data ss:Type="String">cep
                                        </Data>

                                    </xsl:when>
                                </xsl:choose>
                                        
                                </Cell>
                                <Cell>
                                    
                                    <xsl:choose>
                                    <xsl:when test="(count(assay[contains(@name, 'cepacia_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'cepacia_')])) &gt; .5">

                                        <Data ss:Type="String">cep
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'ubon_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'ubon_')])) &gt; .5">

                                        <Data ss:Type="String">ubonensis
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'vietnam')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'vietnam')])) &gt; .5">

                                        <Data ss:Type="String">vietnamiensis
                                        </Data>

                                    </xsl:when>    
                                    <xsl:when test="(count(assay[contains(@name, 'MSMB175')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'MSMB175')])) &gt; .5">

                                        <Data ss:Type="String">175
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'OK_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'OK_')])) &gt; .5">

                                        <Data ss:Type="String">oklahomensis
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'MSMB264')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'MSMB264')])) &gt; .5">

                                        <Data ss:Type="String">264
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'HUMPTY')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'HUMPTY')])) &gt; .5">

                                        <Data ss:Type="String">humptydoo
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'thai_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'thai_')])) &gt; .5">

                                        <Data ss:Type="String">thailandensis
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'Bm_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bm_')])) &gt; .5">

                                        <Data ss:Type="String">mallei
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'Bpm_C')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bpm_C')])) &gt; .5">

                                        <Data ss:Type="String">pseudomallei/mallei
                                        </Data>

                                    </xsl:when>
                                    <xsl:when test="(count(assay[contains(@name, 'Bp_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bp_')])) &gt; .5">

                                        <Data ss:Type="String">pseudomallei
                                        </Data>

                                    </xsl:when>
                                 
                                </xsl:choose>
                                
                                </Cell>
                                
                                <!-- 0 or 1 used to indicate presence/absence of IPSC-1/2 based on whether reads > $reads value-->
                                <xsl:choose>
                                    <xsl:when test="assay[position()=1]/amplicon/@reads &gt; $reads">

                                        <Cell>
                                                <Data ss:Type="Number">1</Data>
                                        </Cell>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        
                                        <Cell>
                                                <Data ss:Type="Number">0</Data>
                                        </Cell>
                                        
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                                <xsl:choose>
                                    <xsl:when test="assay[position()=2]/amplicon/@reads &gt; $reads">

                                        <Cell>
                                                <Data ss:Type="Number">1</Data>
                                        </Cell>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        
                                        <Cell>
                                                <Data ss:Type="Number">0</Data>
                                        </Cell>
                                        
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!-- For each sample, count the number of amplicon reads > $reads value for each assay/species 
                                and divide by # of species to get % of species hit for each sample-->
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bp_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bp_')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bpm_C')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bpm_C')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bm_')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bm_')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'thai_all')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'thai_all')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'thai_large')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'thai_large')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'thai_small')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'thai_small')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'HUMPTY')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'HUMPTY')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'MSMB264')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'MSMB264')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'OK_c')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'OK_c')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'OK_like')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'OK_like')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'MSMB175')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'MSMB175')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'vietnam')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'vietnam')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'ubon_all')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'ubon_all')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'ubon_large')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'ubon_large')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'ubon_small')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'ubon_small')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'cepacia')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'cepacia')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bvir')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bvir')])" />
                                        </Data>
                                </Cell>
                                <Cell ss:StyleID="s25">
                                        <Data ss:Type="Number"> 
                                            <xsl:value-of select="count(assay[contains(@name, 'Bpm_MLST')]/amplicon[@reads &gt; $reads]) div count(assay[contains(@name, 'Bpm_MLST')])" />
                                        </Data>
                                </Cell>
                          
                        </Row>
                        
                    </xsl:for-each>
                       
                </Table>
                
        </Worksheet>

    </Workbook>
                                
  </xsl:template>

</xsl:stylesheet>
