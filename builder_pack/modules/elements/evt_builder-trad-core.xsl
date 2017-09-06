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
			EN: Templates used to process the TEI elements of the CORE module.
			IT: I template per la trasformazione degli elementi TEI del modulo Core.
		</xd:short>
	</xd:doc>
	
	
	<!--             -->
	<!-- Page layout -->
	<!--             -->
	
	<!-- Seleziona elemento SPAN add by FS -->
	<xsl:template match="tei:span" mode="trad">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name3,name()" separator="-"/>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<!-- P Paragraphs -->
	<xsl:template match="tei:p" mode="trad">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name3,name()" separator="-"/>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<!-- L Verse line-->
	<xsl:template match="tei:l" mode="trad">
		<xsl:apply-templates mode="#current"/> 
		<xsl:text> </xsl:text><!--important-->
	</xsl:template>
	
	<!-- CDP:embedded -->
	<!-- LINE Verse line-->
	<xsl:template match="tei:line" mode="trad">
		<xsl:if test="current()[not((string-length(normalize-space()))= 0)]"><!-- Escludo elementi <line> vuoti -->
			<xsl:element name="div">
				<xsl:attribute name="class" select="$ed_name3"/>
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name3, 'lineN'" separator="-"/>
					<xsl:value-of select="if(@n) then (if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;',@n))) else ('&#xA0;&#xA0;&#xA0;')"/><xsl:text>&#xA0;&#xA0;</xsl:text>
				</xsl:element>
				<xsl:element name="div">
					<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->					
					<xsl:attribute name="class" select="if(@rend) then ($ed_name3, translate(@rend, '.', '_')) else ($ed_name3, 'left')" separator="-"/>
					<xsl:apply-templates mode="#current"/>
					<xsl:text> </xsl:text><!--important-->
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<!-- ZONE -->
	<xsl:template match="tei:zone" mode="trad">
		<xsl:choose>
			<xsl:when test="not(current()[@lrx][@lry][@ulx][@uly])"><!-- in questo modo se non c'e' collegamento testo immagine le zone vengono separate -->
				<xsl:element name="div">
					<xsl:attribute name="class"><xsl:value-of select="$ed_name3, 'zone'" separator="-" /></xsl:attribute>
					<xsl:apply-templates mode="#current"/>
					<xsl:text> </xsl:text><!--important-->
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><!--important-->
	</xsl:template>
	
	<!-- DESC -->
	<xsl:template match="tei:desc" mode="trad">
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="node()[@attachment]" mode="trad">
		<xsl:element name="div">
			<xsl:attribute name="class" select="$ed_name3, 'attachment'" separator="-" />
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- Page break -->
	<xsl:template match="tei:pb" mode="trad">
		<xsl:copy-of select="."/>
	</xsl:template>		
	
	
	<!--               -->
	<!-- Transcription -->
	<!--               -->
	
	<!-- Choice -->
	
	<!--
		SIC Text reproduced although apparently incorrect or inaccurate
		DEL Deletions
		DAMAGE Damage
		ORIG Original form
		REG Regularization
		ABBR Abbreviation
	-->
	
	<!--
		CORR Correction
		EXPAN Expansion
	-->
	
	<!-- HI Highlighted text -->
	<xsl:template match="tei:hi" mode="trad" priority="2">
		<xsl:element name="span">
			<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->
			<xsl:attribute name="class" select="$ed_name3,name(),translate(@rend, '.', '_')" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<!-- For Embedded  Transcription -->
	<xsl:template match="node()[name()='div'][@id='areaAnnotations']" mode="trad">
		<xsl:copy-of select="." />
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@id='AnnMenu' or @class='AnnMenuItem']|node()[name()='div'][contains(@class, 'AnnSubmenu')]" mode="trad">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- REF References to additional text -->
	<xsl:template match="tei:ref" mode="trad">
		<xsl:choose>
			<xsl:when test="starts-with(@target,'#')">
				<xsl:choose>
					<xsl:when test="node()/ancestor::tei:note">
						<!-- Se il tei:ref si trova all'interno di una nota diventa soltanto un trigger -->
						<xsl:element name="span">
							<xsl:attribute name="class">ref</xsl:attribute>
							<xsl:attribute name="data-target"><xsl:value-of select="@target"/></xsl:attribute>
							<xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
							<xsl:apply-templates mode="#current"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<!-- Do nothing -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:front" mode="trad">
		<!-- Do nothing -->
	</xsl:template>
	
	<xsl:template match="tei:body" mode="trad">
		<xsl:element name="div">
			<xsl:attribute name="class">doc</xsl:attribute>
			<xsl:attribute name="data-doc" select="current()/parent::tei:text/@xml:id"/>
			<xsl:attribute name="title"><xsl:text>Doc. </xsl:text>
				<xsl:choose>
					<xsl:when test="current()/parent::tei:text/@n">
						<xsl:value-of select="current()/parent::tei:text/@n"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="generateTextLabel">
							<xsl:with-param name="text_id">
								<xsl:value-of select="current()/parent::tei:text/@xml:id" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<!-- EMPH emphasized  -->
	<xsl:template match="tei:emph" mode="trad">
		<xsl:choose>
			<xsl:when test="node()/ancestor::tei:note">
				<xsl:element name="span">
					<xsl:attribute name="class">emph</xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- TERM -->
	<xsl:template match="tei:term" mode="trad">
		<xsl:element name="span">
			<xsl:attribute name="class">term</xsl:attribute>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- NOTE Note or annotation -->
	<xsl:template match="tei:note" mode="trad">
		<!-- Do nothing -->
	</xsl:template>
	
	<!-- DATE -->
	<xsl:template match="tei:date" mode="trad">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- PERS NAME personal name -->
	<xsl:template match="tei:persName[starts-with(@ref,'#')]" mode="trad">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- MEASURE  -->
	<xsl:template match="tei:measure" mode="trad">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- ROLE NAME -->
	<xsl:template match="tei:roleName" mode="trad">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- ORG NAME  -->
	<xsl:template match="tei:orgName" mode="trad">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- PLACE NAME personal name -->
	<xsl:template match="tei:placeName[starts-with(@ref,'#')]" mode="trad">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- PTR Pointer -->
	<xsl:template match="tei:ptr" mode="trad">
		<xsl:choose>
			<xsl:when test="@type='noteAnchor'">
				<xsl:if test="@target and @target!='' and $root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
					<xsl:for-each select="$root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
						<xsl:call-template name="notePopup"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- Do nothing -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- QUOTE Quotes -->
	<xsl:template match="tei:quote" mode="trad">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
</xsl:stylesheet>