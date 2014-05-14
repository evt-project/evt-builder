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

	<xsl:template match="tei:g" mode="facs">
		<xsl:variable name="id" select="substring-after(@ref,'#')"/>
		<xsl:apply-templates select="if($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) then($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) else($root//tei:charDecl//tei:char[@xml:id=$id]/tei:mapping[@type='diplomatic'])" mode="#current"/>
	</xsl:template>

	<xsl:template match="tei:fw" mode="facs" priority="2">
		<xsl:choose>
			<xsl:when test="@place='top-middle'">
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name1,'center'" separator="-"/>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@place='top-right'">
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name1,'right'" separator="-"/>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:ab" mode="facs" priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name1, name()"/>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
