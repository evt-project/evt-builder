<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:eg="http://www.tei-c.org/ns/Examples" 
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all">

    <xd:doc type="stylesheet">
        <xd:short>
                EN: This file has been prepared for you to add your personal XSLT templates
                IT: Questo file è stato predisposto per accogliere template personalizzati
        </xd:short>
    </xd:doc>
    <!-- In order to make it work properly you need to add mode="interp dipl #default" to each template -->
    
    <!-- The following XSLT template are provided as an example to transform elements within the <titlePage> -->
    <xsl:template match="tei:docImprint" mode="interp dipl #default">
        <div class="docImprint">
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:byline" mode="interp dipl #default">
        <div class="docImprint">
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:docAuthor" mode="interp dipl #default" priority="9">
        <div class="docImprint">
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:docEdition" mode="interp dipl #default">
        <div class="docImprint">
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:ex" mode="interp dipl #default" priority="9">
        <xsl:element name="span">
            <!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->
            <xsl:attribute name="class" select="name()"/>
            <xsl:call-template name="dataAttributesFromAttributes"/>
            <xsl:text>(</xsl:text><xsl:apply-templates mode="#current"/><xsl:text>)</xsl:text>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
