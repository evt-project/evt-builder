<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">

	<xd:doc type="stylesheet">
		<xd:short>
			EN: Fundamental calls to generate the HTML structure.
			IT: Le chiamate principali per la generazione della struttura HTML.
		</xd:short>
	</xd:doc>

	<!-- ########### -->
	<!-- HEADER INFO -->
	<!-- ########### -->
	<xsl:template name="headerInfo_generation">
		<html lang="en-US">
			<body>
				<div id="headerInfo">
					<div class="main-title"><span lang="def">PROJECT_INFO</span></div>
					<a href="javascript:void(0);" id="close_header_info_cont" title="Close Header Info"><i class="fa fa-close"></i></a>
					<div id="headerInfo_content">
						<xsl:apply-templates select="//tei:teiHeader"/>
						
						<xsl:if test="tei:TEI/tei:text/tei:front and not(tei:TEI/tei:text/tei:body)">
							<div id="generalFront_content">
								<xsl:apply-templates select="tei:TEI/tei:text/tei:front"/>
							</div>
						</xsl:if>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<!-- ###################### -->
	<!-- MANUSCRIPT DESCRIPTION -->
	<!-- ###################### -->
	<xsl:template name="msDesc_generation">
		<html lang="en-US">
			<body>
				<div id="msDescription">
					<xsl:apply-templates select="//tei:msDesc"/>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<!-- ####### -->
	<!-- REGESTO -->
	<!-- ####### -->
	<xsl:template name="doc_regesto">
		<xsl:param name="doc_id" />
		<xsl:param name="front" />
		<html lang="en-US">
			<xsl:call-template name="html_head">
				<xsl:with-param name="html_path" select="$dataPrefix"/>
				<xsl:with-param name="html_tc" select="'datastructure'"/>
				<xsl:with-param name="output" select="regesto"/>
			</xsl:call-template>
			<body>
				<div id="regesto">
					<div class="front">
						<div class="info">
							<div class="align-center"><span class="intestazione inline">Numerazione nuova: </span><xsl:value-of select="$front/tei:titlePart[@type='numerazioneNuova']"/></div>
							<div class="align-center"><span class="intestazione inline">Numerazione originale: </span><xsl:value-of select="$front/tei:titlePart[@type='numerazioneOrig']"/></div>
							<div class="align-center">
								<span class="intestazione inline">
									<xsl:apply-templates mode="dipl" select="$front/tei:docDate"/>
								</span>
							</div>
						</div>
						<div class="reg_text">
							<!--<xsl:value-of select="$front/tei:div[@type='regesto']"/>-->
							<xsl:apply-templates select="$front/tei:div[@type='regesto']" mode="dipl"/>
						</div>
						<div class="reg_note">
							<hr/>
							<p class="bibliografia">
								<!--<xsl:value-of select="$front//tei:div[@type='orig_doc']"/>-->
								<xsl:apply-templates select="$front//tei:div[@type='orig_doc']" mode="dipl"></xsl:apply-templates>
							</p>
							<p class="bibliografia">
								<xsl:for-each select="$front//tei:div[@type='biblio']/tei:p">
									<xsl:apply-templates mode='dipl'/>
								</xsl:for-each>
							</p>
							<p class="crit_notes">
								<xsl:for-each select="tei:front//tei:div[@type='crit_notes']/tei:note">
									<xsl:apply-templates mode="dipl"/>
								</xsl:for-each>
							</p>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	
	
	
	<!-- ########## -->
	<!-- FRONT INFO -->
	<!-- ########## -->
	<xsl:template name="front_generation">
		<xsl:param name="front" />
		<html lang="en-US">
			<body>
				<div id="frontInfo">
					<div id="front">
						<div class="front">
							<xsl:apply-templates select="$front"/>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="tei:front/tei:titlePage">
		<div class="title"><xsl:value-of select="."/></div>
	</xsl:template>
	
	<xsl:template match="tei:front/tei:div">
		<xsl:element name="div">
			<xsl:attribute name="class">
				<xsl:if test="@type">
					<xsl:value-of select="@type"/>
				</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:if test="@subtype">
					<xsl:value-of select="@subtype"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:if test="@subtype">
				<div class="section-title">
					<xsl:value-of select="@subtype"/>
				</div>
			</xsl:if>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:front/tei:listBibl">
		<span class="title">References</span>
		<xsl:apply-templates select="tei:front/tei:biblStruct">
			<xsl:sort order="ascending" select=".//date"/>
		</xsl:apply-templates>
	</xsl:template>
	
</xsl:stylesheet>
