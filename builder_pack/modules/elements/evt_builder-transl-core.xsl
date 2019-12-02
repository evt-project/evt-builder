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
			EN: Templates used to tradcess the TEI elements of the CORE module. Stylesheet add by FS.
			IT: I template per la trasformazione degli elementi TEI del modulo CORE. Foglio di stile aggiunto da FS. 
		</xd:short>
	</xd:doc>

	<!-- TRANSLATION - DIV - Container of Translation Edition -->
	<xsl:template match="tei:div[starts-with(@type,'transl')] | tei:div[starts-with(@type,'transl')]" mode="transl">
		<xsl:element name="div">
			<xsl:attribute name="class">doc</xsl:attribute>
			<xsl:attribute name="data-doc" select="current()/(replace (@xml:id, '_transl', ''))"/>
			<xsl:attribute name="title"><xsl:text>Doc. </xsl:text>
				<xsl:choose>
					<xsl:when test="current()/@n">
						<xsl:value-of select="current()/@n"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="generateTextLabel">
							<xsl:with-param name="text_id">
								<xsl:value-of select="current()/(replace (@xml:id, '_transl', ''))" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:div" mode="transl">
		<xsl:element name="div">
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	<!--            -->
	<!-- Page layout -->
	<!--             -->
		
	<!-- P Paragraphs -->
	<xsl:template match="tei:p" mode="transl">
		<xsl:element name="p">
			<xsl:attribute name="data-id" select="if(@xml:id) then(@xml:id) else(if(@n) then(@n) else(position()))"/>			
			<xsl:if test="current()[not((string-length(normalize-space()))= 0)]">
				<xsl:attribute name="class" select="'transl', name()" separator="-"/>
				<xsl:call-template name="dataAttributesFromAttributes"/>
				<xsl:apply-templates mode="#current"> </xsl:apply-templates>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<!-- L Verse line-->
	<xsl:template match="tei:l" mode="transl">
		<xsl:element name="div">
			<xsl:attribute name="class" select="'transl line'"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:attribute name="data-line-n" select="if (@n) then(@n) else(position())"/>
			<xsl:attribute name="data-line-id" select="if (@xml:id) then(@xml:id) else(if(@n) then (@n) else (position()))"/>
			<div class="transl-lineN">
				<xsl:value-of
					select="
						if (@n) then
							(if (string-length(@n) &gt; 1) then
								(@n)
							else
								(concat('&#xA0;&#xA0;', @n)))
						else
							('&#xA0;&#xA0;&#xA0;')"/>
				<xsl:text>&#xA0;&#xA0;</xsl:text>
			</div>
			<div class="transl-left"><xsl:apply-templates mode="#current"/></div>
		</xsl:element>
		<xsl:text> </xsl:text><!--important-->
	</xsl:template>
	
	<!-- CDP:embedded - copied from evt_builder-interp-core.xsl --> 
	<!-- LINE Verse line-->
	<xsl:template match="tei:line" mode="transl">
		<!-- DO NOTHING -->
	</xsl:template>	
		
	<xsl:template match="node()[@attachment]" mode="transl">
		<xsl:element name="div">
			<xsl:attribute name="class" select="'transl-attachment'"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- Page break -->
	<xsl:template match="tei:pb" mode="transl">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- Column break -->
	<xsl:template match="tei:cb" mode="transl">
		<xsl:copy-of select="."/>
	</xsl:template>	
	
	<!-- Head -->
	<xsl:template match="tei:head" mode="transl">
		<xsl:element name="div">
			<xsl:attribute name="class" select="'transl', 'head'" separator="-" />
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>	
	<!-- For Embedded  Transcription no usefull -->
		
	<!-- REF References to additional text -->
	<xsl:template match="tei:ref" mode="transl">
		<xsl:choose>
			<!-- Se il @target fa riferiemento ad una risorsa online, allora lo trasformo in link HTML -->
			<xsl:when test="@target[contains(., 'www')] or @target[contains(., 'http')]">
				<xsl:element name="a">
					<xsl:attribute name="href" select="if(@target[contains(., 'http')]) then(@target) else(concat('http://', @target))" />
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="target" select="'_blank'"/>
					<xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:when>
			
			<xsl:when test="node()/ancestor::tei:note or node()/ancestor::tei:desc">
			<!-- Se il tei:ref si trova all'interno di una nota o della descrizione allora diventa soltanto un trigger -->
				<xsl:element name="span">
					<xsl:attribute name="class">ref</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				
			<!-- Altrimenti si trasforma in popup -->
				<xsl:element name="span">
					<xsl:attribute name="class">popup ref</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:for-each select="//tei:bibl[@xml:id=substring-after(current()/@target,'#')]">
							<xsl:apply-templates mode="#current"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:note[@place='foot']" mode="transl">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="tei:front" mode="transl">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="tei:body" mode="transl">
		<!-- DO NOTHING -->
	</xsl:template>
	
	<!-- DESC Desc-->
	<xsl:template match="tei:desc" mode="transl">
		<xsl:element name="span">
			<xsl:attribute name="class">desc</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<!-- TITLEs in NOTE emphasized  -->
	<xsl:template match="tei:note//tei:title" mode="transl">
		<xsl:element name="span">
			<xsl:attribute name="class">title emph</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- EMPH emphasized  -->
	<xsl:template match="tei:emph" mode="transl">
		<xsl:element name="span">
			<xsl:attribute name="class">emph</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- TERM -->
	<xsl:template match="tei:term" mode="transl">
		<xsl:element name="span">
			<xsl:attribute name="class">term</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>	
	</xsl:template>
	
	<!-- DATE -->
	<xsl:template match="tei:date" mode="transl">
		<xsl:choose>
			<xsl:when test="@when and @when != ''">
				<xsl:element name="span">
					<xsl:attribute name="class">popup date</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:text>Data normalizzata: </xsl:text>
						<xsl:value-of select="@when"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">date no-info </xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PERS NAME personal name -->
	<xsl:template match="tei:persName[starts-with(@ref,'#')]" mode="transl">
		<xsl:choose>
			<xsl:when test="@ref and @ref!='' and $root//tei:person[@xml:id=substring-after(current()/@ref,'#')]">
				<xsl:element name="span">
					<xsl:attribute name="class">popup persName</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-list">listPerson</xsl:attribute>
					<xsl:attribute name="data-ref"><xsl:value-of select="translate(@ref, '#', '')" /></xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:for-each select="$root//tei:person[@xml:id=substring-after(current()/@ref,'#')]">
							<xsl:call-template name="person5"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">persName no-info <xsl:value-of select="substring-after(current()/@ref,'#')" /></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="title"><xsl:value-of select="substring-after(current()/@ref,'#')" /></xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="person5">
		<xsl:choose>
			<xsl:when test="current()//tei:forename or current()//tei:surname or current()//tei:sex or current()//tei:occupation">
				<xsl:element name="span">
					<xsl:attribute name="class">entity_name <xsl:if test="$list_person=true()"> link_active</xsl:if></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-list">listPerson</xsl:attribute>
					<xsl:attribute name="data-ref">
						<xsl:value-of select="@xml:id" />
					</xsl:attribute>
					<xsl:if test="current()//tei:forename">
						<xsl:value-of select="tei:persName//tei:forename"/>
					</xsl:if>
					<xsl:if test="current()//tei:surname">
						<xsl:text>&#xA0;</xsl:text><xsl:value-of select="tei:persName//tei:surname"/>
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
				<span class="toggle_list_element"><i class="fa fa-angle-right"></i></span>
				<xsl:if test="current()/tei:note and current()/tei:note != ''">
					<span class='small-note'><xsl:apply-templates select="tei:note" mode="transl"/></span>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">display-block</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<span lang="def">NO_INFO</span>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- MEASURE  -->
	<xsl:template match="tei:measure" mode="transl">
		<xsl:choose>
			<xsl:when test="@type or @quantity or @unit">
				<xsl:element name="span">
					<xsl:attribute name="class">popup measure</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:value-of select="@quantity"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="@unit"/>
						<xsl:if test="@type">
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@type"/>
							<xsl:text>) </xsl:text>
						</xsl:if>
						
						<!--<xsl:if test="@type!=''">
							<xsl:element name="span">
								<xsl:attribute name="class">display-block</xsl:attribute>
								<xsl:text>Tipo: </xsl:text>
								<xsl:value-of select="@type"></xsl:value-of>
							</xsl:element>
						</xsl:if>
						<xsl:if test="@quantity!=''">
							<xsl:element name="span">
								<xsl:attribute name="class">display-block</xsl:attribute>
								<xsl:text>Quantità: </xsl:text>
								<xsl:value-of select="@quantity"></xsl:value-of>
							</xsl:element>
						</xsl:if>
						<xsl:if test="@unit!=''">
							<xsl:element name="span">
								<xsl:attribute name="class">display-block</xsl:attribute>
								<xsl:text>Unità: </xsl:text>
								<xsl:value-of select="@unit"></xsl:value-of>
							</xsl:element>
						</xsl:if>-->
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">measure no-info</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ROLE NAME -->
	<xsl:template match="tei:roleName" mode="transl">
		<xsl:element name="span">
			<xsl:attribute name="class">roleName</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<!-- ORG NAME  -->
	<xsl:template match="tei:orgName" mode="transl">
		<xsl:choose>
			<xsl:when test="ancestor-or-self::node()/tei:org">
				<!-- DO NOTHING -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@ref and @ref!='' and $root//tei:org[@xml:id=substring-after(current()/@ref,'#')]">
						<xsl:element name="span">
							<xsl:attribute name="class" select="'popup orgName'"/>
							<xsl:call-template name="dataAttributesFromAttributes"/>
							<xsl:attribute name="data-list">listOrg</xsl:attribute>
							<xsl:attribute name="data-ref" select="translate(@ref, '#', '')" />
							<xsl:element name="span">
								<xsl:attribute name="class" select="'trigger'"/>
								<xsl:apply-templates mode="#current"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class" select="'tooltip'"/>
								<xsl:element name="span"><xsl:attribute name="class" select="'before'"/></xsl:element>
								<xsl:for-each select="$root//tei:org[@xml:id=substring-after(current()/@ref,'#')]">
									<xsl:call-template name="org5"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="span">
							<xsl:attribute name="class" select="concat('placeName', 'no-info', substring-after(current()/@ref,'#'))"/>
							<xsl:call-template name="dataAttributesFromAttributes"/>
							<xsl:attribute name="title" select="substring-after(current()/@ref,'#')" />
							<xsl:apply-templates mode="#current" />
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="org5">
		<xsl:choose>
			<xsl:when test="current()[@type] or current()[@subtype] or current()[@role] or current()/tei:orgName or current()/tei:desc">
				<xsl:if test="current()/tei:orgName">
					<xsl:element name="span">
						<xsl:attribute name="class">entity_name <xsl:if test="$list_org=true()"> link_active</xsl:if></xsl:attribute>
						<xsl:call-template name="dataAttributesFromAttributes"/>
						<xsl:attribute name="data-list">listOrg</xsl:attribute>
						<xsl:attribute name="data-ref" select="@xml:id" />
						<xsl:for-each select="current()/tei:orgName">
							<xsl:value-of select="current()"/>
							<xsl:if test="@type or @subtype or @notAfter or @notBefore or @from or @to">
								<xsl:text>&#xA0;(</xsl:text>
								<xsl:if test="@type">
									<xsl:value-of select="replace(replace(@type, '-', '/'), '_', ' ')"/>
									<xsl:text>&#xA0;</xsl:text>
								</xsl:if>
								<xsl:if test="@subtype">
									<xsl:value-of select="replace(replace(@subtype, '-', '/'), '_', ' ')"/>
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
				<span class="toggle_list_element"><i class="fa fa-angle-right"></i></span>
				<xsl:if test="current()/tei:desc and current()/tei:desc != ''">
					<span class='small-note'><xsl:apply-templates select="current()/tei:desc" mode="transl"/></span>
				</xsl:if>
				<xsl:if test="current()/tei:state">
					<xsl:for-each select="current()/tei:state">
						<span class='small-note orgName-state'>
							<xsl:if test="current()/@type">
								<span lang="def"><xsl:value-of select="replace(current()/@type, '-', '/')"/></span>
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
							<xsl:apply-templates mode="transl" />
							<xsl:text>.</xsl:text>
						</span>
						
					</xsl:for-each>
					</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class" select="'display-block'"/>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<span lang="def">NO_INFO</span>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- PLACE NAME place name -->
	<xsl:template match="tei:placeName[starts-with(@ref,'#')]" mode="transl">
		<xsl:choose>
			<xsl:when test="@ref and @ref!='' and $root//tei:place[@xml:id=substring-after(current()/@ref,'#')]">
				<xsl:element name="span">
					<xsl:attribute name="class">popup placeName</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-list">listPlace</xsl:attribute>
					<xsl:attribute name="data-ref"><xsl:value-of select="translate(@ref, '#', '')" /></xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:for-each select="$root//tei:place[@xml:id=substring-after(current()/@ref,'#')]">
							<xsl:call-template name="place5"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">placeName no-info <xsl:value-of select="substring-after(current()/@ref,'#')" /></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="title"><xsl:value-of select="substring-after(current()/@ref,'#')" /></xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="place5">
		<xsl:choose>
			<xsl:when test="current()//tei:settlement or current()//tei:placeName or current()//tei:district">
				<xsl:if test="current()/tei:settlement">
					<xsl:element name="span">
						<xsl:attribute name="class">
							entity_name
							<xsl:if test="$list_place=true()"> link_active</xsl:if>
						</xsl:attribute>
						<xsl:call-template name="dataAttributesFromAttributes"/>
						<xsl:attribute name="data-list">listPlace</xsl:attribute>
						<xsl:attribute name="data-ref">
							<xsl:value-of select="@xml:id" />
						</xsl:attribute>
						<xsl:value-of select="tei:settlement"/>
					</xsl:element>
					<xsl:if test="tei:settlement/@type">
						<xsl:text>, </xsl:text>
						<xsl:choose>
							<xsl:when test="contains(current()/tei:settlement/@type, '_')">
								<xsl:variable name="settlementType1"><xsl:value-of select="substring-before(current()/tei:settlement/@type, '_')"/></xsl:variable>
								<xsl:value-of select="replace($settlementType1, '-', '/')"/>
								<xsl:variable name="settlementType2"><xsl:value-of select="substring-after(current()/tei:settlement/@type, '_')"></xsl:value-of></xsl:variable>
								<xsl:choose>
									<xsl:when test="contains($settlementType2, '_')">
										<xsl:text>&#xA0;(</xsl:text>
										<xsl:value-of select="replace($settlementType2, '_', ')')"></xsl:value-of>		
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>&#xA0;</xsl:text>
										<xsl:value-of select="$settlementType2"></xsl:value-of>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="replace(current()/tei:settlement/@type, '-', '/')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
				<xsl:if test="current()/tei:placeName[@type='new']">
					<xsl:text>, oggi nota come </xsl:text>
					<xsl:value-of select="tei:placeName[@type='new']"/>	
				</xsl:if>
				<xsl:if test="current()/tei:district">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="replace(current()/tei:district/@type, '_', ' ')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:district"/>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<span class="toggle_list_element"><i class="fa fa-angle-right"></i></span>
				<xsl:if test="current()/tei:note and current()/tei:note != ''">
					<span class='small-note'><xsl:apply-templates select="tei:note" mode="transl"/></span>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">display-block</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<span lang="def">NO_INFO</span>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PTR Pointer -->
	<xsl:template match="tei:ptr" mode="transl">
		<xsl:choose>
			<xsl:when test="@type='noteAnchor'">
				<xsl:if test="@target and @target!='' and $root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
					<xsl:for-each select="$root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
						<xsl:call-template name="notePopup"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@target">
					<xsl:element name="span">
						<xsl:attribute name="class">popup image</xsl:attribute>
						<xsl:call-template name="dataAttributesFromAttributes"/>
						<xsl:element name="span">
							<xsl:attribute name="class">trigger</xsl:attribute>
							<xsl:element name="i">
								<xsl:attribute name="class">fa fa-picture-o</xsl:attribute>
							</xsl:element>
						</xsl:element>
						<xsl:element name="span">
							<xsl:attribute name="class">tooltip</xsl:attribute>
							<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
							<xsl:for-each select="$root//tei:item[@xml:id=translate(current()/@target,'#','')]">
								<xsl:element name="img">
									<xsl:attribute name="src">data/input_data/<xsl:value-of select=".//tei:graphic/@url"/></xsl:attribute>
									<xsl:attribute name="width">180px</xsl:attribute>
								</xsl:element>
								<span class="imageDetails">
									<span class="head"><xsl:value-of select=".//tei:head"/></span>
									<span class="figDesc"><xsl:value-of select=".//tei:figDesc"/></span>
								</span>
							</xsl:for-each>
							<!-- aggiungere riferimento ad entita specifica e relative info  -->
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- QUOTE Quotes -->
	<xsl:template match="tei:quote" mode="transl">		
		<xsl:element name="span">
			<xsl:attribute name="class">quote</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			&#171;<xsl:apply-templates mode="#current" />&#187;
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="tei:lb[not(@*) or @rend='empty']" mode="transl">
		<xsl:choose>
			<xsl:when test="@n">
				<xsl:element name="div">
					<xsl:attribute name="class">
						<xsl:value-of select="'lb '"/>
						<xsl:value-of select="'transl'"/>
						<xsl:value-of select="' line'"/>
					</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:element name="span">
						<xsl:attribute name="class" select="'transl', 'lineN'" separator="-"/>
						<xsl:value-of select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;', @n))"/>
						<xsl:text>&#xA0;&#xA0;</xsl:text>
					</xsl:element>
					<div class="transl-left">
						<xsl:attribute name="data-type" select="'empty'"/>
					</div>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class" select="'lb'"/>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-type" select="'empty'"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>