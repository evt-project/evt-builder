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
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all">
    
    <xd:doc type="stylesheet">
        <xd:short>
            EN: Template to add at every line of the text the HTML elements that are necessary for the correct formatting.
            IT: Template per aggiungere ad ogni linea di testo gli elementi HTML div necessari per la formattazione.
        </xd:short>
    </xd:doc>
    
    <xsl:template name="divLine">
        <xsl:param name="text"/>
        <xsl:param name="ed_name"/>
        
        <xsl:for-each-group select="$text/node()" group-starting-with="//tei:lb">
            <xsl:choose>
                <xsl:when test="self::tei:lb">
                    <xsl:copy-of select="current-group()/self::tei:lb"/> <!-- IT: copia lb -->
                    <xsl:element name="div">
                        <xsl:attribute name="class" select="concat($ed_name, ' line')"/>
                        <xsl:if test="@type">
                            <xsl:attribute name="data-type" select="@type"/>
                        </xsl:if>
                        <xsl:if test="@rend">
                            <xsl:attribute name="data-rend" select="@rend"/>
                        </xsl:if>
                        <xsl:if test="@rendition">
                            <xsl:attribute name="data-rendition" select="@rendition"/>
                        </xsl:if>
                        <xsl:if test="current-group()/self::node()[name()='span'][@class=concat($ed_name,'-lineN')]">
                            <xsl:copy-of select="current-group()/self::node()[name()='span'][@class=concat($ed_name,'-lineN')]"></xsl:copy-of> <!-- IT: copia n linea -->
                        </xsl:if>
                        <xsl:element name="div"> <!-- IT: aggiungi div con classe edition_rend -->
                            <xsl:attribute name="class" select="if(tei:lb[@rend]) then ($ed_name1, translate(tei:lb/@rend, '.', '_')) else ($ed_name, 'left')" separator="-"/>
                            <xsl:copy-of select="current-group()[not(self::tei:lb)] [not(self::node()[name()='span'][@class=concat($ed_name,'-lineN')])]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise> <!--IT: Gruppo che non ha un lb (puo succedere nel primo gruppo)  -->
                    <xsl:copy-of select="current-group()"></xsl:copy-of>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    
    <xsl:template name="divCb">
        <xsl:param name="text"/>
        <xsl:param name="ed_name"/>
        <xsl:for-each-group select="$text/node()" group-starting-with="//tei:cb">
            <xsl:choose>
                <xsl:when test="self::tei:cb">
                    <xsl:element name="div">
                        <xsl:attribute name="class" select="$ed_name"/>
                        <xsl:element name="div"> <!-- IT: aggiungi div con classe edition_rend -->
                            <xsl:attribute name="class" select="if(@rend) then ($ed_name1, 'column', translate(@rend, '.', '_')) else ($ed_name, 'column', 'left')" separator="-"/>
                            <xsl:copy-of select="current-group()[not(self::tei:cb)]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise> <!--IT: Gruppo che non ha un lb (puo succedere nel primo gruppo)  -->
                    <xsl:copy-of select="current-group()"></xsl:copy-of>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>