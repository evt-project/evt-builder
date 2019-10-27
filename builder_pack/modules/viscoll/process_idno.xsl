<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"> 
    
    <xsl:template match="@*|node()|comment()" mode="find_idno">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="manuscript" mode="find_idno"> 
        <xsl:variable name="idno_shelfmark" select="translate(shelfmark,' ','')"/>
        <xsl:value-of select="$idno_shelfmark"/>  
    </xsl:template>
    
    
    
</xsl:stylesheet>