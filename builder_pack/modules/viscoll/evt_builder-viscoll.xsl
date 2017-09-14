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
      
    
    
    <xsl:template name="viscoll">    
        <xsl:variable name="path" select="doc('../../../data/input_data/text/CP.xml')"/>
        <xsl:variable name="viscoll_process4">  <!-- Definisco variabile viscoll_process4 per la trasformazione process4.xsl-->
            <xsl:apply-templates select="$path" mode="viscoll4">  <!-- Gli associo il percorso del file con attributo mode, cioe' il modello da applicare, in base al tipo e al contesto di ogni nodo selezionato. -->
            </xsl:apply-templates>
        </xsl:variable>
    
        <xsl:variable name="viscoll_process5">
            <xsl:apply-templates select="$viscoll_process4" mode="viscoll5">
            </xsl:apply-templates>
        </xsl:variable>
        
        <xsl:variable name="viscoll_process6">
        <xsl:apply-templates select="$viscoll_process5" mode="viscoll6">
        </xsl:apply-templates>
        </xsl:variable>
        
        <xsl:apply-templates select="$viscoll_process6" mode="viscoll7">
        </xsl:apply-templates>
        
        
    </xsl:template>


</xsl:stylesheet>