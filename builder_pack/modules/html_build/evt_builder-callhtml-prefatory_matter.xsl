<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">

	<xd:doc type="stylesheet">
		<xd:short>
			EN: Fundamental calls to generate the HTML structure for prefatory matter.
			IT: Le chiamate principali per la generazione della struttura HTML per i vari contenuti introduttivi.
		</xd:short>
	</xd:doc>

	<!-- ########### -->
	<!-- HEADER INFO -->
	<!-- ########### -->
	<xsl:template name="headerInfo_generation">
		<html lang="en-US">
			<body>
				<div id="headerInfo" class="dialog_cont">
					<a href="javascript:void(0);" id="close_header_info_cont" class="dialog_close" data-dialog="headerInfo_cont" lang="def" title="CLOSE"><i class="fa fa-close"></i></a>
					<div class="title main"><span lang="def">PROJECT_INFO</span>
						<xsl:if test="$webSite != ''">
							<xsl:element name="a">
								<xsl:attribute name="class">project-web-site_link</xsl:attribute>
								<xsl:attribute name="href"><xsl:value-of select="$webSite"/></xsl:attribute>
								<xsl:attribute name="target">_blank</xsl:attribute>
								<xsl:attribute name="lang">def</xsl:attribute>
								<xsl:attribute name="title">VISIT_WEB_SITE</xsl:attribute>
								<i class="fa fa-external-link"></i>
							</xsl:element>
						</xsl:if>
					</div>
					<div class="dialog_separator"><i class="fa fa-caret-down"></i></div>
					<div id="headerInfo_content" class="dialog_cont_inner">
						<xsl:apply-templates select="//tei:teiHeader"/>
						<!--<xsl:if test="tei:TEI/tei:text/tei:front and not(tei:TEI/tei:text/tei:body)">
							<div id="generalFront_content">
								<xsl:apply-templates select="tei:TEI/tei:text/tei:front"/>
							</div>
						</xsl:if>-->
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
									<xsl:apply-templates mode="interp" select="$front/tei:docDate"/>
								</span>
							</div>
						</div>
						<div class="reg_text">
							<!--<xsl:value-of select="$front/tei:div[@type='regesto']"/>-->
							<xsl:apply-templates select="$front/tei:div[@type='regesto']" mode="interp"/>
						</div>
						<div class="reg_note">
							<hr/>
							<p class="bibliografia">
								<!--<xsl:value-of select="$front//tei:div[@type='orig_doc']"/>-->
								<xsl:apply-templates select="$front//tei:div[@type='orig_doc']" mode="interp"></xsl:apply-templates>
							</p>
							<p class="bibliografia">
								<xsl:for-each select="$front//tei:div[@type='biblio']/tei:p">
									<xsl:apply-templates mode='interp'/>
								</xsl:for-each>
							</p>
							<p class="crit_notes">
								<xsl:for-each select="tei:front//tei:div[@type='crit_notes']/tei:note">
									<xsl:choose>
										<xsl:when test="$root//tei:ptr[@type='noteAnchor'][@target=concat('#',current()/@xml:id)]">
											<!-- DO NOTHING -->
											<!-- Se nel testo esiste un pointer a questa nota, la nota NON deve essere renderizzata nel punto in cui è stata codificata, 
							                    ma verrà visualizzata nel punto in cui compare il pointer. La sua trasformazione verrà dunque gestita dal template per il pointer -->
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates mode="interp"/>
										</xsl:otherwise>
									</xsl:choose>
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
	
	<xsl:template match="tei:front//tei:lb">
		<xsl:value-of disable-output-escaping="yes">&lt;br/&gt;</xsl:value-of>
	</xsl:template>
	
	<xsl:template match="tei:front//tei:ptr">
		<xsl:choose>
			<xsl:when test="@type='noteAnchor'">
				<xsl:if test="@target and @target!='' and $root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
					<xsl:for-each select="$root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
						<xsl:call-template name="notePopup"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- DO NOTHING -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:front//tei:ref">
		<xsl:choose>
			<xsl:when test="@target[contains(., 'www')] or @target[contains(., 'http')]">
				<xsl:element name="a">
					<xsl:attribute name="href" select="if(@target[contains(., 'http')]) then(@target) else(concat('http://', @target))" />
					<xsl:attribute name="target" select="'_blank'"/>
					<xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="starts-with(@target,'#')">
				<xsl:choose>
					<xsl:when test="node()/ancestor::tei:note">
						<!-- Se il tei:ref si trova all'interno di una nota diventa soltanto un trigger -->
						<xsl:element name="span">
							<xsl:attribute name="class">ref</xsl:attribute>
							<xsl:attribute name="data-target"><xsl:value-of select="@target"/></xsl:attribute>
							<xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<!-- Do nothing -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
