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
		<xd:short> EN: Main calls for building the system IT: Le chiamate principali per il build
			del sistema </xd:short>
	</xd:doc>

	<!-- All -->
	<xd:doc>
		<xd:short> EN: Main system call IT: Chiamata principale del sistema </xd:short>
		<xd:detail> EN: The first part outputs the HTML files for the different edition levels,
			while the second one calls the general template to build the index. IT: La prima parte
			produce in output i file HTML delle diverse edizioni, mentre la seconda richiama il
			template generale per il build della index. </xd:detail>
	</xd:doc>

	<xsl:output indent="yes" method="html" encoding="UTF-8" media-type="text/plain"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

	<xsl:variable name="root" select="/"/>
	<xsl:template match="/" priority="1">
		<!-- Found the node(s) for embedded transcription-->
		<!-- 
			<xsl:choose>
				<xsl:when test="tei:TEI/tei:sourceDoc">
				
				<xsl:apply-templates select="." mode="splitPages4embedded"></xsl:apply-templates>
				<xsl:apply-templates select="." mode="structure_generation4embedded"></xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$step0" mode="splitPages"></xsl:apply-templates>
				<xsl:apply-templates select="$step0" mode="file4search"></xsl:apply-templates>
				<xsl:apply-templates select="$step0" mode="structure_generation"></xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>-->
		<!-- CDP: Embedded -->
		<!-- EN: If there is at least a <sourceDoc> element the transformations for embedded are activated -->
		<!-- IT: Le trasformazioni per l'embedded transcription vengono attivate se nel documento esiste almeno un elemento <sourceDoc> -->
		<xsl:if test="tei:TEI/tei:sourceDoc">
			<xsl:apply-templates select="." mode="splitPages4embedded"/>
			<!-- SEARCH -->
			<xsl:if test="$search = true()">
				<xsl:apply-templates select="." mode="file4search4embedded"/>
			</xsl:if>
		</xsl:if>
		<!-- EN: If there is at least a <text> element the transformations for parallel transcription are activated -->
		<!-- IT: Le trasformazioni per la parallel transcription vengono attivate se nel documento esiste almeno un elemento <text> -->
		<xsl:if test="tei:TEI/tei:text">
			<xsl:apply-templates select="$step0" mode="splitPages"/>

			<!-- HEADER INFORMATION -->
			<xsl:if test="$headerInfo = true()">
				<xsl:call-template name="headerInfo"/>
			</xsl:if>

			<!-- MANUSCRIPT DESCRIPTION -->
			<xsl:if test="$msDesc = true()">
				<xsl:call-template name="msDesc"/>
			</xsl:if>

			<!-- REGESTO -->
			<xsl:if test="$regesto=true()">
				<xsl:choose>
					<xsl:when test="tei:TEI/tei:text/tei:group/tei:text">
						<xsl:for-each select="tei:TEI/tei:text/tei:group/tei:text">
							<xsl:call-template name="regesto"/>
							<xsl:if test="$edition_array='Translation'">
								<xsl:call-template name="translate"/><!-- TODO: CHECK IF TRANSLATION IS ACTIVE-->
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="tei:TEI/tei:text">
							<xsl:call-template name="regesto"/>
							<xsl:if test="$edition_array='Translation'">
								<xsl:call-template name="translate"/><!-- TODO: CHECK IF TRANSLATION IS ACTIVE-->
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<!-- FRONT INFORMATION -->
			<xsl:if test="$frontInfo = true()">
				<xsl:choose>
					<xsl:when test="$root//tei:text/tei:group">
						<!-- Gestione TEXT multipli in tei:group -->
						<xsl:for-each select="$root//tei:text/tei:group/tei:text">
							<xsl:if test="current()/tei:front">
								<xsl:call-template name="front"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="tei:TEI/tei:text">
							<xsl:if test="current()/tei:front">
								<xsl:call-template name="front"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<!-- LISTS -->
			<xsl:if test="$list_person = true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
					byte-order-mark="yes"
					href="{$filePrefix}/data/output_data/liste/listPerson.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listPerson</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listPerson"/>
						<xsl:apply-templates select="$step0" mode="listPersonOccurences"/>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			<xsl:if test="$list_place = true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
					byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listPlace.html"
					indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listPlace</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listPlace"/>
						<xsl:apply-templates select="$step0" mode="listPlaceOccurences"/>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			<xsl:if test="$list_org = true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
					byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listOrg.html"
					indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listOrg</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listOrg"/>
						<xsl:apply-templates select="$step0" mode="listOrgOccurences"/>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			
			<xsl:if test="$list_term=true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listTerm.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listTerm</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listTerm"/>
						<xsl:apply-templates select="$step0" mode="listTermOccurences"/>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
		</xsl:if>
		
		<!-- GM -->
		<xsl:if test="$viscoll_info">
			<xsl:result-document method="xml" encoding="UTF-8" href="{$filePrefix}/data/output_data/listImage.xml" indent="yes">
				<xsl:call-template name="prova"></xsl:call-template>
			</xsl:result-document>
			
			<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/viscoll/viscoll-idno.html" indent="yes">
				<xsl:element name="div">
					<xsl:attribute name="id">viscoll_idno</xsl:attribute>
					<xsl:call-template name="idno_process"></xsl:call-template>
				</xsl:element>
		</xsl:result-document>
		</xsl:if>
		
		<!-- GM -->
		<xsl:if test="$viscoll_info">
			<xsl:result-document method="html" encoding="UTF-8" href="{$filePrefix}/data/output_data/viscoll/viscoll-output.html" indent="yes">
				<xsl:call-template name="viscoll"></xsl:call-template>  <!-- Chiama il template dell'elemento selezionato -->
			</xsl:result-document>
			
			<xsl:if test="$list_gloss=true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listGloss.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listGloss</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listGloss"/>
						<xsl:apply-templates select="$step0" mode="listGlossOccurences"/>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			<!--chronological index /list document -->
			<xsl:if test="$list_doc = true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
					byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listDoc.html"
					indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listDoc</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listDoc"/>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>


			<!-- SEARCH -->
			<xsl:if test="$search = true()">
				<xsl:apply-templates select="$step0" mode="file4search"/>
			</xsl:if>

		</xsl:if>
		
		<!-- EN: The index and structure generation are the same for both the parallel and the embedded  -->
		<!-- IT: La generazione dell'index e della struttura sono uguali sia per la parallel sia per l'embedded -->
		<xsl:call-template name="index"/>
		<xsl:apply-templates select="." mode="structure_generation"/>
	</xsl:template>

	<xsl:template name="index">
		<!-- EN: Index generation. The index_build template can be found in html_build/evt_builder-callhtml.xsl -->
		<!-- IT: Generazione della index. Il template index_build si trova in html_build/evt_builder-callhtml.xsl -->
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
			href="{$filePrefix}/index.html" indent="yes">
			<xsl:call-template name="index_build"/>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="page">
		<!-- CDP:embedded -->
		<xsl:variable name="pb_n">
			<xsl:choose>
				<xsl:when test="@xml:id">
					<xsl:value-of select="@xml:id"/>
				</xsl:when>
				<xsl:when test="@n">
					<xsl:value-of select="@n"/>
				</xsl:when>
				<xsl:when test="@facs">
					<xsl:value-of select="@facs"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="position()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- EN: For every single page, the system generates the corresponding edition. Data_structure template is in html_builder/evt_builder-callhtml.xsl -->
		<!-- IT: Per ogni pagina, genera le corrispettive edizioni. Il template data_structure si trova in html_build/evt_builder-callhtml.xsl r. 144 -->
		<xsl:for-each select="$edition_array">
			<xsl:if test=". != ''">
				<xsl:variable name="edition_current" select="lower-case(.)"/>
				<xsl:if test="position()!=3"><!-- TRANSLATION IS HANDLED DIFFERENTLY -->
					<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/{$edition_current}/page_{$pb_n}_{$edition_current}.html" indent="yes">
						<xsl:call-template name="data_structure">
							<xsl:with-param name="output" select="$edition_current"/>
							<xsl:with-param name="pb_n" select="$pb_n"/>
							<xsl:with-param name="edition_pos" select="position()"/>
						</xsl:call-template>
					</xsl:result-document>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="edition_level">
		<xsl:param name="pb_n"/>
		<xsl:param name="edition_pos"/>
		
		<xsl:if test="$edition_pos=1">
			<xsl:choose>
				<!-- CDP:embedded -->
				<!-- Se il file e' codificato in Embedded Transcription e almeno un elemento <zone> presenta le coordinate spaziali 
					viene attivata la trasformazione per il collegamento testo immagine -->
				<xsl:when
					test="($root//tei:sourceDoc) and (current-group()/tei:zone[@lrx][@lry][@ulx][@uly])">
					<!--<xsl:copy-of select="current-group()"/> -->
					<!-- <-use this to find split errors -->
					<!--<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>-->
					<xsl:variable name="text">
						<xsl:apply-templates select="current-group()" mode="ITLembedded">
							<xsl:with-param name="edition_level" select="$ed_name1"/>
						</xsl:apply-templates>
					</xsl:variable>
					<xsl:apply-templates select="$text" mode="dipl"/>
				</xsl:when>
				<!-- IT: Se c'è il surface viene creato un albero temporaneo che corrisponde al gruppo corrente trasformato in base al livello di edizione;
										 a questo viene applicato il template per il collegamento testo-immagine-->
				<xsl:when test="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=replace($pb_n, '-front', '')]//tei:zone[@rendition='Line'] | $root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=replace($pb_n, '-front', '')]//tei:zone[@rendition='HotSpot']">
					<!--<xsl:copy-of select="current-group()"/>--> <!-- <-use this to find split errors -->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>
					<!-- IT: aggiungi elementi div per linee di testo -->
					<xsl:variable name="text2">
						<xsl:call-template name="divCb">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ed_name" select="$ed_name1"/>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="text3">
						<xsl:call-template name="divLine">
							<xsl:with-param name="text" select="$text2"/>
							<xsl:with-param name="ed_name" select="$ed_name1"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- IT: trasforma el per ITL e HS-->
					<xsl:apply-templates select="$text3" mode="ITL"/>
				</xsl:when>
				<!-- EN: If the surface element is not present only the diplomatic edition templates are applied -->
				<!-- IT: Se non c'è il surface devo applicare direttamente i templates per l'edizione diplomatica -->
				<xsl:otherwise>
					<xsl:variable name="text">
						<xsl:apply-templates select="current-group()" mode="dipl"/>
					</xsl:variable>
					<!-- IT: aggiungi elementi div per linee di testo -->
					<xsl:variable name="text2">
						<xsl:call-template name="divCb">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ed_name" select="$ed_name1"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="divLine">
						<xsl:with-param name="text" select="$text2"/>
						<xsl:with-param name="ed_name" select="$ed_name1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>	
		<xsl:if test="$edition_pos=2">
			<xsl:choose>
				<!-- CDP:embedded -->
				<!-- EN: If the text is encoded in Embedded Transcription and there is at least one <one> element with spatial coordinates
						 the transformation for the image-text link will be activated -->
				<!-- IT: Se il file e' codificato in Embedded Transcription e almeno un elemento <zone> presenta le coordinate spaziali 
						 viene attivata la trasformazione per il collegamento testo immagine -->
				<xsl:when
					test="($root//tei:sourceDoc) and (current-group()/tei:zone[@lrx][@lry][@ulx][@uly])">
					<!--<xsl:copy-of select="current-group()"/>-->
					<!-- <-use this to find split errors -->
					<!--<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="interp"/></xsl:variable>-->
					<xsl:variable name="text">
						<xsl:apply-templates select="current-group()" mode="ITLembedded">
							<xsl:with-param name="edition_level" select="$ed_name2"/>
						</xsl:apply-templates>
					</xsl:variable>
					<xsl:apply-templates select="$text" mode="interp"/>
				</xsl:when>
				<!-- IT: Se c'è il surface viene creato un albero temporaneo che corrisponde al gruppo corrente trasformato in base al livello di edizione;
										 a questo viene applicato il template per il collegamento testo-immagine-->
				<xsl:when test="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=replace($pb_n, '-front', '')]//tei:zone[@rendition='Line'] | $root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=replace($pb_n, '-front', '')]//tei:zone[@rendition='HotSpot']">
					<!--<xsl:copy-of select="current-group()"/>--> <!-- <-use this to find split errors -->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="interp"/></xsl:variable>
					<xsl:variable name="text2">
						<xsl:call-template name="divLine">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ed_name" select="$ed_name2"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="text3">
						<xsl:call-template name="divLine">
							<xsl:with-param name="text" select="$text2"/>
							<xsl:with-param name="ed_name" select="$ed_name2"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:apply-templates select="$text3" mode="ITL"/>
				</xsl:when>
				<!-- EN: If the surface element is not present only the diplomatic edition templates are applied -->
				<!-- IT: Se non c'è il surface devo applicare direttamente i templates per l'edizione diplomatica-->
				<xsl:otherwise>
					<xsl:variable name="text">
						<xsl:apply-templates select="current-group()" mode="interp"/>
					</xsl:variable>
					<xsl:variable name="text2">
						<xsl:call-template name="divCb">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ed_name" select="$ed_name2"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="divLine">
						<xsl:with-param name="text" select="$text2"/>
						<xsl:with-param name="ed_name" select="$ed_name2"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="translate">
		<xsl:variable name="doc_id">
			<xsl:choose>
				<xsl:when test="current()/@xml:id">
					<xsl:value-of select="current()/@xml:id"/>
				</xsl:when>
				<xsl:when test="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id">
					<xsl:value-of select="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(preceding-sibling::tei:text) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/translation/translation_{$doc_id}.html" indent="yes">
			<html lang="en-US">
				<xsl:call-template name="html_head">
					<xsl:with-param name="html_path" select="$dataPrefix"/>
					<xsl:with-param name="html_tc" select="'datastructure'"/>
					<xsl:with-param name="output" select="translation"/>
				</xsl:call-template>
				<body>
					<section id="central_wrapper">
						<div id="text_frame">
							<div id="text" class="translation">
								<xsl:choose>
									<xsl:when test="current()/tei:back/tei:div[starts-with(@type,'transl')]">
										<xsl:variable name="text">
											<xsl:apply-templates select="current()/tei:back/tei:div[starts-with(@type,'transl')]" mode="trad"/>
										</xsl:variable>
										<xsl:variable name="text2">
											<xsl:call-template name="divCb">
												<xsl:with-param name="text" select="$text"/>
												<xsl:with-param name="ed_name" select="$ed_name3"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:call-template name="divLine">
											<xsl:with-param name="text" select="$text2"/>
											<xsl:with-param name="ed_name" select="$ed_name3"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<div lang="def">NO_TRANSLATION_AVAILABLE</div>
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</div>
					</section>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<!-- HEADER INFO -->
	<xsl:template name="headerInfo">
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
			byte-order-mark="yes"
			href="{$filePrefix}/data/output_data/prefatory_matter/header_info.html" indent="yes">
			<xsl:call-template name="headerInfo_generation"/>
		</xsl:result-document>
	</xsl:template>
	
	<!-- MS DESCRIPTION -->
	<xsl:template name="msDesc">
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
			byte-order-mark="yes"
			href="{$filePrefix}/data/output_data/prefatory_matter/ms_desc.html" indent="yes">
			<xsl:call-template name="msDesc_generation"/>
		</xsl:result-document>
	</xsl:template>

	<!-- FRONT -->
	<xsl:template name="front">
		<xsl:variable name="front" select="current()/tei:front"/>
		<xsl:variable name="doc_id">
			<xsl:choose>
				<xsl:when test="current()/@xml:id">
					<xsl:value-of select="current()/@xml:id"/>
				</xsl:when>
				<xsl:when test="current()/tei:body/tei:div[@subtype = 'edition_text']/@xml:id">
					<xsl:value-of
						select="current()/tei:body/tei:div[@subtype = 'edition_text']/@xml:id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(preceding-sibling::tei:text) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not($doc_id = '')">
			<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
				byte-order-mark="yes"
				href="{$filePrefix}/data/output_data/prefatory_matter/front/front_doc_{$doc_id}.html"
				indent="yes">
				<xsl:call-template name="front_generation">
					<xsl:with-param name="front" select="$front"/>
				</xsl:call-template>
			</xsl:result-document>
		</xsl:if>
	</xsl:template>

	<!-- REGESTO -->
	<xsl:template name="regesto">
		<xsl:variable name="doc_id">
			<xsl:choose>
				<xsl:when test="current()/@xml:id">
					<xsl:value-of select="current()/@xml:id"/>
				</xsl:when>
				<xsl:when test="current()/tei:body/tei:div[@subtype = 'edition_text']/@xml:id">
					<xsl:value-of
						select="current()/tei:body/tei:div[@subtype = 'edition_text']/@xml:id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(preceding-sibling::tei:text) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain"
			byte-order-mark="yes"
			href="{$filePrefix}/data/output_data/prefatory_matter/regesto/regesto_doc_{$doc_id}.html"
			indent="yes">
			<xsl:variable name="front" select="current()/tei:front"/>
			<xsl:call-template name="doc_regesto">
				<xsl:with-param name="doc_id" select="$doc_id"/>
				<xsl:with-param name="front" select="$front"/>
			</xsl:call-template>
		</xsl:result-document>
	</xsl:template>

	<!-- LIST PERSON -->
	<xsl:template name="listPerson">
		<xsl:element name="ul">
			<xsl:attribute name="id" select="'ul_listPerson'"/>
			<xsl:attribute name="class" select="'ul_list'"/>
			<xsl:for-each select="$root//tei:listPerson/person">
				<xsl:sort select="lower-case(tei:persName/tei:forename)" order="ascending"/>
				<xsl:sort select="lower-case(tei:persName/tei:name)" order="ascending"/>
				<xsl:element name="li">
					<xsl:attribute name="id" select="@xml:id"/>
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-order-list">
						<xsl:choose>
							<xsl:when test="tei:persName/tei:forename">
								<xsl:value-of select="substring(tei:persName/tei:forename, 1, 1)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(tei:persName/tei:name, 1, 1)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<!--<xsl:value-of select="substring(@xml:id, 1, 1)"/>-->
					<xsl:call-template name="person"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- LIST PLACE -->
	<xsl:template name="listPlace">
		<xsl:element name="ul">
			<xsl:attribute name="id" select="'ul_listPlace'"/>
			<xsl:attribute name="class" select="'ul_list'"/>
			<xsl:for-each select="$root//tei:listPlace/place">
				<xsl:sort select="lower-case(tei:settlement)" order="ascending"/>
				<xsl:element name="li">
					<xsl:attribute name="id" select="@xml:id"/>
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-order-list" select="substring(tei:settlement, 1, 1)"/>
					<!--<xsl:value-of select="substring(@xml:id, 1, 1)"/>-->
					<xsl:call-template name="place"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- LIST ORG -->
	<xsl:template name="listOrg">
		<xsl:element name="ul">
			<xsl:attribute name="id" select="'ul_listOrg'"/>
			<xsl:attribute name="class" select="'ul_list'"/>
			<xsl:for-each select="$root//tei:listOrg/org">
				<xsl:sort select="lower-case(@xml:id)" order="ascending"/>
				<xsl:element name="li">
					<xsl:attribute name="id" select="@xml:id"/>
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-order-list" select="substring(@xml:id, 1, 1)"/>
					<xsl:call-template name="org"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- LIST TERM -->
	<xsl:template name="listTerm">
		<xsl:element name="ul">
			<xsl:attribute name="id" select="'ul_listTerm'"/>
			<xsl:attribute name="class" select="'ul_list'"/>
			<xsl:for-each select="$root//tei:term">
				<xsl:sort
					select="
						if (@xml:id) then
							(lower-case(@xml:id))
						else
							(lower-case(normalize-space(current())))"
					order="ascending"/>
				<xsl:variable name="termText">
					<xsl:apply-templates select="current()"/>
				</xsl:variable>
				<xsl:element name="li">
					<xsl:attribute name="id">
						<xsl:choose>
							<xsl:when test="@xml:id">
								<xsl:value-of select="@xml:id"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="translate(normalize-space($termText), ' ', '')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-order-list" select="substring($termText, 1, 1)"/>
					<xsl:element name="span">
						<xsl:attribute name="class" select="'toggle_list_element'"/>
						<xsl:apply-templates select="current()"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- LIST GLOSS -->
	<xsl:template name="listGloss">
		<xsl:element name="ul">
			<xsl:attribute name="id" select="'ul_listGloss'"/>
			<xsl:attribute name="class" select="'ul_list'"/>
			<xsl:for-each select="$root//tei:gloss">
				<xsl:sort
					select="
						if (@xml:id) then
							(lower-case(@xml:id))
						else
							(lower-case(normalize-space(current())))"
					order="ascending"/>
				<xsl:variable name="glossText">
					<xsl:apply-templates select="current()"/>
				</xsl:variable>
				<xsl:element name="li">
					<xsl:attribute name="id">
						<xsl:choose>
							<xsl:when test="@xml:id">
								<xsl:value-of select="@xml:id"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="translate(normalize-space($glossText), ' ', '')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-order-list" select="substring($glossText, 1, 1)"/>
					<xsl:element name="span">
						<xsl:attribute name="class" select="'toggle_list_element'"/>
						<xsl:apply-templates select="current()"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!--CHRONOLOGICAL INDEX - LIST DOCUMENT -->
	<!--TEMPLATE FOR SORTING ATTRIBUTE AND BUTTON ASC/DESC-->

	<xsl:template name="sortOptions">
		<span id="span_listDoc_select" class="like_select" title="SELECTOR_SORT_ATTRIBUTE"
			lang="def">
			<div class="docList_sort_attribute_select">
				<span data-value="sort_date" class="label_selected" lang="def">DATE</span>
				<div class="open_select open_down">
					<i class="fa fa-sort-desc"/>
				</div>
				<div class="option_container down">
					<div class="option" data-value="sort_date" lang="def">DATE</div>
					<div class="option" data-value="sort_document" lang="def">DOCUMENT</div>
				</div>
			</div>
		</span>
		<div id="sortingOrder" class="mainButtons" title="SORT_ORDER" lang="def">
			<span lang="def" />
			<i class="fa"/>
		</div>
	</xsl:template>

	<xsl:template name="dateValue">
		<xsl:param name="date"/>
		<xsl:choose>
			<!--funziona correttamente solo usando questo ordine per i match-->
			<xsl:when test="matches($date, '\d{4}-\d{2}-\d{2}')">
				<xsl:value-of select="$date"/>
			</xsl:when>
			<xsl:when test="matches($date, '\d{4}-\d{2}')">
				<xsl:value-of select="concat($date, '-01')"/>
			</xsl:when>
			<xsl:when test="matches($date, '\d{4}')">
				<xsl:value-of select="concat($date, '-01', '-01')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="listDoc">
		<xsl:element name="ul">
			<xsl:attribute name="id" select="'ul_listDocument'"/>
			<xsl:attribute name="class" select="'ul_list'"/>
			<xsl:for-each select="$root//tei:text/tei:group/tei:text">
				<xsl:element name="li">
					<xsl:attribute name="id" select="@xml:id"/>
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-sort-date">
						<xsl:choose>
							<xsl:when test="current()//tei:docDate//tei:date[@when]">
								<xsl:call-template name="dateValue">
									<xsl:with-param name="date">
										<xsl:value-of
											select="tei:front//tei:docDate//(tei:date[@when])[1]/@when"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="current()//tei:docDate//tei:date[@notBefore]">
								<xsl:call-template name="dateValue">
									<xsl:with-param name="date">
										<xsl:value-of
											select="tei:front//tei:docDate//tei:date/@notBefore"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="current()//tei:docDate//tei:date[@from]">
								<xsl:call-template name="dateValue">
									<xsl:with-param name="date">
										<xsl:value-of
											select="tei:front//tei:docDate//tei:date/@from"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<!--   <xsl:otherwise>
                               <xsl:call-template name="dateValue">
                               <xsl:with-param name="date"><xsl:value-of select="tei:front//tei:docDate//tei:date/@"/></xsl:with-param>
                               </xsl:call-template>  
                           </xsl:otherwise> -->
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="data-sort-num">
						<xsl:value-of
							select="current()//tei:front//tei:titlePart[@type = 'numerazioneNuova']"
						/>
					</xsl:attribute>
					<xsl:call-template name="document"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!--END CHRONOLOGICAL INDEX -->

	<xsl:template name="prova">
		<xsl:apply-templates select="tei:TEI//tei:facsimile" mode="create_imageList"></xsl:apply-templates>	
	</xsl:template>
	
	<!-- GM -->
	<xsl:template name="idno_process">
		<xsl:variable name="path" select="doc('../../data/input_data/text/CP.xml')"/>
			<xsl:apply-templates select="$path" mode="find_idno"></xsl:apply-templates>
			
	</xsl:template>
	
	<xsl:template match="text()" mode="deleteSpaces">
		<xsl:choose>
			<xsl:when test="ancestor::*[@xml:space][1]/@xml:space = 'preserve'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Retain one leading space if node isn't first, has non-space content, and has leading space.-->
				<xsl:if test="position() != 1 and matches(., '^\s') and normalize-space() != ''">
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:choose>
					<!-- node is an only child, and has content but it's all space -->
					<xsl:when test="last() = 1 and string-length() != 0 and normalize-space() = ''">
						<xsl:text> </xsl:text>
					</xsl:when>
					<!-- node isn't last, isn't first, and has trailing space -->
					<xsl:when test="position() != 1 and position() != last() and matches(., '\s$')">
						<xsl:text> </xsl:text>
					</xsl:when>
					<!-- node isn't last, is first, has trailing space, and has non-space content   -->
					<xsl:when
						test="position() = 1 and matches(., '\s$') and normalize-space() != ''">
						<xsl:text> </xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:back" mode="exclude_back">
		<!-- DO NOTHING -->
	</xsl:template>

	<xsl:template match="@* | node()" mode="delete_el1">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template
		match="node()[name() = 'span'][@class = 'dipl-choice_popup']/node()[name() = 'span'][@class = 'dipl-reg']"
		mode="delete_el1">
		<!-- DO NOTHING -->
	</xsl:template>

	<xsl:template match="node()[name() = 'div'][@class = 'dipl-zone']" mode="delete_el1">
		<!-- DO NOTHING -->
	</xsl:template>

	<xsl:template match="node()[name() = 'div'][@class = 'dipl-attachment']" mode="delete_el1">
		<!-- DO NOTHING -->
	</xsl:template>

	<xsl:template match="@* | node()" mode="delete_el2">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template
		match="node()[name() = 'span'][@class = 'interp-choice_popup']/node()[name() = 'span'][@class = 'interp-orig'] | node()[name() = 'span'][@class = 'interp-corr']"
		mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>

	<xsl:template match="node()[name() = 'div'][@class = 'interp-zone']" mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>

	<xsl:template match="node()[name() = 'div'][@class = 'interp-attachment']" mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name() = 'span'][@class = 'tooltip_text']" mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name() = 'span'][@class = 'tooltip' ]" mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="delete_el3">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()[name()='span'][@class='tdipl-choice_popup']/node()[name()='span'][@class='tdipl-orig']|node()[name()='span'][@class='tdipl-corr']" mode="delete_el3">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='tdipl-zone']" mode="delete_el3">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='tdipl-attachment']" mode="delete_el3">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="delete_el4">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()[name()='span'][@class='crit-choice_popup']/node()[name()='span'][@class='crit-orig']|node()[name()='span'][@class='crit-corr']" mode="delete_el4">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='crit-zone']" mode="delete_el4">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='crit-attachment']" mode="delete_el4">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template name="search_file">
		<xsl:if test="$edition_array[1]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[1])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<!-- Questa istruzione introdotta da XSLT 2.0 selezione un set di elementi, li divide in guppi seguendo un determinato criterio e infine processa il contenuto
				di ogni gruppo. Per la selezione dei gruppi utilizza attributo group-starting-with: che divide il blocco di elementi in gruppi, creando un niovo gruppo
				ogni volta che inconta l'elemento indicato come criterio di selezione-->
					<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
						<xsl:choose>
							<xsl:when test="current-group()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										<!-- TEXTUAL CONTENT -->
										<xsl:variable name="current_text">
											<xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="dipl"/>
										</xsl:variable>
										<xsl:variable name="current_text1">
											<xsl:apply-templates select="$current_text" mode="delete_el1"/>
										</xsl:variable>
										<xsl:variable name="current_text2">
											<xsl:apply-templates select="$current_text1//text()[not(ancestor::span)]" mode="deleteSpaces"/>
										</xsl:variable>
										{ 
											"line" : "<xsl:call-template name="line_refs4search"/>",
											"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
											"tags" : "<xsl:call-template name="doc_refs4search"/>",
											"loc" : "<xsl:call-template name="page_refs4search"/>"
										},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current-group()/(descendant-or-self::p)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current-group()/descendant::p" group-starting-with="//tei:p">
									<xsl:variable name="current_text">
										<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/>
									</xsl:variable>
									<xsl:variable name="current_text1">
										<xsl:apply-templates select="$current_text"
											mode="delete_el2"/>
									</xsl:variable>
									<xsl:variable name="current_text2">
										<xsl:apply-templates
											select="$current_text1//text()[not(ancestor::span)]"
											mode="deleteSpaces"/>
									</xsl:variable>
									{
									"line" : "<xsl:call-template name="paragraph_refs4search"/>",
									"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
									"tags" : "<xsl:call-template name="doc_refs4search"/>",
									"loc" : "<xsl:call-template name="page_refs4search"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<!-- TEXTUAL CONTENT -->
								<xsl:variable name="current_text">
									<xsl:apply-templates select="current-group()[not(self::tei:pb)]"
										mode="dipl"/>
								</xsl:variable>
								<xsl:variable name="current_text1">
									<xsl:apply-templates select="$current_text" mode="delete_el1"/>
								</xsl:variable>
								<xsl:variable name="current_text2">
									<xsl:apply-templates
										select="$current_text1//text()[not(ancestor::span)]"
										mode="deleteSpaces"/>
								</xsl:variable> 
								{ 
									"line" : "<xsl:call-template name="line_refs4search"/>", 
									"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>", 
									"tags" : "<xsl:call-template name="doc_refs4search"/>", 
									"loc" : "<xsl:call-template name="page_refs4search"/>" }, 
							</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each-group> { "line" : "", "text" : "", "tags" : "", "loc" : "" }]}
			</xsl:result-document>
		</xsl:if>
		
		<xsl:if test="$edition_array[2]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[2])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
					<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
						<xsl:choose>
							<xsl:when test="current-group()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										<xsl:variable name="current_text">
											<xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="interp"/>
										</xsl:variable>
										<xsl:variable name="current_text1">
											<xsl:apply-templates select="$current_text" mode="delete_el2"/>
										</xsl:variable>
										<xsl:variable name="current_text2">
											<xsl:apply-templates select="$current_text1//text()[not(ancestor::span)]" mode="deleteSpaces"/>
										</xsl:variable>
										{ 
											"line" : "<xsl:call-template name="line_refs4search"/>",
											"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
											"tags" : "<xsl:call-template name="doc_refs4search"/>",
											"loc" : "<xsl:call-template name="page_refs4search"/>"
										},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current-group()/(descendant-or-self::p)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current-group()/descendant::p" group-starting-with="//tei:p">
									<xsl:variable name="current_text">
										<xsl:apply-templates
											select="current-group()[not(self::tei:lb)]"
											mode="interp"/>
									</xsl:variable>
									<xsl:variable name="current_text1">
										<xsl:apply-templates select="$current_text"
											mode="delete_el2"/>
									</xsl:variable>
									<xsl:variable name="current_text2">
										<xsl:apply-templates
											select="$current_text1//text()[not(ancestor::span)]"
											mode="deleteSpaces"/>
									</xsl:variable>
									{
										"line" : "<xsl:call-template name="line_refs4search"/>", 
										"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
										"tags" : "<xsl:call-template name="doc_refs4search"/>",
										"loc" : "<xsl:call-template name="page_refs4search"/>" },
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="current_text">
									<xsl:apply-templates select="current-group()[not(self::tei:pb)]"
										mode="interp"/>
								</xsl:variable>
								<xsl:variable name="current_text1">
									<xsl:apply-templates select="$current_text" mode="delete_el2"/>
								</xsl:variable>
								<xsl:variable name="current_text2">
									<xsl:apply-templates
										select="$current_text1//text()[not(ancestor::span)]"
										mode="deleteSpaces"/>
								</xsl:variable> 
								{ 
									"line" : "<xsl:call-template name="paragraph_refs4search"/>", 
									"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>", 
									"tags" : "<xsl:call-template name="doc_refs4search"/>", 
									"loc" : "<xsl:call-template name="page_refs4search"/>" }, 
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each-group> 
				{ "line" : "", "text" : "", "tags" : "", "loc" : "" }]}
			</xsl:result-document>
		</xsl:if>
		
		<xsl:if test="$edition_array[3]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[3])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<!-- Questa istruzione introdotta da XSLT 2.0 selezione un set di elementi, li divide in guppi seguendo un determinato criterio e infine processa il contenuto
				di ogni gruppo. Per la selezione dei gruppi utilizza attributo group-starting-with: che divide il blocco di elementi in gruppi, creando un niovo gruppo
				ogni volta che inconta l'elemento indicato come criterio di selezione-->
				<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
					<xsl:choose>
						<xsl:when test="current-group()/(descendant-or-self::lb)">
							<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
								<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
									<!-- TEXTUAL CONTENT -->
									<xsl:variable name="current_text">
										<xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="tdipl"/>
									</xsl:variable>
									<xsl:variable name="current_text1">
										<xsl:apply-templates select="$current_text" mode="delete_el3"/>
									</xsl:variable>
									<xsl:variable name="current_text2">
										<xsl:apply-templates select="$current_text1//text()[not(ancestor::span)]" mode="deleteSpaces"/>
									</xsl:variable>
									{ 
									"line" : "<xsl:call-template name="line_refs4search"/>",
									"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
									"tags" : "<xsl:call-template name="doc_refs4search"/>",
									"loc" : "<xsl:call-template name="page_refs4search"/>"
									},
								</xsl:if>
							</xsl:for-each-group>
						</xsl:when>
						<xsl:when test="current-group()/(descendant-or-self::p)">
							<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
							<xsl:for-each-group select="current-group()/descendant::p" group-starting-with="//tei:p">
								<xsl:variable name="current_text">
									<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="tdipl"/>
								</xsl:variable>
								{
								"line" : "<xsl:call-template name="paragraph_refs4search"/>",
								"text" : "<xsl:value-of select="fn:normalize-space($current_text)"/>",
								"tags" : "<xsl:call-template name="doc_refs4search"/>",
								"loc" : "<xsl:call-template name="page_refs4search"/>"
								},
							</xsl:for-each-group>
						</xsl:when>
						<xsl:otherwise>
							<!-- TEXTUAL CONTENT -->
							<xsl:variable name="current_text">
								<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="tdipl"/>
							</xsl:variable>
							<xsl:variable name="current_text1">
								<xsl:apply-templates select="$current_text" mode="delete_el3"/>
							</xsl:variable>
							<xsl:variable name="current_text2">
								<xsl:apply-templates select="$current_text1//text()[not(ancestor::span)]" mode="deleteSpaces"/>
							</xsl:variable>
							{ 
							"line" : "<xsl:call-template name="line_refs4search"/>",
							"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
							"tags" : "<xsl:call-template name="doc_refs4search"/>",
							"loc" : "<xsl:call-template name="page_refs4search"/>"
							},
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each-group>
				{
				"line" : "",
				"text" : "",
				"tags" : "",
				"loc" : ""
				}]}
			</xsl:result-document>
		</xsl:if>


		<!-- ADD BY FS - Edizione critica -->
		<xsl:if test="$edition_array[4]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[4])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
					<xsl:choose>
					<xsl:when test="current-group()/(descendant-or-self::lb)">
                    	<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
                        	<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
                            	<xsl:variable name="current_text">
                                	<xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="crit"/>
                            	</xsl:variable>
                            	<xsl:variable name="current_text1">
                               		<xsl:apply-templates select="$current_text" mode="delete_el4"/>
                            	</xsl:variable>
                            	<xsl:variable name="current_text2">
                                	<xsl:apply-templates select="$current_text1//text()[not(ancestor::span)]" mode="deleteSpaces"/>
                           		 </xsl:variable>
                            		{ 
                          				"line" : "<xsl:call-template name="line_refs4search"/>",
                            			"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
                           				"tags" : "<xsl:call-template name="doc_refs4search"/>",
                            			"loc" : "<xsl:call-template name="page_refs4search"/>"
                            		},
                        		</xsl:if>
                    		</xsl:for-each-group>
						</xsl:when>
               
						<xsl:when test="current-group()/(descendant-or-self::p)">
							<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="crit"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
							<xsl:for-each-group select="current-group()/descendant::p" group-starting-with="//tei:p">
								<xsl:variable name="current_text">
									<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="crit"/>
								</xsl:variable>
								{
								"line" : "<xsl:call-template name="paragraph_refs4search"/>",
								"text" : "<xsl:value-of select="fn:normalize-space($current_text)"/>",
								"tags" : "<xsl:call-template name="doc_refs4search"/>",
								"loc" : "<xsl:call-template name="page_refs4search"/>"
								},
							</xsl:for-each-group>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="current_text">
								<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="crit"/>
							</xsl:variable>
							<xsl:variable name="current_text1">
								<xsl:apply-templates select="$current_text" mode="delete_el4"/>
							</xsl:variable>
							<xsl:variable name="current_text2">
								<xsl:apply-templates select="$current_text1//text()[not(ancestor::span)]" mode="deleteSpaces"/>
							</xsl:variable>
							{
							"line" : "<xsl:call-template name="paragraph_refs4search"/>",
							"text" : "<xsl:copy-of select="replace($current_text2, '(\\|/)', '$1$1')"/>",
							"tags" : "<xsl:call-template name="doc_refs4search"/>",
							"loc" : "<xsl:call-template name="page_refs4search"/>"
							},
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each-group>
				{
				"line" : "",
				"text" : "",
				"tags" : "",
				"loc" : ""
				}]}
			</xsl:result-document>
		</xsl:if>
		<!-- ADD BY FS - Edizione di traduzione -->
		<xsl:if test="$edition_array[5]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[5])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<!-- Questa istruzione introdotta da XSLT 2.0 selezione un set di elementi, li divide in guppi seguendo un determinato criterio e infine traduce il contenuto
				di ogni gruppo. Per la selezione dei gruppi utilizza attributo group-starting-with: che divide il blocco di elementi in gruppi, creando un niovo gruppo
				ogni volta che inconta l'elemento indicato come criterio di selezione-->
				<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
					<xsl:choose>
						<xsl:when test="current-group()/(descendant-or-self::lb)">
							<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
								<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
									<!-- TEXTUAL CONTENT -->
									<xsl:variable name="current_text">
										<xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="trad"/>
									</xsl:variable>
									<xsl:variable name="current_text1">
										<xsl:apply-templates select="$current_text//text()[not(ancestor::span)]" mode="deleteSpaces"/>
									</xsl:variable>
									{ 
									"line" : "<xsl:call-template name="line_refs4search"/>",
									"text" : "<xsl:copy-of select="replace($current_text1, '(\\|/)', '$1$1')"/>",
									"tags" : "<xsl:call-template name="doc_refs4search"/>",
									"loc" : "<xsl:call-template name="page_refs4search"/>"
									},
								</xsl:if>
							</xsl:for-each-group>
						</xsl:when>
						<xsl:when test="current-group()/(descendant-or-self::p)">
							<xsl:for-each-group select="current-group()/descendant::p" group-starting-with="//tei:p">
								<xsl:variable name="current_text">
									<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="trad"/>
								</xsl:variable>
								{
								"line" : "<xsl:call-template name="paragraph_refs4search"/>",
								"text" : "<xsl:value-of select="fn:normalize-space($current_text)"/>",
								"tags" : "<xsl:call-template name="doc_refs4search"/>",
								"loc" : "<xsl:call-template name="page_refs4search"/>"
								},
							</xsl:for-each-group>
						</xsl:when>
						<xsl:otherwise>
							<!-- TEXTUAL CONTENT -->
							<xsl:variable name="current_text">
								<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="trad"/>
							</xsl:variable>
							<xsl:variable name="current_text1">
								<xsl:apply-templates select="$current_text//text()[not(ancestor::span)]" mode="deleteSpaces"/>
							</xsl:variable>
							{ 
							"line" : "<xsl:call-template name="line_refs4search"/>",
							"text" : "<xsl:copy-of select="replace($current_text1, '(\\|/)', '$1$1')"/>",
							"tags" : "<xsl:call-template name="doc_refs4search"/>",
							"loc" : "<xsl:call-template name="page_refs4search"/>"
							},
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each-group>
				{
				"line" : "",
				"text" : "",
				"tags" : "",
				"loc" : ""
				}]}
			</xsl:result-document>
		</xsl:if>
	
	</xsl:template>

	<xsl:template name="doc_refs4search">
		<xsl:variable name="doc_id">
			<xsl:choose>
				<xsl:when test="current-group()/ancestor-or-self::tei:text[1]/@xml:id">
					<xsl:value-of select="current-group()/ancestor-or-self::tei:text[1]/@xml:id"/>
				</xsl:when>
				<xsl:when
					test="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype = 'edition_text'][1]/@xml:id">
					<xsl:value-of
						select="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype = 'edition_text'][1]/@xml:id"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="concat('text_', current-group()/ancestor-or-self::tei:text[1]/position())"
					/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="doc_label">
			<xsl:choose>
				<xsl:when test="current-group()/ancestor-or-self::tei:text[1]/@n">
					<xsl:value-of select="current-group()/ancestor-or-self::tei:text[1]/@n"/>
				</xsl:when>
				<xsl:when
					test="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype = 'edition_text'][1]/@n">
					<xsl:value-of
						select="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype = 'edition_text'][1]/@n"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="generateTextLabel">
						<xsl:with-param name="text_id">
							<xsl:value-of select="$doc_id"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$doc_id"/>|<xsl:value-of select="$doc_label"/>
	</xsl:template>

	<xsl:template name="page_refs4search">
		<xsl:variable name="page_id">
			<xsl:choose>
				<xsl:when test="preceding::pb[1]/@xml:id">
					<xsl:value-of select="preceding::pb[1]/@xml:id"/>
				</xsl:when>
				<xsl:otherwise>no_page_info</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="page_label">
			<xsl:choose>
				<xsl:when test="preceding::pb[1]/@n">
					<xsl:value-of select="preceding::pb[1]/@n"/>
				</xsl:when>
				<xsl:when test="preceding::pb[1]/@xml:id">
					<xsl:value-of select="preceding::pb[1]/@xml:id"/>
				</xsl:when>
				<xsl:otherwise>no_page_info</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$page_id"/>|<xsl:value-of select="$page_label"/>
	</xsl:template>

	<xsl:template name="line_refs4search">
		<xsl:choose>
			<xsl:when test="self::tei:lb/@n">
				<xsl:value-of select="concat(self::tei:lb/@n, '|line ', self::tei:lb/@n)"/>
			</xsl:when>
			<xsl:otherwise>no line info |no line info</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="paragraph_refs4search">
		<xsl:variable name="p_id">
			<xsl:choose>
				<xsl:when test="@xml:id">
					<xsl:value-of select="@xml:id"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="p_label">
			<xsl:choose>
				<xsl:when test="@n">
					<xsl:value-of select="concat('par ', @n)"/>
				</xsl:when>
				<xsl:when test="@xml:id">
					<xsl:value-of select="concat('par ', @xml:id)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$p_id"/>|<xsl:value-of select="$p_label"/>
	</xsl:template>

	<xsl:template name="search_file4embedded">
		<xsl:if test="$edition_array[1] != ''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[1])"/>
			<xsl:result-document method="text"
				href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json"
				indent="no"> {"pages": [ <xsl:for-each select="$root//tei:surface">
					<xsl:if test="current()/@xml:id">
						<xsl:variable name="pageId"
							select="
								if (@xml:id) then
									(@xml:id)
								else
									(@n)"/>
						<xsl:variable name="pageLabel"
							select="
								if (@n) then
									(@n)
								else
									(@xml:id)"/>
						<xsl:choose>
							<xsl:when test="current()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current()[not(self::pb)]"
									group-starting-with="tei:lb">
									<xsl:if
										test="current-group()[not((string-length(normalize-space())) = 0)]"
										> { "line" : "<xsl:value-of
											select="
												if (self::tei:lb/@n) then
													(concat(self::tei:lb/@n, '|line ', self::tei:lb/@n))
												else
													('no line info|no line info')"
										/>", "text" : "<xsl:variable name="var"><xsl:apply-templates
												select="current-group()[not(self::tei:lb)]"
												mode="dipl"/></xsl:variable><xsl:variable
											name="var1"><xsl:apply-templates select="$var"
												mode="delete_el1"/></xsl:variable><xsl:variable
											name="var2"><xsl:apply-templates
												select="$var1//text()[not(ancestor::span)]"
												mode="deleteSpaces"/></xsl:variable><xsl:copy-of
											select="replace($var2, '(\\|/)', '$1$1')"/>", "tags" :
											"<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"
												/>|<xsl:choose><xsl:when
												test="ancestor::tei:sourceDoc/@n"><xsl:value-of
												select="ancestor::tei:sourceDoc/@n"
												/></xsl:when><xsl:otherwise><xsl:call-template
												name="generateTextLabel"><xsl:with-param
												name="text_id"><xsl:value-of
												select="ancestor::tei:sourceDoc/@xml:id"
												/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
										"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of
											select="$pageLabel"/>" }, </xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::line)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::line"
									group-starting-with="//tei:line"> { "line" : "<xsl:value-of
										select="
											if (@xml:id) then
												(@xml:id)
											else
												('no line info')"
										/>|<xsl:value-of
										select="
											if (@n) then
												(concat('line ', @n))
											else
												('no line info')"
									/>", "text" : "<xsl:variable name="var"><xsl:apply-templates
											select="current-group()[not(self::tei:pb)]" mode="dipl"
										/></xsl:variable><xsl:value-of
										select="fn:normalize-space($var)"/>", "tags" :
										"<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"
											/>|<xsl:choose><xsl:when
											test="ancestor::tei:sourceDoc/@n"><xsl:value-of
												select="ancestor::tei:sourceDoc/@n"
												/></xsl:when><xsl:otherwise><xsl:call-template
												name="generateTextLabel"><xsl:with-param
												name="text_id"><xsl:value-of
												select="ancestor::tei:sourceDoc/@xml:id"
												/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of
										select="$pageLabel"/>" }, </xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise> { "line" : "no line info|no line info", "text" :
									"<xsl:variable name="var"><xsl:apply-templates
										select="current()" mode="dipl"/></xsl:variable><xsl:variable
									name="var1"><xsl:apply-templates select="$var" mode="delete_el2"
									/></xsl:variable><xsl:copy-of select="$var1//text()"/>", "tags"
								: "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"
										/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"
											><xsl:value-of select="ancestor::tei:sourceDoc/@n"
										/></xsl:when><xsl:otherwise><xsl:call-template
											name="generateTextLabel"><xsl:with-param name="text_id"
												><xsl:value-of
												select="ancestor::tei:sourceDoc/@xml:id"
												/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
								"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of
									select="$pageLabel"/>" }, </xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each> { "line" : "", "text" : "", "tags" : "", "loc" : "" }]}
			</xsl:result-document>
		</xsl:if>
		
		<xsl:if test="$edition_array[2]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[2])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<xsl:for-each select="$root//tei:surface">
					<xsl:if test="current()/@xml:id">
						<xsl:variable name="pageId"
							select="
								if (@xml:id) then
									(@xml:id)
								else
									(@n)"/>
						<xsl:variable name="pageLabel"
							select="
								if (@n) then
									(@n)
								else
									(@xml:id)"/>
						<xsl:choose>
							<xsl:when test="current()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current()" group-starting-with="tei:lb">
									<xsl:if
										test="current-group()[not((string-length(normalize-space())) = 0)]"
										> { "line" : "<xsl:value-of
											select="
												if (self::tei:lb/@n) then
													(concat(self::tei:lb/@n, '|line ', self::tei:lb/@n))
												else
													('no line info |no line info')"
										/>", "text" : "<xsl:variable name="var"><xsl:apply-templates
												select="current-group()[not(self::tei:lb)]"
												mode="interp"/></xsl:variable><xsl:variable
											name="var1"><xsl:apply-templates select="$var"
												mode="delete_el2"/></xsl:variable><xsl:variable
											name="var2"><xsl:apply-templates
												select="$var1//text()[not(ancestor::span)]"
												mode="deleteSpaces"/></xsl:variable><xsl:copy-of
											select="replace($var2, '(\\|/)', '$1$1')"/>", "tags" :
											"<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"
												/>|<xsl:choose><xsl:when
												test="ancestor::tei:sourceDoc/@n"><xsl:value-of
												select="ancestor::tei:sourceDoc/@n"
												/></xsl:when><xsl:otherwise><xsl:call-template
												name="generateTextLabel"><xsl:with-param
												name="text_id"><xsl:value-of
												select="ancestor::tei:sourceDoc/@xml:id"
												/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
										"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of
											select="$pageLabel"/>" }, </xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::p)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::p"
									group-starting-with="//tei:p"> { "line" : "<xsl:value-of
										select="
											if (@xml:id) then
												(@xml:id)
											else
												('no par info')"
										/>|<xsl:value-of
										select="
											if (@n) then
												(concat('par ', @n))
											else
												('no par info')"
									/>", "text" : "<xsl:variable name="var"><xsl:apply-templates
											select="current-group()[not(self::tei:pb)]" mode="dipl"
										/></xsl:variable><xsl:value-of
										select="fn:normalize-space($var)"/>", "tags" :
										"<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"
											/>|<xsl:choose><xsl:when
											test="ancestor::tei:sourceDoc/@n"><xsl:value-of
												select="ancestor::tei:sourceDoc/@n"
												/></xsl:when><xsl:otherwise><xsl:call-template
												name="generateTextLabel"><xsl:with-param
												name="text_id"><xsl:value-of
												select="ancestor::tei:sourceDoc/@xml:id"
												/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of
										select="$pageLabel"/>" }, </xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::line)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::line"
									group-starting-with="//tei:line"> { "line" : "<xsl:value-of
										select="
											if (@xml:id) then
												(@xml:id)
											else
												('no line info')"
										/>|<xsl:value-of
										select="
											if (@n) then
												(concat('line ', @n))
											else
												('no line info')"
									/>", "text" : "<xsl:variable name="var"><xsl:apply-templates
											select="current-group()[not(self::tei:pb)]" mode="dipl"
										/></xsl:variable><xsl:value-of
										select="fn:normalize-space($var)"/>", "tags" :
										"<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"
											/>|<xsl:choose><xsl:when
											test="ancestor::tei:sourceDoc/@n"><xsl:value-of
												select="ancestor::tei:sourceDoc/@n"
												/></xsl:when><xsl:otherwise><xsl:call-template
												name="generateTextLabel"><xsl:with-param
												name="text_id"><xsl:value-of
												select="ancestor::tei:sourceDoc/@xml:id"
												/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of
										select="$pageLabel"/>" }, </xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise> { "line" : "no line info|no line info", "text" :
									"<xsl:variable name="var"><xsl:apply-templates
										select="current()" mode="interp"
									/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates
										select="$var" mode="delete_el2"/></xsl:variable><xsl:copy-of
									select="$var1//text()"/>", "tags" : "<xsl:value-of
									select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when
										test="ancestor::tei:sourceDoc/@n"><xsl:value-of
											select="ancestor::tei:sourceDoc/@n"
											/></xsl:when><xsl:otherwise><xsl:call-template
											name="generateTextLabel"><xsl:with-param name="text_id"
												><xsl:value-of
												select="ancestor::tei:sourceDoc/@xml:id"
												/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
								"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of
									select="$pageLabel"/>" }, </xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each> { "line" : "", "text" : "", "tags" : "", "loc" : "" }]}
			</xsl:result-document>
		</xsl:if>
		
		<xsl:if test="$edition_array[3]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[3])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<xsl:for-each select="$root//tei:surface">
					<xsl:if test="current()/@xml:id">
						<xsl:variable name="pageId" select="if(@xml:id) then (@xml:id) else (@n)"/>
						<xsl:variable name="pageLabel" select="if(@n) then (@n) else (@xml:id)"/>
						<xsl:choose>
							<xsl:when test="current()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current()" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										{ 
										"line" : "<xsl:value-of select="if(self::tei:lb/@n) then(concat(self::tei:lb/@n, '|line ',self::tei:lb/@n)) else('no line info |no line info')" />",
										"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="tdipl"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el3"/></xsl:variable><xsl:variable name="var2"><xsl:apply-templates select="$var1//text()[not(ancestor::span)]" mode="deleteSpaces"/></xsl:variable><xsl:copy-of select="replace($var2, '(\\|/)', '$1$1')"/>",
										"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
										"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
										},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::p)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::p" group-starting-with="//tei:p">
									{
									"line" : "<xsl:value-of select="if(@xml:id) then (@xml:id) else('no par info')" />|<xsl:value-of select="if(@n) then(concat('par ',@n)) else('no par info')" />",
									"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="tdipl"/></xsl:variable><xsl:value-of select="fn:normalize-space($var)"/>",
									"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::line)">
								<xsl:for-each-group select="current()/descendant::line" group-starting-with="//tei:line">
									{
									"line" : "<xsl:value-of select="if(@xml:id) then (@xml:id) else('no line info')" />|<xsl:value-of select="if(@n) then(concat('line ',@n)) else('no line info')" />",
									"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="tdipl"/></xsl:variable><xsl:value-of select="fn:normalize-space($var)"/>",
									"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								{
								"line" : "no line info|no line info",
								"text" : "<xsl:variable name="var"><xsl:apply-templates select="current()" mode="tdipl"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el3"/></xsl:variable><xsl:copy-of select="$var1//text()"/>",
								"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
								"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
								},
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
				{
				"line" : "",
				"text" : "",
				"tags" : "",
				"loc" : ""
				}]}
			</xsl:result-document>
		</xsl:if>			
		<!-- ADD BY FS - Edizione critica  -->
		<xsl:if test="$edition_array[4]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[4])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<xsl:for-each select="$root//tei:surface">
					<xsl:if test="current()/@xml:id">
						<xsl:variable name="pageId" select="if(@xml:id) then (@xml:id) else (@n)"/>
						<xsl:variable name="pageLabel" select="if(@n) then (@n) else (@xml:id)"/>
						<xsl:choose>					
							<xsl:when test="current()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current()" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										{ 
										"line" : "<xsl:value-of select="if(self::tei:lb/@n) then(concat(self::tei:lb/@n, '|line ',self::tei:lb/@n)) else('no line info |no line info')" />",
										"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="crit"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el4"/></xsl:variable><xsl:variable name="var2"><xsl:apply-templates select="$var1//text()[not(ancestor::span)]" mode="deleteSpaces"/></xsl:variable><xsl:copy-of select="replace($var2, '(\\|/)', '$1$1')"/>",
										"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
										"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
										},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when> 
							<xsl:when test="current()/(descendant-or-self::p)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::p" group-starting-with="//tei:p">
									{
									"line" : "<xsl:value-of select="if(@xml:id) then (@xml:id) else('no par info')" />|<xsl:value-of select="if(@n) then(concat('par ',@n)) else('no par info')" />",
									"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="dipl"/></xsl:variable><xsl:value-of select="fn:normalize-space($var)"/>",
									"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::line)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::line" group-starting-with="//tei:line">
									{
									"line" : "<xsl:value-of select="if(@xml:id) then (@xml:id) else('no line info')" />|<xsl:value-of select="if(@n) then(concat('line ',@n)) else('no line info')" />",
									"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="dipl"/></xsl:variable><xsl:value-of select="fn:normalize-space($var)"/>",
									"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								{
								"line" : "no line info|no line info",
								"text" : "<xsl:variable name="var"><xsl:apply-templates select="current()" mode="crit"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el4"/></xsl:variable><xsl:copy-of select="$var1//text()"/>",
								"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
								"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
								},
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
				{
				"line" : "",
				"text" : "",
				"tags" : "",
				"loc" : ""
				}]}
			</xsl:result-document>
		</xsl:if>
		<!-- ADD BY FS - Edizione di Traduzione  -->
		<xsl:if test="$edition_array[5]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[5])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<xsl:for-each select="$root//tei:surface">
					<xsl:if test="current()/@xml:id">
						<xsl:variable name="pageId" select="if(@xml:id) then (@xml:id) else (@n)"/>
						<xsl:variable name="pageLabel" select="if(@n) then (@n) else (@xml:id)"/>
						<xsl:choose>
							<xsl:when test="current()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current()" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										{ 
										"line" : "<xsl:value-of select="if(self::tei:lb/@n) then(concat(self::tei:lb/@n, '|line ',self::tei:lb/@n)) else('no line info |no line info')" />",
										"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="trad"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var//text()[not(ancestor::span)]" mode="deleteSpaces"/></xsl:variable><xsl:copy-of select="replace($var1, '(\\|/)', '$1$1')"/>",
										"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
										"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
										},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::p)">
								<xsl:for-each-group select="current()/descendant::p" group-starting-with="//tei:p">
									{
									"line" : "<xsl:value-of select="if(@xml:id) then (@xml:id) else('no par info')" />|<xsl:value-of select="if(@n) then(concat('par ',@n)) else('no par info')" />",
									"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="trad"/></xsl:variable><xsl:value-of select="fn:normalize-space($var)"/>",
									"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::line)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::line" group-starting-with="//tei:line">
									{
									"line" : "<xsl:value-of select="if(@xml:id) then (@xml:id) else('no line info')" />|<xsl:value-of select="if(@n) then(concat('line ',@n)) else('no line info')" />",
									"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="trad"/></xsl:variable><xsl:value-of select="fn:normalize-space($var)"/>",
									"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								{
								"line" : "no line info|no line info",
								"text" : "<xsl:variable name="var"><xsl:apply-templates select="current()" mode="trad"/></xsl:variable><xsl:copy-of select="$var//text()"/>",
								"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
								"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
								},
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
				{
				"line" : "",
				"text" : "",
				"tags" : "",
				"loc" : ""
				}]}
			</xsl:result-document>
		</xsl:if>	
	</xsl:template>		
	
	<xsl:template match="tei:emph">
		<span class="emph">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:hi[@rend]">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of select="@rend"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
		
</xsl:stylesheet>
