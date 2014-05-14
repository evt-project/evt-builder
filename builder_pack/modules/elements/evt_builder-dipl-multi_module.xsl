<?xml version="1.0" encoding="UTF-8"?>
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
	
	<xsl:template match="tei:g" mode="dipl">
		<xsl:variable name="id" select="substring-after(@ref,'#')"/>
		<xsl:apply-templates select="if($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='normalized']) then($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='normalized']) else($root//tei:charDecl//tei:char[@xml:id=$id]/tei:mapping[@type='normalized'])" mode="#current"/>
	</xsl:template>
	
	<xsl:template match="tei:fw" mode="dipl">
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
	
	<xsl:template match="tei:ab" mode="dipl" priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
