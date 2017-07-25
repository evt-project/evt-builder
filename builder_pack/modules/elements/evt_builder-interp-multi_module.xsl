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
			EN: Templates used to process the TEI elements of the TRANSCR, LINKING and gaiji modules.
			IT: I template per la trasformazione degli elementi TEI del modulo TRANSCR, LINKING e gaiji.
		</xd:short>
	</xd:doc>
	
	<xsl:template match="tei:g" mode="interp">
		<xsl:variable name="id" select="substring-after(@ref,'#')"/>
		<xsl:apply-templates select="if($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='normalized']) then($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='normalized']) else($root//tei:charDecl//tei:char[@xml:id=$id]/tei:mapping[@type='normalized'])" mode="#current"/>
	</xsl:template>
	
	<xsl:template match="tei:fw" mode="interp">
		<xsl:choose>
			<xsl:when test="@place='top-middle'">
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name2,'center'" separator="-"/>
					<xsl:apply-templates mode="#current"/> 
				</xsl:element>
			</xsl:when>
			<xsl:when test="@place='top-right'">
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name2,'right'" separator="-"/>
					<xsl:apply-templates mode="#current"/> 
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:apply-templates mode="#current"/> 
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:ab" mode="interp" priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
