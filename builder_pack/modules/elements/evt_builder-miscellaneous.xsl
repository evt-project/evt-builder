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
            EN: Templates used to process the TEI elements of the CORE module.
            IT: I template per la trasformazione degli elementi TEI del modulo CORE.
        </xd:short>
    </xd:doc>
    
    
    <!-- NOTE Note or annotation -->
    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test="node()/ancestor::tei:listPerson or node()/ancestor::tei:listPlace">
                <xsl:apply-templates mode="#current"/>
            </xsl:when>
            <xsl:otherwise>
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
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>