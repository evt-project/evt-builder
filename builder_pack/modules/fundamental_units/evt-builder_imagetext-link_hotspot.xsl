<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">

	<xd:doc type="stylesheet">
		<xd:short>
			EN: Template to create all elements necessary for text-image linking.
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
		<xsl:variable name="n" select="tei:pb/@n"/>
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
								<xsl:when test="if(@facs) then(translate(@facs, '#', '')=$root//tei:surface[@xml:id=concat('surf_',$n)]//tei:zone[@rendition='Line']/@xml:id) else(translate(@corresp, '#', '')=$root//tei:surface[@xml:id=concat('surf_',$n)]//tei:zone/@xml:id)">
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
				<xsl:value-of select="$root//tei:facsimile/tei:surface[substring(@xml:id, string-length(@xml:id)-3)=$n]/tei:graphic/@width"/>
			</xsl:element>
			<xsl:for-each select="$root//tei:facsimile/tei:surface[substring(@xml:id, string-length(@xml:id)-3)=$n]/tei:zone">
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
		<xsl:for-each select="$root//tei:back//tei:div[if(@facs)then(translate(@facs, '#', '')=$root//tei:surface[@xml:id=concat('surf_',$n)]//tei:zone[@rendition='HotSpot']/@xml:id) else(translate(@corresp, '#', '')=$root//tei:surface[@xml:id=concat('surf_',$n)]//tei:zone[@rendition='HotSpot']/@xml:id)]">
			<!-- Find out the id it's linked to, whether it happens to use @facs or @corresp to point to it. -->
			<xsl:variable name="linkId" select="if(@facs) then(translate(@facs, '#', '')) else(translate(@corresp, '#', ''))"/>
			<xsl:element name="div">
				<xsl:attribute name="id">Ann_<xsl:value-of select="$linkId"></xsl:value-of></xsl:attribute>
				<xsl:attribute name="class">Annotation</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">AnnTitlebar</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">PopupCloser</xsl:attribute>
						<xsl:attribute name="onclick">HideAnnHS('Ann_<xsl:value-of select="$linkId"></xsl:value-of>')</xsl:attribute>X</xsl:element>
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
	
	<xsl:template match="." mode="ITLembedded">
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
					<xsl:for-each select="current-group()/child::node()"><!-- per ogni zone -->
						<xsl:choose>
							<xsl:when test="self::tei:zone">
								<xsl:choose>
									<xsl:when test="current()[@lrx][@lry][@ulx][@uly]"><!-- Verifico se in <zone> ci sono le coordinate -->
										<xsl:choose>
											<!-- se <zone> e' vuoto devo creare un collegamento tra lui e i <line> corrispondenti-->
											<xsl:when test="current()[((string-length(normalize-space()))= 0)]">
												<xsl:choose>
													<!-- Controllo se esiste una <line> con l'id cui la <zone> fa riferimento -->
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
															<!--<xsl:if test="$edition_level='facs'">
																<xsl:apply-templates select="//node()[@facs=concat('#', $CurrAnnId)]" mode="facs"></xsl:apply-templates>
															</xsl:if>
															<xsl:if test="$edition_level='dipl'">
																<xsl:apply-templates select="//node()[@facs=concat('#', $CurrAnnId)]" mode="dipl"></xsl:apply-templates>
															</xsl:if>-->
														</xsl:element>	
													</xsl:when>
													<xsl:otherwise />
												</xsl:choose>
											</xsl:when>
											<!-- altrimenti vuol dire che i <line> sono all'interno di <zone> stesso -->
											<xsl:otherwise>
												<xsl:choose>
													<!-- se il figlio di zone è un <graohic> devo trattare zone come HS -->
													<xsl:when test="current()//tei:graphic">
														<xsl:call-template name="Area">
															<xsl:with-param name="suffix" select="'HS'"/>
														</xsl:call-template>
													</xsl:when>
													<!-- altrimenti creo semplicemente il collegamento testo immagine -->
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
															<!--<xsl:if test="$edition_level='facs'">
																<xsl:apply-templates select="current()" mode="facs"></xsl:apply-templates>
															</xsl:if>
															<xsl:if test="$edition_level='dipl'">
																<xsl:apply-templates select="current()" mode="dipl"></xsl:apply-templates>
															</xsl:if>-->
														</xsl:element>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise><!-- se in <zone> non ci sono le coordinate -->
										<xsl:copy-of select="current()" />
										<!--<xsl:if test="$edition_level='facs'">
											<xsl:apply-templates select="current()" mode="facs"></xsl:apply-templates>
										</xsl:if>
										<xsl:if test="$edition_level='dipl'">
											<xsl:apply-templates select="current()" mode="dipl"></xsl:apply-templates>
										</xsl:if>-->
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="not(self::tei:line) or self::tei:line[not (translate(@facs, '#', '')=//tei:zone/@xml:id)]">
								<xsl:copy-of select="current()" />
								<!--<xsl:if test="$edition_level='facs'">
									<xsl:apply-templates select="current()" mode="facs"></xsl:apply-templates>
								</xsl:if>
								<xsl:if test="$edition_level='dipl'">
									<xsl:apply-templates select="current()" mode="dipl"></xsl:apply-templates>
								</xsl:if>-->
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
				<xsl:value-of select="current-group()/tei:graphic/@width"/>
			</xsl:element>
			
			<xsl:for-each select="current-group()/tei:zone">
				<!-- EN: Creates a div for area annotations -->
				<!-- IT: Crea un div per area annotations -->
				<xsl:variable name="CurrClass"><xsl:value-of select="if(@rendition) then(@rendition) else ('Zone')"/></xsl:variable>
				<xsl:choose>
					<!-- se hotspot allora HS altrimenti quello che facciamo nel line-->
					<xsl:when test="($CurrClass='HotSpot')or(current()//tei:graphic)"><!-- se lo zone ha un figlio <graphic> viene trattato come HS -->
						<xsl:variable name="idL" select="if(@xml:id) then (@xml:id) else (generate-id())"/>
						<!-- IT: crea un div areaHS solo se esiste un div corrispondente alla zona corrente -->
						<xsl:if test="current()/tei:graphic/@url"><xsl:call-template name="embeddedHS"/></xsl:if><!-- se zone ha un figlio <graphic> devo richiamare il template embeddedHS -->
						<xsl:if test="(//tei:div[@type='hotspot']/tei:div/translate(@facs, '#', '')=$idL) or (current()//tei:graphic/@url)">
							<xsl:call-template name="Area">
								<xsl:with-param name="suffix" select="'HS'"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$CurrClass!=''">
						<!-- IT: Se <zone> non e' vuoto o se il suo attributo xml:id ha una corrispondenza nel @facs di un <line>
								viene creato un div AREA corrispondente alla zona corrente	-->					
						<xsl:if test="(current()[not((string-length(normalize-space()))= 0)])or(concat('#', @xml:id)=following-sibling::tei:line/@facs)">
							<xsl:call-template name="Area"></xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
				<!-- genero ora gli HS per gli elementi zone interni ad altri zone -->
				<xsl:for-each select="current()//tei:zone">
					<xsl:call-template name="embeddedHS"/>
					<!-- L'HS in questo caso viene generato solo se l'elemento ha figli o se ha un collegamento con un elemento esterno -->
					<!-- Il testo dei nodi figli o dell'elemento cui risulta collegato diventa il testo nel box dell'HS-->
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
					<xsl:attribute name="onclick">HideAnnHS('Ann_<xsl:value-of select="$linkId"></xsl:value-of>')</xsl:attribute>X</xsl:element>
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
