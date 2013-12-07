<?xml version="1.0" encoding="UTF-8"?>
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

	<!-- P Paragraphs -->
	<xsl:template match="tei:p" mode="facs">
		<xsl:element name="span">
			<xsl:attribute name="class"><xsl:value-of>facs-<xsl:value-of select="name()"/></xsl:value-of></xsl:attribute>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!-- L Verse line-->
	<xsl:template match="tei:l" mode="facs">
		<xsl:apply-templates mode="#current"/> 
		<xsl:text> </xsl:text><!--important-->
	</xsl:template>

	<!-- Line break -->
	<!-- IT: Ignora i lb che hanno xml:id che termina con 'r' e riporta quelli che hanno xml:id che termina con 'o' eliminando quest'ultimo carattere -->
	<xsl:template match="tei:lb" mode="facs">
			<xsl:choose>
				<xsl:when test="@xml:id">
					<xsl:choose>
						<xsl:when test="not(ends-with(@xml:id, 'reg'))">
							<xsl:element name="tei:lb">
								<xsl:copy-of select="@* except(@xml:id)"></xsl:copy-of>
								<xsl:attribute name="{@xml:id/name()}" select="if(ends-with(@xml:id, 'orig')) then(replace(@xml:id, 'orig', '')) else(@xml:id)"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	<!-- Page break -->
	<xsl:template match="tei:pb" mode="facs">
		<xsl:copy-of select="."/>
	</xsl:template>
	


	<!--               -->
	<!-- Transcription -->
	<!--               -->

	<!-- Choice -->
	<xsl:template match="tei:choice" mode="facs" priority="3">
		<xsl:choose>
			<xsl:when test="tei:sic">
				<xsl:apply-templates select="tei:sic" mode="#current"> </xsl:apply-templates>
			</xsl:when>
			<xsl:when test="tei:orig">
				<xsl:element name="span">
					<xsl:attribute name="class">
						<xsl:value-of>facs-choice_popup</xsl:value-of>
					</xsl:attribute>
					<xsl:apply-templates select="tei:reg" mode="#current"> </xsl:apply-templates>
					<xsl:sequence select="' '"/>
					<xsl:apply-templates select="tei:orig" mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
		</xsl:choose>	
	</xsl:template>
	
	<!--SUBST substitution -->
	<xsl:template match="tei:subst" mode="facs" priority="3">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of>facs-<xsl:value-of select="name()"/></xsl:value-of>
			</xsl:attribute>
			<xsl:apply-templates select="tei:add" mode="#current"> </xsl:apply-templates>
			<xsl:apply-templates select="tei:del" mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!-- ADD Addition -->
	<xsl:template match="tei:add" mode="facs" priority="2">
			<xsl:choose>
				<xsl:when test="@place='sup'">
					\<xsl:element name="span">
						<xsl:attribute name="class">
							<xsl:value-of>facs-<xsl:value-of select="@place"/></xsl:value-of>
							<xsl:value-of> facs-add</xsl:value-of>
						</xsl:attribute>
						<xsl:apply-templates mode="#current"> </xsl:apply-templates>
					</xsl:element>/
				</xsl:when>
				<xsl:when test="@place='sub'">
					/<xsl:element name="span">
						<xsl:attribute name="class">
							<xsl:value-of>facs-<xsl:value-of select="@place"/></xsl:value-of>
							<xsl:value-of> facs-add</xsl:value-of>
						</xsl:attribute>
						<xsl:apply-templates mode="#current"> </xsl:apply-templates>
					</xsl:element>\
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="span">
						<xsl:attribute name="class">
							<xsl:value-of>facs-<xsl:value-of select="name()"/></xsl:value-of>
						</xsl:attribute>
						<xsl:apply-templates mode="#current"> </xsl:apply-templates>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	<!--
		SIC Text reproduced although apparently incorrect or inaccurate
		DEL Deletions
		DAMAGE Damage
		ORIG Original form
		REG Regularization
		ABBR Abbreviation
	-->
	<xsl:template match="tei:sic|tei:del|tei:damage|tei:am|tei:orig|tei:reg|tei:abbr" mode="facs"
		priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of>facs-<xsl:value-of select="name()"/></xsl:value-of>
			</xsl:attribute>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<!--
		CORR Correction
		EXPAN Expansion
	-->
	<xsl:template match="tei:corr|tei:expan" mode="facs" priority="2">
		<!-- Do nothing -->
	</xsl:template>

	<!-- HI Highlighted text -->
	<xsl:template match="tei:hi" mode="facs" priority="2">
		<xsl:choose>
			<xsl:when test="@rend='double'">
				<xsl:element name="span">
					<xsl:attribute name="class">facs-hi-double</xsl:attribute>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@rend='cap'">
				<xsl:element name="span">
					<xsl:attribute name="class">facs-hi-cap</xsl:attribute>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@rend='cap2.0'">
				<xsl:element name="span">
					<xsl:attribute name="class">facs-hi-cap2.0</xsl:attribute>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@rend='7init'">
				<xsl:element name="span">
					<xsl:attribute name="class">facs-hi-7init</xsl:attribute>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@rend='init3.1'">
				<xsl:element name="span">
					<xsl:attribute name="class">facs-hi-init3-1</xsl:attribute>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@rend='red'">
				<xsl:element name="span">
					<xsl:value-of>facs-<xsl:value-of select="@rend"/></xsl:value-of>
					<xsl:apply-templates mode="#current"> </xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current"> </xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
