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
			EN: Templates used to process the TEI elements of the TEXTSTRUCTURE module.
			IT: I template per la trasformazione degli elementi TEI del modulo TEXTSTRUCTURE.
		</xd:short>
	</xd:doc>

	<!-- Main section -->
	<xsl:template match="tei:front" mode="dipl" priority="2">
		<br/>
		<xsl:apply-templates mode="#current"> </xsl:apply-templates>
	</xsl:template>

	<!-- EN: The call to process body's content is in modules/elements/evt_builder-call_main.xsl -->
	<!-- IT: La chiamata per processare il contenuto del body si trova in modules/elements/evt_builder-call_main.xsl -->
	<!--
	<xsl:template match="tei:body" mode="int">
		<xsl:param name="pp_start"/>
		<xsl:param name="pp_end"/>
        <br />
		<xsl:apply-templates mode="#current">
			<xsl:with-param name="pp_start" select="$pp_start"/>
			<xsl:with-param name="pp_end" select="$pp_end"/>
		</xsl:apply-templates>
	</xsl:template>
	-->

	<xsl:template match="tei:back" mode="dipl" priority="2">
		<br/>
		<xsl:apply-templates mode="#current"> </xsl:apply-templates>
	</xsl:template>

	<!-- EN: Template matching the text -->
	<!-- IT: Template per il matching del testo -->
	<!--<xsl:template match="text()" mode="dipl" priority="2">
		<xsl:param name="pp_start"/>
        <xsl:param name="pp_end"/>
        <xsl:if test="not(following::tei:pb[@n=$pp_start/@n]) and not(preceding::tei:pb[@n=$pp_end/@n])">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>-->


</xsl:stylesheet>
