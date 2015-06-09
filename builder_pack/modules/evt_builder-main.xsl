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
		</xsl:if>
		<!-- EN: If there is at least a <text> element the transformations for parallel transcription are activated -->
		<!-- IT: Le trasformazioni per la parallel transcription vengono attivate se nel documento esiste almeno un elemento <text> -->
		<xsl:if test="tei:TEI/tei:text">
			<xsl:apply-templates select="$step0" mode="splitPages"></xsl:apply-templates>
			
			<xsl:if test="$regesto=true()">
				<xsl:for-each select="tei:TEI/tei:text/tei:group/tei:text">
					<xsl:call-template name="regesto"></xsl:call-template>	
				</xsl:for-each>
			</xsl:if>
			
			<xsl:if test="$list_person=true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listPerson.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listPerson</xsl:attribute>
						<xsl:call-template name="listPerson"></xsl:call-template>
						<xsl:apply-templates select="$step0" mode="listPersonOccurences"></xsl:apply-templates>
					</xsl:element>
				</xsl:result-document>
			</xsl:if>
			<xsl:if test="$list_place=true()">
				<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/liste/listPlace.html" indent="yes">
					<xsl:element name="div">
						<xsl:attribute name="id">listPlace</xsl:attribute>
						<xsl:call-template name="listPlace"></xsl:call-template>
						<xsl:apply-templates select="$step0" mode="listPlaceOccurences"></xsl:apply-templates>
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
		<xsl:variable name="pb_n" select="@xml:id" />	
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
					<!--<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="facs"/></xsl:variable>-->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="ITLembedded">
						<xsl:with-param name="edition_level" select="$ed_name1"/>
					</xsl:apply-templates></xsl:variable>
					<xsl:apply-templates select="$text" mode="facs" />
				</xsl:when>
				<!-- IT: Se c'è il surface viene creato un albero temporaneo che corrisponde al gruppo corrente trasformato in base al livello di edizione;
										 a questo viene applicato il template per il collegamento testo-immagine-->
				<xsl:when test="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=$pb_n]//tei:zone[@rendition='Line']">
					<!--<xsl:copy-of select="current-group()"/>--> <!-- <-use this to find split errors -->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="facs"/></xsl:variable>
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
				<!-- EN: If the surface element is not present only the facsimile edition templates are applied -->
				<!-- IT: Se non c'è il surface devo applicare direttamente i templates per l'edizione facsimile -->
				<xsl:otherwise>
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="facs"/></xsl:variable>
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
					<!--<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>-->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="ITLembedded">
						<xsl:with-param name="edition_level" select="$ed_name2"/>
					</xsl:apply-templates></xsl:variable>
					<xsl:apply-templates select="$text" mode="dipl" />
				</xsl:when>
				<!-- IT: Se c'è il surface viene creato un albero temporaneo che corrisponde al gruppo corrente trasformato in base al livello di edizione;
										 a questo viene applicato il template per il collegamento testo-immagine-->
				<xsl:when test="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=$pb_n]//tei:zone[@rendition='Line']">
					<!--<xsl:copy-of select="current-group()"/>--> <!-- <-use this to find split errors -->
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>
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
					<xsl:variable name="text"><xsl:apply-templates select="current-group()" mode="dipl"/></xsl:variable>
					<xsl:call-template name="divLine">
						<xsl:with-param name="text" select="$text"/>
						<xsl:with-param name="ed_name" select="$ed_name2"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template name="regesto">
		<xsl:variable name="doc_id" select="@xml:id" />
		<xsl:result-document method="html" encoding="UTF-8" media-type="text/plain" byte-order-mark="yes" href="{$filePrefix}/data/output_data/regesto/doc_{$doc_id}.html" indent="yes">
			<xsl:variable name="front" select="current()/tei:front" />
			<xsl:call-template name="doc_regesto">
				<xsl:with-param name="doc_id" select="$doc_id"/>
				<xsl:with-param name="front" select="$front"></xsl:with-param>
			</xsl:call-template>
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template name="listPerson">
			<xsl:element name="ul">
				<xsl:attribute name="id">ul_listPerson</xsl:attribute>
				<xsl:attribute name="class">ul_list</xsl:attribute>
				<xsl:for-each select="$root//tei:listPerson/person">
					<xsl:element name="li">
						<xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
						<xsl:attribute name="class">list_element</xsl:attribute>
						<xsl:attribute name="data-order-list"><xsl:value-of select="substring(@xml:id, 1, 1)"></xsl:value-of></xsl:attribute>
						<xsl:call-template name="person" />
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
	</xsl:template>
	
	<xsl:template name="listPlace">
		<xsl:element name="ul">
			<xsl:attribute name="id">ul_listPlace</xsl:attribute>
			<xsl:attribute name="class">ul_list</xsl:attribute>
			<xsl:for-each select="$root//tei:listPlace/place">
				<xsl:element name="li">
					<xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
					<xsl:attribute name="class">list_element</xsl:attribute>
					<xsl:attribute name="data-order-list"><xsl:value-of select="substring(@xml:id, 1, 1)"></xsl:value-of></xsl:attribute>
					<xsl:call-template name="place" />
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="search_file">
		<xsl:if test="$edition_array[1]!=''">
			<xsl:variable name="edition_current" select="lower-case($edition_array[1])" />
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.js" indent="no">
				{"pages": [
					<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
						<xsl:choose>
							<xsl:when test="current-group()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										<xsl:choose>
											<xsl:when test="following::lb">
												{ "line" :
													"<xsl:value-of select="if(self::tei:lb/@n) then(self::tei:lb/@n) else('no line info')" />",
												"text" :
													"<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="facs"/></xsl:variable>
													<xsl:copy-of select="$var//text()"></xsl:copy-of>",
												"tags" : "<xsl:value-of select="parent::div[@subtype='edition_text']/@n"/>",
												"loc" : "<xsl:value-of select="if(preceding::pb[1]/@xml:id) then(preceding::pb[1]/@xml:id) else('no_page_info')"/>"
												},
											</xsl:when>
											<xsl:otherwise>
												{ "line" :
												"<xsl:value-of select="if(self::tei:lb/@n) then(self::tei:lb/@n) else('no line info')" />",
												"text" :
												"<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="facs"/></xsl:variable>
												<xsl:copy-of select="$var//text()"></xsl:copy-of>",
												"tags" : "<xsl:value-of select="parent::div[@subtype='edition_text']/@n"/>",
												"loc" : "<xsl:value-of select="if(preceding::pb[1]/@xml:id) then(preceding::pb[1]/@xml:id) else('no_page_info')"/>"
												}
											</xsl:otherwise>
										</xsl:choose>
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
			<xsl:result-document method="text" href="{$filePrefix}/data/output_data/{$edition_current}/{$edition_current}.json" indent="no">
				{"pages": [
					<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
						<xsl:choose>
							<xsl:when test="current-group()/(descendant-or-self::lb)">
								<xsl:for-each-group select="current-group()[not(self::pb)]" group-starting-with="tei:lb">
									<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]">
										<xsl:choose>
											<xsl:when test="following::lb">
												{ "line" :
													"<xsl:value-of select="if(self::tei:lb/@n) then(self::tei:lb/@n) else('no line info')" />",
												  "text" :
													"<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="dipl"/></xsl:variable>
													<xsl:copy-of select="$var//text()"></xsl:copy-of>",
												  "tags" : "<xsl:value-of select="parent::div[@subtype='edition_text']/@n"/>",
												  "loc" : "<xsl:value-of select="if(preceding::pb[1]/@xml:id) then(preceding::pb[1]/@xml:id) else('no_page_info')"/>"
												},
											</xsl:when>
											<xsl:otherwise>
												{ "line" :
												"<xsl:value-of select="if(self::tei:lb/@n) then(self::tei:lb/@n) else('no line info')" />",
												"text" :
												"<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:lb)]" mode="dipl"/></xsl:variable>
												<xsl:copy-of select="$var//text()"></xsl:copy-of>",
												"tags" : "<xsl:value-of select="parent::div[@subtype='edition_text']/@n"/>",
												"loc" : "<xsl:value-of select="if(preceding::pb[1]/@xml:id) then(preceding::pb[1]/@xml:id) else('no_page_info')"/>"
												}
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<!--<xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="dipl"/></xsl:variable>
								<xsl:copy-of select="$var//text()"></xsl:copy-of>-->
								<xsl:for-each-group select="current-group()/body/descendant::p" group-starting-with="//tei:p">
									<xsl:choose>
										<xsl:when test="following::p">
											{
											"line" : "<xsl:value-of select="@xml:id" />| par <xsl:value-of select="@n" />",
											"text" : <xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="facs"/></xsl:variable>"<xsl:value-of select="fn:normalize-space($var)"></xsl:value-of>",
											"tags" : "<xsl:value-of select="preceding::text[1]/@xml:id" />|<xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="preceding::text[1]/@xml:id"/></xsl:with-param></xsl:call-template>",
											"loc" : "<xsl:value-of select="preceding::pb[1]/@xml:id" />|<xsl:value-of select="preceding::pb[1]/@n" />"
											},
										</xsl:when>
										<xsl:otherwise>
											{
											"line" : "<xsl:value-of select="@xml:id" />| par <xsl:value-of select="@n" />",
											"text" : <xsl:variable name="var"><xsl:apply-templates select="current-group()[not(self::tei:pb)]" mode="facs"/></xsl:variable>"<xsl:value-of select="fn:normalize-space($var)"></xsl:value-of>",
											"tags" : "<xsl:value-of select="preceding::text[1]/@xml:id" />|<xsl:call-template name="generateTextLabel"><xsl:with-param name="text_id"><xsl:value-of select="preceding::text[1]/@xml:id"/></xsl:with-param></xsl:call-template>",
											"loc" : "<xsl:value-of select="preceding::pb[1]/@xml:id" />|<xsl:value-of select="preceding::pb[1]/@n" />"
											}
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each-group>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each-group>
				]}
			</xsl:result-document>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
