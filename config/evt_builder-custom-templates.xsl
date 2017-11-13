<?xml version="1.0" encoding="UTF-8"?>
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
                EN: This file has been prepared for you to add your personal XSLT templates
                IT: Questo file è stato predisposto per accogliere template personalizzati
            </xd:short>
        </xd:doc>
    <!-- In order to make it work properly you need to add mode="interp dipl #default" to each template -->
    
    
    <!--******CORRELATORE PER LA PARTE INFORMATICA: serve per lo sviluppo dell'agoritmo di ordinamento?*******-->
    
    <xsl:param name="list_doc" select="true()"/>
    
    <xsl:output indent="yes" method="html" encoding="UTF-8" media-type="text/plain"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
     
    <xsl:template match="/" priority="9" mode="interp dipl #default">
    <xsl:if test="$list_doc=true()">
        <xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listDoc.html" indent="yes">
            <xsl:element name="div">
                <xsl:attribute name="id">listDoc</xsl:attribute>
                <xsl:attribute name="class">can-change-font-size</xsl:attribute>
                <xsl:call-template name="listDoc"></xsl:call-template>
            </xsl:element>
        </xsl:result-document>
    </xsl:if>
    </xsl:template>
    
    <xsl:template name="listDoc">
        <xsl:element name="ul">
            <xsl:attribute name="id" select="'ul_listDocument'"/>
            <xsl:attribute name="class" select="'ul_list'"/>
            <xsl:for-each select="$root//tei:text/tei:group/tei:text"><!--Se non c'è group non ha senso, giusto?-->
                <xsl:element name="li">
                    <xsl:attribute name="id" select="@xml:id" />
                    <xsl:attribute name="class" select="'list_element'"/>
                    <!--<xsl:attribute name="data-order-list" select=""/>--><!--Per l'ordinamento questo ci va?-->
                    <!--<xsl:value-of select="substring(@xml:id, 1, 1)"/>-->
                    <xsl:call-template name="document" />
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="document">
            <xsl:choose>
                <xsl:when test="current()//tei:front">
                    
                    <!--per la numerazione nuova e originale-->
                    <xsl:element name="span"> <!--la numerazione originale e quella nuova vanno in span diversi per l'ordinamento?-->
                        <xsl:attribute name="class">document_list_info <xsl:if test="$list_doc=true()"> link_active</xsl:if></xsl:attribute>
                        <xsl:attribute name="data-ref"><!--va replicato?-->
                            <xsl:value-of select="@xml:id" />
                        </xsl:attribute>
                        <xsl:if test="current()//tei:titlePart[@type='numerazioneNuova']">
                            <xsl:value-of select="tei:front//tei:titlePart[@type='numerazioneNuova']"/>
                        </xsl:if>
                        <xsl:if test="current()//tei:titlePart[@type='numerazioneOrig']">
                            <xsl:text>&#xA0;-&#xA0;</xsl:text><xsl:value-of select="tei:front//tei:titlePart[@type='numerazioneOrig']"/>
                        </xsl:if>
                    </xsl:element>	
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class">document_list_info</xsl:attribute>
                        <xsl:if test="current()//tei:docDate">
                            <xsl:if test="current()//tei:docDate//tei:date">
                                <xsl:for-each select="current()//tei:docDate//tei:date">
                                    <!--<xsl:choose>-->
                                        <!--<xsl:when test="current()//tei:docDate//tei:date[@when]">-->
                                            <xsl:value-of select="tei:front//tei:docDate//tei:date/@when"/>
                                        <!--</xsl:when>-->
                                        <!--
                                        <xsl:when test="tei:date[@notBefore] and tei:date[@notAfter]">
                                            <xsl:value-of select="tei:front//tei:docDate//tei:date/@notBefore"/>
                                            <xsl:text>&#xA0;-&#xA0;</xsl:text>
                                            <xsl:value-of select="tei:front//tei:docDate//tei:date/@notAfter"/>
                                        </xsl:when>
                                        <xsl:when test="tei:date[@from] and tei:date[@to]">
                                            <xsl:value-of select="tei:front//tei:docDate//tei:date/@from"/>
                                            <xsl:text>&#xA0;-&#xA0;</xsl:text>
                                            <xsl:value-of select="tei:front//tei:docDate//tei:date/@to"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="tei:front//tei:docDate//tei:date"/>
                                        </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:for-each>
                                </xsl:if></xsl:choose>--></xsl:for-each>
                        </xsl:if>
                        </xsl:if>
                    </xsl:element>
                  </xsl:when>
        <xsl:otherwise>    
                    <xsl:element name="span">
                        <xsl:attribute name="class">display-block</xsl:attribute>
                        <span lang="def">NO_INFO</span>
                        <xsl:text>.</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>