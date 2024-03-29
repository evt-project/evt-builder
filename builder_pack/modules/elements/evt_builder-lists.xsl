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
		<xd:short> EN: Templates used to process the TEI elements used to encode lists.
			IT: I template
			per la trasformazione degli elementi TEI che gestiscono liste. </xd:short>
	</xd:doc>

	<xsl:template name="person">
		<xsl:choose>
			<xsl:when
				test="current()//tei:persName or current()//tei:name or current()//tei:forename or current()//tei:surname or current()//tei:sex or current()//tei:occupation or current()//tei:idno">
				<xsl:element name="span">
					<xsl:attribute name="class">entity_name <xsl:if test="$list_person = true()">
							link_active</xsl:if></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-list">listPerson</xsl:attribute>
					<xsl:attribute name="data-ref">
						<xsl:value-of select="@xml:id"/>
					</xsl:attribute>
					<xsl:if test="current()//tei:name">
						<xsl:value-of select="tei:persName//tei:name"/>
					</xsl:if>
					<xsl:if test="current()//tei:forename">
						<xsl:value-of select="tei:persName//tei:forename"/>
					</xsl:if>
					<xsl:if test="current()//tei:surname">
						<xsl:text>&#xA0;</xsl:text>
						<xsl:value-of select="tei:persName//tei:surname"/>
					</xsl:if>
					<xsl:if test="current()//tei:persName">
						<xsl:choose>
							<xsl:when test="count(tei:persName) > 1">
								<xsl:for-each select="tei:persName">
									<xsl:if test="position() != last()">
										<xsl:value-of select="current()"/>
										<xsl:text>/</xsl:text>
									</xsl:if>
									<xsl:if test="position() = last()">
										<xsl:value-of select="current()"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="tei:persName/text()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:element>
				<!--<xsl:if test="current()/tei:sex">
					<xsl:element name="span">
						<xsl:attribute name="class">display-block</xsl:attribute>
						<xsl:text>Sesso: </xsl:text>
						<xsl:value-of select="tei:sex"/>		
					</xsl:element>
				</xsl:if>-->
				<xsl:if test="current()/tei:occupation">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="tei:occupation"/>
					<xsl:if test="current()/tei:occupation/@from and current()/tei:occupation/@to">
						<xsl:text>. Periodo di attività: </xsl:text>
						<xsl:value-of select="tei:occupation/@from"/>
						<xsl:text> - </xsl:text>
						<xsl:value-of select="tei:occupation/@to"/>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<span class="toggle_list_element">
					<i class="fa fa-angle-right"/>
				</span>
				<xsl:if test="current()/tei:note and current()/tei:note != ''">
					<span class="small-note">
						<xsl:apply-templates select="tei:note" mode="interp"/>
					</span>
				</xsl:if>
				<xsl:if test="current()/tei:idno">
					<xsl:apply-templates select="tei:idno"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">display-block</xsl:attribute>
					<span lang="def">NO_INFO</span>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template name="org">
		<xsl:choose>
			<xsl:when
				test="current()[@type] or current()[@subtype] or current()[@role] or current()/tei:orgName or current()/tei:desc or current()//tei:idno or current()//tei:listPerson">
				<xsl:if test="current()/tei:orgName">
					<xsl:element name="span">
						<xsl:attribute name="class">entity_name <xsl:if test="$list_org = true()">
								link_active</xsl:if></xsl:attribute>
						<xsl:call-template name="dataAttributesFromAttributes"/>
						<xsl:attribute name="data-list">listOrg</xsl:attribute>
						<xsl:attribute name="data-ref" select="@xml:id"/>
						<xsl:for-each select="current()/tei:orgName">
							<xsl:value-of select="current()"/>
							<xsl:if
								test="@type or @subtype or @notAfter or @notBefore or @from or @to">
								<xsl:text>&#xA0;(</xsl:text>
								<xsl:if test="@type">
									<xsl:value-of
										select="replace(replace(@type, '-', '/'), '_', ' ')"/>
									<xsl:text>&#xA0;</xsl:text>
								</xsl:if>
								<xsl:if test="@subtype">
									<xsl:value-of
										select="replace(replace(@subtype, '-', '/'), '_', ' ')"/>
									<xsl:text>&#xA0;</xsl:text>
								</xsl:if>
								<xsl:if test="@notAfter">
									<span lang="def">AFTER</span>
									<xsl:text>&#xA0;</xsl:text>
									<xsl:value-of select="@notAfter"/>
								</xsl:if>
								<xsl:if test="@notBefore">
									<span lang="def">BEFORE</span>
									<xsl:text>&#xA0;</xsl:text>
									<xsl:value-of select="@notBefore"/>
								</xsl:if>
								<xsl:if test="@from">
									<span lang="def">FROM</span>
									<xsl:text>&#xA0;</xsl:text>
									<xsl:value-of select="@from"/>
								</xsl:if>
								<xsl:if test="@to">
									<xsl:text>&#xA0;</xsl:text>
									<span lang="def">TO</span>
									<xsl:text>&#xA0;</xsl:text>
									<xsl:value-of select="@to"/>
								</xsl:if>
								<xsl:text>). </xsl:text>
							</xsl:if>

						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				<span class="toggle_list_element">
					<i class="fa fa-angle-right"/>
				</span>
				<xsl:if test="current()/tei:desc and current()/tei:desc != ''">
					<span class="small-note">
						<xsl:apply-templates select="current()/tei:desc" mode="interp"/>
					</span>
				</xsl:if>
				<xsl:if test="current()/tei:state">
					<xsl:for-each select="current()/tei:state">
						<span class="small-note orgName-state">
							<xsl:if test="current()/@type">
								<span lang="def">
									<xsl:value-of select="replace(current()/@type, '-', '/')"/>
								</span>
								<xsl:text>&#xA0;</xsl:text>
							</xsl:if>
							<xsl:if test="current()/@notAfter">
								<span lang="def">AFTER</span>
								<xsl:text>&#xA0;</xsl:text>
								<xsl:value-of select="current()/@notAfter"/>
							</xsl:if>
							<xsl:if test="current()/@notBefore">
								<span lang="def">BEFORE</span>
								<xsl:text>&#xA0;</xsl:text>
								<xsl:value-of select="current()/@notBefore"/>
							</xsl:if>
							<xsl:if test="current()/@from">
								<span lang="def">FROM</span>
								<xsl:text>&#xA0;</xsl:text>
								<xsl:value-of select="current()/@from"/>
							</xsl:if>
							<xsl:if test="current()/@to">
								<xsl:text>&#xA0;</xsl:text>
								<span lang="def">TO</span>
								<xsl:text>&#xA0;</xsl:text>
								<xsl:value-of select="current()/@to"/>
							</xsl:if>
							<xsl:text>:&#xA0;</xsl:text>
							<xsl:apply-templates mode="interp"/>
							<xsl:text>.</xsl:text>
						</span>

					</xsl:for-each>
				</xsl:if>
				<xsl:if test="current()/tei:idno">
					<xsl:apply-templates select="tei:idno"/>
				</xsl:if>
				<xsl:if test="current()//tei:person">
					<span class="nested-list-container">
						<span lang="def">MEMBERS</span>:
						<span class="nested-list" data-list="listPerson">
							<xsl:for-each select="current()//tei:person">
								<span data-ref="{substring-after(current()/@sameAs, '#')}">
									<xsl:choose>
										<xsl:when test="@sameAs">
											<xsl:for-each
												select="$root//node()[@xml:id = substring-after(current()/@sameAs, '#')]">										
												<xsl:call-template name="person"/>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</xsl:for-each>
						</span>
					</span>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class" select="'display-block'"/>
					<span lang="def">NO_INFO</span>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="place">
		<xsl:choose>
			<xsl:when
				test="current()//tei:settlement or current()//tei:placeName or current()//tei:district or current()//tei:idno">
				<xsl:if test="current()/tei:settlement">
					<xsl:element name="span">
						<xsl:attribute name="class"> entity_name <xsl:if test="$list_place = true()"
								> link_active</xsl:if>
						</xsl:attribute>
						<xsl:call-template name="dataAttributesFromAttributes"/>
						<xsl:attribute name="data-list">listPlace</xsl:attribute>
						<xsl:attribute name="data-ref">
							<xsl:value-of select="@xml:id"/>
						</xsl:attribute>
						<xsl:value-of select="tei:settlement"/>
					</xsl:element>
					<xsl:if test="tei:settlement[1]/@type">
						<xsl:text>, </xsl:text>
						<xsl:choose>
							<xsl:when test="contains(current()/tei:settlement[1]/@type, '_')">
								<xsl:variable name="settlementType1">
									<xsl:value-of
										select="substring-before(current()/tei:settlement[1]/@type, '_')"
									/>
								</xsl:variable>
								<xsl:value-of select="replace($settlementType1, '-', '/')"/>
								<xsl:variable name="settlementType2">
									<xsl:value-of
										select="substring-after(current()/tei:settlement[1]/@type, '_')"
									/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="contains($settlementType2, '_')">
										<xsl:text>&#xA0;(</xsl:text>
										<xsl:value-of select="replace($settlementType2, '_', ')')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>&#xA0;</xsl:text>
										<xsl:value-of select="$settlementType2"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="replace(current()/tei:settlement[1]/@type, '-', '/')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
				<xsl:if test="current()/tei:placeName[@type = 'new']">
					<xsl:text>, oggi nota come </xsl:text>
					<xsl:value-of select="tei:placeName[@type = 'new']"/>
				</xsl:if>
				<xsl:if test="current()/tei:placeName and not(tei:placeName[@type])">
					<xsl:element name="span">
						<xsl:attribute name="class">
							entity_name 
							<xsl:if test="$list_place = true()"> link_active</xsl:if>
						</xsl:attribute>
						<xsl:call-template name="dataAttributesFromAttributes"/>
						<xsl:attribute name="data-list">listPlace</xsl:attribute>
						<xsl:attribute name="data-ref">
							<xsl:value-of select="@xml:id"/>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="count(tei:placeName) > 1">
								<xsl:for-each select="tei:placeName">
									<xsl:if test="position() != last()">
										<xsl:value-of select="current()"/>
										<xsl:text>/</xsl:text>
									</xsl:if>
									<xsl:if test="position() = last()">
										<xsl:value-of select="current()"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="tei:placeName"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
				<xsl:if test="current()/tei:district">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="replace(current()/tei:district/@type, '_', ' ')"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:district"/>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<span class="toggle_list_element">
					<i class="fa fa-angle-right"/>
				</span>
				<xsl:if test="current()/tei:note and current()/tei:note != ''">
					<span class="small-note">
						<xsl:apply-templates select="tei:note" mode="interp"/>
					</span>
				</xsl:if>
				<xsl:if test="current()/tei:idno">
					<xsl:apply-templates select="tei:idno"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">display-block</xsl:attribute>
					<span lang="def">NO_INFO</span>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--template for list doc-->
	<xsl:template name="document">
		<xsl:choose>
			<xsl:when test="current()//tei:front">
				<span class="document_list_header">
					<xsl:element name="span">
						<xsl:attribute name="class">document_list_data</xsl:attribute>
						<xsl:if test="current()//tei:docDate">
							<xsl:if test="current()//tei:docDate//tei:date">

								<xsl:choose>
									<xsl:when test="current()//tei:docDate//tei:date[@when]">
										<xsl:for-each select="current()//tei:docDate//tei:date[@when]">
											<xsl:value-of select="."/>
											<xsl:text>,&#xA0;</xsl:text>
										</xsl:for-each>
									</xsl:when>
									<xsl:when
										test="current()//tei:docDate//tei:date[@notBefore] and current()//tei:docDate//tei:date[@notAfter]">

										<xsl:value-of select="tei:front//tei:docDate//tei:date"/>

										<xsl:text>,&#xA0;</xsl:text>
									</xsl:when>
									<xsl:when
										test="current()//tei:docDate//tei:date[@from] and current()//tei:docDate//tei:date[@to]">
										<xsl:value-of select="tei:front//tei:docDate//tei:date"/>
										<xsl:text>,&#xA0;</xsl:text>
									</xsl:when>
									<!--<xsl:otherwise>
										<xsl:value-of select="tei:front//tei:docDate//tei:date"/>
									</xsl:otherwise>-->
								</xsl:choose>
							</xsl:if>
						</xsl:if>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">document_list_place</xsl:attribute>
						<xsl:if test="current()//tei:docDate//tei:placeName">
							<xsl:for-each select="current()//tei:docDate//tei:placeName">

								<xsl:choose>
									<xsl:when test="position() &lt; last()">
										<xsl:value-of select="."/>
										<xsl:text>,&#xA0;</xsl:text>
									</xsl:when>
									<xsl:when test="position() = last()">
										<xsl:value-of select="."/>
									</xsl:when>
								</xsl:choose>

							</xsl:for-each>
						</xsl:if>
					</xsl:element>
					
				</span>
				<span class="document_list_doc_title">
					<xsl:text>Doc.&#xA0;</xsl:text>
					<xsl:value-of select="tei:front//tei:titlePart[@type = 'numerazioneOrig']"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:front//tei:titlePart[@type = 'numerazioneNuova']"/>

					<xsl:element name="span">
						<xsl:attribute name="class">document_list_doc_link</xsl:attribute>
						<xsl:attribute name="lang" select="'def'"/>
						<xsl:attribute name="data-lang" select="'OPEN_DOCUMENT'"/>
						<xsl:attribute name="title" select="'OPEN_DOCUMENT'"/>
						<xsl:attribute name="data-value">
							<xsl:value-of select="@xml:id"/>
						</xsl:attribute>
						<i class="fa fa-external-link"></i>
						<!--OR-->
						<!--<xsl:value-of select="@xml:id"/>-->
					</xsl:element>
				</span>
				<xsl:element name="span">
					<xsl:attribute name="class">document_list_regesto</xsl:attribute>
					<xsl:if test="current()//tei:div[@type = 'regesto']">
						<span class="text"><xsl:value-of select="tei:front//tei:div[@type = 'regesto']"/></span>
						<span class="mainButtons toggleRegestoInList visible" data-lang="MORE" lang="def"
							data-action="expand">MORE</span>
						<span class="mainButtons toggleRegestoInList" data-lang="LESS" lang="def" data-action="collapse"
							>LESS</span>
					</xsl:if>
				</xsl:element>
				<!--<span class="toggle_list_element">
                    <i class="fa fa-angle-right"/>
                </span>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">display-block</xsl:attribute>
					<span lang="def">NO_INFO</span>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="glossaryEntryPartial">
		<xsl:element name="span">
			<xsl:attribute name="class">term_occ <xsl:if test="$list_glossary = true()">
				link_active</xsl:if></xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:attribute name="data-list">listGlossary</xsl:attribute>
			<xsl:attribute name="data-ref">
				<xsl:value-of select="@xml:id"/>
			</xsl:attribute>
			
			<xsl:if test="current()/tei:form[@type='lemma']">
				<span class="glossaryEntry-lemma">
					<span class="lemma"><xsl:value-of select="current()/tei:form[@type='lemma']/tei:orth"/></span>
					<xsl:apply-templates select="current()/tei:form[@type='lemma']/tei:gramGrp" mode="glossary"></xsl:apply-templates>
				</span>
			</xsl:if>
			<xsl:if test="current()/tei:form[@type='inflected']">
				<xsl:for-each select="current()/tei:form[@type='inflected']">
					<xsl:text>, </xsl:text>
					<span class="glossaryEntry-inflected">
						<span class="orth"><xsl:value-of select="current()/tei:orth"/></span>
						<xsl:apply-templates select="current()/tei:gramGrp" mode="glossary"></xsl:apply-templates>					
					</span>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="current()/tei:form[@type='variant']">
				<xsl:for-each select="current()/tei:form[@type='variant']">
					<xsl:text>, </xsl:text>
					<span class="glossaryEntry-variant">
						<xsl:value-of select="current()/tei:orth"/>
						<xsl:if test="current()/tei:form[@type='inflected']">
							<xsl:for-each select="current()/tei:form[@type='inflected']">
								<xsl:text>, </xsl:text>
								<span class="glossaryEntry-inflected"><xsl:value-of select="current()/tei:orth"/></span>
								<xsl:apply-templates select="current()/tei:gramGrp" mode="glossary"></xsl:apply-templates>					
							</xsl:for-each>
						</xsl:if>
					</span>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="current()/tei:form[@type='current']">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="current()/tei:form[@type='current']/tei:orth"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:text>, ‘</xsl:text>
			<xsl:apply-templates select="current()/tei:sense[not(@value)]/tei:def"/>
			<xsl:text>’</xsl:text>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="glossaryEntryFull">
		<xsl:call-template name="glossaryEntryPartial"/>
		<span class="toggle_list_element" data-element-to-show=".glossaryEntry-details-container" 
			data-element-for-accordion=".glossaryEntry-details-tabs">
			<i class="fa fa-angle-right"/>
		</span>
		<div class="glossaryEntry-details-container">
			<div class="glossaryEntry-details-tabs">
				<xsl:if test="current()/tei:sense[@value='desc']">
					<h3 lang="def" title="DESCRIPTION"><span lang="def">DESCRIPTION</span></h3>
					<div>
						<xsl:apply-templates select="current()/tei:sense[@value='desc']"/>
					</div>
				</xsl:if>
				<xsl:if test="current()/tei:etym">
					<h3 lang="def" title="ETYMOLOGY"><span lang="def">ETYMOLOGY</span></h3>
					<div>
						<xsl:apply-templates select="current()/tei:etym"/>
					</div>
				</xsl:if>
				<xsl:if test="current()/tei:listBibl">
					<h3 lang="def" title="BIBLIO"><span lang="def">BIBLIO</span></h3>
					<div>
						<xsl:for-each select="current()/tei:listBibl/tei:bibl">
							<div>						
								<xsl:apply-templates select="current()"/>
							</div>
						</xsl:for-each>
					</div>
				</xsl:if>
				
				<h3 lang="def" title="OCCURRENCES"><span lang="def">OCCURRENCES</span></h3>
				<div>
					<xsl:for-each select="current()/tei:cit[@type='concordances']/tei:cit">
						<div>
							<xsl:apply-templates/>
						</div>
					</xsl:for-each>
					<div class="occurences"></div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:gramGrp" mode="glossary">
		<span class="gramGrp">
			<xsl:for-each select="child::node()">
				<xsl:choose>
					<xsl:when test="self::comment()"></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="gramGrpElementLabel"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</span>
	</xsl:template>
	
	<xsl:template name="gramGrpElementLabel">
		<xsl:variable name="empty_string" select="''" />
		<xsl:choose>
			<xsl:when test="self::comment()"></xsl:when>
			<xsl:when test="@ana">
				<xsl:variable name="interpId" select="substring-after(@ana, '#')"/>
				<xsl:choose>
					<xsl:when test="$root//tei:interp[@xml:id=$interpId]">
						<xsl:choose>
							<xsl:when test="$root//tei:interp[@xml:id=$interpId]/@n">
								<xsl:text> </xsl:text><xsl:value-of select="$root//tei:interp[@xml:id=$interpId]/@n"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text><xsl:value-of select="$root//tei:interp[@xml:id=$interpId]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> </xsl:text><xsl:value-of select="$interpId"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@n">
				<xsl:text> </xsl:text><xsl:value-of select="@n"/>
			</xsl:when>
			<xsl:when test="normalize-space(.) != $empty_string">
				<xsl:text> </xsl:text><xsl:value-of select="current()"/>
			</xsl:when>
			<xsl:when test="@value">
				<xsl:text> </xsl:text><xsl:value-of select="@value"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>	
	</xsl:template>

</xsl:stylesheet>