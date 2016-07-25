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
			<xsl:apply-templates select="." mode="splitPages4embedded"></xsl:apply-templates>
			<!-- SEARCH -->
			<xsl:if test="$search=true()">
				<xsl:apply-templates select="." mode="file4search4embedded"></xsl:apply-templates>
			</xsl:if>
		</xsl:if>
		<!-- EN: If there is at least a <text> element the transformations for parallel transcription are activated -->
		<!-- IT: Le trasformazioni per la parallel transcription vengono attivate se nel documento esiste almeno un elemento <text> -->
		<xsl:if test="tei:TEI/tei:text">
			<xsl:apply-templates select="$step0" mode="splitPages"/>
			
			<!-- HEADER INFORMATION -->
			<xsl:if test="$headerInfo=true()">
				<xsl:call-template name="headerInfo"/>
			</xsl:if>
			
			<!-- MANUSCRIPT DESCRIPTION -->
			<xsl:if test="$msDesc=true()">
				<xsl:call-template name="msDesc"/>
			</xsl:if>
			
			<!-- REGESTO -->
			<xsl:if test="$regesto=true()">
				<xsl:for-each select="tei:TEI/tei:text/tei:group/tei:text">
					<xsl:call-template name="regesto"/>	
				</xsl:for-each>
			</xsl:if>
			
			<!-- FRONT INFORMATION -->
			<xsl:if test="$frontInfo=true()">
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
			<xsl:if test="$list_person=true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listPerson.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listPerson</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listPerson"></xsl:call-template>
						<xsl:apply-templates select="$step0" mode="listPersonOccurences"></xsl:apply-templates>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			<xsl:if test="$list_place=true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listPlace.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listPlace</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listPlace"></xsl:call-template>
						<xsl:apply-templates select="$step0" mode="listPlaceOccurences"></xsl:apply-templates>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			<xsl:if test="$list_org=true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listOrg.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listOrg</xsl:attribute>
						<xsl:attribute name="class">can-change-font-size</xsl:attribute>
						<xsl:call-template name="listOrg"></xsl:call-template>
						<xsl:apply-templates select="$step0" mode="listOrgOccurences"></xsl:apply-templates>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			
			<!-- SEARCH -->
			<xsl:if test="$search=true()">
				<xsl:apply-templates select="$step0" mode="file4search"></xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
		<!-- EN: The index and structure generation are the same for both the parallel and the embedded  -->
		<!-- IT: La generazione dell'index e della struttura sono uguali sia per la parallel sia per l'embedded -->
		<xsl:call-template name="index"></xsl:call-template>
		<xsl:apply-templates select="." mode="structure_generation"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="index">
		<!-- EN: Index generation. The index_build template can be found in html_build/evt_builder-callhtml.xsl -->
		<!-- IT: Generazione della index. Il template index_build si trova in html_build/evt_builder-callhtml.xsl -->
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" href="{$filePrefix}/index.html" indent="yes">
			<xsl:call-template name="index_build" />			
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
		<!-- IT: Per ogni pagina, genera le corrispettive edizioni. Il template data_structure si trova in html_build/evt_builder-callhtml.xsl -->
		<xsl:for-each select="$edition_array">
			<xsl:if test=".!=''">
				<xsl:variable name="edition_current" select="lower-case(.)"/>
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/{$edition_current}/page_{$pb_n}_{$edition_current}.html" indent="yes">
					<xsl:call-template name="data_structure">
						<xsl:with-param name="output" select="$edition_current"/>
						<xsl:with-param name="pb_n" select="$pb_n"/>
						<xsl:with-param name="edition_pos" select="position()"></xsl:with-param>
					</xsl:call-template>
				</xsl:result-document>
			</xsl:if>
		</xsl:for-each>
    </xsl:template>
	
	<xsl:template name="edition_level">
		<xsl:param name="pb_n"></xsl:param>
		<xsl:param name="edition_pos"/>
		<xsl:if test="$edition_pos=1">
			<xsl:choose>
				<!-- CDP:embedded -->
				<!-- Se il file e' codificato in Embedded Transcription e almeno un elemento <zone> presenta le coordinate spaziali 
					viene attivata la trasformazione per il collegamento testo immagine -->
				<xsl:when test="($root//tei:sourceDoc)and(current-group()/tei:zone[@lrx][@lry][@ulx][@uly])">
					<!--<xsl:copy-of select="current-group()"/> --><!-- <-use this to find split errors -->
					<!--<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>-->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="ITLembedded">
						<xsl:with-param name="edition_level" select="$ed_name1"/>
					</xsl:apply-templates></xsl:variable>
					<xsl:apply-templates select="$text" mode="dipl" />
				</xsl:when>
				<!-- IT: Se c'è il surface viene creato un albero temporaneo che corrisponde al gruppo corrente trasformato in base al livello di edizione;
										 a questo viene applicato il template per il collegamento testo-immagine-->
				<xsl:when test="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=replace($pb_n, '-front', '')]//tei:zone[@rendition='Line']">
					<!--<xsl:copy-of select="current-group()"/>--> <!-- <-use this to find split errors -->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>
					<!-- IT: aggiungi elementi div per linee di testo -->
					<xsl:variable name="text2">
						<xsl:call-template name="divLine">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ed_name" select="$ed_name1"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- IT: trasforma el per ITL e HS-->
					<xsl:apply-templates select="$text2" mode="ITL"/>
				</xsl:when>
				<!-- EN: If the surface element is not present only the diplomatic edition templates are applied -->
				<!-- IT: Se non c'è il surface devo applicare direttamente i templates per l'edizione diplomatica -->
				<xsl:otherwise>
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>
					<!-- IT: aggiungi elementi div per linee di testo -->
					<xsl:call-template name="divLine">
						<xsl:with-param name="text" select="$text"/>
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
				<xsl:when test="($root//tei:sourceDoc)and(current-group()/tei:zone[@lrx][@lry][@ulx][@uly])">
					<!--<xsl:copy-of select="current-group()"/>--> <!-- <-use this to find split errors -->
					<!--<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="interp"/></xsl:variable>-->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="ITLembedded">
						<xsl:with-param name="edition_level" select="$ed_name2"/>
					</xsl:apply-templates></xsl:variable>
					<xsl:apply-templates select="$text" mode="interp" />
				</xsl:when>
				<!-- IT: Se c'è il surface viene creato un albero temporaneo che corrisponde al gruppo corrente trasformato in base al livello di edizione;
										 a questo viene applicato il template per il collegamento testo-immagine-->
				<xsl:when test="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=replace($pb_n, '-front', '')]//tei:zone[@rendition='Line']">
					<!--<xsl:copy-of select="current-group()"/>--> <!-- <-use this to find split errors -->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="interp"/></xsl:variable>
					<xsl:variable name="text2">
						<xsl:call-template name="divLine">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ed_name" select="$ed_name2"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:apply-templates select="$text2" mode="ITL"/>
				</xsl:when>
				<!-- EN: If the surface element is not present only the diplomatic edition templates are applied -->
				<!-- IT: Se non c'è il surface devo applicare direttamente i templates per l'edizione diplomatica-->
				<xsl:otherwise>
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="interp"/></xsl:variable>
					<xsl:call-template name="divLine">
						<xsl:with-param name="text" select="$text"/>
						<xsl:with-param name="ed_name" select="$ed_name2"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
	</xsl:template>
	
	<!-- HEADER INFO -->
	<xsl:template name="headerInfo">
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/prefatory_matter/header_info.html" indent="yes">
			<xsl:call-template name="headerInfo_generation"/>
		</xsl:result-document>
	</xsl:template>
	<!-- MS DESCRIPTION -->
	<xsl:template name="msDesc">
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/prefatory_matter/ms_desc.html" indent="yes">
			<xsl:call-template name="msDesc_generation"/>
		</xsl:result-document>
	</xsl:template>
	
	<!-- FRONT -->
	<xsl:template name="front">
		<xsl:variable name="front" select="current()/tei:front" />
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
		<xsl:if test="not($doc_id='')">
			<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/prefatory_matter/front/front_doc_{$doc_id}.html" indent="yes">
				<xsl:call-template name="front_generation">
					<xsl:with-param name="front" select="$front"></xsl:with-param>
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
				<xsl:when test="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id">
					<xsl:value-of select="current()/tei:body/tei:div[@subtype='edition_text']/@xml:id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(preceding-sibling::tei:text) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/prefatory_matter/regesto/regesto_doc_{$doc_id}.html" indent="yes">
			<xsl:variable name="front" select="current()/tei:front" />
			<xsl:call-template name="doc_regesto">
				<xsl:with-param name="doc_id" select="$doc_id"/>
				<xsl:with-param name="front" select="$front"></xsl:with-param>
			</xsl:call-template>
		</xsl:result-document>
	</xsl:template>
	
	<!-- LIST PERSON -->
	<xsl:template name="listPerson">
			<xsl:element name="ul">
				<xsl:attribute name="id" select="'ul_listPerson'"/>
				<xsl:attribute name="class" select="'ul_list'"/>
				<xsl:for-each select="$root//tei:listPerson/person">
					<xsl:element name="li">
						<xsl:attribute name="id" select="@xml:id" />
						<xsl:attribute name="class" select="'list_element'"/>
						<xsl:attribute name="data-order-list" select="substring(tei:persName/tei:forename, 1, 1)"/>
							<!--<xsl:value-of select="substring(@xml:id, 1, 1)"/>-->
						<xsl:call-template name="person" />
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
				<xsl:element name="li">
					<xsl:attribute name="id" select="@xml:id" />
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-order-list" select="substring(tei:settlement, 1, 1)"/>
						<!--<xsl:value-of select="substring(@xml:id, 1, 1)"/>-->
					<xsl:call-template name="place" />
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
				<xsl:element name="li">
					<xsl:attribute name="id" select="@xml:id" />
					<xsl:attribute name="class" select="'list_element'"/>
					<xsl:attribute name="data-order-list" select="substring(@xml:id, 1, 1)"/>
					<xsl:call-template name="org" />
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="text()" mode="deleteSpaces">
		<xsl:choose>
			<xsl:when
				test="ancestor::*[@xml:space][1]/@xml:space='preserve'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Retain one leading space if node isn't first, has non-space content, and has leading space.-->
				<xsl:if test="position()!=1 and matches(.,'^\s') and normalize-space()!=''">
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:choose>
					<!-- node is an only child, and has content but it's all space -->
					<xsl:when test="last()=1 and string-length()!=0 and normalize-space()=''">
						<xsl:text> </xsl:text>
					</xsl:when>
					<!-- node isn't last, isn't first, and has trailing space -->
					<xsl:when test="position()!=1 and position()!=last() and matches(.,'\s$')">
						<xsl:text> </xsl:text>
					</xsl:when>
					<!-- node isn't last, is first, has trailing space, and has non-space content   -->
					<xsl:when test="position()=1 and matches(.,'\s$') and normalize-space()!=''">
						<xsl:text> </xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="delete_el1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()[name()='span'][@class='dipl-choice_popup']/node()[name()='span'][@class='dipl-reg']" mode="delete_el1">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='dipl-zone']" mode="delete_el1">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='dipl-attachment']" mode="delete_el1">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="delete_el2">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()[name()='span'][@class='interp-choice_popup']/node()[name()='span'][@class='interp-orig']|node()[name()='span'][@class='interp-corr']" mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='interp-zone']" mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@class='interp-attachment']" mode="delete_el2">
		<!-- DO NOTHING -->
	</xsl:template>
	
	
	<xsl:template name="search_file">
		<xsl:if test="$edition_array[1]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[1])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
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
										<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="inter"/>
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
									<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="dipl"/>
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
										<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="dipl"/>
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
									<xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/>
								</xsl:variable>
								<xsl:variable name="current_text1">
									<xsl:apply-templates select="$current_text" mode="delete_el2"/>
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
	</xsl:template>
	
	<xsl:template name="doc_refs4search">
		<xsl:variable name="doc_id">
			<xsl:choose>
				<xsl:when test="current-group()/ancestor-or-self::tei:text[1]/@xml:id">
					<xsl:value-of select="current-group()/ancestor-or-self::tei:text[1]/@xml:id"/>
				</xsl:when>
				<xsl:when test="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype='edition_text'][1]/@xml:id">
					<xsl:value-of select="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype='edition_text'][1]/@xml:id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('text_',current-group()/ancestor-or-self::tei:text[1]/position())"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="doc_label">
			<xsl:choose>
				<xsl:when test="current-group()/ancestor-or-self::tei:text[1]/@n">
					<xsl:value-of select="current-group()/ancestor-or-self::tei:text[1]/@n"/>
				</xsl:when>
				<xsl:when test="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype='edition_text'][1]/@n">
					<xsl:value-of select="current-group()/ancestor-or-self::tei:body[1]/tei:div[@subtype='edition_text'][1]/@n"/>
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
				<xsl:value-of select="concat(self::tei:lb/@n, '|line ',self::tei:lb/@n)"/>
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
				<xsl:otherwise> <xsl:value-of select="''"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$p_id" />|<xsl:value-of select="$p_label" />
	</xsl:template>
	
	<xsl:template name="search_file4embedded">
		<xsl:if test="$edition_array[1]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[1])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
				<xsl:for-each select="$root//tei:surface">
					<xsl:if test="current()/@xml:id">
						<xsl:variable name="pageId" select="if(@xml:id) then (@xml:id) else (@n)"/>
						<xsl:variable name="pageLabel" select="if(@n) then (@n) else (@xml:id)"/>
						<xsl:choose>
							<xsl:when test="current()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current()[not(self::pb)]" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										{ 
										"line" : "<xsl:value-of select="if(self::tei:lb/@n) then(concat(self::tei:lb/@n, '|line ',self::tei:lb/@n)) else('no line info|no line info')" />",
										"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="dipl"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el1"/></xsl:variable><xsl:variable name="var2"><xsl:apply-templates select="$var1//text()[not(ancestor::span)]" mode="deleteSpaces"/></xsl:variable><xsl:copy-of select="replace($var2, '(\\|/)', '$1$1')"></xsl:copy-of>",
										"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
										"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
										},
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:when test="current()/(descendant-or-self::line)">
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="interp"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current()/descendant::line" group-starting-with="//tei:line">
									{
									"line" : "<xsl:value-of select="if(@xml:id) then (@xml:id) else('no line info')" />|<xsl:value-of select="if(@n) then(concat('line ',@n)) else('no line info')" />",
									"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="dipl"/></xsl:variable><xsl:value-of select="fn:normalize-space($var)"></xsl:value-of>",
									"tags" : "<xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/>|<xsl:choose><xsl:when test="ancestor::tei:sourceDoc/@n"><xsl:value-of select="ancestor::tei:sourceDoc/@n"/></xsl:when><xsl:otherwise><xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="ancestor::tei:sourceDoc/@xml:id"/></xsl:with-param></xsl:call-template></xsl:otherwise></xsl:choose>",
									"loc" : "<xsl:value-of select="$pageId"/>|<xsl:value-of select="$pageLabel"/>"
									},
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								{
								"line" : "no line info|no line info",
								"text" : "<xsl:variable name="var"><xsl:apply-templates select="current()" mode="dipl"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el2"/></xsl:variable><xsl:copy-of select="$var1//text()"></xsl:copy-of>",
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
		<xsl:if test="$edition_array[2]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[2])" />
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
										"text" : "<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="interp"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el2"/></xsl:variable><xsl:variable name="var2"><xsl:apply-templates select="$var1//text()[not(ancestor::span)]" mode="deleteSpaces"/></xsl:variable><xsl:copy-of select="replace($var2, '(\\|/)', '$1$1')"/>",
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
								"text" : "<xsl:variable name="var"><xsl:apply-templates select="current()" mode="interp"/></xsl:variable><xsl:variable name="var1"><xsl:apply-templates select="$var" mode="delete_el2"/></xsl:variable><xsl:copy-of select="$var1//text()"/>",
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
		<p><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match="tei:hi[@rend]">
		<xsl:element name="span">
			<xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
