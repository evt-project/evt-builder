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
				<xsl:value-of select="//tei:titleStmt/tei:title"/>
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
				<script type="text/javascript" src="js/switchZM.js"/>
				<xsl:comment>/magnifier</xsl:comment>
				
				<xsl:comment>hashchange</xsl:comment>
				<script src="js/plugin/jquery.ba-bbq.js"/>
				<xsl:comment>/hashchange</xsl:comment>
				
				<xsl:comment>image text link</xsl:comment>
				<script type="text/javascript" src="js/ImageTextLink.js"/>
				<xsl:comment>/image text link</xsl:comment>

			</xsl:if>
		</head>
	</xsl:template>

	<xsl:template name="data_structure">
		<xsl:param name="pb_n"/>
		<xsl:param name="output"/>

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
							<xsl:if test="$output='facsimile'">
								<xsl:choose>
									<!-- EN: If the surface element is present first of all we apply the text-image link template, to which only the pb is passed -->
									<!-- IT: Se c'è il surface viene applicato per primo il template per il collegamento testo-immagine al quale devo passare solo il pb -->
									<xsl:when test="//tei:facsimile/tei:surface[substring(@xml:id, string-length(@xml:id)-3)=$pb_n]">
										<!--<xsl:copy-of select="current-group()"/>-->
										<xsl:apply-templates select="." mode="facs">
											<xsl:with-param name="n" select="$pb_n"/>
										</xsl:apply-templates>
									</xsl:when>
									<!-- EN: If the surface element is not present only the diplomatic edition templates are applied; those need all the page content -->
									<!-- IT: Se non c'è il surface devo applicare direttamente i templates per l'edizione diplomatica; a questi devo passare tutto il contenuto della pagina -->
									<xsl:otherwise>
										<xsl:apply-templates select="current-group()" mode="facs">
											<xsl:with-param name="n" select="$pb_n"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="$output='diplomatic'">
								<xsl:choose>
									<!-- EN: If the surface element is present first of all we apply the text-image link template, to which only the pb is passed -->
									<!-- IT: Se c'è il surface viene applicato per primo il template per il collegamento testo-immagine al quale devo passare solo il pb-->
									<xsl:when test="//tei:facsimile/tei:surface[substring(@xml:id, string-length(@xml:id)-3)=$pb_n]">
										<xsl:apply-templates select="." mode="dipl">
											<xsl:with-param name="n" select="$pb_n"/>
										</xsl:apply-templates>
									</xsl:when>
									<!-- EN: If the surface element is not present only the diplomatic edition templates are applied; those need all the page content -->
									<!-- IT: Se non c'è il surface devo applicare direttamente i templates per l'edizione diplomatica; a questi devo passare tutto il contenuto della pagina -->
									<xsl:otherwise>
										<xsl:apply-templates select="current-group()" mode="dipl">
											<xsl:with-param name="n" select="$pb_n"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
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
						
						<xsl:if test="$image_frame=true()">
							<div id="mode_switch">
								<a href="javascript:void(0);" id="txtimg_link" class="current_mode"
									title="text/image mode"> [T|I] </a>
								<!--<a href="javascript:void(0);" id="imgimg_link" title="image/image mode"> [I|I] </a>-->
								<a href="javascript:void(0);" id="txttxt_link"
									title="text/text mode"> [T|T] </a>
							</div>
						</xsl:if>
						
						<div id="cont_fullscreen">
							<a href="javascript:void(0);" id="main_fullscreen" title="fullscreen"
								style="float: right; padding: 12px; padding-left: 14px;"
								><!--<img id="img_fullscreen" src="images/full_screen.png" />--></a>
						</div>
					</header>
					
					<section id="central_wrapper">

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
							<!--
							<div id="main_right_menu">
								<a href="javascript:void(0);" id="main_right_menu-openlink"
									title="Open menu"> + </a>
								<a href="javascript:void(0);" id="main_right_menu-closelink"
									title="Close menu"> - </a>
							</div>
							-->
							<xsl:if test="$image_frame=false()">
								<div id="main_left_arrow" onclick="UnInitialize()" title="Previous"/>
							</xsl:if>
							<div id="main_right_arrow" title="Next"/>
							<header id="right_header">
								<div id="text_menu">
									<span class="span_pp_select"><xsl:call-template
										name="pp_select_build">
										<xsl:with-param name="html_select_main"
											select="'html_select_main'"/>
									</xsl:call-template>
									</span>

									<span>
										<xsl:call-template name="ee_select_build" />
									</span>
									
									<form id="radio_edition" name="radio_edition_name">
										<xsl:call-template name="rm-loops_radio">
											<xsl:with-param name="rm_for">
												<xsl:value-of select="count($edition_array)"/>
											</xsl:with-param>
											<xsl:with-param name="rm_counter_test"
												>1</xsl:with-param>
											<xsl:with-param name="rm_object" select="$edition_array"
											/>
										</xsl:call-template>
									</form>
								</div>
							</header>
							<div id="text_cont">
								<div id="text_elem"/>
							</div>
						</div>
						
						
						<xsl:if test="$image_frame=true()">
							<div id="main_left_frame">
								<!--
								<div id="main_left_menu">
									<a href="javascript:void(0);" id="main_left_menu-openlink"
										title="Open menu"> + </a>
									<a href="javascript:void(0);" id="main_left_menu-closelink"
										title="Close menu"> - </a>
								</div>
								-->
								<div id="main_left_arrow" title="Previous"/>
								<header id="left_header">
									<div id="image_menu">
										<span class="span_pp_select"><xsl:call-template
											name="pp_select_build"/>
										</span>
										<p id="thumb_elem">
											<a href="javascript:void(0);" id="thumb_link"> Thumb
											</a>
										</p>
										<input type="image" src="images/zoom.png" id="switchZoom" value="zoom" onclick="zoomOn()"/>
										<input type="image" src="images/magOff.png" id="switchMag" value="mag" onclick="magOn()"/>
										<input type="image" src="images/ITLoff.png" id="switchITL" value="turn ITL on" title="Image text link" onclick="switchIMT()"/>
									</div>
								</header>
								<div id="image_cont">
									<div id="image_elem">
										<!--<img id="iviewerImage" src="images/null.jpg" />-->
									</div>
									<div id="mag_image_elem"></div>
									
									<div id="image_tool">
										<span id="spb">
											<a id="zoom_orig" class="zoom_btn"
													href="javascript:void(0);" title="100%"></a>
											<a id="zoom_fit" class="zoom_btn"
												href="javascript:void(0);" title="Fit to frame"
												>	</a>
											<a id="zoom_out" href="javascript:void(0);"></a>
											<div id="spb_cont">
												<div id="slider"/>
											</div>
											<a id="zoom_in" href="javascript:void(0);"></a>
										</span>
									</div>
									<input id="dimFit" type="hidden" value=""/>
									<input id="imgTit" type="hidden" value=""/>
									<div id="thumb_cont">
										<xsl:for-each select="//tei:pb">
											<figure>
												<img class="thumb_single" id="{@n}_small"
													src="data/input_data/images/{@n}_small.jpg"/>
												<figcaption>
													<xsl:value-of select="@n"/>
												</figcaption>
											</figure>
										</xsl:for-each>
									</div>									
								</div>
							</div>
						</xsl:if>
					</section>
					<section id="central_button">
						<div id="edval">
							<span>Edition</span>
						</div>
						<div id="central_page_number">
							<span>Folio: </span>
						</div>
						<div id="zval">
							<xsl:if test="$image_frame=true()">
								<span id="zvalint">Zoom: <span id="val">0</span>%</span>
								<span id="zvalopz"/>
							</xsl:if>
							<xsl:if test="$image_frame=false()">
								<span>No image</span>
							</xsl:if>
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
