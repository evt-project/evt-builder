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
			EN: Templates used to process the TEI elements of the CORE module.
			IT: I template per la trasformazione degli elementi TEI del modulo Core.
		</xd:short>
	</xd:doc>
	
	
	<!--             -->
	<!-- Page layout -->
	<!--             -->
	
	<!-- P Paragraphs -->
	<xsl:template match="tei:p" mode="dipl">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name1,name()" separator="-"/>
			<xsl:if test="@part">
				<xsl:attribute name="data-part" select="@part"/>
			</xsl:if>
			<xsl:apply-templates mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<!-- L Verse line-->
	<xsl:template match="tei:l" mode="dipl">
		<xsl:apply-templates mode="#current"/> 
		<xsl:text> </xsl:text><!--important-->
	</xsl:template>
	
	<!-- CDP:embedded -->
	<!-- LINE Verse line-->
	<xsl:template match="tei:line" mode="dipl">
		<xsl:if test="current()[not((string-length(normalize-space()))= 0)]"><!-- Escludo elementi <line> vuoti -->
			<xsl:element name="div">
				<xsl:attribute name="class" select="$ed_name1"/>
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name1, 'lineN'" separator="-"/>
					<xsl:value-of select="if(@n) then (if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;',@n))) else ('&#xA0;&#xA0;&#xA0;')"/><xsl:text>&#xA0;&#xA0;</xsl:text>
				</xsl:element>
				<xsl:element name="div">
					<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->					
					<xsl:attribute name="class" select="if(@rend) then ($ed_name1, translate(@rend, '.', '_')) else ($ed_name1, 'left')" separator="-"/>
					<xsl:apply-templates mode="#current"/>
					<xsl:text> </xsl:text><!--important-->
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<!-- ZONE -->
	<xsl:template match="tei:zone" mode="dipl">
		<xsl:choose>
			<xsl:when test="not(current()[@lrx][@lry][@ulx][@uly])"><!-- in questo modo se non c'e' collegamento testo immagine le zone vengono separate -->
				<xsl:element name="div">
					<xsl:attribute name="class"><xsl:value-of select="$ed_name1, 'zone'" separator="-" /></xsl:attribute>
					<xsl:apply-templates mode="#current"/>
					<xsl:text> </xsl:text><!--important-->
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><!--important-->
	</xsl:template>
	
	<!-- DESC -->
	<xsl:template match="tei:desc" mode="dipl">
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="node()[@attachment]" mode="dipl">
		<xsl:element name="div">
			<xsl:attribute name="class" select="$ed_name1, 'attachment'" separator="-" />
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	<!-- CDP:embedded END -->
	
	<!-- Line break -->
	<!-- IT: Ignora i lb che hanno xml:id che termina con 'r' e riporta quelli che hanno xml:id che termina con 'o' eliminando quest'ultimo carattere -->
	<xsl:template match="tei:lb" mode="dipl">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<xsl:choose>
					<xsl:when test="(not(ends-with(@xml:id, 'reg')) and not(ends-with(@xml:id, 'corr')) and not(ends-with(@xml:id, 'expan')))">
						<xsl:element name="tei:lb">
							<xsl:copy-of select="@* except(@xml:id)"></xsl:copy-of>
							<xsl:attribute name="{@xml:id/name()}">
								<xsl:choose>
									<xsl:when test="ends-with(@xml:id, 'orig')">
										<xsl:value-of select="replace(@xml:id, 'orig', '')"/>
									</xsl:when>
									<xsl:when test="ends-with(@xml:id, 'abbr')">
										<xsl:value-of select="replace(@xml:id, 'abbr', '')"/>
									</xsl:when>
									<xsl:when test="ends-with(@xml:id, 'sic')">
										<xsl:value-of select="replace(@xml:id, 'sic', '')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@xml:id"/>
									</xsl:otherwise>
								</xsl:choose>	
							</xsl:attribute>
						</xsl:element>
						<xsl:if test="@n">
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name1,'lineN'" separator="-"/>
								<xsl:value-of select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;',@n))"/><xsl:text>&#xA0;&#xA0;</xsl:text>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Page break -->
	<xsl:template match="tei:pb" mode="dipl">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- Column break -->
	<xsl:template match="tei:cb" mode="dipl">
		<xsl:element name="tei:cb">
			<xsl:copy-of select="@* except(@xml:id)"></xsl:copy-of>
			<xsl:attribute name="{@xml:id/name()}" select="if(ends-with(@xml:id, 'orig')) then(replace(@xml:id, 'orig', '')) else(@xml:id)"/>
		</xsl:element>
	</xsl:template>
	
	
	
	<!--               -->
	<!-- Transcription -->
	<!--               -->
	
	<!-- Choice -->
	<xsl:template match="tei:choice" mode="dipl" priority="3">
		<xsl:choose>
			<!-- IT: Questo è per la prima parte di CHOICE (che contine un el ORIG), la parte che dovrà contenere la tooltip -->
			<xsl:when test="@part=1">
				<!--ORIG 1: <xsl:copy-of select="tei:orig"></xsl:copy-of>
				<xsl:variable name="choiceId" select="orig/ancestor::tei:choice[1]/@id"></xsl:variable>
				siblings:	<xsl:copy-of select="orig/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]"/>
				REG 1: <xsl:copy-of select="orig/ancestor::node()[parent::node()[name()=$start_split]]/tei:reg/node()"/>
				REG: <xsl:copy-of select="orig/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:reg/node()"/>
				--> 
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name1,'choice_popup'" separator="-"/>
					<xsl:if test="@id">
						<xsl:variable name="vApos">'</xsl:variable>
						<xsl:attribute name="class" select="$ed_name1,'-choice_popup ',@id" separator=""/>
						<xsl:attribute name="onmouseover" select="'overChoice(',$vApos,@id,$vApos,')'" separator=""/>
						<xsl:attribute name="onmouseout" select="'outChoice(',$vApos,@id,$vApos,')'" separator=""/>
					</xsl:if>
					<xsl:element name="span">
						<xsl:attribute name="class" select="$ed_name1,'reg'" separator="-"/>
						<xsl:choose>
							<xsl:when test="tei:abbr">
								<xsl:variable name="choiceId" select="abbr/ancestor::tei:choice[1]/@id"></xsl:variable>
								<xsl:apply-templates select="abbr/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:expan/node(),
									abbr/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:expan/node()"
									mode="#current"/>		
							</xsl:when>
							<xsl:when test="tei:orig">
								<xsl:variable name="choiceId" select="orig/ancestor::tei:choice[1]/@id"></xsl:variable>
								<xsl:apply-templates select="orig/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:reg/node(),
									orig/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:reg/node()"
									mode="#current"/>		
							</xsl:when>
							<xsl:when test="tei:seg[@type='original']">
								<xsl:variable name="choiceId" select="tei:seg[@type='original']/ancestor::tei:choice[1]/@id"></xsl:variable>
								<xsl:apply-templates select="tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:seg[@type='alter']/node(),
									tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:seg[@type='alter']/node()"
									mode="#current"/>
							</xsl:when>
						</xsl:choose>
						
					</xsl:element>
					<xsl:sequence select="' '"/>
					<xsl:choose>
						<xsl:when test="tei:orig">
							<xsl:apply-templates select="tei:orig" mode="#current"> </xsl:apply-templates>
						</xsl:when>
						<xsl:when test="tei:abbr">
							<xsl:apply-templates select="tei:abbr" mode="#current"> </xsl:apply-templates>
						</xsl:when>
						<xsl:when test="tei:seg[@type='original']">
							<xsl:apply-templates select="tei:seg" mode="#current"> </xsl:apply-templates>
						</xsl:when>
					</xsl:choose>
					
				</xsl:element>
			</xsl:when>
			<!-- IT: Questo è per le altre parti, che dovranno contenere solo ORIG-->
			<xsl:when test="@part and not(@part=1)">
				<xsl:element name="span">
					<xsl:attribute name="class" select="$ed_name1,'choice_popup'" separator="-"/>
					<xsl:if test="@id">
						<xsl:variable name="vApos">'</xsl:variable>
						<xsl:attribute name="class" select="$ed_name1,'-choice_popup ',@id" separator=""/>
						<xsl:attribute name="onmouseover" select="'overChoice(',$vApos,@id,$vApos,')'" separator=""/>
						<xsl:attribute name="onmouseout" select="'outChoice(',$vApos,@id,$vApos,')'" separator=""/>
					</xsl:if>
					<xsl:if test="tei:orig">
						<xsl:apply-templates select="tei:orig" mode="#current"/>
					</xsl:if>
					<xsl:if test="tei:abbr">
						<xsl:apply-templates select="tei:abbr" mode="#current"/>
					</xsl:if>
					<xsl:if test="tei:seg[@type='original']">
						<xsl:apply-templates select="tei:seg[@type='original']" mode="#current"/>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			<!-- IT: Questo è per i casi in cui CHOICE non è suddiviso in più parti-->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="tei:sic">
						<xsl:apply-templates select="tei:sic" mode="#current"> </xsl:apply-templates>
					</xsl:when>
					<xsl:when test="tei:abbr">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono reg vuoti (che contengono solo white-spaces) usati per la punteggiatura
									 2. escludi i choice che contengono reg che contengono solo punteggiatura-->
							<xsl:when test="tei:expan[not(descendant::tei:pc)][normalize-space()] or
								tei:expan[descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name1,'choice_popup'" separator="-"/>
									<xsl:apply-templates select="tei:expan" mode="#current"> </xsl:apply-templates>
									<xsl:sequence select="' '"/>
									<xsl:apply-templates select="tei:abbr" mode="#current"> </xsl:apply-templates>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:abbr" mode="#current"> </xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="tei:orig">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono reg vuoti (che contengono solo white-spaces) usati per la punteggiatura
									 2. escludi i choice che contengono reg che contengono solo punteggiatura-->
							<xsl:when test="tei:reg[not(descendant::tei:pc)][normalize-space()] or
											tei:reg[descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name1,'choice_popup'" separator="-"/>
									<xsl:apply-templates select="tei:reg" mode="#current"> </xsl:apply-templates>
									<xsl:sequence select="' '"/>
									<xsl:apply-templates select="tei:orig" mode="#current"> </xsl:apply-templates>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:orig" mode="#current"> </xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="tei:seg[@type='original']">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono reg vuoti (che contengono solo white-spaces) usati per la punteggiatura
									 2. escludi i choice che contengono reg che contengono solo punteggiatura-->
							<xsl:when test="tei:seg[@type='alter'][not(descendant::tei:pc)][normalize-space()] or
								tei:reg[descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name1,'choice_popup'" separator="-"/>
									<xsl:apply-templates select="tei:seg[@type='alter']" mode="#current"> </xsl:apply-templates>
									<xsl:sequence select="' '"/>
									<xsl:apply-templates select="tei:seg[@type='original']" mode="#current"> </xsl:apply-templates>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:seg[@type='original']" mode="#current"> </xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:choice/tei:reg//tei:g" mode="dipl">
		<xsl:variable name="id" select="substring-after(@ref,'#')"/>
		<xsl:apply-templates select="if($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='normalized']) then($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='normalized']) else($root//tei:charDecl//tei:char[@xml:id=$id]/tei:mapping[@type='normalized'])" mode="#current"/>
	</xsl:template>
		
	<!--SUBST substitution -->
	<xsl:template match="tei:subst" mode="dipl" priority="3">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name1,name()" separator="-"/>
			<xsl:apply-templates select="tei:del" mode="#current"> </xsl:apply-templates>
			<xsl:apply-templates select="tei:add" mode="#current"> </xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<!-- ADD Addition -->
	<xsl:template match="tei:add" mode="dipl" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::reg">
				<xsl:choose>
					<xsl:when test="@place='sup'">\<xsl:element name="span">
						<xsl:attribute name="class" select="$ed_name1,concat(name(),' ',$ed_name1),@place" separator="-"/>
						<xsl:apply-templates mode="#current"/> 
					</xsl:element>/</xsl:when>
					<xsl:when test="@place='sub'">/<xsl:element name="span">
						<xsl:attribute name="class" select="$ed_name1,concat(name(),' ',$ed_name1),@place" separator="-"/>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>\</xsl:when>
					<xsl:otherwise><xsl:element name="span">
						<xsl:attribute name="class" select="$ed_name1,name()" separator="-"/>
						<xsl:apply-templates mode="#current"/> 
					</xsl:element></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<!-- if @place then "ed_name-add ed_name-@place" else "ed_name-add" -->
					<xsl:attribute name="class" select="if(@place) then($ed_name1,concat(name(),' ',$ed_name1),@place) else($ed_name1,name())" separator="-"/>
					<xsl:apply-templates mode="#current"/> 
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
		SIC Text reproduced although apparently incorrect or inaccurate
		DEL Deletions
		DAMAGE Damage
		ORIG Original form
		REG Regularization
		ABBR Abbreviation
	-->
	<xsl:template match="tei:sic|tei:del|tei:damage|tei:am|tei:orig|tei:reg|tei:abbr|tei:expan" mode="dipl"
		priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name1,name()" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template match="tei:supplied" mode="dipl">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name1, name()" separator="-"/>
			<xsl:attribute name="data-reason" select="@reason"/>
			<xsl:attribute name="data-type" select="@type"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:seg" mode="dipl" priority="2">
		<xsl:element name="span">
			<xsl:choose>
				<xsl:when test="@type='original'">
					<xsl:attribute name="class" select="$ed_name1,'orig'" separator="-"/>		
				</xsl:when>
				<xsl:when test="@type='alter'">
					<xsl:attribute name="class" select="$ed_name1,'reg'" separator="-"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="$ed_name1,@type" separator="-"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<!--
		CORR Correction
		EXPAN Expansion
	-->
	<xsl:template match="tei:corr" mode="dipl" priority="2">
		<!-- Do nothing -->
	</xsl:template>	
	<xsl:template match="tei:expan[ancestor::tei:reg]" mode="dipl" priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name1,name()" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<!-- HI Highlighted text -->
	<xsl:template match="tei:hi" mode="dipl" priority="2">
		<xsl:element name="span">
			<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->
			<xsl:attribute name="class" select="$ed_name1,name(),translate(@rend, '.', '_')" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<!-- For Embedded  Transcription -->
	<xsl:template match="node()[name()='div'][@id='areaAnnotations']" mode="dipl">
		<xsl:copy-of select="." />
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@id='AnnMenu' or @class='AnnMenuItem']|node()[name()='div'][contains(@class, 'AnnSubmenu')]" mode="dipl">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- REF References to additional text -->
	<xsl:template match="tei:ref" mode="dipl">
		<xsl:choose>
			<xsl:when test="starts-with(@target,'#')">
				<xsl:choose>
					<xsl:when test="node()/ancestor::tei:note">
						<!-- Se il tei:ref si trova all'interno di una nota diventa soltanto un trigger -->
						<xsl:element name="span">
							<xsl:attribute name="class">ref</xsl:attribute>
							<xsl:attribute name="data-target"><xsl:value-of select="@target"/></xsl:attribute>
							<xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
							<xsl:apply-templates mode="#current"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<!-- Do nothing -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:front" mode="dipl">
		<!-- Do nothing -->
	</xsl:template>
	
	<xsl:template match="tei:body" mode="dipl">
		<xsl:element name="div">
			<xsl:attribute name="class">doc</xsl:attribute>
			<xsl:attribute name="data-doc" select="current()/parent::tei:text/@xml:id"/>
			<xsl:attribute name="title"><xsl:text>Doc. </xsl:text>
				<xsl:choose>
					<xsl:when test="current()/parent::tei:text/@n">
						<xsl:value-of select="current()/parent::tei:text/@n"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="generateTextLabel">
							<xsl:with-param name="text_id">
								<xsl:value-of select="current()/parent::tei:text/@xml:id" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<!-- EMPH emphasized  -->
	<xsl:template match="tei:emph" mode="dipl">
		<xsl:choose>
			<xsl:when test="node()/ancestor::tei:note">
				<xsl:element name="span">
					<xsl:attribute name="class">emph</xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="#current" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- TERM -->
	<xsl:template match="tei:term" mode="dipl">
		<xsl:element name="span">
			<xsl:attribute name="class">term</xsl:attribute>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- NOTE Note or annotation -->
	<xsl:template match="tei:note" mode="dipl">
		<!-- Do nothing -->
	</xsl:template>
	
	<!-- DATE -->
	<xsl:template match="tei:date" mode="dipl">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- PERS NAME personal name -->
	<xsl:template match="tei:persName[starts-with(@ref,'#')]" mode="dipl">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- MEASURE  -->
	<xsl:template match="tei:measure" mode="dipl">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- ROLE NAME -->
	<xsl:template match="tei:roleName" mode="dipl">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- ORG NAME  -->
	<xsl:template match="tei:orgName" mode="dipl">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- PLACE NAME personal name -->
	<xsl:template match="tei:placeName[starts-with(@ref,'#')]" mode="dipl">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<!-- PTR Pointer -->
	<xsl:template match="tei:ptr" mode="dipl">
		<xsl:choose>
			<xsl:when test="@type='noteAnchor'">
				<xsl:if test="@target and @target!='' and $root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
					<xsl:for-each select="$root//tei:note[@xml:id=substring-after(current()/@target,'#')]">
						<xsl:call-template name="notePopup"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- Do nothing -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- QUOTE Quotes -->
	<xsl:template match="tei:quote" mode="dipl">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
</xsl:stylesheet>