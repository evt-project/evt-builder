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
    <xsl:template match="tei:lb" mode="interp dipl #default">
        <span class="spazio"></span>
    </xsl:template>
    <xsl:template match="tei:l" mode="interp dipl #default">
        <xsl:choose>
            <xsl:when test="@n=1">
                <p class="verso"><sup class="cerchio"><xsl:value-of select="@n"/></sup><xsl:apply-templates mode="#current"/></p>
            </xsl:when>
            <xsl:when test="@n != preceding::tei:l[1]/@n"> <!-- first part of l -->
                <xsl:choose>
                    <xsl:when test="@n=9">
                        <p class="verso"><sup class="cerchio"><xsl:value-of select="@n"/></sup><xsl:apply-templates mode="#current"/><xsl:value-of select="following::tei:l[1]"/><xsl:value-of select="following::tei:l[2]"/></p>
                    </xsl:when>
                    <xsl:when test="@n != following::tei:l[1]/@n"> <!--  if l has only one part -->
                        <p class="verso"><sup class="cerchio"><xsl:value-of select="@n"/></sup><xsl:apply-templates mode="#current"/></p>
                    </xsl:when>
                    <xsl:otherwise> <!-- not first part of l -->
                        <p class="verso"><sup class="cerchio"><xsl:value-of select="@n"/></sup><xsl:apply-templates mode="#current"/><xsl:value-of select="following::tei:l[1]"/></p>
                    </xsl:otherwise>
                </xsl:choose>               
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>