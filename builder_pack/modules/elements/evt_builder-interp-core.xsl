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
		<xd:short> EN: Templates used to process the TEI elements of the CORE module. IT: I template
			per la trasformazione degli elementi TEI del modulo CORE. </xd:short>
	</xd:doc>


	<!--             -->
	<!-- Page layout -->
	<!--             -->

	<!-- P Paragraphs -->
	<xsl:template match="tei:p" mode="interp">
		<xsl:element name="p">
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:attribute name="data-id" select="@xml:id"/>
			<!-- <xsl:if test="current()[not((string-length(normalize-space()))= 0)]"> -->
			<xsl:attribute name="class" select="$ed_name2, name()" separator="-"/>
			<xsl:apply-templates mode="#current"/>
			<!-- </xsl:if> -->
		</xsl:element>
	</xsl:template>

	<!-- L Verse line-->
	<xsl:template match="tei:l" mode="interp">
		<xsl:if test="$prose_verses_toggler=true()">
			<xsl:choose>
				<xsl:when test="@n > 9">
					<xsl:choose>
						<xsl:when test="@n != preceding::tei:l[1]/@n">
							<!-- se è il primo pezzo di l -->
							<xsl:choose>
								<xsl:when test="@n != following::tei:l[1]/@n">
									<!-- se è l'ultimo pezzo di l -->
									<xsl:if test="$prose_verses_toggler=true()">
										<span class="spazio"/>
										<sup class="cerchio">
											<xsl:value-of select="@n"/>
										</sup>
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$prose_verses_toggler=true()">
										<span class="spazio"/>
										<sup class="cerchio">
											<xsl:value-of select="@n"/>
										</sup>
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@n = 1">
							<xsl:if test="$prose_verses_toggler=true()">
								<span class="spazio"/>
								<sup class="cerchio">
									<xsl:text>0</xsl:text>
									<xsl:value-of select="@n"/>
								</sup>
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:when>
						<xsl:when test="@n != preceding::tei:l[1]/@n">
							<!-- se è il primo pezzo di l -->
							<xsl:choose>
								<xsl:when test="@n != following::tei:l[1]/@n">
									<!-- se è l'ultimo pezzo di l -->
									<xsl:if test="$prose_verses_toggler=true()">
										<span class="spazio"/>
										<sup class="cerchio">
											<xsl:text>0</xsl:text>
											<xsl:value-of select="@n"/>
										</sup>
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$prose_verses_toggler=true()">
										<span class="spazio"/>
										<sup class="cerchio">
											<xsl:text>0</xsl:text>
											<xsl:value-of select="@n"/>
										</sup>
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="parent::tei:lg">
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name2, name()" separator="-"/>
					<xsl:attribute name="data-display" select="'inline-block'"/>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:apply-templates mode="#current"/> 
					<xsl:text> </xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when test="not(ancestor-or-self::node()[ancestor-or-self::node()[name()=$start_split]]//tei:lb) and (not(@part) or number(@part) &lt; 0 or @group!='lb')">
				<xsl:choose>
					<xsl:when test="@n">
						<xsl:element name="div">
							<xsl:attribute name="class">
								<xsl:value-of select="'lb '"/>
								<xsl:value-of select="$ed_name1"/>
								<xsl:value-of select="' line'"/>
							</xsl:attribute>
							<xsl:call-template name="dataAttributesFromAttributes"/>
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name1, 'lineN'" separator="-"/>
								<xsl:attribute name="data-five-mult" select="if(abs(@n) mod 5 = 0) then('yes') else('no')"/>
								<xsl:value-of select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;', @n))"/>
								<xsl:text>&#xA0;&#xA0;</xsl:text>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class" select="concat($ed_name1, '-left ', $ed_name1,'-', name())"/>
								<xsl:call-template name="dataAttributesFromAttributes"/>
								<xsl:apply-templates mode="#current"/> 
								<xsl:text> </xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="span">
							<xsl:attribute name="class" select="$ed_name1, name()" separator="-"/>
							<xsl:attribute name="data-display" select="'block'"/>
							<xsl:call-template name="dataAttributesFromAttributes"/>
							<xsl:apply-templates mode="#current"/> 
							<xsl:text> </xsl:text>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates mode="#current"/>
					<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<!--important-->
	</xsl:template>

	<!-- CDP:embedded -->
	<!-- LINE Verse line-->
	<xsl:template match="tei:line" mode="interp">
		<xsl:if test="current()[not((string-length(normalize-space()))=0)]">
			<xsl:element name="div">
				<xsl:attribute name="class" select="$ed_name2"/>
				<xsl:call-template name="dataAttributesFromAttributes"/>
				<xsl:element name="span">
					<xsl:attribute name="class" select="'interp-lineN'"/>
					<xsl:value-of
						select="if(@n) then(if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;', @n))) else('&#xA0;&#xA0;&#xA0;')"/>
					<xsl:text>&#xA0;&#xA0;</xsl:text>
				</xsl:element>
				<xsl:element name="div">
					<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->
					<xsl:attribute name="class"
						select="if(@rend) then($ed_name2, translate(@rend, '.', '_')) else($ed_name2, 'left')"
						separator="-"/>
					<xsl:apply-templates mode="#current"/>
					<xsl:text> </xsl:text>
					<!--important-->
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!-- ZONE -->
	<xsl:template match="tei:zone" mode="interp">
		<xsl:if test="current()[not((string-length(normalize-space())) = 0)]">
			<!-- Escludo elementi <line> vuoti -->
			<xsl:choose>
				<xsl:when test="not(current()[@lrx][@lry][@ulx][@uly])">
					<!-- in questo modo se non c'e' collegamento testo immagine le zone vengono separate -->
					<xsl:element name="div">
						<xsl:attribute name="class">
							<xsl:value-of select="$ed_name2, 'zone'" separator="-"/>
						</xsl:attribute>
						<xsl:call-template name="dataAttributesFromAttributes"/>
						<xsl:apply-templates mode="#current"/>
						<xsl:text> </xsl:text>
						<!--important-->
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="#current"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
			<!--important-->
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()[@attachment]" mode="interp">
		<xsl:element name="div">
			<xsl:attribute name="class" select="$ed_name2, 'attachment'" separator="-"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- CDP:embedded END -->

	<!--<xsl:template match="tei:l" mode="interp">
		<xsl:variable name="n"><xsl:value-of select="@n"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="following-sibling::tei:l[1]/@n=$n">
				<xsl:apply-templates mode="#current"> </xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="(@n mod 5 = 0)">
						<xsl:value-of select="."/>
						<span class="right">[<xsl:value-of select="@n"/>]</span>
						<xsl:value-of disable-output-escaping="yes">&lt;hr /&gt;</xsl:value-of>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="#current"> </xsl:apply-templates>
						<xsl:value-of disable-output-escaping="yes">&lt;hr /&gt;</xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->


	<!-- Line break -->
	<!-- IT: Ignora i lb che hanno xml:id che termina con 'o' e riporta quelli che hanno xml:id che termina con 'r' eliminando quest'ultimo carattere -->
	<xsl:template match="tei:lb[@* and not(@rend='empty')]" mode="interp">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<xsl:choose>
					<xsl:when
						test="(not(ends-with(@xml:id, 'orig')) and not(ends-with(@xml:id, 'corr')) and not(ends-with(@xml:id, 'abbr')))">
						<xsl:element name="tei:lb">
							<xsl:copy-of select="@* except (@xml:id)"/>
							<xsl:attribute name="{@xml:id/name()}">
								<xsl:choose>
									<xsl:when test="ends-with(@xml:id, 'reg')">
										<xsl:value-of select="replace(@xml:id, 'reg', '')"/>
									</xsl:when>
									<xsl:when test="ends-with(@xml:id, 'expan')">
										<xsl:value-of select="replace(@xml:id, 'expan', '')"/>
									</xsl:when>
									<xsl:when test="ends-with(@xml:id, 'sic')">
										<xsl:value-of select="replace(@xml:id, 'sic', '')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@xml:id"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="class" select="'lb'" separator="-"/>
						</xsl:element>
						<xsl:if test="@n">
							<xsl:element name="span">
								<xsl:attribute name="class" select="'interp-lineN'"/>
								<xsl:value-of
									select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;', @n))"/>
								<xsl:text>&#xA0;&#xA0;</xsl:text>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="(ends-with(@xml:id, 'orig') or ends-with(@xml:id, 'corr') or ends-with(@xml:id, 'abbr'))"/>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:lb[not(@*) or @rend='empty']" mode="interp">
		<xsl:choose>
			<xsl:when test="@n">
				<xsl:element name="div">
					<xsl:attribute name="class">
						<xsl:value-of select="'lb '"/>
						<xsl:value-of select="$ed_name2"/>
						<xsl:value-of select="' line'"/>
					</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:element name="span">
						<xsl:attribute name="class" select="$ed_name2, 'lineN'" separator="-"/>
						<xsl:value-of select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;', @n))"/>
						<xsl:text>&#xA0;&#xA0;</xsl:text>
					</xsl:element>
					<div class="{$ed_name2}-left">
						<xsl:attribute name="data-type" select="'empty'"/>
					</div>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class" select="'lb'"/>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-type" select="'empty'"/>
					<xsl:value-of select="concat(' ', .)"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Page break -->
	<xsl:template match="tei:pb" mode="interp">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- Column break -->
	<xsl:template match="tei:cb" mode="interp">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!--               -->
	<!-- Transcription -->
	<!--               -->

	<!-- Choice -->
	<xsl:template match="tei:choice" mode="interp" priority="3">
		<xsl:choose>
			<xsl:when test="@id">
				<xsl:variable name="choiceId" select="@id"/>
				<!--IT: Controlla che il nodo contenga qualcosa oltre a ORIG, se c'è solo ORIG non viene fatto niente-->
				<xsl:if
					test="*[not(self::orig)] or *[not(self::abbr)] or *[not(self::seg[@type='original'])] or *[not(self::corr)]">
					<xsl:choose>
						<!-- IT: Questo è per la prima parte di CHOICE che contine un el SIC, la parte che dovrà contenere la tooltip -->
						<xsl:when
							test="@part and tei:sic or boolean(./ancestor::node()[parent::node()[name()=$start_split]]//preceding-sibling::node()[not(self::lb)][1]//tei:choice[@id=$choiceId and not(//tei:corr)])">
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2, 'choice_popup_corr'" separator="-"/>
								<xsl:if test="@id">
									<xsl:variable name="vApos">'</xsl:variable>
									<xsl:attribute name="class"
										select="$ed_name2, '-choice_popup_corr ', @id" separator=""/>
									<xsl:attribute name="onmouseover"
										select="'overChoice(', $vApos, @id, $vApos, ')'"
										separator=""/>
									<xsl:attribute name="onmouseout"
										select="'outChoice(', $vApos, @id, $vApos, ')'" separator=""/>
								</xsl:if>
								<xsl:if test="tei:corr">
									<xsl:element name="span">
										<xsl:attribute name="class" select="$ed_name2, 'corr'" separator="-"/>
										<xsl:apply-templates
											select="
												corr/ancestor::node()[parent::node()[name()=$start_split]]/preceding-sibling::node()[not(self::lb)][position() lt 2]//tei:choice[@id=$choiceId]//tei:corr/node(),
												corr/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:corr/node(),
												corr/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:corr/node()"
											mode="#current"/>
									</xsl:element>
								</xsl:if>
								<xsl:sequence select="' '"/>
								<xsl:apply-templates select="tei:sic" mode="#current" />
							</xsl:element>
						</xsl:when>
						<!-- IT: Questo è per la prima parte di CHOICE che contine un el EXPAN, la parte che dovrà contenere la tooltip -->
						<xsl:when
							test="@part and boolean(./ancestor::node()[parent::node()[name()=$start_split]]//preceding-sibling::node()[not(self::lb)][1]//tei:choice[@id = $choiceId and not(//tei:expan)])">
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2, 'choice_popup'"
									separator="-"/>
								<xsl:if test="@id">
									<xsl:variable name="vApos">'</xsl:variable>
									<xsl:attribute name="class"
										select="$ed_name2, '-choice_popup ', @id" separator=""/>
									<xsl:attribute name="onmouseover"
										select="'overChoice(', $vApos, @id, $vApos, ')'"
										separator=""/>
									<xsl:attribute name="onmouseout"
										select="'outChoice(', $vApos, @id, $vApos, ')'" separator=""
									/>
								</xsl:if>
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2, 'abbr'"
										separator="-"/>
									<xsl:apply-templates
										select="
											abbr/ancestor::node()[parent::node()[name()=$start_split]]/preceding-sibling::node()[not(self::lb)][position() lt 2]//tei:choice[@id=$choiceId]//tei:abbr/node(),
											abbr/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id = $choiceId]//tei:abbr/node(),
											abbr/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:abbr/node()"
										mode="#current"/>
								</xsl:element>
								<xsl:sequence select="' '"/>
								<xsl:apply-templates select="tei:expan" mode="#current" />
							</xsl:element>
						</xsl:when>
						<!-- IT: Questo è per la prima parte di CHOICE che contine un el REG, la parte che dovrà contenere la tooltip -->
						<xsl:when
							test="@part and boolean(./ancestor::node()[parent::node()[name()=$start_split]]//preceding-sibling::node()[not(self::lb)][1]//tei:choice[@id=$choiceId and not(descendant::tei:reg)])">
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2, 'choice_popup'" separator="-"/>
								<xsl:if test="@id">
									<xsl:variable name="vApos">'</xsl:variable>
									<xsl:attribute name="class"
										select="$ed_name2, '-choice_popup ', @id" separator=""/>
									<xsl:attribute name="onmouseover"
										select="'overChoice(', $vApos, @id, $vApos, ')'"
										separator=""/>
									<xsl:attribute name="onmouseout"
										select="'outChoice(', $vApos, @id, $vApos, ')'" separator=""
									/>
								</xsl:if>
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2, 'orig'" separator="-"/>
									<xsl:apply-templates
										select="
											orig/ancestor::node()[parent::node()[name()=$start_split]]/preceding-sibling::node()[not(self::lb)][position() lt 2]//tei:choice[@id=$choiceId]//tei:orig/node(),
											orig/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:orig/node(),
											orig/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:orig/node()"
										mode="#current"/>
								</xsl:element>
								<xsl:sequence select="' '"/>
								<xsl:apply-templates select="tei:reg, tei:seg[@type='alter']" mode="#current"/>
							</xsl:element>
						</xsl:when>
						<!-- per gestire choice contenenti tei:seg con @type=original per ORIG e @type=alter per REG-->
						<xsl:when
							test="@part and boolean(./ancestor::node()[parent::node()[name()=$start_split]]//preceding-sibling::node()[not(self::lb)][1]//tei:choice[@id=$choiceId and not(descendant::tei:seg[@type='alter'])])">
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2, 'choice_popup'" separator="-"/>
								<xsl:if test="@id">
									<xsl:variable name="vApos">'</xsl:variable>
									<xsl:attribute name="class"
										select="$ed_name2, '-choice_popup ', @id" separator="" />
									<xsl:attribute name="onmouseover"
										select="'overChoice(', $vApos, @id, $vApos, ')'" separator="" />
									<xsl:attribute name="onmouseout"
										select="'outChoice(', $vApos, @id, $vApos, ')'" separator="" />
								</xsl:if>
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2, 'orig'" separator="-"/>
									<xsl:apply-templates
										select="
											tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]/preceding-sibling::node()[not(self::lb)][position() lt 2]//tei:choice[@id=$choiceId]//tei:seg[@type='original']/node(),
											tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:seg[@type='original']/node(),
											tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:seg[@type='original']/node()"
										mode="#current"/>
								</xsl:element>
								<xsl:sequence select="' '"/>
								<xsl:apply-templates select="tei:reg, tei:seg[@type='alter']" mode="#current"/>
							</xsl:element>
						</xsl:when>
						<!-- IT: Questo è per le altre parti, che dovranno contenere solo REG -->
						<xsl:otherwise>
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2, 'choice_popup'" separator="-"/>
								<xsl:if test="@id">
									<xsl:variable name="vApos">'</xsl:variable>
									<xsl:attribute name="class"
										select="$ed_name2, '-choice_popup ', @id" separator=""/>
									<xsl:attribute name="onmouseover"
										select="'overChoice(', $vApos, @id, $vApos, ')'" separator=""/>
									<xsl:attribute name="onmouseout"
										select="'outChoice(', $vApos, @id, $vApos, ')'" separator=""/>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="tei:reg">
										<xsl:apply-templates select="tei:reg" mode="#current"/>
									</xsl:when>
									<xsl:when test="tei:expan">
										<xsl:apply-templates select="tei:expan" mode="#current"/>
									</xsl:when>
									<xsl:when test="tei:corr">
										<xsl:apply-templates select="tei:corr" mode="#current"/>
									</xsl:when>
									<xsl:when test="tei:sic">
										<xsl:apply-templates select="tei:sic" mode="#current"/>
									</xsl:when>
									<xsl:when test="tei:seg[@type='alter']">
										<xsl:apply-templates select="tei:seg[@type='alter']" mode="#current"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<!-- IT: Questo viene usato quando CHOICE non è suddiviso in più parti -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="tei:sic">
						<xsl:element name="span">
							<xsl:attribute name="class" select="$ed_name2, 'choice_popup_corr'" separator="-"/>
							<xsl:if test="tei:corr">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2, 'corr'" separator="-"/>
									<!--<xsl:element name="span"><xsl:attribute name="class" select="'interp-corr-resp'"/>
										<xsl:value-of select="tei:corr/@resp"/>
									</xsl:element><xsl:text>&#xA0;</xsl:text>-->
									<xsl:apply-templates select="tei:corr[not(child::node())]"/>
									<xsl:apply-templates select="tei:corr/node()" mode="#current"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2, 'sic'" separator="-"/>
								<xsl:apply-templates select="tei:sic[not(child::node())]"/>
								<xsl:apply-templates select="tei:sic/node()" mode="#current"/>
							</xsl:element>
						</xsl:element>

					</xsl:when>
					<xsl:when test="tei:expan">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono expan vuoti (che contengono solo white-spaces)-->
							<xsl:when
								test="
									tei:expan[not(descendant::tei:pc)][normalize-space()] or
									tei:expan[descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2, 'choice_popup'"
										separator="-"/>
									<xsl:if test="tei:abbr">
										<xsl:apply-templates select="tei:abbr" mode="#current"/>
										<xsl:sequence select="' '"/>
										<!--important-->
									</xsl:if>
									<xsl:apply-templates select="tei:expan" mode="#current"
									> </xsl:apply-templates>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:expan" mode="#current" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="tei:reg">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono reg vuoti (che contengono solo white-spaces) usati per la punteggiatura
									 2. escludi i choice che contengono reg che contengono solo punteggiatura-->
							<xsl:when
								test="tei:reg[not(descendant::tei:pc)][normalize-space()] or tei:reg[descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2, 'choice_popup'" separator="-"/>
									<xsl:if test="tei:orig">
										<xsl:apply-templates select="tei:orig" mode="#current"/>
										<!--important-->
									</xsl:if>
									<xsl:apply-templates select="tei:reg" mode="#current" />
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:reg" mode="#current" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="tei:seg[@type='alter']">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono seg vuoti (che contengono solo white-spaces) usati per la punteggiatura
									 2. escludi i choice che contengono seg che contengono solo punteggiatura-->
							<xsl:when
								test="
									tei:seg[@type='alter'][not(descendant::tei:pc)][normalize-space()] or
									tei:seg[@type='alter'][descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2, 'choice_popup'" separator="-"/>
									<xsl:if test="tei:seg[@type = 'original']">
										<xsl:apply-templates select="tei:seg[@type = 'original']" mode="#current"/>
										<!--important-->
									</xsl:if>
									<xsl:apply-templates select="tei:seg[@type='alter']" mode="#current" />
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:seg[@type='alter']" mode="#current" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:choice/tei:orig//tei:g" mode="interp">
		<xsl:variable name="id" select="substring-after(@ref, '#')"/>
		<xsl:apply-templates
			select="if($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) then($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) else($root//tei:charDecl//tei:char[@xml:id=$id]/tei:mapping[@type='diplomatic'])"
			mode="#current"/>
	</xsl:template>

	<!-- SUBST substitution -->
	<xsl:template match="tei:subst" mode="interp" priority="3">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2, name()" separator="-"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates select="tei:del" mode="#current"/>|<xsl:apply-templates
				select="tei:add" mode="#current"/>|</xsl:element>
	</xsl:template>

	<!-- ADD Addition -->
	<xsl:template match="tei:add" mode="interp" priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2, name()" separator="-"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:choose>
				<xsl:when test="ancestor::orig">
					<xsl:element name="span">
						<!-- if @place then "ed_name-add ed_name-@place" else "ed_name-add" -->
						<xsl:attribute name="class"
							select="if(@place) then($ed_name2, concat(name(), ' ', $ed_name2), @place) else($ed_name2, name())"
							separator="-"/>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@place='sup'">
							\<xsl:element name="span">
								<xsl:attribute name="class"
									select="$ed_name2, concat(name(), ' ', $ed_name2), @place"
									separator="-"/>
								<xsl:apply-templates mode="#current"/>
							</xsl:element>/
						</xsl:when>
						<xsl:when test="@place = 'sub'">
							/<xsl:element name="span">
								<xsl:attribute name="class"
									select="$ed_name2, concat(name(), ' ', $ed_name2), @place"
									separator="-"/>
								<xsl:apply-templates mode="#current"/>
							</xsl:element>\
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class" select="$ed_name2, name()" separator="-"/>
							<xsl:apply-templates mode="#current"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>


	<!--EXPAN expansion
		DAMAGE Damage
		EX editorial expansion
		CORR Correction
		REG Regularization
		ORIG Original form
		ABBR Abbreviation
		SIC
	-->
	<xsl:template
		match="tei:expan | tei:damage | tei:ex | tei:corr | tei:reg | tei:orig | tei:abbr | tei:sic"
		mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2, name()" separator="-"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:supplied" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of select="$ed_name2, name()" separator="-"/>
				<xsl:value-of select="' ', name()" separator="-"/>
			</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:seg" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of select="name(), ' '" separator=""/>
				<xsl:choose>
					<xsl:when test="@type='original'">
						<xsl:value-of select="$ed_name2, 'orig'" separator="-"/>
					</xsl:when>
					<xsl:when test="@type='alter'">
						<xsl:value-of select="$ed_name2, 'reg'" separator="-"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$ed_name2, @type" separator="-"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:sic" mode="interp">
		<!-- do nothing -->
	</xsl:template>

	<!-- DEL Deletions -->
	<xsl:template match="tei:del" mode="interp">
		<xsl:element name="span">
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:attribute name="class" select="$ed_name2, name()" separator="-"
				/>[[<xsl:apply-templates mode="#current"/>]]</xsl:element>
	</xsl:template>

	<!-- HI Highlighted text -->
	<xsl:template match="tei:hi" mode="interp">
		<xsl:element name="span">
			<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->
			<xsl:attribute name="class" select="$ed_name2, name(), translate(@rend, '.', '_')" separator="-"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- For Embedded  Transcription -->
	<xsl:template match="node()[name() = 'div'][@id = 'areaAnnotations']" mode="interp">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template
		match="node()[name() = 'div'][@id = 'AnnMenu' or @class = 'AnnMenuItem'] | node()[name() = 'div'][contains(@class, 'AnnSubmenu')]"
		mode="interp">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>


	<!-- REF References to additional text -->
	<xsl:template match="tei:ref" mode="interp">
		<xsl:choose>
			<!-- Se il @target fa riferiemento ad una risorsa online, allora lo trasformo in link HTML -->
			<xsl:when test="@target[contains(., 'www')] or @target[contains(., 'http')]">
				<xsl:element name="a">
					<xsl:attribute name="href"
						select="if(@target[contains(., 'http')]) then(@target) else(concat('http://', @target))"/>
					<xsl:attribute name="target" select="'_blank'"/>
					<xsl:call-template name="dataAttributesFromAttributes"/>
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
							select="//tei:bibl[@xml:id = substring-after(current()/@target, '#')]">
							<xsl:apply-templates mode="#current"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:front" mode="interp">
		<!-- do nothing -->
	</xsl:template>

	<xsl:template match="tei:body" mode="interp">
		<xsl:element name="div">
			<xsl:attribute name="class">doc</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:attribute name="data-doc" select="current()/parent::tei:text/@xml:id"/>
			<xsl:attribute name="title">
				<xsl:text>Doc. </xsl:text>
				<xsl:choose>
					<xsl:when test="current()/parent::tei:text/@n">
						<xsl:value-of select="current()/parent::tei:text/@n"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="generateTextLabel">
							<xsl:with-param name="text_id">
								<xsl:value-of select="current()/parent::tei:text/@xml:id"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- DESC Desc-->
	<xsl:template match="tei:desc" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">desc</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- TITLEs in NOTE emphasized  -->
	<xsl:template match="tei:note//tei:title" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">title emph</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- EMPH emphasized  -->
	<xsl:template match="tei:emph" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">emph</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- GLOSS -->
	<xsl:template match="tei:gloss" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">gloss</xsl:attribute>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:variable name="glossText">
				<xsl:apply-templates mode="#current"/>
			</xsl:variable>
			<xsl:attribute name="data-list">listGloss</xsl:attribute>
			<xsl:attribute name="data-ref">
				<xsl:choose>
					<xsl:when test="@xml:id">
						<xsl:value-of select="@xml:id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space($glossText)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<!-- PTR Pointer -->
	<xsl:template match="tei:ptr" mode="interp">
		<xsl:choose>
			<xsl:when test="@type = 'noteAnchor'">
				<xsl:if
					test="@target and @target != '' and $root//tei:note[@xml:id = substring-after(current()/@target, '#')]">
					<xsl:for-each
						select="$root//tei:note[@xml:id = substring-after(current()/@target, '#')]">
						<xsl:call-template name="notePopup"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@target and @target != ''">
					<xsl:choose>
						<xsl:when test="contains(@target, 'http') or contains(@target, 'www')">
							<xsl:element name="a">
		                        <xsl:attribute name="class">ptr external_link</xsl:attribute>
								<xsl:call-template name="dataAttributesFromAttributes"/>
								<xsl:attribute name="href">
		                            <xsl:value-of select="@target"/>
		                        </xsl:attribute>
		                        <xsl:attribute name="target">_blank</xsl:attribute>
		                        <xsl:choose>
		                            <xsl:when test="@n">
		                                <xsl:attribute name="title">
		                                    <xsl:value-of select="@n"/>
		                                </xsl:attribute>
		                            </xsl:when>
		                            <xsl:otherwise>
		                                <xsl:attribute name="lang">def</xsl:attribute>
		                                <xsl:attribute name="title">OPEN_WEB_PAGE</xsl:attribute>
		                            </xsl:otherwise>
		                        </xsl:choose>
		                        <i class="fa fa-external-link"/>
		                    </xsl:element>
						</xsl:when>
						<xsl:otherwise>
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
									<xsl:element name="span">
										<xsl:attribute name="class">before</xsl:attribute>
									</xsl:element>
									<xsl:for-each select="$root//tei:item[@xml:id = translate(current()/@target,'#','')]">
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
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- QUOTE Quotes -->
	<xsl:template match="tei:quote" mode="interp">
		<xsl:element name="span">
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:attribute name="class">quote</xsl:attribute> &#171;<xsl:apply-templates
				mode="#current"/>&#187; </xsl:element>
	</xsl:template>


	<xsl:template match="tei:back" mode="interp">
		<!-- Do nothing -->
	</xsl:template>

	<!-- Regole estratte da personalizzazioni di Alice Martinelli per edizione Gherardi -->
	<!-- HEAD -->
    <xsl:template match="tei:head" mode="interp">
		<xsl:element name="h1">
			<xsl:attribute name="class" select="'center'"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>				
    </xsl:template>

	<xsl:template match="tei:titlePage" mode="interp">
		<xsl:element name="h1">
			<xsl:attribute name="class" select="'center'"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	 <xsl:template match="tei:titlePart" mode="interp">
		<xsl:element name="h1">
			<xsl:attribute name="class" select="'titlePart center'"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>				
    </xsl:template>

    <!-- DOCAUTHOR-->
    <xsl:template match="tei:docAuthor" mode="interp">
        <xsl:element name="span">
            <xsl:attribute name="class" select="'autore'"/>
        	<xsl:call-template name="dataAttributesFromAttributes"/>
        	<xsl:apply-templates mode="#current"/><br/>
        </xsl:element>
    </xsl:template>


    <!-- @XML:LANG -->
	<!-- FOREIGN  -->
	<xsl:template match="*[@xml:lang]" mode="interp">
		<xsl:choose>
			<xsl:when test="$lang_tooltip">
				<xsl:element name="span">
					<xsl:attribute name="class">popup foreign <xsl:value-of select="name()"/></xsl:attribute>
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
						<span lang="def"><xsl:value-of select="upper-case(@xml:lang)"/></span>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">foreign <xsl:value-of select="name()"/></xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:div" mode="interp">
		<xsl:choose>
			<xsl:when test="starts-with(@type,'transl')">
				<!-- DO NOTHING -->
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="starts-with(@type,'transl')">
				<!-- DO NOTHING -->
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:w" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class" select="'w'"/>
			<xsl:call-template name="dataAttributesFromAttributes"/>
			<xsl:choose>
				<xsl:when test="tei:w[@info='complete_word']">
					<xsl:apply-templates select="tei:w[@info='complete_word']" mode="#current"/>
				</xsl:when>
				<xsl:when test="@info='broken_word'">
					<!-- DO NOTHING -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="#current"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:name" mode="interp">
		<xsl:choose>
			<xsl:when test="@ref and @ref != '' and $root//node()[@xml:id = substring-after(current()/@ref, '#')]">
				<xsl:variable name="refEl" select="$root//node()[@xml:id = substring-after(current()/@ref, '#')]"/>
				<xsl:variable name="listParent" select="$refEl/ancestor-or-self::node()[starts-with(name(), 'list')]"/>
				<xsl:element name="span">
					<xsl:attribute name="class">popup name</xsl:attribute>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:attribute name="data-list" select="$listParent/name()"/>
					<xsl:attribute name="data-list-type" select="$listParent/@type"/>
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
							select="$root//node()[@xml:id = substring-after(current()/@ref, '#')]">
							<xsl:choose>
								<xsl:when test="name() = 'person'">
									<xsl:call-template name="person"/>
								</xsl:when>
								<xsl:when test="name() = 'place'">
									<xsl:call-template name="place"/>
								</xsl:when>
								<xsl:when test="name() = 'org'">
									<xsl:call-template name="org"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates mode="#current"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class" select="'name interp-name'"/>
					<xsl:call-template name="dataAttributesFromAttributes"/>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
