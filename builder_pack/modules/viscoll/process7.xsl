<?xml version="1.0" encoding="UTF-8"?>
<!-- TO DO:

* Only output one units folder (make sure the paths are the same for both single-page and multi-page views)
* Incorporate terms!

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="ss" version="2.0">
	<!--<xsl:output method="text"/><xsl:output method="html" indent="yes" name="html"/>-->
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p>
				<xd:b>Created on:</xd:b>July 2, 2014 </xd:p>
			<xd:p>
				<xd:b>Author:</xd:b> Dot Porter </xd:p>
			<xd:p>
				<xd:b>Modified on:</xd:b>April 29, 2016 </xd:p>
			<xd:p>
				<xd:b>Modified by:</xd:b> Dot Porter </xd:p>
			<xd:p>This document takes as its input the output from process6.xsl. It generates *
				several HTML files that make up a collation site for a manuscript. * a single HTML
				document (with -diagrams appended) containing diagrams for each quire. * a single
				HTML document containing digrams and bifolia view for the entire manuscript Note
				that although this document can handle quires containing up to 16 folios, the
				diagrams for quires with 14 and 16 folios will be cut off at the bottom.
				Congratulations! You are done! </xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="/" mode="viscoll7">
		<xsl:apply-templates mode="viscoll7"/>
	</xsl:template>
	<xsl:template match="manuscript" mode="viscoll7">
		<!-- Elemento manuscript con idno, msname, empty, msurl -->
		<xsl:variable name="idno" select="@idno"/>
		<xsl:variable name="msname" select="@msname"/>
		<xsl:variable name="empty"/>
		<xsl:variable name="msurl">
			<xsl:value-of select="@msURL"/>
		</xsl:variable>
		<xsl:for-each select="quire">
			<!-- Elemento quire con n, positions e filename con concatenzaione con CP-20-21-numeroQuire.html -->
			<xsl:variable name="quireNo" select="@n"/>
			<xsl:variable name="positions" select="@positions"/>
			<xsl:variable name="filename" select="concat($idno, '-', $quireNo, '.html')"/>
			<!-- Crea la variabile filename con valore CP-19_20_21_22.html -->
			<!-- Multiple HTML Files output below -->
			<!-- GM (modifica) Crea la cartella CP/quires con dentro i file CP-20.html, CP-21.html, ecc... -->
			<xsl:result-document method="html" encoding="UTF-8"
				href="{concat('../../../data/output_data/viscoll/',$idno,'/quires/',$filename)}"
				indent="yes">
				<html>
					<!--  -->
					<head>
						<title>Collation - Quire <xsl:value-of select="$quireNo"/>
						</title>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
						<!-- Add jQuery library -->
						<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/lib/jquery-1.10.1.min.js">x</script>
						<!-- Add fancyBox main JS and CSS files -->
						<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.js?v=2.1.5">x</script>
						<link rel="stylesheet" type="text/css"
							href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css?v=2.1.5"
							media="screen"/>
						<link
							href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css"
							rel="stylesheet" type="text/css"/>
						<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/iframescript.js">x</script>
						<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/collation.js">x</script>
						<link
							href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/css/collation.css"
							rel="stylesheet" type="text/css"/>
					</head>
					<body>
						<!-- this div is the same for all quires -->
						<div id="divtop">
							<span class="topheader">
								<a href="http://www.library.upenn.edu" target="_blank">
									<img
										src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/pennlogo.gif"
										width="28" height="27" style="align:left;" alt="UPenn"/>
								</a>Generated using the <xsl:text></xsl:text>
								<a href="http://www.schoenberginstitute.org" target="blank">
									<xsl:text></xsl:text>
									<xsl:text></xsl:text>Schoenberg Institute for Manuscript Studies </a>
								<a href="https://github.com/leoba/VisColl" target="blank"> Collation
									Modeler</a>
							</span>
						</div>
						<!-- This div will be the same for all quires -->
						<div id="listofquires">
							<span class="mstitle">
								<a href="{$msurl}" target="_blank">
									<xsl:value-of select="$msname"/>, <xsl:value-of select="$idno"/>
								</a>
							</span>
							<xsl:text></xsl:text>
							<xsl:text></xsl:text>
							<xsl:text></xsl:text>
							<xsl:text></xsl:text>
							<xsl:text></xsl:text>
							<xsl:text></xsl:text>
							<select name="quirelist" id="quirelist"
								onchange="MM_jumpMenu('parent',this,1)">
								<option>Select a Quire</option>
								<xsl:for-each select="parent::manuscript/quire">
									<xsl:element name="option">
										<xsl:attribute name="value">
											<xsl:value-of select="concat($idno, '-', @n, '.html')"/>
										</xsl:attribute> Quire <xsl:value-of select="@n"/> (
											<xsl:value-of select="@positions"/>) </xsl:element>
								</xsl:for-each>
							</select>
						</div>
						<br/> Quire <xsl:value-of select="$quireNo"/> ( <xsl:value-of
							select="$positions"/>) <xsl:text></xsl:text>
						<xsl:text></xsl:text>
						<xsl:for-each select="units/unit">
							<xsl:comment>
                                begin set
                            </xsl:comment>
							<!-- This sets up the pairs -->
							<!--Variables set for the left and right positions, inside-->
							<xsl:variable name="bi1" select="inside/left/@pos"/>
							<xsl:variable name="bi2" select="inside/right/@pos"/>
							<!--Variable setting the URL to the "X" image-->
							<xsl:variable name="imgX"
								>https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/x.jpg</xsl:variable>
							<!-- Variables grabbing the image URLs for all four sides in the unit -->
							<xsl:variable name="insideLeftImgTest" select="inside/left/@url"/>
							<xsl:variable name="insideRightImgTest" select="inside/right/@url"/>
							<xsl:variable name="outsideLeftImgTest" select="outside/left/@url"/>
							<xsl:variable name="outsideRightImgTest" select="outside/right/@url"/>
							<!-- Variables checking when image URLs are empty and mode is missing, and replacing them with X image if they are -->
							<xsl:variable name="insideLeftImg">
								<xsl:choose>
									<xsl:when test="$insideLeftImgTest = $empty">
										<xsl:if test="inside/left/@mode = 'missing'">
											<xsl:value-of select="$imgX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$insideLeftImgTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="insideRightImg">
								<xsl:choose>
									<xsl:when test="$insideRightImgTest = $empty">
										<xsl:if test="inside/right/@mode = 'missing'">
											<xsl:value-of select="$imgX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$insideRightImgTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="outsideLeftImg">
								<xsl:choose>
									<xsl:when test="$outsideLeftImgTest = $empty">
										<xsl:if test="outside/left/@mode = 'missing'">
											<xsl:value-of select="$imgX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$outsideLeftImgTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="outsideRightImg">
								<xsl:choose>
									<xsl:when test="$outsideRightImgTest = $empty">
										<xsl:if test="outside/right/@mode = 'missing'">
											<xsl:value-of select="$imgX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$outsideRightImgTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!-- Variable setting "X", to be used when another folio number is empty -->
							<xsl:variable name="folNoX">X</xsl:variable>
							<!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
							<xsl:variable name="insideLeftFolNoTest" select="inside/left/@folNo"/>
							<xsl:variable name="insideRightFolNoTest" select="inside/right/@folNo"/>
							<xsl:variable name="outsideLeftFolNoTest" select="outside/left/@folNo"/>
							<xsl:variable name="outsideRightFolNoTest" select="outside/right/@folNo"/>
							<!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
							<xsl:variable name="insideLeftFolNo">
								<xsl:choose>
									<xsl:when test="not($insideLeftFolNoTest)">
										<xsl:if test="inside/left/@mode = 'missing'">
											<xsl:value-of select="$folNoX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$insideLeftFolNoTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="insideRightFolNo">
								<xsl:choose>
									<xsl:when test="not($insideRightFolNoTest)">
										<xsl:if test="inside/right/@mode = 'missing'">
											<xsl:value-of select="$folNoX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$insideRightFolNoTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="outsideLeftFolNo">
								<xsl:choose>
									<xsl:when test="not($outsideLeftFolNoTest)">
										<xsl:if test="outside/left/@mode = 'missing'">
											<xsl:value-of select="$folNoX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$outsideLeftFolNoTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="outsideRightFolNo">
								<xsl:choose>
									<xsl:when test="not($outsideRightFolNoTest)">
										<xsl:if test="outside/right/@mode = 'missing'">
											<xsl:value-of select="$folNoX"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$outsideRightFolNoTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!-- Variables removing r and v from the folio numbers - used as a check in the next set (xsl:when below) -->
							<!-- For paginated manuscripts, we just use the page numbers as a check (xsl:otherwise) -->
							<xsl:variable name="leftFolTest">
								<xsl:choose>
									<xsl:when test="contains($insideLeftFolNo, 'r') or contains($insideLeftFolNo, 'v')">
										<xsl:value-of select="concat(substring-before($insideLeftFolNo, 'r'), substring-before($insideLeftFolNo, 'v'))" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$insideLeftFolNo"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="rightFolTest">
								<xsl:choose>
									<xsl:when test="contains($insideRightFolNo, 'r') or contains($insideRightFolNo, 'v')">
										<xsl:value-of select="concat(substring-before($insideRightFolNo, 'r'), substring-before($insideRightFolNo, 'v'))" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$insideRightFolNo"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
							<xsl:variable name="leftFol">
								<xsl:choose>
									<xsl:when test="not($leftFolTest)">
										<xsl:value-of select="$folNoX"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$leftFolTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="rightFol">
								<xsl:choose>
									<xsl:when test="not($rightFolTest)">
										<xsl:value-of select="$folNoX"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$rightFolTest"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="leftFolFileName">
								<xsl:choose>
									<xsl:when test="$leftFol = $folNoX">
										<xsl:value-of select="concat($folNoX, $quireNo, $bi1)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$leftFol"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="rightFolFileName">
								<xsl:choose>
									<xsl:when test="$rightFol = $folNoX">
										<xsl:value-of select="concat($folNoX, $quireNo, $bi2)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$rightFol"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="divsetNo" select="@n"/>
							<xsl:comment> If you would like to include the ability to show and hide quires, uncommend the code below </xsl:comment>
							<xsl:comment>
								<div class="bititles">Quire
									<xsl:value-of select="$quireNo"/>, Unit 
									<xsl:value-of select="$leftFol"/>, 
									<xsl:value-of select="$rightFol"/>
									<xsl:text></xsl:text>
									<xsl:text></xsl:text>
									<a href="#" onclick="MM_changeProp('divset{$divsetNo}','','height','auto','DIV')">
										<img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/open.gif" alt="Open" class="openimage"/>
									</a>
									<a href="#" onclick="MM_changeProp('divset{$divsetNo}','','height','0px','DIV')">
										<img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/close.gif" alt="Close" class="closeimage"/>
									</a>
								</div>
							</xsl:comment>
							<br/>
							<div>
								<xsl:attribute name="id">divset <xsl:value-of select="$divsetNo"/>
								</xsl:attribute>
								<div class="bif">
									<!-- L'attributo preserveAspectRatio prende due valori: il primo indica come la casella di visualizzazione (viewBox) è allineata nella finestra di visualizzazione (allinea la metà della casella di visualizzazione nella parte centrale della finestra di visualizzazione) mentre il secondo indica come deve essere conservato il rapporto di aspetto (conserva il rapporto di aspetto e scala la casella di visualizzazione (viewBox) per adattarsi alla finestra di visualizzazione) -->
									<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0" y="0" width="100mm" height="90mm"
										preserveAspectRatio="xMidYMid meet" style="background: #415a6c;" viewBox="0 0 100 90">
										<defs>
											<!-- Elemento contenitore per gli elementi di riferimento -->
											<filter id="f1" filterUnits="userSpaceOnUse">
												<!-- Definisce una regione sul canvas che applica un determinato effetto filtro e fornisce una risoluzione per tutte le immagini (l'attributo fedinisce il sistema di coordinata x, y, width e height: in questo caso è userSpaceOnUse cioè rappresenta i valori nel sistema di coordinate attualmente in vigore al momento in cui viene indicato il filtro -->
												<feGaussianBlur in="SourceGraphic" stdDeviation="1"/>
												<!-- Questo filtro primitivo esegue una sfocatura gaussiana sull'immagine di ingresso: in identifica l'input per filtro primitivo dato, cioè SourceGraphic che è una parola chiave che rappresenta gli elementi grafici che erano l'input originale nell'elemento filtro mentre stdDeviation è la deviazione per l'operazione di sfocatura. -->
											</filter>
										</defs>
										<desc>Collation diagram Quire <xsl:value-of select="$quireNo"/>
										</desc>
										<text x="20" y="5" class="bititle">Quire <xsl:value-of select="$quireNo"/>, 
											Unit <xsl:value-of select="$leftFol"/>, <xsl:value-of select="$rightFol"/>
										</text>
										<xsl:for-each select="ancestor::quire">
											<xsl:variable name="positions" select="@positions"/>
											<xsl:for-each select="1 to $positions">
												<!-- Per ogni positions (da 1 al valore di positions) -->
												<!--<text><xsl:attribute name="x">75</xsl:attribute><xsl:attribute name="class">nums</xsl:attribute><xsl:if test=".>($positions div 2)"><xsl:attribute name="y"><xsl:value-of select="11 + 6*."/></xsl:attribute><xsl:value-of select="."></xsl:value-of></xsl:if><xsl:if test=".&lt;=($positions div 2)"><xsl:attribute name="y"><xsl:value-of select="10 + 6*(.-1)"/></xsl:attribute><xsl:value-of select="."/></xsl:if></text>-->
												<xsl:if test=". = $bi1">
													<text class="labels" x="75">
														<xsl:attribute name="y">
															<xsl:value-of select="4 + 6 * ."/>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$insideLeftFolNo = $folNoX">
																<xsl:value-of select="$folNoX"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$leftFolTest"/>
															</xsl:otherwise>
														</xsl:choose>
													</text>
												</xsl:if>
												<xsl:if test=". = $bi2">
													<text class="labels" x="75">
														<xsl:attribute name="y">
															<xsl:value-of select="17 + 6 * (. - 1)"/>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$insideRightFolNo = $folNoX">
																<xsl:value-of select="$folNoX"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$rightFolTest"/>
															</xsl:otherwise>
														</xsl:choose>
													</text>
												</xsl:if>
											</xsl:for-each>
										</xsl:for-each>
										<svg x="0" y="0">
											<xsl:for-each select="parent::units">
												<xsl:variable name="positions" select="parent::quire/@positions"/>
												<xsl:for-each select="unit">
													<desc>Unit # <xsl:value-of select="@n"/></desc>
													<xsl:variable name="leftPos" select="inside/left/@pos"/>
													<xsl:variable name="rightPos" select="inside/right/@pos"/>
													<xsl:variable name="path1-left">
														<xsl:value-of select="9 + 6 * ($leftPos - 1)"/>
													</xsl:variable>
													<xsl:variable name="path1-right">
														<xsl:value-of select="9 + 6 * $rightPos"/>
													</xsl:variable>
													<xsl:variable name="count" select="$positions div 2"/>
													<xsl:variable name="max" select="$count * 6"/>
													<xsl:variable name="path2" select="$max - ($leftPos - 1) * 6"/>
													<xsl:variable name="path3">
														<xsl:if test="$count = 2">
															<xsl:value-of select="14 + ($leftPos - 1) * 6"/>
														</xsl:if>
														<xsl:if test="$count = 1 or $count = 4">
															<xsl:value-of select="5 + ($leftPos - 1) * 5"/>
														</xsl:if>
														<xsl:if test="$count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">
															<xsl:value-of select="19 + ($leftPos - 1) * 6"/>
														</xsl:if>
													</xsl:variable>
													<xsl:variable name="path4" select="15 + ($count - 1) * 6"/>
													<xsl:variable name="M-path1">
														<xsl:if test="$count = 1">M12</xsl:if>
														<xsl:if test="$count = 2">M24</xsl:if>
														<xsl:if test="$count = 3">M36</xsl:if>
														<xsl:if test="$count = 4">M26</xsl:if>
														<xsl:if test="$count = 5">M48</xsl:if>
														<xsl:if test="$count = 6">M54</xsl:if>
														<xsl:if test="$count = 7">M60</xsl:if>
														<xsl:if test="$count = 8">M66</xsl:if>
													</xsl:variable>
													<xsl:variable name="M-path2">
														<xsl:if test="$count = 1 or $count = 2 or $count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">M70</xsl:if>
														<xsl:if test="$count = 4 or $count = 7">M26</xsl:if>
													</xsl:variable>
													<xsl:variable name="L">
														<xsl:if test="$count = 1">L12</xsl:if>
														<xsl:if test="$count = 2">L24</xsl:if>
														<xsl:if test="$count = 3">L36</xsl:if>
														<xsl:if test="$count = 4">L60</xsl:if>
														<xsl:if test="$count = 5">L48</xsl:if>
														<xsl:if test="$count = 6">L54</xsl:if>
														<xsl:if test="$count = 7">L60</xsl:if>
														<xsl:if test="$count = 8">L66</xsl:if>
													</xsl:variable>
													<g>
														<g>
															<xsl:attribute name="class">
																<xsl:choose>
																	<xsl:when test="@n = $bi1">thisleaf</xsl:when>
																	<xsl:otherwise>leaf</xsl:otherwise>
																</xsl:choose>
																<xsl:if test="inside/left[not(@mode)]"> empty</xsl:if>
																<xsl:if test="inside/left[@mode = 'missing']"> missing</xsl:if>
																<xsl:if test="inside/left[@mode = 'added']"> added</xsl:if>
																<xsl:if test="inside/left[@mode = 'replaced']"> replaced</xsl:if>
															</xsl:attribute>
															<path stroke-linecap="round">
																<xsl:attribute name="d">
																	<xsl:value-of select="$M-path1"/>, 
																	<xsl:value-of select="$path1-left"/> A <xsl:value-of select="$path2"/>, 
																	<xsl:value-of select="$path2"/> 0 0,0 <xsl:value-of select="$path3"/>, 
																	<xsl:value-of select="$path4"/>
																</xsl:attribute>
															</path>
															<path>
																<xsl:attribute name="d"> <xsl:value-of select="$M-path2"/>, 
																	<xsl:value-of select="$path1-left"/>
																	<xsl:text></xsl:text>
																	<xsl:value-of select="$L"/>, 
																	<xsl:value-of select="$path1-left"/>
																</xsl:attribute>
															</path>
														</g>
														<g>
															<xsl:attribute name="class">
																<xsl:choose>
																	<xsl:when test="@n = $bi1">thisleaf</xsl:when>
																	<xsl:otherwise>leaf</xsl:otherwise>
																</xsl:choose>
																<xsl:if test="inside/right[not(@mode)]"> empty</xsl:if>
																<xsl:if test="inside/right[@mode = 'missing']"> missing</xsl:if>
																<xsl:if test="inside/right[@mode = 'added']"> added</xsl:if>
																<xsl:if test="inside/right[@mode = 'replaced']"> replaced</xsl:if>
															</xsl:attribute>
															<path stroke-linecap="round">
																<xsl:attribute name="d">
																	<xsl:value-of select="$M-path1"/>, 
																	<xsl:value-of select="$path1-right"/> A <xsl:value-of select="$path2"/>, 
																	<xsl:value-of select="$path2"/> 0 0,1 <xsl:value-of select="$path3"/>,
																	<xsl:value-of select="$path4"/>
																</xsl:attribute>
															</path>
															<path>
																<xsl:attribute name="d">
																	<xsl:value-of select="$M-path2"/>, 
																	<xsl:value-of select="$path1-right"/>
																	<xsl:text></xsl:text>
																	<xsl:value-of select="$L"/>, 
																	<xsl:value-of select="$path1-right"/>
																</xsl:attribute>
															</path>
														</g>
													</g>
												</xsl:for-each>
											</xsl:for-each>
										</svg>
									</svg>
								</div>
								<div class="img1">
									<a class="fancybox fancybox.iframe" rel="set{@n}"
										title="(Quire {$quireNo}, Unit {$leftFol}.{$rightFol}, inside)"
										href="../units/{$leftFolFileName}_{$rightFolFileName}_i.html">
										<xsl:choose>
											<xsl:when test="contains($insideLeftImg, '.')">
												<xsl:call-template name="imgElement">
													<xsl:with-param name="imgHeight" select="225"/>
													<xsl:with-param name="altValue" select="$insideLeftFolNo"/>
													<xsl:with-param name="dataPage" select="$insideLeftImg"/>
													<xsl:with-param name="initialUrl" select="$insideLeftImg"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="contains($insideRightImg, '.')">
												<xsl:call-template name="imgElement">
													<xsl:with-param name="imgHeight" select="225"/>
													<xsl:with-param name="altValue" select="$insideRightFolNo"/>
													<xsl:with-param name="dataPage" select="$insideRightImg"/>
													<xsl:with-param name="initialUrl" select="$insideRightImg"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</a>
									<br/>
									<span class="fol-num num-left"><xsl:value-of select="$insideLeftFolNo"/></span>
									<xsl:if test="contains($insideRightImg, '.') and contains($insideLeftImg, '.')">
										<span class="spacer"> <xsl:text></xsl:text> </span>
									</xsl:if>
									<span class="fol-num num-right"><xsl:value-of select="$insideRightFolNo"/></span>
								</div>
								<div class="img2">
									<a class="fancybox fancybox.iframe" rel="set{@n}"
										title="(Quire {$quireNo}, Unit {$leftFol}.{$rightFol}, outside)"
										href="../units/{$leftFolFileName}_{$rightFolFileName}_o.html">
										<xsl:if test="contains($outsideLeftImg, '.')">
											<xsl:call-template name="imgElement">
												<xsl:with-param name="imgHeight" select="225"/>
												<xsl:with-param name="altValue" select="$outsideLeftFolNo"/>
												<xsl:with-param name="dataPage" select="$outsideLeftImg"/>
												<xsl:with-param name="initialUrl" select="$outsideLeftImg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="contains($outsideRightImg, '.')">
											<xsl:call-template name="imgElement">
												<xsl:with-param name="imgHeight" select="225"/>
												<xsl:with-param name="altValue" select="$outsideRightFolNo"/>
												<xsl:with-param name="dataPage" select="$outsideRightImg"/>
												<xsl:with-param name="initialUrl" select="$outsideRightImg"/>
											</xsl:call-template>
										</xsl:if>
									</a>
									<br/>
									<span class="fol-num num-left"><xsl:value-of select="$outsideLeftFolNo"/></span>
									<xsl:if test="contains($outsideLeftImg, '.') and contains($outsideRightImg, '.')">
										<span class="spacer"> <xsl:text></xsl:text> </span>
									</xsl:if>
									<span class="fol-num num-right"><xsl:value-of select="$outsideRightFolNo"/></span>
								</div>
							</div>
						</xsl:for-each>
					</body>
				</html>
			</xsl:result-document>
		</xsl:for-each>
		<!--Diagram HTML output below-->
		<!-- GM -->
		<xsl:variable name="filename-diagrams" select="concat('../../../../data/output_data/viscoll/', $idno, '/', $idno, '-diagrams.html')"/>
		<xsl:result-document method="html" encoding="UTF-8" href="{concat($idno,'/',$filename-diagrams)}" indent="yes">
			<!--<xsl:result-document href="{concat($idno,'/',$filename-diagrams)}" format="html">-->
			<html xmlns="http://www.w3.org/1999/xhtml">
				<!--  -->
				<head>
					<title>Quires - Quire <xsl:value-of select="$msname"/>
					</title>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/lib/jquery-1.10.1.min.js">x</script>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.js?v=2.1.5">x</script>
					<link rel="stylesheet" type="text/css"
						href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css?v=2.1.5"
						media="screen"/>
					<link href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css" rel="stylesheet" type="text/css"/>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/iframescript.js">x</script>
					<link href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/css/collation.css" rel="stylesheet" type="text/css"/>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/querys.js">x</script>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/collation.js">x</script>
				</head>
				<body>
					<!-- this div is the same for all quires -->
					<div id="divtop">
						<span class="topheader">
							<a href="http://www.library.upenn.edu" target="_blank">
								<img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/pennlogo.gif" width="28" height="27" style="align:left;" alt="UPenn"/>
							</a>Generated using the <xsl:text></xsl:text>
							<a href="http://www.schoenberginstitute.org" target="blank">
								<xsl:text></xsl:text>
								<xsl:text></xsl:text>Schoenberg Institute for Manuscript Studies 
							</a>
							<a href="https://github.com/leoba/VisColl" target="blank"> Collation Modeler</a>
						</span>
					</div>
					<div id="listofquires">
						<span class="mstitle">
							<a target="_blank" href="{$msurl}">
								Collation diagrams for <xsl:value-of select="$msname"/>, <xsl:value-of select="$idno"/>
							</a>
						</span>
					</div>
					<br/>
					<span class="helptext">Select a unit to display/hide, or </span>
					<br/>
					<span class="quires_toggler mainButtons" data-status="expanded">
						<span lang="def">HIDE_ALL_QUIRES</span>
					</span>
					<xsl:for-each select="quire">
						<xsl:variable name="quireNo" select="@n"/>
						<xsl:variable name="positions" select="@positions"/>
						<!-- Here we get one div class newquire, and then a quireset with three divs - one svg and two images (img1 and img2) -->
						<xsl:comment>
                            begin set
                        </xsl:comment>
						<!-- This sets up the pairs -->
						<!--Variables set for the left and right positions, inside-->
						<xsl:variable name="bi1" select="inside/left/@pos"/>
						<xsl:variable name="bi2" select="inside/right/@pos"/>
						<!-- Variable setting "X", to be used when another folio number is empty -->
						<xsl:variable name="folNoX">X</xsl:variable>
						<!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
						<xsl:variable name="insideLeftFolNoTest"
							select="units/unit[@n = '1']/inside/left/@folNo"/>
						<xsl:variable name="insideRightFolNoTest"
							select="units/unit[@n = '1']/inside/right/@folNo"/>
						<xsl:variable name="outsideLeftFolNoTest"
							select="units/unit[@n = '1']/outside/left/@folNo"/>
						<xsl:variable name="outsideRightFolNoTest"
							select="units/unit[@n = '1']/outside/right/@folNo"/>
						<!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
						<xsl:variable name="insideLeftFolNo">
							<xsl:choose>
								<xsl:when test="not($insideLeftFolNoTest)">
									<xsl:if test="inside/left/@mode = 'missing'">
										<xsl:value-of select="$folNoX"/>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$insideLeftFolNoTest"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="insideRightFolNo">
							<xsl:choose>
								<xsl:when test="not($insideRightFolNoTest)">
									<xsl:if test="inside/right/@mode = 'missing'">
										<xsl:value-of select="$folNoX"/>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$insideRightFolNoTest"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="outsideLeftFolNo">
							<xsl:choose>
								<xsl:when test="not($outsideLeftFolNoTest)">
									<xsl:if test="outside/left/@mode = 'missing'">
										<xsl:value-of select="$folNoX"/>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$outsideLeftFolNoTest"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="outsideRightFolNo">
							<xsl:choose>
								<xsl:when test="not($outsideRightFolNoTest)">
									<xsl:if test="outside/right/@mode = 'missing'">
										<xsl:value-of select="$folNoX"/>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$outsideRightFolNoTest"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!-- Variables removing r and v from the folio numbers - used as a check in the next set (xsl:when below) -->
						<!-- For paginated manuscripts, we just use the page numbers as a check (xsl:otherwise) -->
						<xsl:variable name="leftFolTest">
							<xsl:choose>
								<xsl:when test="contains($insideLeftFolNo, 'r') or contains($insideLeftFolNo, 'v')">
									<xsl:value-of select="concat(substring-before($insideLeftFolNo, 'r'), substring-before($insideLeftFolNo, 'v'))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$insideLeftFolNo"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="rightFolTest">
							<xsl:choose>
								<xsl:when test="contains($insideRightFolNo, 'r') or contains($insideRightFolNo, 'v')">
									<xsl:value-of select="concat(substring-before($insideRightFolNo, 'r'), substring-before($insideRightFolNo, 'v'))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$insideRightFolNo"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
						<xsl:variable name="leftFol">
							<xsl:choose>
								<xsl:when test="not($leftFolTest)">
									<xsl:value-of select="$folNoX"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$leftFolTest"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="rightFol">
							<xsl:choose>
								<xsl:when test="not($rightFolTest)">
									<xsl:value-of select="$folNoX"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$rightFolTest"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<div class="newquire">
							<span class="bititles">
								<a href="javascript:void(0);">
									Quire <xsl:value-of select="$quireNo" />
								</a>
							</span>
						</div>
						<div class="quireset">
							<div class="bif">
								<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0" 
									y="0" width="100mm" height="90mm" preserveAspectRatio="xMidYMid meet" style="background: #415a6c;" viewBox="0 0 100 90">
									<defs>
										<filter id="f1" filterUnits="userSpaceOnUse">
											<feGaussianBlur in="SourceGraphic" stdDeviation="1"/>
										</filter>
									</defs>
									<desc>Collation diagram Quire <xsl:value-of select="$quireNo"/> </desc>
									<text x="20" y="5" class="bititle">Quire <xsl:value-of select="$quireNo"/></text>
									<svg x="0" y="0">
										<xsl:for-each select="units">
											<xsl:variable name="positions" select="parent::quire/@positions"/>
											<xsl:for-each select="unit">
												<desc>Unit # <xsl:value-of select="@n"/> </desc>
												<xsl:variable name="leftPos" select="inside/left/@pos"/>
												<xsl:variable name="rightPos" select="inside/right/@pos"/>
												<xsl:variable name="path1-left">
													<xsl:value-of select="9 + 6 * ($leftPos - 1)"/>
												</xsl:variable>
												<xsl:variable name="path1-right">
													<xsl:value-of select="9 + 6 * $rightPos"/>
												</xsl:variable>
												<!-- page/folio numbers for first and last leaves in a quire -->
												<xsl:if test="@n = '1'">
													<!--<xsl:if test=". = $bi1">-->
													<text class="labels" x="75">
														<xsl:attribute name="y">
															<xsl:value-of select="$path1-left + 1"/>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$insideLeftFolNo = $folNoX">
																<xsl:value-of select="$folNoX"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$leftFolTest"/>
															</xsl:otherwise>
														</xsl:choose>
													</text>
													<!--</xsl:if>-->
													<!--<xsl:if test=". = $bi2">-->
													<text class="labels" x="75">
														<xsl:attribute name="y">
															<xsl:value-of select="$path1-right + 1"/>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$insideRightFolNo = $folNoX">
																<xsl:value-of select="$folNoX"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$rightFolTest"/>
															</xsl:otherwise>
														</xsl:choose>
													</text>
													<!--</xsl:if>-->
												</xsl:if>
												<xsl:variable name="count" select="$positions div 2"/>
												<xsl:variable name="max" select="$count * 6"/>
												<xsl:variable name="path2" select="$max - ($leftPos - 1) * 6"/>
												<xsl:variable name="path3">
													<xsl:if test="$count = 2">
														<xsl:value-of select="14 + ($leftPos - 1) * 6"/>
													</xsl:if>
													<xsl:if test="$count = 1 or $count = 4">
														<xsl:value-of select="5 + ($leftPos - 1) * 5"/>
													</xsl:if>
													<xsl:if test="$count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">
														<xsl:value-of select="19 + ($leftPos - 1) * 6"/>
													</xsl:if>
												</xsl:variable>
												<xsl:variable name="path4" select="15 + ($count - 1) * 6"/>
												<xsl:variable name="M-path1">
													<xsl:if test="$count = 1">M12</xsl:if>
													<xsl:if test="$count = 2">M24</xsl:if>
													<xsl:if test="$count = 3">M36</xsl:if>
													<xsl:if test="$count = 4">M26</xsl:if>
													<xsl:if test="$count = 5">M48</xsl:if>
													<xsl:if test="$count = 6">M54</xsl:if>
													<xsl:if test="$count = 7">M60</xsl:if>
													<xsl:if test="$count = 8">M66</xsl:if>
												</xsl:variable>
												<xsl:variable name="M-path2">
													<xsl:if test="$count = 1 or $count = 2 or $count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">M70</xsl:if>
													<xsl:if test="$count = 4 or $count = 7">M26</xsl:if>
												</xsl:variable>
												<xsl:variable name="L">
													<xsl:if test="$count = 1">L12</xsl:if>
													<xsl:if test="$count = 2">L24</xsl:if>
													<xsl:if test="$count = 3">L36</xsl:if>
													<xsl:if test="$count = 4">L60</xsl:if>
													<xsl:if test="$count = 5">L48</xsl:if>
													<xsl:if test="$count = 6">L54</xsl:if>
													<xsl:if test="$count = 7">L60</xsl:if>
													<xsl:if test="$count = 8">L66</xsl:if>
												</xsl:variable>
												<g>
													<g>
														<xsl:attribute name="class">leaf 
															<xsl:if test="inside/left[not(@mode)]"> empty</xsl:if>
															<xsl:if test="inside/left[@mode = 'missing']"> missing</xsl:if>
															<xsl:if test="inside/left[@mode = 'added']"> added</xsl:if>
															<xsl:if test="inside/left[@mode = 'replaced']"> replaced</xsl:if>
														</xsl:attribute>
														<path stroke-linecap="round">
															<xsl:attribute name="d">
																<xsl:value-of select="$M-path1"/>, 
																<xsl:value-of select="$path1-left"/> A <xsl:value-of select="$path2"/>, 
																<xsl:value-of select="$path2"/>0 0,0 <xsl:value-of select="$path3"/>,
																<xsl:value-of select="$path4"/>
															</xsl:attribute>
														</path>
														<path>
															<xsl:attribute name="d">
															<xsl:value-of select="$M-path2"/>, 
																<xsl:value-of select="$path1-left"/>
																<xsl:text></xsl:text>
																<xsl:value-of select="$L"/>, 
																<xsl:value-of select="$path1-left"/>
															</xsl:attribute>
														</path>
													</g>
													<g>
														<xsl:attribute name="class">leaf 
															<xsl:if test="inside/right[not(@mode)]"> empty</xsl:if>
															<xsl:if test="inside/right[@mode = 'missing']"> missing</xsl:if>
															<xsl:if test="inside/right[@mode = 'added']"> added</xsl:if>
															<xsl:if test="inside/right[@mode = 'replaced']"> replaced</xsl:if>
														</xsl:attribute>
														<path stroke-linecap="round">
															<xsl:attribute name="d">
															<xsl:value-of select="$M-path1"/>, 
															<xsl:value-of select="$path1-right"/> A <xsl:value-of select="$path2"/>, 
															<xsl:value-of select="$path2"/> 0 0,1 <xsl:value-of select="$path3"/>,
															<xsl:value-of select="$path4"/>
														</xsl:attribute>
														</path>
														<path>
															<xsl:attribute name="d">
																<xsl:value-of select="$M-path2"/>, 
																<xsl:value-of select="$path1-right"/>
																<xsl:text></xsl:text>
																<xsl:value-of select="$L"/>, 
																<xsl:value-of select="$path1-right"/>
															</xsl:attribute>
														</path>
													</g>
												</g>
											</xsl:for-each>
										</xsl:for-each>
									</svg>
								</svg>
							</div>
						</div>
					</xsl:for-each>
				</body>
			</html>
		</xsl:result-document>
		<!--One single page for all bifolia output below -->
		<!-- GM -->
		<xsl:variable name="filename" select="concat($idno, '.html')"/>
		<xsl:result-document method="html" encoding="UTF-8" href="{concat('../../../data/output_data/viscoll/',$idno,'/',$filename)}" indent="yes">
			<!-- NEEDS DOCTYPE TO WORK: 
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> -->
			<xsl:comment>&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;</xsl:comment>
			<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
				<!--  -->
				<head>
					<title>Quires - Quire <xsl:value-of select="$msname"/></title>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					<!-- Non è più data/output_data/viscoll/support/ ma ./../viscoll/support/... con <iframe> -->
					<script type="text/javascript" src="../../../../js/plugin/support_viscoll/jquery-1.10.1.min.js"/>
					<script type="text/javascript" src="../../../../js/plugin/support_viscoll/jquery.fancybox.js?v=2.1.5"/>
					<link rel="stylesheet" type="text/css"
						href="../../../../js/plugin/support_viscoll/jquery.fancybox.css?v=2.1.5"
						media="screen"/>
					<link href="../../../../js/plugin/support_viscoll/jquery.fancybox.css"
						rel="stylesheet" type="text/css"/>
					<!--<script type="text/javascript" src="../../../../js/plugin/support_viscoll/iframescript.js">x</script>-->
					<link href="../../../../js/plugin/support_viscoll/collation.css"
						rel="stylesheet" type="text/css"/>
					<script type="text/javascript" src="../../../../js/plugin/support_viscoll/querys.js"/>
					<script type="text/javascript" src="../../../../js/plugin/support_viscoll/collation.js"/>
					<!--<link href="css/collation.css" rel="stylesheet" type="text/css"></link>-->
				</head>
				<body>
					<div id="quires_cont">
						<!-- Tolto href="{$msurl} da <a target... -->
						<div id="listofquires">
							<span class="mstitle">
								<a target="_blank">Collation diagrams for <xsl:value-of select="$msname"/>, <xsl:value-of select="$idno"/></a>
							</span>
						</div>
						<!--<span class="helptext">Select a Quire to display/hide, or </span><br/>-->
						<span class="quires_toggler mainButtons" data-status="expanded">
							<span lang="def">HIDE_ALL_QUIRES</span>
						</span>

						<xsl:for-each select="quire">
							<xsl:variable name="quireNo" select="@n"/>
							<xsl:variable name="positions" select="@positions"/>
							<!-- Here we get one div class newquire, and then a quireset with three divs - one svg and two images (img1 and img2) -->
							<xsl:for-each select="units/unit">
								<xsl:comment>
	                                begin set
	                            </xsl:comment>
								<!-- This sets up the pairs -->
								<!--Variables set for the left and right positions, inside-->
								<xsl:variable name="bi1" select="inside/left/@pos"/>
								<xsl:variable name="bi2" select="inside/right/@pos"/>
								<!--Variable setting the URL to the "X" image-->
								<xsl:variable name="imgX">https://cdn.rawgit.com/leoba/VisColl/master/data/support/images/x.jpg</xsl:variable>
								<!-- Variables grabbing the image URLs for all four sides in the unit -->
								<xsl:variable name="insideLeftImgTest" select="inside/left/@url"/>
								<xsl:variable name="insideRightImgTest" select="inside/right/@url"/>
								<xsl:variable name="outsideLeftImgTest" select="outside/left/@url"/>
								<xsl:variable name="outsideRightImgTest" select="outside/right/@url"/>
								<!-- Variables checking when image URLs are empty and mode is missing, and replacing them with X image if they are -->
								<xsl:variable name="insideLeftImg">
									<xsl:choose>
										<xsl:when test="$insideLeftImgTest = $empty">
											<xsl:if test="inside/left/@mode = 'missing'">
												<xsl:value-of select="$imgX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$insideLeftImgTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="insideRightImg">
									<xsl:choose>
										<xsl:when test="$insideRightImgTest = $empty">
											<xsl:if test="inside/right/@mode = 'missing'">
												<xsl:value-of select="$imgX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$insideRightImgTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="outsideLeftImg">
									<xsl:choose>
										<xsl:when test="$outsideLeftImgTest = $empty">
											<xsl:if test="outside/left/@mode = 'missing'">
												<xsl:value-of select="$imgX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$outsideLeftImgTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="outsideRightImg">
									<xsl:choose>
										<xsl:when test="$outsideRightImgTest = $empty">
											<xsl:if test="outside/right/@mode = 'missing'">
												<xsl:value-of select="$imgX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$outsideRightImgTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- Variable setting "X", to be used when another folio number is empty -->
								<xsl:variable name="folNoX">X</xsl:variable>
								<!-- Variables setting the folio numbers (including r and v), used as checks in the next bunch of variables -->
								<xsl:variable name="insideLeftFolNoTest" select="inside/left/@folNo"/>
								<xsl:variable name="insideRightFolNoTest" select="inside/right/@folNo"/>
								<xsl:variable name="outsideLeftFolNoTest" select="outside/left/@folNo"/>
								<xsl:variable name="outsideRightFolNoTest" select="outside/right/@folNo"/>
								<!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
								<xsl:variable name="insideLeftFolNo">
									<xsl:choose>
										<xsl:when test="not($insideLeftFolNoTest)"/>
										<xsl:when test="$insideLeftFolNoTest[not(string())]">
											<xsl:if test="inside/left/@mode = 'missing'">
												<xsl:value-of select="$folNoX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$insideLeftFolNoTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="insideRightFolNo">
									<xsl:choose>
										<xsl:when test="not($insideRightFolNoTest)"/>
										<xsl:when test="$insideRightFolNoTest[not(string())]">
											<xsl:if test="inside/right/@mode = 'missing'">
												<xsl:value-of select="$folNoX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$insideRightFolNoTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="outsideLeftFolNo">
									<xsl:choose>
										<xsl:when test="not($outsideLeftFolNoTest)"/>
										<xsl:when test="$outsideLeftFolNoTest[not(string())]">
											<xsl:if test="outside/left/@mode = 'missing'">
												<xsl:value-of select="$folNoX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$outsideLeftFolNoTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="outsideRightFolNo">
									<xsl:choose>
										<xsl:when test="not($outsideRightFolNoTest)"/>
										<xsl:when test="$outsideRightFolNoTest[not(string())]">
											<xsl:if test="outside/right/@mode = 'missing'">
												<xsl:value-of select="$folNoX"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$outsideRightFolNoTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- Variables removing r and v from the folio numbers - used as a check in the next set (xsl:when below) -->
								<!-- For paginated manuscripts, we just use the page numbers as a check (xsl:otherwise) -->
								<xsl:variable name="leftFolTest">
									<xsl:choose>
										<xsl:when test="contains($insideLeftFolNo, 'r') or contains($insideLeftFolNo, 'v')">
											<xsl:value-of select="concat(substring-before($insideLeftFolNo, 'r'), substring-before($insideLeftFolNo, 'v'))"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$insideLeftFolNo"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="rightFolTest">
									<xsl:choose>
										<xsl:when test="contains($insideRightFolNo, 'r') or contains($insideRightFolNo, 'v')">
											<xsl:value-of select="concat(substring-before($insideRightFolNo, 'r'), substring-before($insideRightFolNo, 'v'))"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$insideRightFolNo"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- Variables checking when folio number variables are empty, and replacing them with X if they are -->
								<xsl:variable name="leftFol">
									<xsl:choose>
										<xsl:when test="not($leftFolTest)">
											<xsl:value-of select="$folNoX"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$leftFolTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="rightFol">
									<xsl:choose>
										<xsl:when test="not($rightFolTest)">
											<xsl:value-of select="$folNoX"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$rightFolTest"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="leftFolFileName">
									<xsl:choose>
										<xsl:when test="$leftFol = $folNoX">
											<xsl:value-of select="concat($folNoX, $quireNo, $bi1)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$leftFol"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="rightFolFileName">
									<xsl:choose>
										<xsl:when test="$rightFol = $folNoX">
											<xsl:value-of select="concat($folNoX, $quireNo, $bi2)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$rightFol"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<div class="newquire">
									<span class="bititles">
										<a href="javascript:void(0);">
											Quire <xsl:value-of select="$quireNo"/>, 
											Unit <xsl:value-of select="$leftFol"/>, 
											<xsl:value-of select="$rightFol"/>
										</a>
									</span>
								</div>
								<div class="quireset">
									<div class="bif">
										<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1"
											x="0" y="0" width="39mm" height="42.3mm" preserveAspectRatio="xMidYMid meet" style="background: #415a6c;" viewBox="0 -3 110 90">
											<!-- GM: modificata height da 100 a 42.3, width da 90 a 39 e la viewBox da 0 0 100 90 a 0 -3 110 90-->
											<defs>
												<filter id="f1" filterUnits="userSpaceOnUse">
													<feGaussianBlur in="SourceGraphic" stdDeviation="1"/>
												</filter>
											</defs>
											<desc>Collation diagram Quire <xsl:value-of select="$quireNo"/>
											</desc>
											<text x="8" y="0" class="bititle">
												Quire <xsl:value-of select="$quireNo"/>, 
												Unit <xsl:value-of select="$leftFol"/>, 
												<xsl:value-of select="$rightFol"/>
											</text>
											<!-- Modificata la x da 20 a 8 e la y da 5 a 0 -->
											<xsl:for-each select="ancestor::quire">
												<xsl:variable name="positions" select="@positions"/>
												<xsl:for-each select="1 to $positions">
													<!--<text><xsl:attribute name="x">75</xsl:attribute><xsl:attribute name="class">nums</xsl:attribute><xsl:if test=".>($positions div 2)"><xsl:attribute name="y"><xsl:value-of select="11 + 6*."/></xsl:attribute><xsl:value-of select="."></xsl:value-of></xsl:if><xsl:if test=".&lt;=($positions div 2)"><xsl:attribute name="y"><xsl:value-of select="10 + 6*(.-1)"/></xsl:attribute><xsl:value-of select="."/></xsl:if></text>-->
													<xsl:if test=". = $bi1">
														<text class="labels" x="75">
															<xsl:attribute name="y">
																<xsl:value-of select="4 + 6 * ."/>
															</xsl:attribute>
															<xsl:choose>
																<xsl:when test="$insideLeftFolNo = $folNoX">
																	<xsl:value-of select="$folNoX"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$leftFolTest"/>
																</xsl:otherwise>
															</xsl:choose>
														</text>
													</xsl:if>
													<xsl:if test=". = $bi2">
														<text class="labels" x="75">
															<xsl:attribute name="y">
																<xsl:value-of select="17 + 6 * (. - 1)"/>
															</xsl:attribute>
															<xsl:choose>
																<xsl:when test="$insideRightFolNo = $folNoX">
																	<xsl:value-of select="$folNoX"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$rightFolTest"/>
																</xsl:otherwise>
															</xsl:choose>
														</text>
													</xsl:if>
												</xsl:for-each>
											</xsl:for-each>
											<svg x="0" y="0">
												<xsl:for-each select="parent::units">
													<xsl:variable name="positions" select="parent::quire/@positions"/>
													<xsl:for-each select="unit">
														<desc>Unit # <xsl:value-of select="@n"/> </desc>
														<xsl:variable name="leftPos" select="inside/left/@pos"/>
														<xsl:variable name="rightPos" select="inside/right/@pos"/>
														<xsl:variable name="path1-left">
															<xsl:value-of select="9 + 6 * ($leftPos - 1)"/>
														</xsl:variable>
														<xsl:variable name="path1-right">
															<xsl:value-of select="9 + 6 * $rightPos"/>
														</xsl:variable>
														<xsl:variable name="count" select="$positions div 2"/>
														<xsl:variable name="max" select="$count * 6"/>
														<xsl:variable name="path2" select="$max - ($leftPos - 1) * 6"/>
														<xsl:variable name="path3">
															<xsl:if test="$count = 2">
																<xsl:value-of select="14 + ($leftPos - 1) * 6"/>
															</xsl:if>
															<xsl:if test="$count = 1 or $count = 4">
																<xsl:value-of select="5 + ($leftPos - 1) * 5"/>
															</xsl:if>
															<xsl:if test="$count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">
																<xsl:value-of select="19 + ($leftPos - 1) * 6"/>
															</xsl:if>
														</xsl:variable>
														<xsl:variable name="path4" select="15 + ($count - 1) * 6"/>
														<xsl:variable name="M-path1">
															<xsl:if test="$count = 1">M12</xsl:if>
															<xsl:if test="$count = 2">M24</xsl:if>
															<xsl:if test="$count = 3">M36</xsl:if>
															<xsl:if test="$count = 4">M26</xsl:if>
															<xsl:if test="$count = 5">M48</xsl:if>
															<xsl:if test="$count = 6">M54</xsl:if>
															<xsl:if test="$count = 7">M60</xsl:if>
															<xsl:if test="$count = 8">M66</xsl:if>
														</xsl:variable>
														<xsl:variable name="M-path2">
															<xsl:if test="$count = 1 or $count = 2 or $count = 3 or $count = 5 or $count = 6 or $count = 7 or $count = 8">M70</xsl:if>
															<xsl:if test="$count = 4 or $count = 7">M26</xsl:if>
														</xsl:variable>
														<xsl:variable name="L">
															<xsl:if test="$count = 1">L12</xsl:if>
															<xsl:if test="$count = 2">L24</xsl:if>
															<xsl:if test="$count = 3">L36</xsl:if>
															<xsl:if test="$count = 4">L60</xsl:if>
															<xsl:if test="$count = 5">L48</xsl:if>
															<xsl:if test="$count = 6">L54</xsl:if>
															<xsl:if test="$count = 7">L60</xsl:if>
															<xsl:if test="$count = 8">L66</xsl:if>
														</xsl:variable>
														<g>
															<g>
																<xsl:attribute name="class">
																<xsl:choose>
																	<xsl:when test="@n = $bi1">thisleaf</xsl:when>
																	<xsl:otherwise>leaf</xsl:otherwise>
																</xsl:choose>
																<xsl:if test="inside/left[not(@mode)]"> empty</xsl:if>
																<xsl:if test="inside/left[@mode = 'missing']"> missing</xsl:if>
																<xsl:if test="inside/left[@mode = 'added']"> added</xsl:if>
																<xsl:if test="inside/left[@mode = 'replaced']"> replaced</xsl:if>
																</xsl:attribute>
																<path stroke-linecap="round">
																	<xsl:attribute name="d">
																		<xsl:value-of select="$M-path1"/>, 
																		<xsl:value-of select="$path1-left"/> A <xsl:value-of select="$path2"/>, 
																		<xsl:value-of select="$path2"/> 0 0,0 <xsl:value-of select="$path3"/>,
																		<xsl:value-of select="$path4"/>
																	</xsl:attribute>
																</path>
																<path>
																	<xsl:attribute name="d">
																		<xsl:value-of select="$M-path2"/>, 
																		<xsl:value-of select="$path1-left"/>
																		<xsl:text></xsl:text>
																		<xsl:value-of select="$L"/>, 
																		<xsl:value-of select="$path1-left"/>
																	</xsl:attribute>
																</path>
															</g>
															<g>
																<xsl:attribute name="class">
																	<xsl:choose>
																		<xsl:when test="@n=$bi1">thisleaf</xsl:when>
																		<xsl:otherwise>leaf</xsl:otherwise>
																	</xsl:choose>
																	<xsl:if test="inside/right[not(@mode)]"> empty</xsl:if>
																	<xsl:if test="inside/right[@mode = 'missing']"> missing</xsl:if>
																	<xsl:if test="inside/right[@mode = 'added']"> added</xsl:if>
																	<xsl:if test="inside/right[@mode = 'replaced']"> replaced</xsl:if>
																</xsl:attribute>
																<path stroke-linecap="round">
																	<xsl:attribute name="d">
																		<xsl:value-of select="$M-path1"/>, 
																		<xsl:value-of select="$path1-right"/> A <xsl:value-of select="$path2"/>, 
																		<xsl:value-of select="$path2"/> 0 0,1 <xsl:value-of select="$path3"/>,
																		<xsl:value-of select="$path4"/>
																	</xsl:attribute>
																</path>
																<path>
																	<xsl:attribute name="d">
																	<xsl:value-of select="$M-path2"/>, 
																		<xsl:value-of select="$path1-right"/>
																		<xsl:text></xsl:text>
																		<xsl:value-of select="$L"/>, 
																		<xsl:value-of select="$path1-right"/>
																	</xsl:attribute>
																</path>
															</g>
														</g>
													</xsl:for-each>
												</xsl:for-each>
											</svg>
										</svg>
									</div>
									<xsl:variable name="emptyImage1" select="'true'"/>
									<!-- GM: caso in cui l'utente ha inserito più fogli ma non ci sono le immagini -->
									<xsl:variable name="emptyImage2" select="'true'"/>
									<div class="img1">
										<!-- GM -->
										<a class="fancybox fancybox.iframe" rel="set{$quireNo}.{@n}"
											title="(Quire {$quireNo}, Unit {$leftFol}.{$rightFol}, inside)">
											<!-- Ho tolto href -->
											<!-- href="units/{$leftFolFileName}_{$rightFolFileName}_i.html"> -->
											<xsl:choose>
												<xsl:when test="contains($insideLeftImg, '.')">
													<xsl:call-template name="imgElement">
														<xsl:with-param name="imgHeight" select="145"/>
														<xsl:with-param name="altValue" select="$insideLeftFolNo"/>
														<xsl:with-param name="dataPage" select="$insideLeftImg"/>
														<xsl:with-param name="initialUrl" select="$insideLeftImg"/>
													</xsl:call-template>
													<!-- Modificata height da 225 a 145 -->
												</xsl:when>
												<xsl:otherwise/>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="contains($insideRightImg, '.')">
													<xsl:call-template name="imgElement">
														<xsl:with-param name="imgHeight" select="145"/>
														<xsl:with-param name="altValue" select="$insideRightFolNo"/>
														<xsl:with-param name="dataPage" select="$insideRightImg"/>
														<xsl:with-param name="initialUrl" select="$insideRightImg"/>
													</xsl:call-template>
												<!-- Modificata height da 225 a 145 -->
												</xsl:when>
												<xsl:otherwise/>
											</xsl:choose>
										</a>
										<div class="quireUnitInfo">
											<span class="fol-num num-left">
												<xsl:value-of select="$insideLeftFolNo"/>
											</span>
											<xsl:if test="contains($insideRightImg, '.') and contains($insideLeftImg, '.') or $emptyImage1 = 'true'">
												<!-- GM -->
												<span class="spacer"><xsl:text></xsl:text></span>
											</xsl:if>
											<span class="fol-num num-right">
												<xsl:value-of select="$insideRightFolNo"/>
											</span>
										</div>
										<!--<br/>-->
										<!-- GM: tolto -->
									</div>
									<div class="img2">
										<!-- GM -->
										<a class="fancybox fancybox.iframe" rel="set{$quireNo}.{@n}" title="(Quire {$quireNo}, Unit {$leftFol}.{$rightFol}, outside)">
											<!-- href="units/{$leftFolFileName}_{$rightFolFileName}_o.html"> -->
											<!-- Ho tolto href -->
											<xsl:choose>
												<xsl:when test="contains($outsideLeftImg, '.')">
													<xsl:call-template name="imgElement">
														<xsl:with-param name="imgHeight" select="145"/>
														<xsl:with-param name="altValue" select="$outsideLeftFolNo"/>
														<xsl:with-param name="dataPage" select="$outsideLeftImg"/>
														<xsl:with-param name="initialUrl" select="$outsideLeftImg"/>
													</xsl:call-template>
													<!-- Modificata height da 225 a 145 -->
												</xsl:when>
												<xsl:otherwise/>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="contains($outsideRightImg, '.')">
													<xsl:call-template name="imgElement">
														<xsl:with-param name="imgHeight" select="145"/>
														<xsl:with-param name="altValue" select="$outsideRightFolNo"/>
														<xsl:with-param name="dataPage" select="$outsideRightImg"/>
														<xsl:with-param name="initialUrl" select="$outsideRightImg"/>
													</xsl:call-template>
													<!-- Modificata height da 225 a 145 -->
												</xsl:when>
												<xsl:otherwise/>
											</xsl:choose>
										</a>
										<!--<br/>-->
										<!-- GM: tolto -->
										<div class="quireUnitInfo">
											<span class="fol-num num-left">
												<xsl:value-of select="$outsideLeftFolNo"/>
											</span>
											<xsl:if test="contains($outsideLeftImg, '.') and contains($outsideRightImg, '.') or $emptyImage2 = 'true'">
												<!-- GM -->
												<span class="spacer"><xsl:text></xsl:text></span>
											</xsl:if>
											<span class="fol-num num-left">
												<xsl:value-of select="$outsideRightFolNo"/>
											</span>
										</div>
									</div>
								</div>
								<!-- GM -->
								<xsl:result-document method="html" encoding="UTF-8"
									href="../../../data/output_data/viscoll/{$idno}/units/{$leftFolFileName}_{$rightFolFileName}_i.html" indent="yes">
									<xsl:for-each select="inside">
										<html xmlns="http://www.w3.org/1999/xhtml">
											<head>
												<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
												<title>
													Quire <xsl:value-of select="$quireNo"/>, 
													Unit <xsl:value-of select="$leftFol"/>. 
													<xsl:value-of select="$rightFol"/>, inside 
												</title>
												<link href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/css/imagepages.css" rel="stylesheet" type="text/css"/>
											</head>
											<body>
												<table id="tblimages">
													<tr>
														<td>
															<!-- GM -->
															<xsl:call-template name="imgElement">
																<xsl:with-param name="classEl" select="'bifolimage'"/>
																<xsl:with-param name="altValue" select="$insideLeftFolNo"/>
																<xsl:with-param name="dataPage" select="$insideLeftImg"/>
																<xsl:with-param name="initialUrl" select="$insideLeftImg"/>
															</xsl:call-template>
														</td>
														<td>
															<!-- GM -->
															<xsl:call-template name="imgElement">
																<xsl:with-param name="classEl" select="'bifolimage'"/>
																<xsl:with-param name="altValue" select="$insideRightFolNo"/>
																<xsl:with-param name="dataPage" select="$insideRightImg"/>
																<xsl:with-param name="initialUrl" select="$insideRightImg"/>
															</xsl:call-template>
														</td>
													</tr>
													<tr>
														<td>
															<xsl:value-of select="$insideLeftFolNo"/>
														</td>
														<td>
															<xsl:value-of select="$insideRightFolNo"/>
														</td>
													</tr>
												</table>
											</body>
										</html>
									</xsl:for-each>
								</xsl:result-document>
								<!-- GM -->
								<xsl:result-document method="html" encoding="UTF-8"
									href="../../../data/output_data/viscoll/{$idno}/units/{$leftFolFileName}_{$rightFolFileName}_o.html" indent="yes">
									<xsl:for-each select="outside">
										<html xmlns="http://www.w3.org/1999/xhtml">
											<head>
												<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
												<title>
													Quire <xsl:value-of select="$quireNo"/>, 
													Unit <xsl:value-of select="$leftFol"/>. 
													<xsl:value-of select="$rightFol"/>, outside 
												</title>
												<link href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/css/imagepages.css" rel="stylesheet" type="text/css"/>
											</head>
											<body>
												<table id="tblimages">
													<tr>
														<td>
															<!-- GM -->
															<xsl:call-template name="imgElement">
																<xsl:with-param name="classEl" select="'bifolimage'"/>
																<xsl:with-param name="altValue" select="$outsideLeftFolNo"/>
																<xsl:with-param name="dataPage" select="$outsideLeftImg"/>
																<xsl:with-param name="initialUrl" select="$outsideLeftImg"/>
															</xsl:call-template>
														</td>
														<td>
															<!-- GM -->
															<xsl:call-template name="imgElement">
																<xsl:with-param name="classEl" select="'bifolimage'"/>
																<xsl:with-param name="altValue" select="$outsideRightFolNo"/>
																<xsl:with-param name="dataPage" select="$outsideRightImg"/>
																<xsl:with-param name="initialUrl" select="$outsideRightImg"/>
															</xsl:call-template>
														</td>
													</tr>
													<tr>
														<td>
															<xsl:value-of select="$outsideLeftFolNo"/>
														</td>
														<td>
															<xsl:value-of select="$outsideRightFolNo"/>
														</td>
													</tr>
												</table>
											</body>
										</html>
									</xsl:for-each>
								</xsl:result-document>
							</xsl:for-each>
						</xsl:for-each>
						<!--<script type="text/javascript" src="data/output_data/viscoll/support/jquery-1.10.1.min.js">x</script><script type="text/javascript" src="data/output_data/viscoll/support/jquery.fancybox.js?v=2.1.5">x</script><link rel="stylesheet" type="text/css" href="data/output_data/viscoll/support/jquery.fancybox.css?v=2.1.5" media="screen"></link><link href="data/output_data/viscoll/support/jquery.fancybox.css" rel="stylesheet" type="text/css"></link><script type="text/javascript" src="data/output_data/viscoll/support/iframescript.js">x</script><link href="data/output_data/viscoll/support/collation.css" rel="stylesheet" type="text/css"></link><script type="text/javascript" src="data/output_data/viscoll/support/querys.js">x</script><script type="text/javascript" src="data/output_data/viscoll/support/support/collation.js">x</script>-->
					</div>
				</body>
			</html>
		</xsl:result-document>
		<!-- Collation Formulas -->
		<xsl:variable name="filename-formulas" select="concat($idno, '-formulas.html')"/>
		<xsl:result-document method="html" encoding="UTF-8" href="{concat('../../../data/output_data/viscoll/',$idno,'/',$filename-formulas)}" indent="yes">
			<html xmlns="http://www.w3.org/1999/xhtml">
				<!--  -->
				<head>
					<title>Collation Formulas - <xsl:value-of select="$msname"/> </title>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/lib/jquery-1.10.1.min.js">x</script>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.js?v=2.1.5">x</script>
					<link rel="stylesheet" type="text/css"
						href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css?v=2.1.5"
						media="screen"/>
					<link
						href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/jquery.fancybox.css"
						rel="stylesheet" type="text/css"/>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/source/iframescript.js">x</script>
					<link
						href="https://cdn.rawgit.com/leoba/VisColl/master/data/support/css/collation.css"
						rel="stylesheet" type="text/css"/>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/querys.js">x</script>
					<script type="text/javascript" src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/fancybox/collation.js">x</script>
				</head>
				<!-- this div is the same for all quires -->
				<div id="divtop">
					<span class="topheader">
						<a href="http://www.library.upenn.edu" target="_blank">
							<img src="https://cdn.rawgit.com/leoba/VisColl/master/data/support/pennlogo.gif" width="28" height="27" style="align:left;" alt="UPenn"/>
						</a>
						Generated using the <xsl:text></xsl:text>
						<a href="http://www.schoenberginstitute.org" target="blank">
							<xsl:text></xsl:text>
							<xsl:text></xsl:text>Schoenberg Institute for Manuscript Studies 
						</a>
						<a href="https://github.com/leoba/VisColl" target="blank"> Collation Modeler</a>
					</span>
				</div>
				<body>
					<p>Collation Formula for <a href="{$msurl}"> <xsl:value-of select="$msname"/> </a> </p>
					<p>Formula 1: 
						<xsl:for-each select="//quireCopy">
							<!-- to be in the format 1(8, -4, +3) -->
							<xsl:variable name="quire-no" select="@n"/>
							<xsl:variable name="no-leaves" select="child::leaf[last()]/@n"/>
							<xsl:value-of select="$quire-no"/> ( <xsl:value-of select="$no-leaves"/>
							<xsl:for-each select="child::leaf[@mode = 'missing']">, - <xsl:value-of select="@n"/> </xsl:for-each>
							<xsl:for-each select="child::leaf[@mode = 'added']">, + <xsl:value-of select="@n"/> </xsl:for-each>
							<xsl:for-each select="child::leaf[@mode = 'replaced']">, leaf in position <xsl:value-of select="@n"/> has been replaced </xsl:for-each>), <xsl:text></xsl:text>
						</xsl:for-each>
					</p>
					<p>Formula 2: 
						<xsl:for-each select="//quireCopy">
							<!-- to be in the format 1(8, leaf missing between fol. X and fol. Y, leaf added after fol. X) -->
							<xsl:variable name="quire-no" select="@n"/>
							<xsl:variable name="no-leaves" select="child::leaf[last()]/@n"/>
							<xsl:value-of select="$quire-no"/> ( <xsl:value-of select="$no-leaves"/>
							<xsl:for-each select="child::leaf[@mode = 'missing']">
								<xsl:choose>
									<xsl:when test="preceding-sibling::leaf">, leaf missing after
										fol. <xsl:value-of select="preceding-sibling::leaf[1]/@folio_number"/>
									</xsl:when>
									<xsl:otherwise>, first leaf is missing</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
							<xsl:for-each select="child::leaf[@mode = 'added']">
								<xsl:choose>
									<xsl:when test="preceding-sibling::leaf">, leaf added after fol.
										<xsl:value-of select="preceding-sibling::leaf[1]/@folio_number"/>
									</xsl:when>
									<xsl:otherwise>, first leaf is added</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
							<xsl:for-each select="child::leaf[@mode = 'replaced']">
								<xsl:choose>
									<xsl:when test="preceding-sibling::leaf">, leaf replaced after
										fol. <xsl:value-of select="preceding-sibling::leaf[1]/@folio_number"/>
									</xsl:when>
									<xsl:otherwise>, first leaf is replaced</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>), <xsl:text></xsl:text>
						</xsl:for-each>
					</p>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>
	
	<xd:doc>
		<xd:desc/>
		<xd:param name="initialUrl"/>
	</xd:doc>
	<xsl:template name="imgUrl">
		<xsl:param name="initialUrl"/>
		<xsl:choose>
			<xsl:when test="contains($initialUrl, 'http') or contains($initialUrl, 'www.') or contains($initialUrl, 'data/input_data/')">
				<xsl:value-of select="$initialUrl"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('data/input_data/images/single/', $initialUrl)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xd:doc>
		<xd:desc/>
		<xd:param name="altValue"/>
		<xd:param name="dataPage"/>
		<xd:param name="initialUrl"/>
		<xd:param name="imgHeight"/>
		<xd:param name="classEl"/>
	</xd:doc>
	<xsl:template name="imgElement">
		<xsl:param name="imgHeight"/>
		<xsl:param name="classEl"/>
		<xsl:param name="altValue"/>
		<xsl:param name="dataPage"/>
		<xsl:param name="initialUrl"/>
		<xsl:element name="img">
			<xsl:if test="$imgHeight">
				<xsl:attribute name="height" select="$imgHeight"/>
			</xsl:if>
			<xsl:if test="$classEl">
				<xsl:attribute name="class" select="$classEl"/>
			</xsl:if>
			<xsl:attribute name="alt" select="$altValue"/>
			<xsl:attribute name="data-page" select="$dataPage"/>
			<!--<xsl:attribute name="onError">this.onerror=null; this.src='images/no-image.png;'</xsl:attribute>-->
			<xsl:attribute name="data-initialUrl" select="$initialUrl"/>
			<xsl:attribute name="src">
				<xsl:call-template name="imgUrl">
					<xsl:with-param name="initialUrl" select="$initialUrl"/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
