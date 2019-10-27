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
        <xd:short> EN: Templates used to process the TEI elements of the CORE module and other
            general purpose elements not related to editorial activities. IT: I template per la
            trasformazione degli elementi TEI del modulo CORE e altri elementi di uso generale non
            legati alle attività editoriali. </xd:short>
    </xd:doc>

    <!-- NOTE Note or annotation -->
    <xsl:template match="//tei:table" mode="interp dipl #default">
        <xsl:element name="div">
            <xsl:attribute name="class" select="'table'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="//tei:table/tei:head" mode="interp dipl #default">
        <xsl:element name="div">
            <xsl:attribute name="class" select="'table-head'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="//tei:table/tei:row" mode="interp dipl #default">
        <xsl:element name="div">
            <xsl:attribute name="class" select="'table-row'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="//tei:table/tei:row/tei:cell" mode="interp dipl #default">
        <xsl:element name="div">
            <xsl:attribute name="class" select="'table-cell'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <!-- NOTE Note or annotation -->
    <xsl:template match="//tei:note" mode="interp dipl #default">
        <xsl:choose>
            <xsl:when
                test="$root//tei:ptr[@type = 'noteAnchor'][@target = concat('#', current()/@xml:id)]">
                <!-- DO NOTHING -->
                <!-- Se nel testo esiste un pointer a questa nota, la nota NON deve essere renderizzata nel punto in cui è stata codificata,
                    ma verrà visualizzata nel punto in cui compare il pointer. La sua trasformazione verrà dunque gestita dal template per il pointer -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when
                        test="node()/ancestor::tei:listPerson or node()/ancestor::tei:listPlace">
                        <xsl:apply-templates mode="#current"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="notePopup"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="notePopup">
        <xsl:element name="span">
            <xsl:attribute name="class">inline_note popup <xsl:value-of select="@type"/></xsl:attribute>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:attribute name="id">note_<xsl:value-of select="if (@xml:id) then(@xml:id) else(count(preceding::*[name() = name(current())]))"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="@type = 'critical' and @n != ''">
                    <xsl:element name="i">
                        <xsl:attribute name="class">open_note trigger</xsl:attribute>
                        <xsl:value-of select="@n"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="i">
                        <xsl:attribute name="class">fa fa-circle open_note trigger</xsl:attribute>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="span">
                <xsl:attribute name="class">text_note tooltip</xsl:attribute>
                <xsl:attribute name="id">tooltip_<xsl:value-of select="if (@xml:id) then(@xml:id) else(count(preceding::*[name() = name(current())]))"/></xsl:attribute>
                <xsl:element name="span">
                    <xsl:attribute name="class">before</xsl:attribute>
                </xsl:element>
                <xsl:element name="span">
                    <xsl:attribute name="class">tooltip_text</xsl:attribute>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:back//tei:ptr" mode="interp dipl #default">
        <xsl:choose>
            <xsl:when test="@type = 'noteAnchor'">
                <xsl:if
                    test="@target and @target != '' and $root//tei:note[@xml:id = substring-after(current()/@target, '#')]">
                    <xsl:for-each
                        select="$root//tei:note[@xml:id = substring-after(current()/@target, '#')]">
                        <xsl:call-template name="notePopup"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@target and @target != ''">
                    <xsl:choose>
                        <xsl:when test="contains(@target, 'http') or contains(@target, 'www')">
                            <xsl:element name="a">
                                <xsl:attribute name="class">ptr external_link</xsl:attribute>
                                <xsl:call-template name="dataAttributesFromAttributes"/>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="@target"/>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="@n">
                                        <xsl:attribute name="title">
                                            <xsl:value-of select="@n"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="lang">def</xsl:attribute>
                                        <xsl:attribute name="title">OPEN_WEB_PAGE</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <i class="fa fa-external-link"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="span">
                                <xsl:attribute name="class">popup image</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">trigger</xsl:attribute>
                                    <xsl:element name="i">
                                        <xsl:attribute name="class">fa fa-picture-o</xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">tooltip</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">before</xsl:attribute>
                                        <xsl:attribute name="data-target"><xsl:value-of select="@target"/></xsl:attribute>
                                        <xsl:attribute name="data-target-trans"><xsl:value-of select="translate(current()/@target, '#', '')"/></xsl:attribute>
                                    </xsl:element>
                                    <xsl:for-each select="$root//tei:item[@xml:id = translate(current()/@target, '#', '')]">
                                        <xsl:element name="img">
                                            <xsl:attribute name="src">data/input_data/<xsl:value-of select=".//tei:graphic/@url"/></xsl:attribute>
                                            <xsl:attribute name="width">180px</xsl:attribute>
                                        </xsl:element>
                                        <span class="imageDetails">
                                            <span class="head"><xsl:value-of select=".//tei:head"/></span>
                                            <span class="figDesc"><xsl:value-of select=".//tei:figDesc"/></span>
                                        </span>
                                    </xsl:for-each>
                                    <!-- aggiungere riferimento ad entita specifica e relative info  -->
                                </xsl:element>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:back//tei:ref" mode="interp dipl #default">
        <xsl:choose>
            <xsl:when test="@target[contains(., 'www')] or @target[contains(., 'http')]">
                <xsl:element name="a">
                    <xsl:attribute name="href"
                        select="
                            if (@target[contains(., 'http')]) then
                                (@target)
                            else
                                (concat('http://', @target))"/>
                    <xsl:attribute name="target" select="'_blank'"/>
                    <xsl:call-template name="dataAttributesFromAttributes"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(@target, '#')">
                <xsl:element name="span">
                    <xsl:attribute name="class">ref</xsl:attribute>
                    <xsl:call-template name="dataAttributesFromAttributes"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="//tei:castList" mode="interp dipl #default">
        <xsl:element name="div">
            <xsl:attribute name="class" select="'castList'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="//tei:castItem" mode="interp dipl #default">
        <xsl:element name="span">
            <xsl:attribute name="class" select="'castItem'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="//tei:castItem//tei:role" mode="interp dipl #default">
        <xsl:element name="span">
            <xsl:attribute name="class" select="'role'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="//tei:castItem//tei:roleDesc" mode="interp dipl #default">
        <xsl:element name="span">
            <xsl:attribute name="class" select="'roleDesc'"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="//tei:idno" mode="interp dipl #default">
        <xsl:for-each select="current()">
            <xsl:choose>
                <xsl:when test="lower-case(@type)='viaf' or lower-case(@type)='uri'">
                    <xsl:if test="lower-case(@type)='viaf'">
                        <xsl:element name="span">
                            <xsl:attribute name="class">display-block small-note</xsl:attribute>
                            <xsl:text>VIAF:&#xA0;</xsl:text>
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:text>https://viaf.org/viaf/</xsl:text>
                                    <xsl:value-of select="current()"/>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:value-of select="current()"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="lower-case(@type)='uri'">
                        <xsl:element name="span">
                            <xsl:attribute name="class">display-block small-note</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="current()"/>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:value-of select="current()"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="span">
                        <xsl:attribute name="class">display-block small-note</xsl:attribute>
                        <xsl:value-of select="current()/@type"/>
                        <xsl:text>:&#xA0;</xsl:text>
                        <xsl:value-of select="current()"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:gap" mode="interp dipl #default">
        <xsl:element name="span">
            <xsl:attribute name="class">gap</xsl:attribute>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:variable name="unit" select="@unit"/>
            <xsl:choose>
                <!-- <gap quantity=”2″ unit=”chars” reason=”illegible”/> -->
                <xsl:when test="@unit='chars'">
                    <xsl:for-each select="1 to @quantity">
                        <xsl:text>&#xA0;</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="1 to @quantity">
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="'gap-unit'"/>
                            <xsl:attribute name="data-unit" select="$unit"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>    
    </xsl:template>
    
    <xsl:template name="dataAttributesFromAttributes">
        <xsl:attribute name="data-tagName" select="name(.)"/>
        <xsl:for-each select="@*">
            <xsl:if test="name(.) != 'active' and name(.) != 'label'">
                <xsl:attribute name="data-{replace(name(.), ':', '-')}" select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
