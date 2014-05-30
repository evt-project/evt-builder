<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">
	
	<xd:doc type="stylesheet">
		<xd:short>
			EN: Templates used to process the TEI elements of the CORE module.
			IT: I template per la trasformazione degli elementi TEI del modulo CORE.
		</xd:short>
	</xd:doc>
	
	
	<!--             -->
	<!-- Page layout -->
	<!--             -->
	
	<!-- P Paragraphs -->
	<xsl:template match="tei:p" mode="dipl">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
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
		<xsl:if test="current()[not((string-length(normalize-space()))= 0)]">
			<xsl:if test="@n">
				<xsl:element name="span">
					<xsl:attribute name="class" select="'dipl-lineN'"/>
					<xsl:value-of select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;',@n))"/><xsl:text>&#xA0;&#xA0;</xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates mode="#current"/>
			<xsl:if test="following-sibling::*[1][self::tei:line]">
				<xsl:value-of disable-output-escaping="yes">&lt;br/&gt;</xsl:value-of>
			</xsl:if>
			<xsl:text> </xsl:text><!--important-->
		</xsl:if>
	</xsl:template>
	
	<!-- ZONE -->
	<xsl:template match="tei:zone" mode="dipl">
		<xsl:if test="current()[not((string-length(normalize-space()))= 0)]"><!-- Escludo elementi <line> vuoti -->
			<xsl:apply-templates mode="#current"/>
			<xsl:if test="not(current()[@lrx][@lry][@ulx][@uly])"><!-- in questo modo se non c'e' collegamento testo immagine le zone vengono separate -->
				<xsl:value-of disable-output-escaping="yes">&lt;br/&gt;</xsl:value-of>
			</xsl:if>
			<xsl:text> </xsl:text><!--important-->
		</xsl:if>
	</xsl:template>
	
	<!-- DESC -->
	<xsl:template match="tei:desc" mode="dipl">
		<xsl:text> </xsl:text>
	</xsl:template>
	<!-- CDP:embedded END -->
	
	<!--<xsl:template match="tei:l" mode="dipl">
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
	<xsl:template match="tei:lb" mode="dipl">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<xsl:choose>
					<xsl:when test="not(ends-with(@xml:id, 'orig'))">
						<xsl:element name="tei:lb">
							<xsl:copy-of select="@* except(@xml:id)"></xsl:copy-of>
							<xsl:attribute name="{@xml:id/name()}" select="if(ends-with(@xml:id, 'reg')) then(replace(@xml:id, 'reg', '')) else(@xml:id)"/>
						</xsl:element>
						<xsl:if test="@n">
							<xsl:element name="span">
								<xsl:attribute name="class" select="'dipl-lineN'"/>
								<xsl:value-of select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;',@n))"/><xsl:text>&#xA0;&#xA0;</xsl:text>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="ends-with(@xml:id, 'orig')"></xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- CDP:embedded 
	<xsl:template match="tei:zone" mode="dipl">
		<xsl:element name="ul">
			<xsl:attribute name="class">AnnSubmenu</xsl:attribute>
			<xsl:for-each select="tei:line">
				<xsl:apply-templates select="current()" mode="#current"></xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:line" mode="dipl">
		<xsl:element name="li">
			<xsl:if test="@n">
				<xsl:element name="span">
					<xsl:attribute name="class" select="'dipl-lineN'"/>
					<xsl:value-of select="if(string-length(@n) &gt; 1) then(@n) else(concat('&#xA0;&#xA0;',@n))"/><xsl:text>&#xA0;&#xA0;</xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates mode="#current"/> 
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:note" mode="dipl">
		<xsl:element name="span">
			<xsl:attribute name="class" select="'nota'" />
			<xsl:copy-of select="."></xsl:copy-of>
		</xsl:element>
	</xsl:template>
	
	 CDP:embedded END -->
	
	<!-- Page break -->
	<xsl:template match="tei:pb" mode="dipl">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	
	<!--               -->
	<!-- Transcription -->
	<!--               -->
	
	<!-- Choice -->
	<xsl:template match="tei:choice" mode="dipl" priority="3">
		<xsl:choose>
			<xsl:when test="@id">
				<xsl:variable name="choiceId" select="@id"/>
				<!--IT: Controlla che il nodo contenga qualcosa oltre a ORIG, se c'è solo ORIG non viene fatto niente-->
				<xsl:if test="*[not(self::orig)]">
					<xsl:choose>
						<!-- IT: Questo è per la prima parte di CHOICE che contine un el REG, la parte che dovrà contenere la tooltip -->
						<xsl:when test="@part and boolean(./ancestor::node()[parent::node()[name()=$start_split]]//preceding-sibling::node()[not(self::lb)][1]//tei:choice[@id=$choiceId and not(tei:reg)])"><xsl:element name="span">
							<xsl:attribute name="class" select="$ed_name2,'choice_popup'" separator="-"/>
							<xsl:if test="@id">
								<xsl:variable name="vApos">'</xsl:variable>
								<xsl:attribute name="class" select="$ed_name2,'-choice_popup ',@id" separator=""/>
								<xsl:attribute name="onmouseover" select="'overChoice(',$vApos,@id,$vApos,')'" separator=""/>
								<xsl:attribute name="onmouseout" select="'outChoice(',$vApos,@id,$vApos,')'" separator=""/>
							</xsl:if>
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2,'orig'" separator="'-'"/>
								<xsl:apply-templates select="orig/ancestor::node()[parent::node()[name()=$start_split]]/preceding-sibling::node()[not(self::lb)][position() lt 2]//tei:choice[@id=$choiceId]//tei:orig/node(), 
									orig/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:orig/node(),
									orig/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:orig/node()"
									mode="#current"/>
							</xsl:element>
							<xsl:sequence select="' '"/>
							<xsl:apply-templates select="tei:reg" mode="#current"> </xsl:apply-templates>
						</xsl:element>
						</xsl:when>
						<!-- IT: Questo è per le altre parti, che dovranno contenere solo REG -->
						<xsl:otherwise>
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2,'choice_popup'" separator="-"/>
								<xsl:if test="@id">
									<xsl:variable name="vApos">'</xsl:variable>
									<xsl:attribute name="class" select="$ed_name2,'-choice_popup ',@id" separator=""/>
									<xsl:attribute name="onmouseover" select="'overChoice(',$vApos,@id,$vApos,')'" separator=""/>
									<xsl:attribute name="onmouseout" select="'outChoice(',$vApos,@id,$vApos,')'" separator=""/>
								</xsl:if>
								<xsl:apply-templates select="tei:reg" mode="#current"/>
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
							<xsl:attribute name="class" select="$ed_name2,'choice_popup_corr'" separator="-"/>
							<xsl:if test="tei:corr">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2,'corr'" separator="-"/>
									<!--<xsl:element name="span"><xsl:attribute name="class" select="'dipl-corr-resp'"/>
										<xsl:value-of select="tei:corr/@resp"/>
									</xsl:element><xsl:text>&#xA0;</xsl:text>-->
									<xsl:apply-templates select="tei:corr[not(child::node())]"/>
									<xsl:apply-templates select="tei:corr/node()" mode="#current"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2,'sic'" separator="-"/>
								<xsl:apply-templates select="tei:sic[not(child::node())]"/>
								<xsl:apply-templates select="tei:sic/node()" mode="#current"/>
							</xsl:element>
						</xsl:element>
						
					</xsl:when>
					<xsl:when test="tei:expan">
						<xsl:apply-templates select="tei:expan" mode="#current"/> 
					</xsl:when>
					<xsl:when test="tei:reg">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono reg vuoti (che contengono solo white-spaces) usati per la punteggiatura
									 2. escludi i choice che contengono reg che contengono solo punteggiatura-->
							<xsl:when test="tei:reg[not(descendant::tei:pc)][normalize-space()] or
										   (tei:reg[descendant::tei:pc] and tei:reg/node()[not(self::tei:pc)]/normalize-space())">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2,'choice_popup'" separator="-"/>
									<xsl:if test="tei:orig"><xsl:apply-templates select="tei:orig" mode="#current"/>
										<xsl:sequence select="' '"/><!--important--></xsl:if>
									<xsl:apply-templates select="tei:reg" mode="#current"> </xsl:apply-templates>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:reg" mode="#current"> </xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:choice/tei:orig//tei:g" mode="dipl">
		<xsl:variable name="id" select="substring-after(@ref,'#')"/>
		<xsl:apply-templates select="if($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) then($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) else($root//tei:charDecl//tei:char[@xml:id=$id]/tei:mapping[@type='diplomatic'])" mode="#current"/>
	</xsl:template>
	
	<!-- SUBST substitution -->
	<xsl:template match="tei:subst" mode="dipl" priority="3">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
			<xsl:apply-templates select="tei:del" mode="#current"></xsl:apply-templates>|<xsl:apply-templates select="tei:add" mode="#current"></xsl:apply-templates>|</xsl:element>
	</xsl:template>
	
	<!-- ADD Addition -->
	<xsl:template match="tei:add" mode="dipl" priority="2">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
			<xsl:choose>
				<xsl:when test="ancestor::orig">
					<xsl:element name="span">
						<!-- if @place then "ed_name-add ed_name-@place" else "ed_name-add" -->
						<xsl:attribute name="class" select="if(@place) then($ed_name2,concat(name(),' ',$ed_name2),@place) else($ed_name2,name())" separator="-"/>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@place='sup'">\<xsl:element name="span">
							<xsl:attribute name="class" select="$ed_name2,concat(name(),' ',$ed_name2),@place" separator="-"/>
							<xsl:apply-templates mode="#current"/> 
						</xsl:element>/</xsl:when>
						<xsl:when test="@place='sub'">/<xsl:element name="span">
							<xsl:attribute name="class" select="$ed_name2,concat(name(),' ',$ed_name2),@place" separator="-"/>
							<xsl:apply-templates mode="#current"/> 
						</xsl:element>\</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
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
	-->
	<xsl:template match="tei:expan|tei:damage|tei:ex|tei:corr|tei:reg|tei:orig|tei:abbr" mode="dipl">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:sic" mode="dipl">
		<!-- do nothing -->
	</xsl:template>
	
	<!-- DEL Deletions -->
	<xsl:template match="tei:del" mode="dipl">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>[[<xsl:apply-templates mode="#current"/>]]</xsl:element>
	</xsl:template>
	
	<!-- HI Highlighted text -->
	<xsl:template match="tei:hi" mode="dipl">
		<xsl:element name="span">
			<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->
			<xsl:attribute name="class" select="$ed_name2,name(),translate(@rend, '.', '_')" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>