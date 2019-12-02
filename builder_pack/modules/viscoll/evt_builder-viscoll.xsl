<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:eg="http://www.tei-c.org/ns/Examples" 
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all">

    <xsl:template name="viscoll">
        <xsl:variable name="viscoll_final_path">
            <xsl:choose>
                <xsl:when test="contains($viscoll_scheme_path, 'http') or contains($viscoll_scheme_path, 'www')">
                    <xsl:value-of select="$viscoll_scheme_path"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('../../../data/input_data/', $viscoll_scheme_path)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="path" select="doc($viscoll_final_path)"/>
        <!-- Definisco variabile viscoll_process4 per la trasformazione process4.xsl-->
        <!-- Gli associo il percorso del file con attributo mode, 
            cioè il modello da applicare, in base al tipo e al contesto di ogni nodo selezionato. -->
        <xsl:variable name="viscoll_process4">
            <xsl:apply-templates select="$path" mode="viscoll4"/>
        </xsl:variable>
        <xsl:variable name="viscoll_process5">
            <xsl:apply-templates select="$viscoll_process4" mode="viscoll5"/>
        </xsl:variable>
        <xsl:variable name="viscoll_process6">
            <xsl:apply-templates select="$viscoll_process5" mode="viscoll6"/>
        </xsl:variable>
        <xsl:apply-templates select="$viscoll_process6" mode="viscoll7"/>
    </xsl:template>
</xsl:stylesheet>