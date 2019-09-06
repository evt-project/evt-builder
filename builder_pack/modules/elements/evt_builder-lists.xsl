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
				test="current()//tei:name or current()//tei:forename or current()//tei:surname or current()//tei:sex or current()//tei:occupation">
				<xsl:element name="span">
					<xsl:attribute name="class">entity_name <xsl:if test="$list_person = true()">
							link_active</xsl:if></xsl:attribute>
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
				test="current()[@type] or current()[@subtype] or current()[@role] or current()/tei:orgName or current()/tei:desc">
				<xsl:if test="current()/tei:orgName">
					<xsl:element name="span">
						<xsl:attribute name="class">entity_name <xsl:if test="$list_org = true()">
								link_active</xsl:if></xsl:attribute>
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
				test="current()//tei:settlement or current()//tei:placeName or current()//tei:district">
				<xsl:if test="current()/tei:settlement">
					<xsl:element name="span">
						<xsl:attribute name="class"> entity_name <xsl:if test="$list_place = true()"
								> link_active</xsl:if>
						</xsl:attribute>
						<xsl:attribute name="data-list">listPlace</xsl:attribute>
						<xsl:attribute name="data-ref">
							<xsl:value-of select="@xml:id"/>
						</xsl:attribute>
						<xsl:value-of select="tei:settlement"/>
					</xsl:element>
					<xsl:if test="tei:settlement/@type">
						<xsl:text>, </xsl:text>
						<xsl:choose>
							<xsl:when test="contains(current()/tei:settlement/@type, '_')">
								<xsl:variable name="settlementType1">
									<xsl:value-of
										select="substring-before(current()/tei:settlement/@type, '_')"
									/>
								</xsl:variable>
								<xsl:value-of select="replace($settlementType1, '-', '/')"/>
								<xsl:variable name="settlementType2">
									<xsl:value-of
										select="substring-after(current()/tei:settlement/@type, '_')"
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
									select="replace(current()/tei:settlement/@type, '-', '/')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
				<xsl:if test="current()/tei:placeName[@type = 'new']">
					<xsl:text>, oggi nota come </xsl:text>
					<xsl:value-of select="tei:placeName[@type = 'new']"/>
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
</xsl:stylesheet>