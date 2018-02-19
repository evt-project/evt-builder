<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Copyright (C) 2013-2017 the EVT Development Team.
    
    EVT 1 is free software: you can redistribute it 
    and/or modify it under the terms of the 
    GNU General Public License version 2
    available in the LICENSE file (or see <http://www.gnu.org/licenses/>).
    
    EVT 1 is distributed in the hope that it will be useful, 
    but WITHOUT ANY WARRANTY; without even the implied 
    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the GNU General Public License for more details. 
-->
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all">
        
        <xd:doc type="stylesheet">
            <xd:short>
                EN: Templates for the creation of structure.xml file
                IT: Templates per la generazione del file structure.xml
            </xd:short>
        </xd:doc>
        
    <!-- All -->
    <xd:doc>
        <xd:short>
            IT: 
        </xd:short>
        <xd:detail>
            IT: 
        </xd:detail>
    </xd:doc>
    
    <xsl:template name="getLastPb">
        <xsl:choose>
            <xsl:when test="current()/tei:body/descendant::tei:pb">
                <xsl:attribute name="n" select="if(current()/descendant::tei:pb[last()]/@n) then(current()/descendant::tei:pb[last()]/@n) else(current()/descendant::tei:pb[last()]/@xml:id)"></xsl:attribute>
                <xsl:value-of select="current()/descendant::tei:pb[last()]/@xml:id"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="current()/preceding-sibling::tei:text[1]">
                    <xsl:call-template name="getLastPb"></xsl:call-template>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="generatePbElement">
        <xsl:param name="pb"/>
        <xsl:param name="position"/>
        <xsl:attribute name="n">
            <xsl:choose>
                <xsl:when test="$pb/@n">
                    <xsl:value-of select="$pb/@n"/>
                </xsl:when>
                <xsl:when test="$pb/@xml:id">
                    <xsl:value-of select="$pb/@xml:id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$position"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="$pb/@xml:id">
                <xsl:value-of select="$pb/@xml:id"/>        
            </xsl:when>
            <xsl:when test="$pb/@n">
                <xsl:value-of select="$pb/@n"/>
            </xsl:when>
            <xsl:when test="$pb/@facs">
                <xsl:value-of select="$pb/@facs"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$position"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*" mode="structure_generation">
        <xsl:result-document method="xml" href="{$filePrefix}/data/output_data/structure.xml" indent="yes">
            <xml>
                <!-- Integrazione by AB -->
                <xsl:if test="$msDesc=true()">
                    <msDesc active="1"/>
                </xsl:if>
                <xsl:if test="$headerInfo=true()">
                    <headerInfo active="1"/>
                </xsl:if>
                <!-- /end Integrazione by AB -->
                
                <xsl:if test="$frontInfo=true()">
                    <front active="1" />
                </xsl:if>
                
                <xsl:if test="$regesto=true()">
                    <regesto active="1" />
                </xsl:if>
                <liste>
                    <xsl:if test="$list_person=true()">
                        <listPerson active="1" lang="def">LIST_PERSON</listPerson>
                    </xsl:if>
                    <xsl:if test="$list_place=true()">
                        <listPlace active="1" lang="def">LIST_PLACE</listPlace>
                    </xsl:if>
                    <xsl:if test="$list_org=true()">
                        <listOrg active="1" lang="def">LIST_ORG</listOrg>
                    </xsl:if>
                    <xsl:if test="$list_term=true()"> 
                        <listTerm active="1" lang="def">LIST_TERM</listTerm> 
                    </xsl:if> 
                    <xsl:if test="$list_gloss=true()"> 
                        <listGloss active="1" lang="def">LIST_GLOSS</listGloss> 
                    </xsl:if>
                </liste>
                <editions>
                    <xsl:for-each select="$edition_array">
                        <xsl:if test="./normalize-space()"><edition><xsl:value-of select="."/></edition></xsl:if>
                    </xsl:for-each>
                </editions>
                <textpage>
                    <xsl:if test="$root//tei:sourceDoc">
                        <xsl:for-each select="$root//tei:sourceDoc">
                            <text>
                                <xsl:attribute name="n" select="if(@xml:id) then(@xml:id) else(count(preceding-sibling::tei:sourceDoc) + 1)"/>
                                <xsl:attribute name="label">
                                    <xsl:choose>
                                        <xsl:when test="@n">
                                            <xsl:value-of select="@n"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="generateTextLabel">
                                                <xsl:with-param name="text_id"><xsl:value-of select="if(@xml:id) then(@xml:id) else(concat('text_',count(preceding-sibling::tei:text) + 1))"/></xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:for-each select="current()/child::node()">
                                    <xsl:call-template name="textFromSourceDoc"></xsl:call-template>
                                </xsl:for-each>
                            </text>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$root//tei:text">
                        <xsl:choose>
                            <xsl:when test="$root//tei:text/tei:group">
                                <!-- Gestione TEXT multipli in tei:group -->
                                <xsl:for-each select="$root//tei:text/tei:group/tei:text">
                                    <xsl:call-template name="generateTextStructure"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="count(//tei:body/tei:div[@subtype='edition_text'])>1">
                                <xsl:for-each select="$root//tei:body/tei:div[@subtype='edition_text']">
                                    <text>
                                        <xsl:attribute name="n" select="if(@xml:id) then(@xml:id) else(count(preceding-sibling::tei:text) + 1)"/>
                                        <xsl:attribute name="label">
                                            <xsl:choose>
                                                <xsl:when test="@n">
                                                    <xsl:value-of select="@n"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:call-template name="generateTextLabel">
                                                        <xsl:with-param name="text_id"><xsl:value-of select="if(@xml:id) then(@xml:id) else(concat('text_',count(preceding-sibling::tei:text) + 1))"/></xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:for-each select=".//tei:pb">
                                            <pb>
                                                <xsl:call-template name="generatePbElement">
                                                    <xsl:with-param name="pb" select="current()"/>
                                                    <xsl:with-param name="position" select="position()"/>
                                                </xsl:call-template>
                                            </pb>
                                        </xsl:for-each>
                                    </text>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Gestione TEXT singolo -->
                                <xsl:for-each select="$root//tei:text">
                                    <xsl:call-template name="generateTextStructure"/>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </textpage>
                <pages>
                    <xsl:if test="$root//tei:sourceDoc">
                        <xsl:for-each select="$root//tei:sourceDoc">
                            <xsl:for-each select="child::node()">
                                <xsl:call-template name="pagesFromSourceDoc"></xsl:call-template>
                            </xsl:for-each>
                        </xsl:for-each>
                        
                    </xsl:if>
                    <xsl:if test="$root//tei:text">
                        <!-- IT: Crea un nuovo gruppo ogni volta che trova un pb con attributo @n che: - finisce con v (104v seguito da 105v vengno inseriti in due gruppi diversi)
                                                                                                       - finisce con r, ma è preceduto da un pb che non finisce con v (104r e 105r vengno inseriti in due gruppi diversi)
                                                                                                       - finisce con r, è preceduto da un pb che finisce con v, ma il numero del @n che finisce con r non è consecutivo a quello del @n che finisce con v (104v e 106r vengno inseriti in due gruppi diversi)
                                                                                                       - non finisce né con v né con r (104 e 105 vengno inseriti in due gruppi diversi)
                        -->
                        <xsl:for-each-group select="$step0//tei:pb" 
                            group-starting-with="node()[ends-with(@n, 'v') 
                                                    or (ends-with(@n, 'r') and not(preceding-sibling::tei:pb[1][ends-with(@n, 'v')]) )
                                                    or (ends-with(@n, 'r') and preceding-sibling::tei:pb[1][ends-with(@n, 'v')] and not( number(translate(@n,'r',''))= number(translate(preceding-sibling::tei:pb[1]/@n,'v',''))+1))
                                                    or (not (ends-with(@n, 'v') or ends-with(@n, 'r')))]" >
                            <pair>
                                <xsl:for-each select="current-group()/self::tei:pb">
                                    <pb>
                                        <xsl:call-template name="generatePbElement">
                                            <xsl:with-param name="pb" select="current()"/>
                                            <xsl:with-param name="position" select="position()"/>
                                        </xsl:call-template>
                                        <!--<xsl:attribute name="n" select="@n"/>
                                        <xsl:choose>
                                            <xsl:when test="@xml:id">
                                                <xsl:value-of select="@xml:id"/>        
                                            </xsl:when>
                                            <xsl:when test="@n">
                                                <xsl:value-of select="@n"/>
                                            </xsl:when>
                                            <xsl:when test="@facs">
                                                <xsl:value-of select="@facs"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="position()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>-->
                                    </pb>
                                </xsl:for-each>
                            </pair>
                        </xsl:for-each-group>
                    </xsl:if>
                </pages>
            </xml>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="generateTextStructure">
        <text>
            <xsl:attribute name="n">
                <xsl:choose>
                    <xsl:when test="current()/@xml:id">
                        <xsl:value-of select="current()/@xml:id"/>
                    </xsl:when>
                    <xsl:when test="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id">
                        <xsl:value-of select="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="count(preceding-sibling::tei:text) + 1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <xsl:attribute name="label">
                <xsl:choose>
                    <xsl:when test="current()/@n">
                        <xsl:value-of select="current()/@n"/>
                    </xsl:when>
                    <xsl:when test="current()/tei:body/tei:div[@subtype='edition_text']/@n">
                        <xsl:value-of select="current()/tei:body/tei:div[@subtype='edition_text']/@n"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="generateTextLabel">
                            <xsl:with-param name="text_id">
                                <xsl:choose>
                                    <xsl:when test="current()/@xml:id">
                                        <xsl:value-of select="current()/@xml:id"/>
                                    </xsl:when>
                                    <xsl:when test="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id">
                                        <xsl:value-of select="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('text_',count(preceding-sibling::tei:text) + 1)"/>
                                    </xsl:otherwise>
                                </xsl:choose>    
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <xsl:if test="not(current()/tei:body/child::*[1][self::tei:pb]) and not(current()/tei:body/tei:div/child::*[1][self::tei:pb]) and not(current()/tei:body/tei:div/child::*[1][self::tei:p]/child::*[1][self::tei:pb]) and not(current()/tei:body/tei:div/child::*[1][self::tei:div]/child::*[1][self::tei:pb])">
                <pb>
                    <xsl:choose>
                        <xsl:when test="current()/preceding-sibling::tei:text[1]/descendant::tei:pb">
                            <xsl:call-template name="generatePbElement">
                                <xsl:with-param name="pb" select="current()/preceding-sibling::tei:text[1]/descendant::tei:pb[last()]"/>
                                <xsl:with-param name="position" select="current()/preceding-sibling::tei:text[1]/descendant::tei:pb[last()]/position()"/>
                            </xsl:call-template>
                            <!--<xsl:attribute name="n" select="if(current()/preceding-sibling::tei:text[1]/descendant::tei:pb[last()]/@n) then (current()/preceding-sibling::tei:text[1]/descendant::tei:pb[last()]/@n) else (current()/preceding-sibling::tei:text[1]/descendant::tei:pb[last()]/@xml:id)"></xsl:attribute>
                                                        <xsl:value-of select="current()/preceding-sibling::tei:text[1]/descendant::tei:pb[last()]/@xml:id"></xsl:value-of>-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="current()/preceding-sibling::tei:text[1]">
                                <xsl:call-template name="getLastPb"></xsl:call-template>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </pb>
            </xsl:if>
            <xsl:for-each select=".//tei:pb">
                <pb>
                    <xsl:call-template name="generatePbElement">
                        <xsl:with-param name="pb" select="current()"/>
                        <xsl:with-param name="position" select="position()"/>
                    </xsl:call-template>
                    <!--<xsl:attribute name="n" select="if(@n) then(@n) else(@xml:id)"></xsl:attribute>
                                                <xsl:value-of select="@xml:id"></xsl:value-of>-->
                </pb>
            </xsl:for-each>
        </text>
    </xsl:template>
    
    <!-- IT: ricorsione per generare correttamente gli elementi di <text> nella ET -->
    <xsl:template name="textFromSourceDoc">
        <xsl:if test="self::tei:surface">
            <xsl:for-each select="current()">
                <pb>
                    <xsl:call-template name="generatePbElement">
                        <xsl:with-param name="pb" select="current()"/>
                        <xsl:with-param name="position" select="position()"/>
                    </xsl:call-template>
                    <!--<xsl:attribute name="n" select="@n"></xsl:attribute>
                    <xsl:value-of select="@xml:id"></xsl:value-of>-->
                </pb>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="self::tei:surfaceGrp[tei:surface]">
            <xsl:for-each select="current()/node()">
                <xsl:call-template name="textFromSourceDoc"></xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- IT: ricorsione per generare correttamente gli elementi ti <pages> nella ET-->
    <xsl:template name="pagesFromSourceDoc">
        <xsl:if test="self::tei:surface">
            <xsl:call-template name="surfaceStructure" />
        </xsl:if>
        <xsl:if test="self::tei:surfaceGrp[tei:surface]">
            <xsl:for-each select="current()/node()">
                <xsl:call-template name="pagesFromSourceDoc" />
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- IT: generazione <pair> nella ET-->
    <xsl:template name="surfaceStructure">
        <xsl:choose>
            <xsl:when test="(ends-with(@n, 'r')) or (ends-with(@n, 'v'))">
                <xsl:if test="(ends-with(@n, 'r')) and not(current()/preceding-sibling::tei:surface[1][ends-with(@n, 'v')])">
                    <pair>
                        <pb>
                            <xsl:call-template name="generatePbElement">
                                <xsl:with-param name="pb" select="current()"/>
                                <xsl:with-param name="position" select="position()"/>
                            </xsl:call-template>
                            <!--<xsl:attribute name="n" select="@n"></xsl:attribute>
                            <xsl:value-of select="@xml:id"></xsl:value-of>-->
                        </pb>
                    </pair>
                </xsl:if>
                <xsl:if test="ends-with(@n, 'v')">
                    <pair>
                        <pb>
                            <xsl:call-template name="generatePbElement">
                                <xsl:with-param name="pb" select="current()"/>
                                <xsl:with-param name="position" select="position()"/>
                            </xsl:call-template>
                            <!--<xsl:attribute name="n" select="@n"></xsl:attribute>
                            <xsl:value-of select="@xml:id"></xsl:value-of>-->
                        </pb>
                        <xsl:if test="current()/following-sibling::tei:surface[1][ends-with(@n, 'r')]">
                            <!-- <pb><xsl:value-of select="current()/following-sibling::tei:surface[1]/@n"></xsl:value-of></pb> -->
                            <pb>
                                <xsl:call-template name="generatePbElement">
                                    <xsl:with-param name="pb" select="current()/following-sibling::tei:surface[1]"/>
                                    <xsl:with-param name="position" select="current()/following-sibling::tei:surface[1]/position()"/>
                                </xsl:call-template>
                                
                                <!--<xsl:attribute name="n" select="current()/following-sibling::tei:surface[1]/@n"></xsl:attribute>
                                <xsl:value-of select="current()/following-sibling::tei:surface[1]/@xml:id"></xsl:value-of>-->
                            </pb>
                        </xsl:if>
                    </pair>
                </xsl:if> 
            </xsl:when>
            <xsl:otherwise>
                <pair>
                    <pb>
                        <xsl:call-template name="generatePbElement">
                            <xsl:with-param name="pb" select="current()"/>
                            <xsl:with-param name="position" select="position()"/>
                        </xsl:call-template>
                        <!--<xsl:attribute name="n" select="@n"></xsl:attribute>
                        <xsl:value-of select="@xml:id"></xsl:value-of>-->
                    </pb>
                </pair>
            </xsl:otherwise>
        </xsl:choose><!-- per gestire i casi in cui la prima pagina è il recto, ovvero quella di destra -->
    </xsl:template>
</xsl:stylesheet>