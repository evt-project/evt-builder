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

	<!--
	<xsl:template name="example">
        <xsl:param name="paraex"/>
        <xsl:if test="$paraex != ''">
            <xsl:attribute name="class">
                <xsl:for-each select="tokenize($paraex, '\s')">
                    <xsl:value-of select="concat(substring-after(., '#'), ' ')"/>
                    <xsl:if test="position() != last()"/>
                </xsl:for-each>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>	
	<xsl:template name="example">
    </xsl:template>	
	
	<xsl:call-template name="example">
		<xsl:with-param name="html_path" select="$mainPrefix"/>
	</xsl:call-template>
	
	<xsl:call-template name="example" />
	
	-->

	<xsl:template name="html_head">
		<xsl:param name="html_path"/>
		<xsl:param name="html_tc"/>
		<xsl:param name="output"/>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

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
				<script src="js/plugin/jquery.rafmas-keydown.js"/>
				<xsl:comment>/keydown</xsl:comment>

				<xsl:comment>iViewer</xsl:comment>
				<script type="text/javascript" src="js/plugin/jquery_iviewer/jquery.mousewheel.min.js"/>
				<script type="text/javascript" src="js/plugin/jquery_iviewer/jquery.iviewer.js"/>
				<script type="text/javascript" src="js/plugin_settings/iviewer_config.js"/>
				<xsl:comment>/iViewer</xsl:comment>

				<xsl:comment>magnifier</xsl:comment>
				<script type="text/javascript" src="js/plugin/jquery.jqzoom-core.js"/>
				<script type="text/javascript" src="js/main/switchZM.js"/>
				<xsl:comment>/magnifier</xsl:comment>
				
				<xsl:comment>hashchange</xsl:comment>
				<script src="js/plugin/jquery.ba-bbq.js"/>
				<xsl:comment>/hashchange</xsl:comment>
				
				<xsl:comment>image text link</xsl:comment>
				<script type="text/javascript" src="js/main/ImageTextLink.js"/>
				<xsl:comment>/image text link</xsl:comment>

			</xsl:if>
			<link rel="stylesheet" href="css/font-awesome.min.css" />
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
						</div>
						<div class='concave'>
							<div class='extTop'>
								<div class='topleftconcave'></div>
							</div>
							<div class='botleftconcave'></div>
						</div>
						<xsl:if test="$image_frame=true()">
							<div id="mode_switch">
								<a href="javascript:void(0);" id="txtimg_link" class="current_mode"
									title="Text/Image mode"> <img src="images/img-txt.png" class="mainHeaderimg"></img></a>
								<!--<a href="javascript:void(0);" id="imgimg_link" title="image/image mode"> [I|I] </a>-->
								<a href="javascript:void(0);" id="txttxt_link"
									title="Text/Text mode"> <img src="images/txt-txt.png" class="mainHeaderimg"></img> </a>
								<xsl:if test="$double_view=true()">
									<a href="javascript:void(0);" id="imgd_link"
										title="Bookreader mode"> <img src="images/double-view.png" class="mainHeaderimg"></img> </a>
								</xsl:if>
							</div>
						</xsl:if>
						
						<div id="cont_fullscreen">
							<a href="javascript:void(0);" id="main_fullscreen" title="Fullscreen"><i class="fa fa-expand"></i></a>
						</div>
					</header>
					<section id="central_wrapper">
						<i class="fa fa-caret-up" id="header_collapse" title="Toggle menu"></i>
						<div id="main_left_arrow" onclick="UnInitialize()" title="Previous"/>
						<div id="main_right_arrow" title="Next"/>
						<xsl:if test="$image_frame=true()">
							<div id="main_left_frame">
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
									<!--<div id="main_left_arrow" onclick="UnInitialize()" title="Previous"/>-->
								</xsl:if>
								<!-- <div id="main_left_arrow" title="Previous"/> -->
								<header id="left_header">
									<i class="fa fa-times-circle closeFullScreen" id="closeFullScreenLeft"></i>
									<div id="left_menu">
										<span id="span_dd_select" class="like_select">
											<xsl:call-template name="div_select_build">
												<xsl:with-param name="html_div_class"
													select="'main_dd_select'"/>
											</xsl:call-template>
										</span>
										<span id="span_ee_select-add" class="like_select">
											<xsl:call-template name="div_select_build">
												<xsl:with-param name="html_div_class"
													select="'main_ee_select'"/>
											</xsl:call-template>
										</span>
										<span id="thumb_elem-add" class="iconButtons">
											<a href="javascript:void(0);" class="thumb_link"><i class="fa fa-th"></i></a>
										</span>
										<div id="image_menu">
											<span class="imageTopTool mainButtons" id="switchMag" value="mag" onclick="magOn()" title="Magnifier">
												<span>Magnifier</span>
												<i class="fa fa-search"></i>
											</span>
											<span class="imageTopTool mainButtons" id="switchHS" value="HS" title="Hot spot" onclick="switchHS()">
												<span>HotSpot</span>
												<i class="fa fa-circle-o"></i>
											</span>
											<span class="imageTopTool mainButtons" id="switchITL" value="turn ITL on" title="Image text link" onclick="switchIMT()">
												<span>TextLink</span>
												<i class="fa fa-chain-broken"></i>
											</span>
											<span id="thumb_elem" class="iconButtons" title="Thumbnails">
												<a href="javascript:void(0);" class="thumb_link"><i class="fa fa-th"></i></a>
											</span>
										</div>
										<!--<input type="image" src="images/zoom.png" id="switchZoom" class="top_image_tools" value="zoom" onclick="zoomOn()"/>-->
										<!--<input type="image" src="images/magOff.png" id="switchMag" class="top_image_tools" value="mag" onclick="magOn()"/>-->
										<!--<input type="image" src="images/ITLoff.png" id="switchITL" class="top_image_tools" value="turn ITL on" title="Image text link" onclick="switchIMT()"/>-->
									</div>
								</header>
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
									
									<div id="image_tool">
										<div id="spb">
											<a id="zoom_orig" class="zoom_btn"
												href="javascript:void(0);" title="100%"><i class="icona">1:1</i></a>
											<a id="zoom_fit" class="zoom_btn"
												href="javascript:void(0);" title="Fit to frame"
												><i class="fa fa-arrows-v"></i></a>
											<a id="zoom_out" href="javascript:void(0);"><i class="fa fa-minus-circle"></i></a>
											<div id="spb_cont">
												<div id="slider"/>
											</div>
											<a id="zoom_in" href="javascript:void(0);"><i class="fa fa-plus-circle"></i></a>
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
										<xsl:for-each select="//tei:pb">
											<figure class="thumb_single" id="{@n}_small">
												<img src="data/input_data/images/{@n}_small.jpg"/>
												<figcaption>
													<xsl:value-of select="@n"/>
												</figcaption>
											</figure>
										</xsl:for-each>
									</div>									
								</div>
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
							<!--<div id="main_right_arrow" title="Previous"/>-->
							<header id="right_header">
								<div id="right_menu">
									<span id="span_tt_select" class="like_select" title="Edition text">
										<xsl:call-template name="div_select_build">
											<xsl:with-param name="html_div_class"
												select="'main_tt_select'"/>
										</xsl:call-template>
									</span>
									<span id="span_pp_select" class="like_select" title="Folio">
										<xsl:call-template name="div_select_build">
											<xsl:with-param name="html_div_class"
												select="'main_pp_select'"/>
										</xsl:call-template>
									</span>
									<span id="span_ee_select" class="like_select" title="Edition levels">
										<xsl:call-template name="div_select_build">
											<xsl:with-param name="html_div_class"
												select="'main_ee_select'"/>
										</xsl:call-template>
									</span>
									<span id="search_elem" class="iconButtons" title="Search">
										<a href="javascript:void(0);" id="search_link"><i class="fa fa-search"></i></a>
									</span>
								</div>
								<i class="fa fa-times-circle closeFullScreen" id="closeFullScreenRight"></i>
							</header>
							<div id="text_cont">
								<div id="text_elem"/>
							</div>
						</div>
					</section>
					<section id="central_button">
						<div id="edval">
							<span>Edition</span>
						</div>
						<div id="central_page_number">
							<span>Folio: </span>
						</div>
						<input id="folio_page_number" type="hidden" value=""/>
					</section>
					
					<footer>
						<p>2012@rafmas</p>
					</footer>
				</div>
				<script src="js/main/fullscreen_request.js"/>
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
