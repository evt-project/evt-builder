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
            EN: Templates used to process the TEI elements regarding named entities. 
            IT: I template per la trasformazione degli elementi che codificano entità nominate. 
        </xd:short>
	</xd:doc>

    <!-- DATE -->
	<xsl:template match="tei:date" mode="dipl interp">
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
						<xsl:element name="span">
							<xsl:attribute name="class">before</xsl:attribute>
						</xsl:element>
						<xsl:text>Data normalizzata: </xsl:text>
						<xsl:value-of select="@when"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@from or @to">
				<xsl:element name="span">
					<xsl:attribute name="class">popup date</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span">
							<xsl:attribute name="class">before</xsl:attribute>
						</xsl:element>
						<xsl:text>Data normalizzata: </xsl:text>
						<xsl:value-of select="@from"/>/<xsl:value-of select="@to"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">date no-info </xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- PERS NAME personal name -->
	<xsl:template match="tei:persName[starts-with(@ref, '#')]" mode="dipl interp">
		<xsl:choose>
			<xsl:when test="count(ancestor::tei:teiHeader) > 0">
				<xsl:apply-templates mode="#current"/>
			</xsl:when>
			<xsl:when
				test="@ref and @ref != '' and $root//tei:person[@xml:id = substring-after(current()/@ref, '#')]">
				<xsl:element name="span">
					<xsl:attribute name="class">popup persName</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-list">listPerson</xsl:attribute>
					<xsl:attribute name="data-ref">
						<xsl:value-of select="translate(@ref, '#', '')"/>
					</xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span">
							<xsl:attribute name="class">before</xsl:attribute>
						</xsl:element>
						<xsl:for-each
							select="$root//tei:person[@xml:id = substring-after(current()/@ref, '#')]">
							<xsl:call-template name="person"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">persName no-info <xsl:value-of
							select="substring-after(current()/@ref, '#')"/></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="title">
						<xsl:value-of select="substring-after(current()/@ref, '#')"/>
					</xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<!-- MEASURE  -->
	<xsl:template match="tei:measure" mode="dipl interp">
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
						<xsl:element name="span">
							<xsl:attribute name="class">before</xsl:attribute>
						</xsl:element>
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
	<xsl:template match="tei:roleName" mode="dipl interp">
		<xsl:element name="span">
			<xsl:attribute name="class">roleName</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- ORG NAME  -->
	<xsl:template match="tei:orgName" mode="dipl interp">
		<xsl:choose>
			<xsl:when test="ancestor-or-self::node()/tei:org">
				<!-- DO NOTHING -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when
						test="@ref and @ref != '' and $root//tei:org[@xml:id = substring-after(current()/@ref, '#')]">
						<xsl:element name="span">
							<xsl:attribute name="class" select="'popup orgName'"/>
							<xsl:call-template name="dataAttributesFromAttributes"/>
							<xsl:attribute name="data-list">listOrg</xsl:attribute>
							<xsl:attribute name="data-ref" select="translate(@ref, '#', '')"/>
							<xsl:element name="span">
								<xsl:attribute name="class" select="'trigger'"/>
								<xsl:apply-templates mode="#current"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class" select="'tooltip'"/>
								<xsl:element name="span">
									<xsl:attribute name="class" select="'before'"/>
								</xsl:element>
								<xsl:for-each
									select="$root//tei:org[@xml:id = substring-after(current()/@ref, '#')]">
									<xsl:call-template name="org"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="span">
							<xsl:attribute name="class"
								select="concat('placeName', 'no-info', substring-after(current()/@ref, '#'))"/>
							<xsl:call-template name="dataAttributesFromAttributes"/>
							<xsl:attribute name="title"
								select="substring-after(current()/@ref, '#')"/>
							<xsl:apply-templates mode="#current"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- PLACE NAME place name -->
	<xsl:template match="tei:placeName[starts-with(@ref, '#')]" mode="dipl interp">
		<xsl:choose>
			<xsl:when
				test="@ref and @ref != '' and $root//tei:place[@xml:id = substring-after(current()/@ref, '#')]">
				<xsl:element name="span">
					<xsl:attribute name="class">popup placeName</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-list">listPlace</xsl:attribute>
					<xsl:attribute name="data-ref">
						<xsl:value-of select="translate(@ref, '#', '')"/>
					</xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span">
							<xsl:attribute name="class">before</xsl:attribute>
						</xsl:element>
						<xsl:for-each
							select="$root//tei:place[@xml:id = substring-after(current()/@ref, '#')]">
							<xsl:call-template name="place"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">placeName no-info <xsl:value-of
							select="substring-after(current()/@ref, '#')"/></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="title">
						<xsl:value-of select="substring-after(current()/@ref, '#')"/>
					</xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <!-- STAGE -->
	<xsl:template match="tei:stage" mode="dipl interp">
		<xsl:choose>
			<!-- CON POPUP -->
			<xsl:when test="@type">
				<xsl:element name="span">
					<xsl:attribute name="class">popup stage <xsl:value-of select="@type"/></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span">
							<xsl:attribute name="class">before</xsl:attribute>
						</xsl:element>
						<xsl:element name="span">
							<xsl:attribute name="class">stageName</xsl:attribute>
							<span lang="def"><xsl:value-of select="concat('STAGE_',upper-case(@type),'_LABEL')"/></span>
						</xsl:element>
						<xsl:element name="span">
							<xsl:attribute name="class">details</xsl:attribute>
							<span lang="def"><xsl:value-of select="concat('STAGE_',upper-case(@type),'_DESC')"/></span>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<!-- SENZA POPUP -->
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">stage no-info</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- SPEAKER-->
	<xsl:template match="tei:speaker" mode="dipl interp">
		<xsl:element name="span">
			<xsl:attribute name="class">speaker</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<!-- SP -->
	<xsl:template match="tei:sp" mode="dipl interp">
		<xsl:element name="span">
			<xsl:attribute name="class">sp speech</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	
</xsl:stylesheet>
