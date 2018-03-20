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
            EN: Templates used to process the TEI elements of the CORE module and other general purpose elements not related to editorial activities.
            IT: I template per la trasformazione degli elementi TEI del modulo CORE e altri elementi di uso generale non legati alle attività editoriali.
        </xd:short>
    </xd:doc>

    <!-- NOTE Note or annotation -->
    <xsl:template match="//tei:table" mode="interp dipl #default">
        <div class="table">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <xsl:template match="//tei:table/tei:head" mode="interp dipl #default">
        <div class="table-head">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <xsl:template match="//tei:table/tei:row" mode="interp dipl #default">
        <div class="table-row">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <xsl:template match="//tei:table/tei:row/tei:cell" mode="interp dipl #default">
        <div class="table-cell">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <!-- NOTE Note or annotation -->
    <xsl:template match="//tei:note" mode="interp dipl #default">
        <xsl:choose>
            <xsl:when test="$root//tei:ptr[@type='noteAnchor'][@target=concat('#',current()/@xml:id)]">
                <!-- DO NOTHING -->
                <!-- Se nel testo esiste un pointer a questa nota, la nota NON deve essere renderizzata nel punto in cui è stata codificata,
                    ma verrà visualizzata nel punto in cui compare il pointer. La sua trasformazione verrà dunque gestita dal template per il pointer -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="node()/ancestor::tei:listPerson or node()/ancestor::tei:listPlace">
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
            <xsl:attribute name="class">
                inline_note popup
                <xsl:value-of select="@type"/>
            </xsl:attribute>

            <xsl:attribute name="id">note_<xsl:value-of select="if(@xml:id) then (@xml:id) else (count(preceding::*[name() = name(current())]))"></xsl:value-of></xsl:attribute>
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
                <xsl:attribute name="id">
                    <xsl:value-of select="./@xml:id"/>
                </xsl:attribute>
                <xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
                <xsl:element name="span">
                    <xsl:attribute name="class">tooltip_text</xsl:attribute>
                    <xsl:apply-templates mode="#current"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
