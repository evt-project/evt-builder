<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">

	<xd:doc type="stylesheet">
		<xd:short>
			EN: Fundamental calls to generate the HTML structure.
			IT: Le chiamate principali per la generazione della struttura HTML.
		</xd:short>
	</xd:doc>


	<xsl:template name="html_head">
		<xsl:param name="html_path"/>
		<xsl:param name="html_tc"/>
		<xsl:param name="output"/>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

			<meta property="og:title" content="{$root//tei:titleStmt/tei:title}"/>
			<meta property="og:image" content="{$html_path}/data/input_data/images/{$fb_thumb}"/>

			<title>
				<xsl:value-of select="$root//tei:titleStmt/tei:title"/>
				<!-- <xsl:value-of select="normalize-space(//tei:titleStmt/tei:title)"/> -->
			</title>

			<xsl:choose>
				<xsl:when test="$html_tc!='datastructure'">
					<link rel="stylesheet" type="text/css" href="{$html_path}/css/main.css"/>
					<link rel="stylesheet" type="text/css"
						href="{$html_path}/css/page_data-include.css"/>
					<link rel="stylesheet" type="text/css"
						href="{$html_path}/css/jquery-ui-1.9.0.custom.css"/>
					<link rel="stylesheet" type="text/css"
						href="{$html_path}/css/ImageTextLink.css"/>
					<link rel="stylesheet" type="text/css"
						href="{$html_path}/css/jquery.jqzoom.css"/>
					<link rel="stylesheet" type="text/css"
						href="{$html_path}/css/font-awesome.min.css" />
					<link rel="stylesheet" type="text/css"
						href="{$html_path}/css/evt-icons.css" />
				</xsl:when>
				<xsl:otherwise>
					<link rel="stylesheet" type="text/css" href="{$html_path}/css/page_data-include-{$output}.css"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:comment>jQuery lib</xsl:comment>
			<script type="text/javascript" src="{$html_path}/js/jquery_lib/jquery-latest.js"/>
			<script type="text/javascript" src="{$html_path}/js/jquery_lib/jquery-ui-latest.js"/>
			<xsl:comment>/jQuery lib</xsl:comment>

			<xsl:if test="$html_tc!='datastructure'">
				<xsl:comment>main lib</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/utils.js"/>
				<xsl:comment>/main lib</xsl:comment>

				<xsl:comment>keydown</xsl:comment>
				<script src="{$html_path}/js/plugin/jquery.rafmas-keydown.js"/>
				<xsl:comment>/keydown</xsl:comment>

				<xsl:comment>iViewer</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/plugin/jquery_iviewer/jquery.mousewheel.min.js"/>
				<script type="text/javascript" src="{$html_path}/js/plugin/jquery_iviewer/jquery.iviewer.js"/>
				<script type="text/javascript" src="{$html_path}/js/plugin_settings/iviewer_config.js"/>
				<xsl:comment>/iViewer</xsl:comment>

				<xsl:comment>magnifier</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/plugin/jquery.jqzoom-core.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/switchZM.js"/>
				<xsl:comment>/magnifier</xsl:comment>
				
				<xsl:comment>hashchange</xsl:comment>
				<script src="{$html_path}/js/plugin/jquery.ba-bbq.js"/>
				<xsl:comment>/hashchange</xsl:comment>
				
				<xsl:comment>image text link</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/main/ImageTextLink.js"/>
				<xsl:comment>/image text link</xsl:comment>
				
				<xsl:comment>page data</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/main/page_data-include.js"/>
				<xsl:comment>/page data</xsl:comment>

				<xsl:comment>highlight</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/plugin/jquery.highlight_mod.js"/>
				<xsl:comment>/highlight</xsl:comment>

				<xsl:if test="$search=true()">
					<xsl:comment>TipueSearch</xsl:comment>
					<script type="text/javascript" src="{$html_path}/js/plugin/tipuesearch/tipuesearch.js"/>
					<script type="text/javascript" src="./js/plugin/tipuesearch/tipuesearch_content.js" />
					<script type="text/javascript" src="./js/plugin/tipuesearch/tipuesearch_set.js" />
					<xsl:comment>/TipueSearch</xsl:comment>
					
					<xsl:comment>search</xsl:comment>
					<script type="text/javascript" src="{$html_path}/js/main/search.js"/>
					<xsl:comment>/search</xsl:comment>
				</xsl:if>
			</xsl:if>
		</head>
	</xsl:template>

	<xsl:template name="data_structure">
		<xsl:param name="output"/>
		<xsl:param name="pb_n"/>
		<xsl:param name="edition_pos"/>

		<html lang="en-US">
			<xsl:call-template name="html_head">
				<xsl:with-param name="html_path" select="$dataPrefix"/>
				<xsl:with-param name="html_tc" select="'datastructure'"/>
				<xsl:with-param name="output" select="$output"/>
			</xsl:call-template>
			<body>
				<section id="central_wrapper">
					<div id="text_frame">
						<div id="text">
							<xsl:call-template name="edition_level">
								<xsl:with-param name="pb_n" select="$pb_n"/>
								<xsl:with-param name="edition_pos" select="$edition_pos"/>
							</xsl:call-template>
						</div>
					</div>
				</section>

				<!--<footer>
					<p>2012@rafmas</p>
				</footer>-->
			</body>
		</html>
	</xsl:template>

	
	<xsl:template name="doc_regesto">
		<xsl:param name="doc_id" />
		<xsl:param name="front" />
		<html lang="en-US">
			<xsl:call-template name="html_head">
				<xsl:with-param name="html_path" select="$dataPrefix"/>
				<xsl:with-param name="html_tc" select="'datastructure'"/>
				<xsl:with-param name="output" select="regesto"/>
			</xsl:call-template>
			<body>
				<div id="regesto">
					<div class="front">
						<div class='title'>Informazioni sul documento</div>
						<div class="info">
							<div class="align-center"><span class="intestazione inline">Numerazione nuova: </span><xsl:value-of select="$front/tei:titlePart[@type='numerazioneNuova']"/></div>
							<div class="align-center"><span class="intestazione inline">Numerazione originale: </span><xsl:value-of select="$front/tei:titlePart[@type='numerazioneOrig']"/></div>
							<div class="align-center">
								<span class="intestazione inline">
									<xsl:apply-templates mode="dipl" select="$front/tei:docDate"/>
								</span>
							</div>
						</div>
						<div class="reg_text">
							<!--<xsl:value-of select="$front/tei:div[@type='regesto']"/>-->
							<xsl:apply-templates select="$front/tei:div[@type='regesto']" mode="dipl"/>
						</div>
						<div class="reg_note">
							<hr/>
							<p class="bibliografia">
								<!--<xsl:value-of select="$front//tei:div[@type='orig_doc']"/>-->
								<xsl:apply-templates select="$front//tei:div[@type='orig_doc']" mode="dipl"></xsl:apply-templates>
							</p>
							<p class="bibliografia">
								<xsl:for-each select="$front//tei:div[@type='biblio']/tei:p">
									<xsl:apply-templates mode='dipl'/>
								</xsl:for-each>
							</p>
							<p class="crit_notes">
								<xsl:for-each select="tei:front//tei:div[@type='crit_notes']/tei:note">
									<xsl:apply-templates mode="dipl"/>
								</xsl:for-each>
							</p>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="index_build">
		<html lang="en-US">
			<xsl:call-template name="html_head">
				<xsl:with-param name="html_path" select="$mainPrefix"/>
			</xsl:call-template>
			<body>
				<div id="global_wrapper">
					<header id="main_header">
						<div id="home_title">
							<xsl:value-of select="$index_title"/>
							<xsl:if test="$badge=true()">
								<div id="badge_title"><xsl:value-of select="$badge_text"/></div>
							</xsl:if>
						</div>
						<div class='concave'>
							<div class='extTop'>
								<div class='topleftconcave'></div>
							</div>
							<div class='botleftconcave'></div>
						</div>
						<div id="mode_switch">
							<xsl:if test="$image_frame=false()">
								<a href="javascript:void(0);" id="txt_single" class="current_mode"
									title="Single Text mode"> <img src="images/txt-single.png" class="mainHeaderimg"></img> </a>
							</xsl:if>
							<xsl:if test="$image_frame=true()">
								<a href="javascript:void(0);" id="txtimg_link" class="current_mode"
									title="Image|Text mode"> <img src="images/img-txt.png" class="mainHeaderimg"></img></a>
								<!--<a href="javascript:void(0);" id="imgimg_link" title="image/image mode"> [I|I] </a>-->
							</xsl:if>
							<xsl:if test="count($edition_array) &gt; 1">
								<a href="javascript:void(0);" id="txttxt_link"
									title="Text|Text mode"> <img src="images/txt-txt.png" class="mainHeaderimg"></img> </a>
							</xsl:if>
							<xsl:if test="$image_frame=true() and $double_view=true()">
								<a href="javascript:void(0);" id="imgd_link"
									title="Bookreader mode"> <img src="images/double-view.png" class="mainHeaderimg"></img> </a>
							</xsl:if>
						</div>
						<div id="cont_fullscreen">
							<a href="javascript:void(0);" id="main_fullscreen" title="Fullscreen"><i class="fa fa-expand"></i></a>
						</div>
					</header>
					<section id="central_wrapper">
						<i class="fa fa-caret-up" id="header_collapse" title="Toggle menu"></i>
						<div class="main_left_arrow" onclick="UnInitialize()" title="Previous"/>
						<div class="main_right_arrow" title="Next"/>
						<xsl:if test="$image_frame=true() or count($edition_array) &gt; 1">
							<xsl:variable name="viewStatus" select="if($image_frame=false()) then 'width:0px; border-left-width:0px; border-right-width:0px;' else ''"/>
							<div id="main_left_frame" style="{$viewStatus}">
								<i class="fa fa-caret-up go-full-left" id="goFullScreenLeft" title="Expand frame"></i>
								<!--
								<div id="main_left_menu">
									<a href="javascript:void(0);" id="main_left_menu-openlink"
										title="Open menu"> + </a>
									<a href="javascript:void(0);" id="main_left_menu-closelink"
										title="Close menu"> - </a>
								</div>
								-->
								<xsl:if test="$image_frame=false()">
									<!--<div class="main_left_arrow" onclick="UnInitialize()" title="Previous"/>-->
								</xsl:if>
								<!-- <div class="main_left_arrow" title="Previous"/> -->
								<header id="left_header" class="top-menu">
									<i class="fa fa-times-circle closeFullScreen" id="closeFullScreenLeft"></i>
									<div id="left_menu">
										<xsl:if test="$pp_selector_pos='left'">
											<span id="span_pp_select" class="like_select left_menu" title="Folio">
												<xsl:call-template name="div_select_build">
													<xsl:with-param name="html_div_class"
														select="'main_pp_select'"/>
												</xsl:call-template>
											</span>	
										</xsl:if>
										<xsl:if test="$double_view=true()">
											<span id="span_dd_select" class="like_select">
												<xsl:call-template name="div_select_build">
													<xsl:with-param name="html_div_class"
														select="'main_dd_select'"/>
												</xsl:call-template>
											</span>
											<span id="thumb_elem-add" class="iconButtons">
												<a href="javascript:void(0);" class="thumb_link"><i class="fa fa-th"></i></a>
											</span>
										</xsl:if>
										<xsl:if test="count($edition_array) &gt; 1">
											<xsl:element name="span">
												<xsl:attribute name="id">span_ee_select-add</xsl:attribute>
												<xsl:attribute name="class">
													like_select
													<xsl:if test="$edition_level_selector=false()">
														hidden
													</xsl:if>
												</xsl:attribute>
												<xsl:call-template name="div_select_build">
													<xsl:with-param name="html_div_class"
														select="'main_ee_select'"/>
												</xsl:call-template>
											</xsl:element>
											<xsl:if test="$regesto=true()">
												<span class="imageTopTool mainButtons toggleReg" id="switchReg-add" value="reg" title="Regesto">
													<span>Regesto</span>
													<i class="fa fa-toggle-off"></i>
												</span>
											</xsl:if>
										</xsl:if>
										<xsl:if test="$image_frame=true()">
											<div id="image_menu">
												<xsl:if test="$thumbs_button=true()">
													<span class="imageTopTool mainButtons thumb_link" id="thumb_elem" value="th" title="Thumbnails">
														<span>Thumbs</span>
														<i class="fa fa-th"></i>
													</span>
												</xsl:if>
												<xsl:if test="$mag_button=true()">
													<span class="imageTopTool mainButtons" id="switchMag" value="mag" onclick="magOn()" title="Magnifying lens">
														<span>Magnifier</span>
														<i class="fa evt-magnifier"></i>
													</span>
												</xsl:if>
												<xsl:if test="$hs_button=true()">
													<span class="imageTopTool mainButtons" id="switchHS" value="HS" title="Hot spot" onclick="switchHS()">
														<span>HotSpot</span>
														<i class="fa fa-circle-o"></i>
													</span>
												</xsl:if>
												<xsl:if test="$txtimg_link_button=true()">
													<span class="imageTopTool mainButtons" id="switchITL" value="turn ITL on" title="Image-Text link" onclick="switchIMT()">
														<span>TextLink</span>
														<i class="fa fa-chain-broken"></i>
													</span>
												</xsl:if>
											</div>
										</xsl:if>
										<!--<input type="image" src="images/zoom.png" id="switchZoom" class="top_image_tools" value="zoom" onclick="zoomOn()"/>-->
										<!--<input type="image" src="images/magOff.png" id="switchMag" class="top_image_tools" value="mag" onclick="magOn()"/>-->
										<!--<input type="image" src="images/ITLoff.png" id="switchITL" class="top_image_tools" value="turn ITL on" title="Image text link" onclick="switchIMT()"/>-->
									</div>
								</header>
								<xsl:if test="$image_frame=true()">
									<xsl:if test="$document_navigation=true()">
										<span id="inside_left_arrow-add"><i class="fa fa-chevron-up"></i></span>
										<span id="inside_right_arrow-add"><i class="fa fa-chevron-down"></i></span>
									</xsl:if>
									<!-- Text frame bottom menu -->
									<div id="text_tool-add" class="bottom-menu">
										<span id="span_list_select-add" class="like_select filter" title="Lists">
											<div class="main_list_select">
												<span data-value="none" class="label_selected">
													No selection
												</span>
												<div class="open_select open_up">
													<i class="fa fa-sort-asc"></i>
												</div>
												<div class="option_container up">
													<xsl:for-each select="$lists">
														<xsl:if test="./normalize-space()">
															<xsl:element name="div">
																<xsl:attribute name="class">option </xsl:attribute>
																<xsl:attribute name="data-value"><xsl:value-of select="name(.)"/></xsl:attribute>
																<i class="fa fa-circle filter_color"></i>
																<xsl:value-of select="."/>
															</xsl:element>
														</xsl:if>
													</xsl:for-each>
													<div class="option" data-value="all">Seleziona Tutto</div>
													<div class="option" data-value="clean">Pulisci Selezione</div>
												</div>
											</div>
										</span>
									</div>
									
									<div id="image_cont">
										<div id="image_fade">
											<div id="image_elem">
												<!--<img id="iviewerImage" src="images/null.jpg" />-->
											</div>
										</div>
										<div id="image_loading">
											<i class="fa fa-refresh fa-spin"></i>
										</div>
										<div id="mag_image_elem"></div>
										
										<div id="image_tool" class="bottom-menu">
											<div id="spb">
												<a id="zoom_orig" class="zoom_btn"
													href="javascript:void(0);" title="100%"><i class="evt-zoom1"></i></a>
												<a id="zoom_fit" class="zoom_btn"
													href="javascript:void(0);" title="Fit to frame"
													><i class="fa evt-zoomfit"></i></a>
												<a id="zoom_out" href="javascript:void(0);" title="Zoom out"><i class="fa evt-zoomminus"></i></a>
												<div id="spb_cont">
													<div id="slider"/>
												</div>
												<a id="zoom_in" href="javascript:void(0);" title="Zoom in"><i class="fa evt-zoomplus"></i></a>
											</div>
											<div id="zval">
												<xsl:if test="$image_frame=true()">
													<span id="zvalint"><span id="val">0</span>%</span>
													<span id="zvalopz"/>
												</xsl:if>
												<xsl:if test="$image_frame=false()">
													<span>No image</span>
												</xsl:if>
											</div>
										</div>
										<input id="dimFit" type="hidden" value=""/>
										<input id="imgTit" type="hidden" value=""/>
										<div id="thumb_cont">
											<!-- CDP:embedded -->
											<!-- <xsl:if test="$root//tei:sourceDoc"> -->
												<!-- Found the node(s) for embedded transcription-->
												<!-- <xsl:for-each select="$root//tei:sourceDoc//tei:surface[not(ancestor::tei:zone)]">
													<figure class="thumb_single" data-value="{@xml:id}">
														<img src="data/input_data/images/single/{@xml:id}_small.jpg"/>
														<figcaption>
															<xsl:value-of select="@n"/>
														</figcaption>
													</figure>
												</xsl:for-each>
											</xsl:if>
											<xsl:if test="$root//tei:text"> -->
												<!-- Found no node(s) for embedded transcription-->
												<!-- <xsl:for-each select="$root//tei:text//tei:pb">
													<figure class="thumb_single" data-value="{@xml:id}">
														<img src="data/input_data/images/single/{@xml:id}_small.jpg"/>
														<figcaption>
															<xsl:value-of select="@n"/>
														</figcaption>
													</figure>
												</xsl:for-each>
											</xsl:if>-->
										</div>									
									</div>
								</xsl:if>
							</div>
						</xsl:if>
						
						<xsl:variable name="id_right_frame">
							<xsl:choose>
								<xsl:when test="$image_frame=true()">
									<text>main_right_frame</text>
								</xsl:when>
								<xsl:otherwise>
									<text>main_right_frame-single</text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						
						<div id="{$id_right_frame}">
							<i class="fa fa-caret-up go-full-right" id="goFullScreenRight" title="Expand frame"></i>
							<!--
							<div id="main_right_menu">
								<a href="javascript:void(0);" id="main_right_menu-openlink"
									title="Open menu"> + </a>
								<a href="javascript:void(0);" id="main_right_menu-closelink"
									title="Close menu"> - </a>
							</div>
							-->
							<!--<div class="main_right_arrow" title="Previous"/>-->
							<header id="right_header" class="top-menu">
								<div id="right_menu">
									<span id="span_tt_select" class="like_select" title="Text">
										<xsl:call-template name="div_select_build">
											<xsl:with-param name="html_div_class"
												select="'main_tt_select'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="$pp_selector_pos='right'">
										<span id="span_pp_select" class="like_select right_menu" title="Folio">
											<xsl:call-template name="div_select_build">
												<xsl:with-param name="html_div_class"
													select="'main_pp_select'"/>
											</xsl:call-template>
										</span>
									</xsl:if>
									<xsl:element name="span">
										<xsl:attribute name="id">span_ee_select</xsl:attribute>
										<xsl:attribute name="title">Edition level</xsl:attribute>
										<xsl:attribute name="class">
											like_select
											<xsl:if test="$edition_level_selector=false()">
												hidden
											</xsl:if>
										</xsl:attribute>
										<xsl:call-template name="div_select_build">
											<xsl:with-param name="html_div_class"
												select="'main_ee_select'"/>
										</xsl:call-template>
									</xsl:element>
									<xsl:if test="$regesto=true()">
										<span class="imageTopTool mainButtons active toggleReg" id="switchReg" value="reg" title="Regesto">
											<span>Regesto</span>
											<i class="fa fa-toggle-on"></i>
										</span>
									</xsl:if>
								</div>
								<i class="fa fa-times-circle closeFullScreen" id="closeFullScreenRight"></i>
							</header>
							<xsl:if test="$regesto=true()">
								<div id="regesto_cont" class="text-box"/>
							</xsl:if>
							<div id="text_cont" class="text-box">
								<div id="text_elem"/>
							</div>
							<xsl:if test="$search=true()">
								<div id="search_cont" class="collapsed bottomBox">
									<div id="search_header" class="bottomBoxHeader">
										<span id="toggle_search_cont" class="mainButtons" title="Apri/Chiudi Ricerca">
											<i class='fa fa-angle-double-up'></i>
										</span>
										<span id="keyboard_link" class="mainButtons small" title="Apri/Chiudi Tastiera">
											<i class="fa fa-keyboard-o"></i>
										</span>
										<input type="text" id="tipue_search_input" />
										<span id="start_search" class="mainButtons small" title="Avvia Ricerca">
											<i class='fa fa-search'></i>
										</span>
									</div>
									<div id="search_sub_header" class="bottomBoxSubHeader">
										<div id="search_query">Enter your query into the search box above!</div>
										<div id="search_results"></div>
									</div>
									<div id="search_cont_results" class="bottomBoxContent">
										<div id="tipue_search_content"></div>
									</div>
									<div id="search_foot" class="bottomBoxFooter"></div>
								</div>	
							</xsl:if>
							
							<div id="lists_cont" class="bottomBox">
								<div id="list_header" class="bottomBoxHeader">
									<span id="toggle_list_cont" class="mainButtons" title="Apri/Chiudi Liste">
										<i class='fa fa-angle-double-down'></i>
									</span>
								</div>
								<div id="list_letters" class="bottomBoxContent">
									<span class="list_filter" data-filter-type="first_letter" data-value="A">A</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="B">B</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="C">C</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="D">D</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="E">E</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="F">F</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="G">G</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="H">H</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="I">I</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="L">L</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="M">M</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="N">N</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="O">O</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="P">P</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="Q">Q</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="R">R</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="S">S</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="T">T</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="U">U</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="V">V</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="Z">Z</span>
								</div>
							</div>
							<xsl:if test="$document_navigation=true()">
								<span id="inside_left_arrow"><i class="fa fa-chevron-up"></i></span>
								<span id="inside_right_arrow"><i class="fa fa-chevron-down"></i></span>
							</xsl:if>
							<!-- Text frame bottom menu -->
							<div id="text_tool" class="bottom-menu">
								<xsl:if test="$search=true()">
									<span id="search_link" class="mainButtons" title="Search">
										<span>Search</span>
										<i class="fa fa-search"></i>
									</span>
								</xsl:if>
								<xsl:if test="$list_person=true()">
									<span id="list_link" class="mainButtons" title="Liste">
										<span>Lists</span>
										<i class="fa fa-list"></i>
									</span>
								</xsl:if>
								<span id="span_list_select" class="like_select filter" title="Lists">
									<div class="main_list_select">
										<span data-value="none" class="label_selected">
											No selection
										</span>
										<div class="open_select open_up">
											<i class="fa fa-sort-asc"></i>
										</div>
										<div class="option_container up">
											<xsl:for-each select="$lists">
												<xsl:if test="./normalize-space()">
													<xsl:element name="div">
														<xsl:attribute name="class">option</xsl:attribute>
														<xsl:attribute name="data-value"><xsl:value-of select="name(.)"/></xsl:attribute>
														<i class="fa fa-circle filter_color"></i>
														<xsl:value-of select="."/>
													</xsl:element>
												</xsl:if>
											</xsl:for-each>
											<div class="option" data-value="all">
												<i class="fa fa-circle filter_color"></i>
												Select All
											</div>
											<div class="option" data-value="clean">
												<i class="fa fa-circle-o filter_color"></i>
												Clean Selection
											</div>
										</div>
									</div>
								</span>
							</div>
						</div>
					</section>
					<section id="central_button">
						<!-- <div id="edval">
							<span>Edition</span>
						</div>
						<div id="central_page_number">
							<span>Folio: </span>
						</div> -->
						<input id="folio_page_number" type="hidden" value=""/>
					</section>
					
					<footer>
						<p>2012@rafmas</p>
					</footer>
				</div>
				<script src="js/main/fullscreen_request.js"/>
				<script>
					(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
					  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
					  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
 					 })(window,document,'script','./js/plugin/analytics.js','ga');

					//ga('create', 'UA-52687967-1', 'auto');
					ga('create', 'UA-52687967-1', {
						'storage': 'none', // no cookies
						'cookieDomain': 'none' // no domain
					});
					ga('set', 'checkProtocolTask', function() {}); //HACK
					ga('send', 'pageview');
				</script>
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
