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
			EN: Main calls for building the system
			IT: Le chiamate principali per il build del sistema
		</xd:short>
	</xd:doc>

	<!-- All -->
    <xd:doc>
        <xd:short>
			EN: Main system call
			IT: Chiamata principale del sistema
        </xd:short>
        <xd:detail>
			EN: The first part outputs the HTML files for the different edition levels, while the second one calls the general template to build the index.
			IT: La prima parte produce in output i file HTML delle diverse edizioni, mentre la seconda richiama il template generale per il build della index.
		</xd:detail>
    </xd:doc>
	
	<xsl:output indent="yes" method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

	<xsl:variable name="root" select="/"/>
	<xsl:template match="/" priority="1">
		<xsl:apply-templates select="$step0" mode="splitPages"></xsl:apply-templates>
		<xsl:apply-templates select="$step0" mode="file4search"></xsl:apply-templates>
		<xsl:apply-templates select="$step0" mode="structure_generation"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="index">
		<!-- EN: index generation. The index_build template can be found in html_build/evt_builder-callhtml.xsl -->
		<!-- IT: Generazione della index. Il template index_build si trova in html_build/evt_builder-callhtml.xsl -->
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/index.html" indent="yes">
			<xsl:call-template name="index_build" />			
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="page">
		<xsl:variable name="pb_n" select="self::tei:pb/@n"/>
		<!-- IT: Per ogni pagina, genera le corrispettive edizioni. Il template data_structure si trova in html_build/evt_builder-callhtml.xsl -->
		<xsl:for-each select="$edition_array">
			<xsl:if test=".!=''">
				<xsl:variable name="edition_current" select="lower-case(.)"/>
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/{$edition_current}/page_{$pb_n}_{$edition_current}.html" indent="yes">
					<xsl:call-template name="data_structure">
						<xsl:with-param name="output" select="$edition_current"/>
						<xsl:with-param name="pb_n" select="$pb_n"/>
					</xsl:call-template>
				</xsl:result-document>
			</xsl:if>
		</xsl:for-each>
    </xsl:template>

	<xsl:template name="search_file">
		<xsl:if test="$edition_array[1]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[1])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.js" indent="no">
				var tipuesearch = {"pages": [
					<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
						<xsl:choose>
							<xsl:when test="current-group()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
									{ "line" :
										"<xsl:value-of select="if(self::tei:lb/@n) then(self::tei:lb/@n) else('no line info')" />",
									"text" :
										"<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="facs"/></xsl:variable>
										<xsl:copy-of select="$var//text()"></xsl:copy-of>",
									"loc" : "<xsl:value-of select="if(preceding::pb[1]/@n) then(preceding::pb[1]/@n) else('no_page_info')"/>"
									},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="facs"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each-group>
				]}
			</xsl:result-document>
		</xsl:if>
		<xsl:if test="$edition_array[2]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[2])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.js" indent="no">
				var tipuesearch = {"pages": [
					<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
						<xsl:choose>
							<xsl:when test="current-group()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
									{ "line" :
										"<xsl:value-of select="if(self::tei:lb/@n) then(self::tei:lb/@n) else('no line info')" />",
									"text" :
										"<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="dipl"/></xsl:variable>
										<xsl:copy-of select="$var//text()"></xsl:copy-of>",
									"loc" : "<xsl:value-of select="if(preceding::pb[1]/@n) then(preceding::pb[1]/@n) else('no_page_info')"/>"
									},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="dipl"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each-group>
				]}
			</xsl:result-document>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
