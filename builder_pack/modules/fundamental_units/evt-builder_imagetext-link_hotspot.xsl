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
			EN: Template to create all necessary elements for text-image linking.
			IT: Template per la creazione degli elementi necessari per il collegamento testo immagine.
		</xd:short>
	</xd:doc>

	<!--
	<xsl:variable name="DocTitle">DORT</xsl:variable>
	<xsl:variable name="DocFileName">DORT</xsl:variable>
	<xsl:variable name="ScaledImageWidth">480</xsl:variable>
	<xsl:variable name="ScaledImageHeight">720</xsl:variable>
	<xsl:variable name="ZoomImageWidth">1200</xsl:variable>
	<xsl:variable name="ZoomImageHeight">1800</xsl:variable>
	<xsl:variable name="ImageScaleFactor">0.4</xsl:variable>
	<xsl:variable name="ScaledImageFileName">VB-104V.jpg</xsl:variable>
	<xsl:variable name="ZoomImageFileName">VB-104V-B.jpg</xsl:variable>
	-->

	<xsl:template match="/" mode="ITL">
		<xsl:variable name="n" select="replace(tei:pb/@xml:id, '-front', '')"/>

		
		<!-- EN: The menu of categories and annotations. -->
		<!-- IT: Il menu di categorie e associazioni. -->
		<xsl:element name="div">
			<xsl:attribute name="id">AnnMenu</xsl:attribute>
			<xsl:variable name="CurrCategory">Line</xsl:variable>
			<!-- EN: Mod by JK -->
			<xsl:element name="div">
				<xsl:attribute name="class" separator="" select="'AnnSubmenu_',$CurrCategory"></xsl:attribute>
				<!--<xsl:element name="span">
					<xsl:attribute name="class">CategoryTitleClosed</xsl:attribute>
					<xsl:attribute name="onclick">ShowCategory(this)</xsl:attribute>
					<xsl:value-of select="$CurrCategory"/>
					</xsl:element>-->
				<xsl:element name="div">
					<xsl:attribute name="class">AnnSubmenu</xsl:attribute>
					<xsl:for-each-group select="node()" group-starting-with="//tei:lb">
						<xsl:if test="current-group()[not((string-length(normalize-space()))= 0)]"><!--IT: non considera le righe vuote-->
							<xsl:choose>
								<xsl:when test="if(@facs) then(translate(@facs, '#', '')=$root//tei:surface[translate(@corresp, '#', '')=$n]//tei:zone[@rendition='Line']/@xml:id) else(translate(@corresp, '#', '')=$root//tei:surface[translate(@corresp, '#', '')=$n]//tei:zone/@xml:id)">
									<xsl:variable name="CurrAnnId" select="if(@facs) then(translate(@facs, '#', '')) else(translate(@corresp, '#', ''))"/>
									<xsl:element name="div">
										<xsl:attribute name="style">list-style:none;</xsl:attribute>
										<xsl:attribute name="class">AnnMenuItem</xsl:attribute>
										<xsl:attribute name="id">MenuItem_<xsl:value-of select="$CurrAnnId"/></xsl:attribute>
										<xsl:attribute name="onclick">JumpTo('<xsl:value-of select="$CurrAnnId"/>')</xsl:attribute>
										<xsl:attribute name="onmouseover">Highlight('<xsl:value-of select="$CurrAnnId"/>')</xsl:attribute>
										<xsl:attribute name="onmouseout">UnHighlight()</xsl:attribute>
										<xsl:copy-of select="current-group()[not(self::tei:lb|self::tei:pb)]"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="current-group()[not(self::tei:lb|self::tei:pb)]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:element>
			</xsl:element>
		</xsl:element>
			
		<xsl:element name="div">
			<xsl:attribute name="id">areaAnnotations</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="id" select="'realImageWidth'"/>
				<xsl:attribute name="style" select="'display:none;'"></xsl:attribute>
				<xsl:value-of select="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=$n]/tei:graphic[1]/@width"/>
			</xsl:element>
			<xsl:for-each select="$root//tei:facsimile/tei:surface[translate(@corresp, '#', '')=$n]/tei:zone">
				<!-- EN: Creates a div for area annotations -->
				<!-- IT: Crea un div per area annotations -->
				<xsl:variable name="CurrClass"><xsl:value-of select="@rendition"/></xsl:variable>
				<xsl:choose>	
					<xsl:when test="$CurrClass='Line'">
						<xsl:variable name="idL" select="@xml:id"/>
						<!-- IT: crea un div area solo se esiste un lb corrispondente alla zona corrente -->
						<xsl:if test="//self::tei:lb/translate(@facs, '#', '')=$idL">
							<xsl:call-template name="Area"></xsl:call-template>
						</xsl:if>		
					</xsl:when>
					<xsl:when test="$CurrClass='HotSpot'">
						<xsl:variable name="idL" select="@xml:id"/>
						<!-- IT: crea un div areaHS solo se esiste un div corrispondente alla zona corrente -->
						<xsl:if test="//tei:div[@type='hotspot']/tei:div/translate(@facs, '#', '')=$idL">
							<xsl:call-template name="Area">
								<xsl:with-param name="suffix" select="'HS'"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
		
		<!-- Now the actual annotation data itself (which will be hidden until called up). -->  
		<xsl:for-each select="$root//tei:back//tei:div[if(@facs)then(translate(@facs, '#', '')=$root//tei:surface[ends-with(@corresp, $n)]//tei:zone[@rendition='HotSpot']/@xml:id) else(translate(@corresp, '#', '')=$root//tei:surface[ends-with(@corresp, $n)]//tei:zone[@rendition='HotSpot']/@xml:id)]">
			<!-- Find out the id it's linked to, whether it happens to use @facs or @corresp to point to it. -->
			<xsl:variable name="linkId" select="if(@facs) then(translate(@facs, '#', '')) else(translate(@corresp, '#', ''))"/>
			<xsl:element name="div">
				<xsl:attribute name="id">Ann_<xsl:value-of select="$linkId"></xsl:value-of></xsl:attribute>
				<xsl:attribute name="class">Annotation</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">AnnTitlebar</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">PopupCloser</xsl:attribute>
						<xsl:attribute name="onclick">HideAnnHS('Ann_<xsl:value-of select="$linkId"></xsl:value-of>')</xsl:attribute><i class="fa fa-times"></i></xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="class">AnnTitle</xsl:attribute>
						<xsl:attribute name="onmousedown">BeginDragHS(this.parentNode.parentNode, event)</xsl:attribute>
						<!--<xsl:apply-templates select="tei:head"/>-->
						<xsl:text>   </xsl:text>
					</xsl:element>
				</xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">AnnText</xsl:attribute>
					<xsl:attribute name="onmousedown">doNothingHS(this, event)</xsl:attribute>
					<xsl:if test="tei:figure/tei:graphic/@url">
						<img alt="HotSpot_{$linkId}">
							<xsl:attribute name="src">data/input_data/images/hotspot/<xsl:value-of select="tei:figure/tei:graphic/@url"/></xsl:attribute>
						</img>
					</xsl:if>
					<xsl:for-each select="tei:p">
						<xsl:apply-templates select="."></xsl:apply-templates>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>   
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="a" mode="ITLembedded">
		<xsl:param name="edition_level"/>
		<!-- EN: The menu of categories and annotations. -->
		<!-- IT: Il menu di categorie e associazioni. -->
		<xsl:element name="div">
			<xsl:attribute name="id">AnnMenu</xsl:attribute>
			<xsl:variable name="CurrCategory">Line</xsl:variable>
			<xsl:element name="div">
				<xsl:attribute name="class" separator="" select="'AnnSubmenu_',$CurrCategory"></xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">AnnSubmenu</xsl:attribute>
					<!-- EN: there is an iteration on each child node of the current <surface>. This is necessary in order to deal with text outside <zone> elements -->
					<!-- IT: ciclo sui nodi figli del <surface> corrente, necessario per gestire del testo esterno a <zone> -->
					<xsl:for-each select="current-group()/child::node()">
						<xsl:choose>
							<!-- EN: if the current node is <zone> -->
							<!-- IT: se il nodo corrente è uno <zone> -->
							<xsl:when test="self::tei:zone">
								<xsl:choose>
									<xsl:when test="current()[@lrx][@lry][@ulx][@uly]"><!-- Verifico se in <zone> ci sono le coordinate -->
										<xsl:choose>
											<!-- EN: if the <zone> element is empty I need to create an alignment with the corresponding <line>-->
											<!-- IT: se <zone> e' vuoto devo creare un collegamento tra lui e il <line> corrispondente-->
											<xsl:when test="current()[((string-length(normalize-space()))= 0)]">
												<xsl:choose>
													<!-- EN: there is a check on the existence of a <line> element that has @facs equal to @xml:id of the <zone>-->
													<!-- IT: Controllo se esiste una <line> con l'id cui la <zone> fa riferimento -->
													<xsl:when test="concat('#', @xml:id)=following-sibling::tei:line/@facs">
														<xsl:variable name="CurrAnnId" select="@xml:id"/>
														<xsl:element name="div">
															<xsl:attribute name="style">list-style:none;</xsl:attribute>
															<xsl:attribute name="class">AnnMenuItem</xsl:attribute>
															<xsl:attribute name="id">MenuItem_<xsl:value-of select="$CurrAnnId"/></xsl:attribute>
															<xsl:attribute name="onclick">JumpTo('<xsl:value-of select="$CurrAnnId"/>')</xsl:attribute>
															<xsl:attribute name="onmouseover">Highlight('<xsl:value-of select="$CurrAnnId"/>')</xsl:attribute>
															<xsl:attribute name="onmouseout">UnHighlight()</xsl:attribute>
															<xsl:copy-of select="//node()[@facs=concat('#', $CurrAnnId)]" />
														</xsl:element>	
													</xsl:when>
													<xsl:otherwise />
												</xsl:choose>
											</xsl:when>
											<!-- EN: if the <zone> element is not empty the corresponding text is inside itself-->
											<!-- IT: se <zone> non e' vuoto, vuol dire che i <line> sono all'interno di <zone> stesso -->
											<xsl:otherwise>
												<xsl:choose>
													<!-- EN: if inside a <zone> there is a <graphic> element, this will be transformed as an HS -->
													<!-- IT: se il figlio di <zone> è un <graphic> questo zone viene trattato come HS -->
													<xsl:when test="current()//tei:graphic">
														<xsl:call-template name="Area">
															<xsl:with-param name="suffix" select="'HS'"/>
														</xsl:call-template>
													</xsl:when>
													<!-- EN: otherwise the image-text link will be created -->
													<!-- IT: altrimenti viene semplicemente creato il collegamento testo immagine -->
													<xsl:otherwise>
														<xsl:variable name="CurrAnnId" select="if(@xml:id) then(@xml:id) else(generate-id())"/>
														<xsl:element name="div">
															<xsl:attribute name="style">list-style:none;</xsl:attribute>
															<xsl:attribute name="class">AnnMenuItem</xsl:attribute>
															<xsl:attribute name="id">MenuItem_<xsl:value-of select="$CurrAnnId"/></xsl:attribute>
															<xsl:attribute name="onclick">JumpTo('<xsl:value-of select="$CurrAnnId"/>')</xsl:attribute>
															<xsl:attribute name="onmouseover">Highlight('<xsl:value-of select="$CurrAnnId"/>')</xsl:attribute>
															<xsl:attribute name="onmouseout">UnHighlight()</xsl:attribute>
															<xsl:copy-of select="current()" />
														</xsl:element>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<!-- EN: if in the current <zone> there aren't any coordinates, the content of element will be simply copied -->
									<!-- IT: se nello <zone> corrente non ci sono le coordinate, viene semplicemente copiato il contenuto dell'elemento stesso  -->
									<xsl:otherwise>
										<xsl:copy-of select="current()" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<!-- EN: if the current node is not a <line> or is a <line> but doesn't have linking attributes referring to an existing <zone>, the content of element will be simply copied -->
							<!-- IT: se il nodo corrente non e' <line> o e' <line> ma non ha attributi di collegamento che fanno riferimento ad uno <zone> esistente, viene semplicemente copiato il contenuto dell'elemento stesso-->
							<xsl:when test="not(self::tei:line) or self::tei:line[not (translate(@facs, '#', '')=//tei:zone/@xml:id)]">
								<xsl:copy-of select="current()" />
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="div"><!-- Div vuoti per il collegamento -->
			<xsl:attribute name="id">areaAnnotations</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="id" select="'realImageWidth'"/>
				<xsl:attribute name="style" select="'display:none;'"></xsl:attribute>
				<xsl:value-of select="current-group()/tei:graphic[1]/@width"/>
			</xsl:element>
			
			<xsl:for-each select="current-group()/tei:zone">
				<!-- EN: Creates a div for area annotations -->
				<!-- IT: Crea un div per area annotations -->
				<xsl:variable name="CurrClass"><xsl:value-of select="if(@rendition) then(@rendition) else ('Zone')"/></xsl:variable>
				<xsl:choose>
					<!-- EN: if the current <zone> has @rendition='HotSpot' or has a <graphic> element as a child, the transformation for HS are activated -->
					<!-- IT: se l'attributo @rendition di <zone> e' 'HotSpot' oppure se lo zone ha un figlio <graphic> vengono attivate le trasformazioni per l'HS-->
					<xsl:when test="($CurrClass='HotSpot')or(current()//tei:graphic)">
						<xsl:variable name="idL" select="if(@xml:id) then (@xml:id) else (generate-id())"/>
						<!-- EN: a div areaHS will be created only if exists a corresponding div in the current <zone>-->
						<!-- IT: crea un div areaHS solo se esiste un div corrispondente allo <zone> corrente -->
						<xsl:if test="current()/tei:graphic/@url"><xsl:call-template name="embeddedHS"/></xsl:if><!-- se zone ha un figlio <graphic> devo richiamare il template embeddedHS -->
						<xsl:if test="(//tei:div[@type='hotspot']/tei:div/translate(@facs, '#', '')=$idL) or (current()//tei:graphic/@url)">
							<xsl:call-template name="Area">
								<xsl:with-param name="suffix" select="'HS'"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<!-- EN: otherwise the transformations for ITL areas are activated -->
					<!-- IT: altrimenti vengono attivare le trasformazioni per la generazione delle aree per l'ITL -->
					<xsl:when test="$CurrClass!=''">
						<!-- EN: if <zone> is not empty or his @xml:id does not have a correspondance in any @facs of any <line>
								 a div AREA corresponding to the current <zone> will be created -->
						<!-- IT: Se <zone> non e' vuoto o se il suo attributo xml:id ha una corrispondenza nel @facs di un <line>
								viene creato un div AREA corrispondente alla zona corrente	-->					
						<xsl:if test="(current()[not((string-length(normalize-space()))= 0)])or(concat('#', @xml:id)=following-sibling::tei:line/@facs)">
							<xsl:call-template name="Area"></xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
				<!-- EN: <zone> elements inside other <zone> elements are treted as HS, where the text is the content of the inner <zone>-->
				<!-- IT: <zone> interni ad altri zone sono considerati HS, il cui testo e' il contenuto dello <zone> piu' interno-->
				<xsl:for-each select="current()//tei:zone">
					<xsl:call-template name="embeddedHS"/>
					<xsl:if test="(current()[not((string-length(normalize-space()))= 0)])or(concat('#', @xml:id)=following-sibling::tei:line/@facs)">
						<xsl:call-template name="Area">
							<xsl:with-param name="suffix" select="'HS'"/>
						</xsl:call-template>
					</xsl:if>					
				</xsl:for-each>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="embeddedHS">
		<xsl:variable name="linkId" select="if(@xml:id) then(@xml:id) else(generate-id())"/>
		<xsl:element name="div">
			<xsl:attribute name="id">Ann_<xsl:value-of select="$linkId"></xsl:value-of></xsl:attribute>
			<xsl:attribute name="class">Annotation</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">AnnTitlebar</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">PopupCloser</xsl:attribute>
					<xsl:attribute name="onclick">HideAnnHS('Ann_<xsl:value-of select="$linkId"></xsl:value-of>')</xsl:attribute><i class="fa fa-times"></i></xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">AnnTitle</xsl:attribute>
					<xsl:attribute name="onmousedown">BeginDragHS(this.parentNode.parentNode, event)</xsl:attribute>
					<!--<xsl:apply-templates select="tei:head"/>-->
					<xsl:text>   </xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="div">
				<xsl:attribute name="class">AnnText</xsl:attribute>
				<xsl:attribute name="onmousedown">doNothingHS(this, event)</xsl:attribute>
				<xsl:if test="(tei:figure/tei:graphic/@url)or(current()//tei:graphic)">
					<img alt="HotSpot_{$linkId}">
						<xsl:attribute name="src">data/input_data/images/hotspot/<xsl:value-of select="if(current()/tei:graphic) then(current()/tei:graphic/@url) else (tei:figure/tei:graphic/@url)"/></xsl:attribute>
					</img>
				</xsl:if>
				<xsl:for-each select="current()">
					<xsl:apply-templates select="."></xsl:apply-templates>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>   
	</xsl:template>
	
	<xsl:template name="Area">
		<xsl:param name="suffix"/>
		<xsl:element name="div">
			<!--<xsl:variable name="CurrRectId" select="@xml:id"/>-->
			<!-- CDP:embedded -->
			<xsl:variable name="CurrRectId" select="if(@xml:id) then(@xml:id) else(generate-id())"/>
			
			<xsl:variable name="RectWidth" select="number(@lrx) - number(@ulx)"/>
			<xsl:variable name="RectHeight" select="number(@lry) - number(@uly)"/>
			<xsl:variable name="suf" select="if ($suffix) then($suffix) else()"/>
			<xsl:attribute name="id">Area_<xsl:value-of select="$CurrRectId"/></xsl:attribute>
			<xsl:attribute name="class">Area<xsl:value-of select="$suf"/></xsl:attribute>
			<xsl:attribute name="onclick">ShowAnn<xsl:value-of select="$suf"/>('<xsl:value-of select="$CurrRectId"/>')</xsl:attribute>
			<!-- EN: Adds a double-click event to show the full-scale image fragment if using scale/zoom. -->
			<!-- IT: Aggiunge un evento di tipo doppio click per mostrare il frammento di immagine a piena risoluzione se si usa lo zoom. -->
			<!--<xsl:if test="number($ImageScaleFactor) &lt; 1">
						<xsl:attribute name="ondblclick">ShowZoom(<xsl:value-of select="@ulx"/>,<xsl:value-of select="@uly"/>,<xsl:value-of
						select="$RectWidth"/>,<xsl:value-of select="$RectHeight"/>)</xsl:attribute>
					</xsl:if>-->
			<xsl:attribute name="onmouseover">Highlight<xsl:value-of select="$suf"/>('<xsl:value-of select="$CurrRectId"/>')</xsl:attribute>
			<xsl:attribute name="onmouseout">UnHighlight<xsl:value-of select="$suf"/>()</xsl:attribute>
			<!-- EN: Calculate the scaled dimensions of the annotation area on the image. -->
			<!-- IT: Calcola le dimensioni in scala dell'area di annotazione dell'immagine. -->
			<!--<xsl:variable name="BoxL"><xsl:value-of select="round(@ulx * number($ImageScaleFactor))"/></xsl:variable>
					<xsl:variable name="BoxT"><xsl:value-of select="round(@uly * number($ImageScaleFactor))"/></xsl:variable>
					<xsl:variable name="BoxW"><xsl:value-of select="round($RectWidth * number($ImageScaleFactor))"/></xsl:variable>
					<xsl:variable name="BoxH"><xsl:value-of select="round($RectHeight * number($ImageScaleFactor))"/></xsl:variable>-->
			
			<!-- EN: Creates the style tag. -->
			<!-- IT: Crea lo style tag. -->
			<xsl:variable name="CurrStyle">
				position: absolute; left: <xsl:value-of select="@ulx"/>px; top: <xsl:value-of select="@uly"/>px;
				width: <xsl:value-of select="$RectWidth"/>px; height: <xsl:value-of select="$RectHeight"/>px;
				<!-- Add the colour setting from the tagsDecl in the header. -->
				<!--<xsl:value-of select="//tei:tagsDecl/tei:rendition[@xml:id=$CurrClass]/tei:code"/>;-->
				padding: 0; cursor: pointer;
				<!-- EN: Includes a font-size setting to make the non-breaking spaces take up most of the box. If we don't do this, then IE will not process mouseover messages for the box (except at the top left, where the nbsp is). Make the text centred in the box. -->
				<!-- IT: Include un'impostazione relativa alle dimensioni del font per far sì che i gli spazi non-breaking occupino la maggior parte del box. Se non si agisce in questo modo, allora IE non interpreterà correttamente i messaggi mouseover per il box (fatta eccezione per in alto a sinistra, dove si trova il nbsp). Centra il testo nel box. -->
				font-size: <xsl:value-of select="($RectHeight - 6)"/>px; text-align: center;
				vertical-align: middle; display: none;
				<!-- EN: Sets it to overflow: hidden, so that we can be sure if there are too many spaces in the box, it will not cause scrollbars. -->
				<!-- IT: Imposta l'opzione overflow: hidden, in modo da essere sicuri che se ci sono troppi spazi nel box non saranno create delle scrollbar. -->
				overflow: hidden;
				<xsl:if test="@rotate">
					transform: rotate(<xsl:value-of select="@rotate"/>deg);
					-ms-transform: rotate(<xsl:value-of select="@rotate"/>deg); /* IE 9 */
					-webkit-transform: rotate(<xsl:value-of select="@rotate"/>deg); /* Safari and Chrome */
					-moz-transform:rotate(<xsl:value-of select="@rotate"/>deg);</xsl:if>
			</xsl:variable>
			<xsl:attribute name="style"><xsl:value-of select="normalize-space($CurrStyle)"/></xsl:attribute>
			<!-- EN: Includes the string value of the head tag as a title element to give us a mouseover hint. -->
			<!-- IT: Include il valore dell'elemento head come titolo per darci un mouseover hint. -->
			<!--<xsl:attribute name="title">
						<xsl:choose>
							<xsl:when test="//tei:div[@facs = concat('#', $CurrRectId)]"><xsl:value-of select="//tei:div[@facs = $CurrRectId]/tei:head"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="//tei:div[@corresp = concat('#', $CurrRectId)]/tei:head"/></xsl:otherwise>
						</xsl:choose>
						<xsl:if test="number($ImageScaleFactor) &lt; 1">(Double-click to zoom.)</xsl:if>
					</xsl:attribute>-->
			<!-- EN: Adds a non-breaking spaces to give some real content. -->
			<!-- IT: Aggiunge degli spazi per creare un contenuto effettivo. -->
			<xsl:text>   </xsl:text>
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>
