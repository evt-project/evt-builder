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
	<xsl:template match="tei:p" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="data-id" select="@xml:id"/>			
			<xsl:if test="current()[not((string-length(normalize-space()))= 0)]">
				<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
				<xsl:apply-templates mode="#current"> </xsl:apply-templates>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<!-- L Verse line-->
	<xsl:template match="tei:l" mode="interp">
		<xsl:apply-templates mode="#current"/> 
		<xsl:text> </xsl:text><!--important-->
	</xsl:template>
	
	<!-- CDP:embedded -->
	<!-- LINE Verse line-->
	<xsl:template match="tei:line" mode="interp">
		<xsl:if test="current()[not((string-length(normalize-space()))= 0)]">
			<xsl:element name="div">
				<xsl:attribute name="class" select="$ed_name1"/>
				<xsl:element name="span">
					<xsl:attribute name="class" select="'interp-lineN'"/>
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
	<xsl:template match="tei:zone" mode="interp">
		<xsl:if test="current()[not((string-length(normalize-space()))= 0)]"><!-- Escludo elementi <line> vuoti -->
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
		</xsl:if>
	</xsl:template>
	
	<!-- DESC -->
	<xsl:template match="tei:desc" mode="interp">
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="node()[@attachment]" mode="interp">
		<xsl:element name="div">
			<xsl:attribute name="class" select="$ed_name2, 'attachment'" separator="-" />
			<xsl:apply-templates mode="#current" />
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
	<xsl:template match="tei:lb" mode="interp">
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
								<xsl:attribute name="class" select="'interp-lineN'"/>
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
	
	<!-- Page break -->
	<xsl:template match="tei:pb" mode="interp">
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
				<xsl:if test="*[not(self::orig)] or *[not(self::seg[@type='original'])]">
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
						<!-- per gestire choice contenenti tei:seg con @type=original per ORIG e @type=alter per REG-->
						<xsl:when test="@part and boolean(./ancestor::node()[parent::node()[name()=$start_split]]//preceding-sibling::node()[not(self::lb)][1]//tei:choice[@id=$choiceId and not(tei:seg[@type='alter'])])"><xsl:element name="span">
							<xsl:attribute name="class" select="$ed_name2,'choice_popup'" separator="-"/>
							<xsl:if test="@id">
								<xsl:variable name="vApos">'</xsl:variable>
								<xsl:attribute name="class" select="$ed_name2,'-choice_popup ',@id" separator=""/>
								<xsl:attribute name="onmouseover" select="'overChoice(',$vApos,@id,$vApos,')'" separator=""/>
								<xsl:attribute name="onmouseout" select="'outChoice(',$vApos,@id,$vApos,')'" separator=""/>
							</xsl:if>
							<xsl:element name="span">
								<xsl:attribute name="class" select="$ed_name2,'orig'" separator="'-'"/>
								<xsl:apply-templates select="tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]/preceding-sibling::node()[not(self::lb)][position() lt 2]//tei:choice[@id=$choiceId]//tei:seg[@type='original']/node(), 
									tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]//tei:choice[@id=$choiceId]//tei:seg[@type='original']/node(),
									tei:seg[@type='original']/ancestor::node()[parent::node()[name()=$start_split]]/following-sibling::node()[not(self::lb)][position() lt 3]//tei:choice[@id=$choiceId]//tei:seg[@type='original']/node()"
									mode="#current"/>
							</xsl:element>
							<xsl:sequence select="' '"/>
							<xsl:apply-templates select="tei:seg[@type='original']" mode="#current"> </xsl:apply-templates>
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
								<xsl:choose>
									<xsl:when test="tei:reg">
										<xsl:apply-templates select="tei:reg" mode="#current"/>		
									</xsl:when>
									<xsl:when test="tei:seg['alter']">
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
							<xsl:attribute name="class" select="$ed_name2,'choice_popup_corr'" separator="-"/>
							<xsl:if test="tei:corr">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2,'corr'" separator="-"/>
									<!--<xsl:element name="span"><xsl:attribute name="class" select="'interp-corr-resp'"/>
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
											tei:reg[descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
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
					<xsl:when test="tei:seg[@type='alter']">
						<xsl:choose>
							<!-- IT: 1. escludi i choice che contengono reg vuoti (che contengono solo white-spaces) usati per la punteggiatura
									 2. escludi i choice che contengono reg che contengono solo punteggiatura-->
							<xsl:when test="tei:seg[@type='alter'][not(descendant::tei:pc)][normalize-space()] or
								tei:seg[@type='alter'][descendant::tei:pc][node()[not(self::tei:pc)][normalize-space()]]">
								<xsl:element name="span">
									<xsl:attribute name="class" select="$ed_name2,'choice_popup'" separator="-"/>
									<xsl:if test="tei:seg[@type='original']"><xsl:apply-templates select="tei:seg[@type='original']" mode="#current"/>
										<xsl:sequence select="' '"/><!--important--></xsl:if>
									<xsl:apply-templates select="tei:seg[@type='alter']" mode="#current"> </xsl:apply-templates>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:seg[@type='alter']" mode="#current"> </xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:choice/tei:orig//tei:g" mode="interp">
		<xsl:variable name="id" select="substring-after(@ref,'#')"/>
		<xsl:apply-templates select="if($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) then($root//tei:charDecl//tei:glyph[@xml:id=$id]/tei:mapping[@type='diplomatic']) else($root//tei:charDecl//tei:char[@xml:id=$id]/tei:mapping[@type='diplomatic'])" mode="#current"/>
	</xsl:template>
	
	<!-- SUBST substitution -->
	<xsl:template match="tei:subst" mode="interp" priority="3">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
			<xsl:apply-templates select="tei:del" mode="#current"></xsl:apply-templates>|<xsl:apply-templates select="tei:add" mode="#current"></xsl:apply-templates>|</xsl:element>
	</xsl:template>
	
	<!-- ADD Addition -->
	<xsl:template match="tei:add" mode="interp" priority="2">
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
	<xsl:template match="tei:expan|tei:damage|tei:ex|tei:corr|tei:reg|tei:orig|tei:abbr" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:seg" mode="interp">
		<xsl:element name="span">
			<xsl:choose>
				<xsl:when test="@type='original'">
					<xsl:attribute name="class" select="$ed_name2,'orig'" separator="-"/>		
				</xsl:when>
				<xsl:when test="@type='alter'">
					<xsl:attribute name="class" select="$ed_name2,'reg'" separator="-"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="$ed_name2,@type" separator="-"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:sic" mode="interp">
		<!-- do nothing -->
	</xsl:template>
	
	<!-- DEL Deletions -->
	<xsl:template match="tei:del" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class" select="$ed_name2,name()" separator="-"/>[[<xsl:apply-templates mode="#current"/>]]</xsl:element>
	</xsl:template>
	
	<!-- HI Highlighted text -->
	<xsl:template match="tei:hi" mode="interp">
		<xsl:element name="span">
			<!-- Aggiungi il valore di @rend alla classe. Se in @rend è presente un '.' viene sostituito con un '_' -->
			<xsl:attribute name="class" select="$ed_name2,name(),translate(@rend, '.', '_')" separator="-"/>
			<xsl:apply-templates mode="#current"/> 
		</xsl:element>
	</xsl:template>
	
	<!-- For Embedded  Transcription -->
	<xsl:template match="node()[name()='div'][@id='areaAnnotations']" mode="interp">
		<xsl:copy-of select="." />
	</xsl:template>
	
	<xsl:template match="node()[name()='div'][@id='AnnMenu' or @class='AnnMenuItem']|node()[name()='div'][contains(@class, 'AnnSubmenu')]" mode="interp">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	
	<!-- REF References to additional text -->
	<xsl:template match="tei:ref" mode="interp">
		<xsl:choose>
			<xsl:when test="node()/ancestor::tei:note">
				<xsl:element name="span">
					<xsl:attribute name="class">ref</xsl:attribute>
					<xsl:attribute name="data-target"><xsl:value-of select="@target"/></xsl:attribute>
					<xsl:attribute name="data-type"><xsl:value-of select="@type"/></xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">popup ref</xsl:attribute>
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
	
	<xsl:template match="tei:front" mode="interp">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="tei:text/tei:body" mode="interp">
		<xsl:if test="current()[not((string-length(normalize-space()))= 0)]">
			<xsl:element name="div">
				<xsl:attribute name="class">doc</xsl:attribute>
				<xsl:attribute name="data-doc"><xsl:value-of select="current()/parent::tei:text/@xml:id"/></xsl:attribute>
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
		</xsl:if>
	</xsl:template>
	
	<!-- TITLEs in NOTE emphasized  -->
	<xsl:template match="tei:note//tei:title" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">title emph</xsl:attribute>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- EMPH emphasized  -->
	<xsl:template match="tei:emph" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">emph</xsl:attribute>
			<xsl:apply-templates mode="#current" />
		</xsl:element>
	</xsl:template>
	
	<!-- TERM -->
	<xsl:template match="tei:term" mode="interp">
		<xsl:choose>
			<xsl:when test="ancestor::tei:front">
				<xsl:element name="span">
					<xsl:attribute name="class">term</xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">term</xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- NOTE Note or annotation -->
	<xsl:template match="tei:note" mode="interp">
		<xsl:choose>
			<xsl:when test="node()/ancestor::tei:listPerson or node()/ancestor::tei:listPlace">
				<xsl:apply-templates mode="#current"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">inline_note popup</xsl:attribute>
					<xsl:attribute name="id">note_<xsl:value-of select="if(@xml:id) then (@xml:id) else (count(preceding::*[name() = name(current())]))"></xsl:value-of></xsl:attribute>
					<xsl:element name="i">
						<xsl:attribute name="class">fa fa-circle open_note trigger</xsl:attribute>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">text_note tooltip</xsl:attribute>
						<xsl:attribute name="id">
							<xsl:value-of select="./@xml:id"/>
						</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- DATE -->
	<xsl:template match="tei:date" mode="interp">
		<xsl:choose>
			<xsl:when test="@when and @when != ''">
				<xsl:element name="span">
					<xsl:attribute name="class">popup date</xsl:attribute>
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
					<xsl:attribute name="class">date</xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PERS NAME personal name -->
	<xsl:template match="tei:persName[starts-with(@ref,'#')]" mode="interp">
		<xsl:choose>
			<xsl:when test="@ref and @ref!='' and $root//tei:person[@xml:id=substring-after(current()/@ref,'#')]">
				<xsl:element name="span">
					<xsl:attribute name="class">popup persName</xsl:attribute>
					<xsl:attribute name="data-ref"><xsl:value-of select="translate(@ref, '#', '')" /></xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:for-each select="$root//tei:person[@xml:id=substring-after(current()/@ref,'#')]">
							<xsl:call-template name="person"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">persName <xsl:value-of select="substring-after(current()/@ref,'#')" /></xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="person">
		<xsl:choose>
			<xsl:when test="current()//tei:forename or current()//tei:surname or current()//tei:sex or current()//tei:occupation">
				<xsl:element name="span">
					<xsl:attribute name="class">
						entity_name 
						<xsl:if test="$list_person=true()"> link_active</xsl:if>
					</xsl:attribute>
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
					<span class='small-note'>[<xsl:apply-templates select="tei:note" mode="interp"/>]</span>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">display-block</xsl:attribute>
					Nessuna informazione.
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- MEASURE  -->
	<xsl:template match="tei:measure" mode="interp">
		<xsl:choose>
			<xsl:when test="@type or @quantity or @unit">
				<xsl:element name="span">
					<xsl:attribute name="class">popup measure</xsl:attribute>
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
					<xsl:attribute name="class">measure</xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ROLE NAME -->
	<xsl:template match="tei:roleName" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">roleName</xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
	<!-- PLACE NAME place name -->
	<xsl:template match="tei:placeName[starts-with(@ref,'#')]" mode="interp">
		<xsl:choose>
			<xsl:when test="@ref and @ref!='' and $root//tei:place[@xml:id=substring-after(current()/@ref,'#')]">
				<xsl:element name="span">
					<xsl:attribute name="class">popup placeName</xsl:attribute>
					<xsl:attribute name="data-ref"><xsl:value-of select="translate(@ref, '#', '')" /></xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">trigger</xsl:attribute>
						<xsl:apply-templates mode="#current"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">tooltip</xsl:attribute>
						<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
						<xsl:for-each select="$root//tei:place[@xml:id=substring-after(current()/@ref,'#')]">
							<xsl:call-template name="place"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">placeName <xsl:value-of select="substring-after(current()/@ref,'#')" /></xsl:attribute>
					<xsl:apply-templates mode="#current" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="place">
		<xsl:choose>
			<xsl:when test="current()//tei:settlement or current()//tei:placeName or current()//tei:district">
				<xsl:if test="current()/tei:settlement">
					<xsl:element name="span">
						<xsl:attribute name="class">
							entity_name
							<xsl:if test="$list_place=true()"> link_active</xsl:if>
						</xsl:attribute>
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
					<span class='small-note'>[<xsl:apply-templates select="tei:note" mode="interp"/>]</span>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:attribute name="class">display-block</xsl:attribute>
					Nessuna informazione.
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PTR Pointer -->
	<xsl:template match="tei:ptr" mode="interp">
		<xsl:if test="@target">
			<xsl:element name="span">
				<xsl:attribute name="class">popup image</xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="class">trigger</xsl:attribute>
					<xsl:element name="i">
						<xsl:attribute name="class">fa fa-picture-o</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<xsl:element name="span">
					<xsl:attribute name="class">tooltip</xsl:attribute>
					<xsl:element name="span"><xsl:attribute name="class">before</xsl:attribute></xsl:element>
					<xsl:for-each select="$root//tei:item[@xml:id=current()/@target]">
						<xsl:element name="img">
							<xsl:attribute name="src">data/input_data/<xsl:value-of select=".//tei:graphic/@url"/></xsl:attribute>
							<xsl:attribute name="width">180px</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
					<!-- aggiungere riferimento ad entita specifica e relative info  -->
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<!-- QUOTE Quotes -->
	<xsl:template match="tei:quote" mode="interp">
		<xsl:element name="span">
			<xsl:attribute name="class">quote</xsl:attribute>
			&#171;<xsl:apply-templates mode="#current" />&#187;
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>