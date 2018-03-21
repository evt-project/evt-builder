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
					<link rel="stylesheet" type="text/css" 
						href="{$html_path}/css/main.css"/>
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
					<link rel="stylesheet" type="text/css"
						href="{$html_path}/css/BRnav.css" />
				</xsl:when>
				<xsl:otherwise>
					<link rel="stylesheet" type="text/css" 
						href="{$html_path}/css/page_data-include-{$output}.css"/>
				</xsl:otherwise>
			</xsl:choose>
			<link rel="stylesheet" type="text/css" 
				href="{$html_path}/config/evt_builder-custom-styles.css"/>
			<xsl:comment>jQuery lib</xsl:comment>
			<script type="text/javascript" src="{$html_path}/js/jquery_lib/jquery-latest.js"/>
			<script type="text/javascript" src="{$html_path}/js/jquery_lib/jquery-ui-latest.js"/>
			<xsl:comment>/jQuery lib</xsl:comment>

			<xsl:if test="$html_tc!='datastructure'">
				<xsl:comment>main lib</xsl:comment>
				<xsl:comment>interface control</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_generic_bindings.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_global_menu.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_internal_fullscreen.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_lists.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_navigation.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_prefatory_matter.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_resizings.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_search.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_viewModes.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_viewVerses.js"/>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_main.js"/>
				<xsl:comment>/interface control</xsl:comment>
				<!-- Inserire qui file js per nuova modalità di visualizzazione-->
				
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
				
				<xsl:comment>BRnav</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_BRnav.js"/>
				<xsl:comment>/BRnav</xsl:comment>
				
				<xsl:comment>VisColl</xsl:comment>
				<script type="text/javascript" src="{$html_path}/js/main/interface_control/ic_viscoll.js"/>
				<xsl:comment>/VisColl</xsl:comment>
				
				<!-- Integrations by LS -->
				<script type="text/javascript" src="{$html_path}/js/plugin/jquery-lang.js"/>
				<script type="text/javascript" src="{$html_path}/config/langpack/en.js"/>
				<script type="text/javascript" src="{$html_path}/config/langpack/it.js"/>
				<script type="text/javascript" src="{$html_path}/config/langpack/fr.js"/>
				<script type="text/javascript" src="{$html_path}/config/langpack/de.js"/>
				<script type="text/javascript" src="{$html_path}/config/langpack/cs.js"/>
				<!-- /end Integration by LS -->
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
				<xsl:element name="section">
					<xsl:attribute name="id">central_wrapper</xsl:attribute>
					<xsl:if test="$bottom_navbar=true()">
						<xsl:attribute name="class">hasNavbar <xsl:value-of select="if($bottom_navbar_initial_status='expanded') then('navBarExpanded') else('navBarCollapsed')"/></xsl:attribute>
					</xsl:if>
					<div id="text_frame">
						<div id="text">
							<xsl:call-template name="edition_level">
								<xsl:with-param name="pb_n" select="$pb_n"/>
								<xsl:with-param name="edition_pos" select="$edition_pos"/>
							</xsl:call-template>
						</div>
					</div>
				</xsl:element>
			</body>
		</html>
	</xsl:template>

	
	<xsl:template name="index_build">
		<html lang="en-US">
			<xsl:call-template name="html_head">
				<xsl:with-param name="html_path" select="$mainPrefix"/>
			</xsl:call-template>
			<body>
				<xsl:if test="$prose_verses_toggler=true()">
					<xsl:attribute name="data-prose-verses-feature" select="'active'"/>
				</xsl:if>
				<xsl:element name="div">
					<xsl:attribute name="id" select="'global_wrapper'"/>
					<xsl:attribute name="data-image-extension" select="$imageExt"/>
					<div id="keyboard_shortcuts_cont" class="dialog" data-content="keyboard_shortcuts">
						<div id="keyboard_shortcuts" class="dialog_cont">
							<a href="javascript:void(0);" id="close_keyboard_shortcuts_cont" class="dialog_close" data-dialog="keyboard_shortcuts_cont" lang="def" title="CLOSE"><i class="fa fa-close"></i></a>
							<div class="title main" lang="def">KEYBOARD_SHORTCUTS</div>
							<div class="dialog_separator"><i class="fa fa-caret-down"></i></div>
							<div class="dialog_cont_inner">
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_OPEN_PROJECT_INFO</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">alt</span>+<span class="shortcuts_key">i</span></p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_SWITCH_MODE_VIEW</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">alt</span>+<span class="shortcuts_key">1</span> / <span class="shortcuts_key">alt</span>+<span class="shortcuts_key">2</span> / <span class="shortcuts_key">alt</span>+<span class="shortcuts_key">3</span> ...</p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_CHANGE_PAGE</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">←</span> and <span class="shortcuts_key">→</span></p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_CHANGE_DOC</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">↑</span> and <span class="shortcuts_key">↓</span></p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_GO_FULLSCREEN</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">ctrl/cmd</span>+<span class="shortcuts_key">alt</span>+<span class="shortcuts_key">shift</span>+<span class="shortcuts_key">f</span></p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_OPEN_SEARCH</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">ctrl/cmd</span>+<span class="shortcuts_key">alt</span>+<span class="shortcuts_key">f</span></p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_OPEN_PAGE_SELECTOR</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">alt</span>+<span class="shortcuts_key">p</span></p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_OPEN_TEXT_SELECTOR</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">alt</span>+<span class="shortcuts_key">t</span></p>
								</div>
								<div class="shortcuts_row">
									<p class="shortcuts_col_left"><span lang="def">KS_OPEN_EDITION_SELECTOR</span></p>
									<p class="shortcuts_col_right"><span class="shortcuts_key">alt</span>+<span class="shortcuts_key">e</span></p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="welcomeInfo_cont" class="dialog" data-content="welcomeInfo">
						<div id="welcomeInfo" class="dialog_cont">
							<a href="javascript:void(0);" id="close_welcome_info_cont" class="dialog_close" data-dialog="welcomeInfo_cont" title="CLOSE" lang="def">
								<i class="fa fa-close"></i>
							</a>
							<div id="welcomeInfo_content_top">
								<xsl:copy-of select="$welcomeMsg"/>		
							</div>	
							<div id="welcomeInfo_content_center">
								<i class="fa fa-caret-down"></i>
							</div>
							<div id="welcomeInfo_content_bottom">								
								<a href="javascript:void(0);" id="button_welcome_info_cont" class="closeDialog" data-dialog="welcomeInfo_cont" title="CLOSE" lang="def">
									<button class="button_welcome">start</button>
								</a>
								<div class="neverShowDiv">
									<input type="checkbox" checked="checked" class="neverShowAgain"/> <span lang="def">NEVER_SHOW_AGAIN</span>
								</div>
							</div>
						</div>
					</div>
					
					<div id="EVTinfo_cont" class="dialog" data-content="EVTinfo">
						<div id="EVTinfo" class="dialog_cont">
							<a href="javascript:void(0);" class="dialog_close" data-dialog="EVTinfo_cont" title="CLOSE" lang="def">
								<i class="fa fa-close"></i>
							</a>
							<div class="title main">Information about EVT</div>
							<div class="dialog_separator"><i class="fa fa-caret-down"></i></div>
							<div id="EVTinfo_content" class="dialog_cont_inner">
								<xsl:copy-of select="$evtTxt"/>	
							</div>
						</div>
					</div>
					
					<!-- Integration by AB -->
					<xsl:if test="$headerInfo=true()">
						<div id="headerInfo_cont" class="dialog" data-content="headerInfo"></div>
					</xsl:if>
					<!-- add by CDP -->
					<xsl:if test="tei:TEI/tei:text/tei:front/descendant::tei:listBibl or tei:TEI/tei:text/tei:back/descendant::tei:listBibl">
						<div id="generalBiblio_cont" class="dialog" data-content="generalBiblio">
							<div id="generalBiblio" class="dialog_cont">
								<a href="javascript:void(0);" class="dialog_close" data-dialog="generalBiblio_cont" title="CLOSE" lang="def">
									<i class="fa fa-close"></i>
								</a>
								<div class="title main" lang="def">BIBLIO</div>
								<div class="dialog_separator"><i class="fa fa-caret-down"></i></div>
									<div id="generalBiblio_content" class="dialog_cont_inner">
									<div>
										<xsl:if test="tei:TEI/tei:text/tei:front/descendant::tei:listBibl">
											<xsl:apply-templates select="tei:TEI/tei:text/tei:front/descendant::tei:listBibl"></xsl:apply-templates>
										</xsl:if>
										<xsl:if test="tei:TEI/tei:text/tei:back/descendant::tei:listBibl">
											<xsl:apply-templates select="tei:TEI/tei:text/tei:back/descendant::tei:listBibl"></xsl:apply-templates>
										</xsl:if>
									</div>
								</div>
							</div>
						</div>
					</xsl:if>
					<!-- /end Integration by AB -->
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
						<div id="cont_interface_tools">
							<div id="mode_switch">
								<xsl:if test="$image_frame=false()">
									<xsl:element name="a">
										<xsl:attribute name="href" select="'javascript:void(0);'"/>
										<xsl:attribute name="id" select="'txt_single'"/>
										<xsl:attribute name="class" select="'current_mode mode_view'"/>
										<xsl:attribute name="title" select="'MODE_SINGLE_TEXT'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<img src="images/txt-single.png" class="mainHeaderimg"/> 
									</xsl:element>
								</xsl:if>
								<xsl:if test="$image_frame=true()">
									<xsl:element name="a">
										<xsl:attribute name="href" select="'javascript:void(0);'"/>
										<xsl:attribute name="id" select="'txtimg_link'"/>
										<xsl:attribute name="class" select="'current_mode mode_view'"/>
										<xsl:attribute name="title" select="'MODE_IMAGE_TEXT'"/>
										<xsl:attribute name="lang" select="'def'"/>
									<img src="images/img-txt.png" class="mainHeaderimg"/>
										<!--<i class="fa evt-imgtxt"></i>-->
									</xsl:element>
								</xsl:if>

								<xsl:if test="count($edition_array) &gt; 1">
									<xsl:element name="a">
										<xsl:attribute name="href" select="'javascript:void(0);'"/>
										<xsl:attribute name="id" select="'txttxt_link'"/>
										<xsl:attribute name="class" select="'mode_view'"/>
										<xsl:attribute name="title" select="'MODE_TEXT_TEXT'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<img src="images/txt-txt.png" class="mainHeaderimg"/>
										<!--<i class="fa evt-txttxt"></i>-->
									</xsl:element>
								</xsl:if>
								<xsl:if test="$image_frame=true() and $double_view=true()">
									<xsl:element name="a">
										<xsl:attribute name="href" select="'javascript:void(0);'"/>
										<xsl:attribute name="id" select="'imgd_link'"/>
										<xsl:attribute name="class" select="'mode_view'"/>
										<xsl:attribute name="title" select="'MODE_BOOKREADER'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<img src="images/double-view.png" class="mainHeaderimg"/>
										<!--<i class="fa evt-bookreader"></i>-->
									</xsl:element>
								</xsl:if>
							</div>											
						
							<!-- Integration by AB -->
							<!--<xsl:if test="$headerInfo=true()">
								<xsl:element name="a">
									<xsl:attribute name="href" select="'javascript:void(0);'"/>
									<xsl:attribute name="id" select="'info_link'"/>
									<xsl:attribute name="title" select="'PROJECT_INFO'"/>
									<xsl:attribute name="lang" select="'def'"/>
									<i class="fa fa-info-circle"></i>
								</xsl:element>
							</xsl:if>-->
							<!-- /end Integration by AB -->
							
							<!-- Integration by LS -->
							<a href= "javascript:void(0);" id="settings_link" lang="def" title="SETTINGS"> 
								<i class="fa fa-navicon"></i>
							</a>	
							<!-- /end Integration by LS -->
							
							<xsl:element name="a" >
								<xsl:attribute name="href" select="'javascript:void(0);'"/>
								<xsl:attribute name="id" select="'main_fullscreen'"/>
								<xsl:attribute name="data-action" select="'go_fullscreen'"/>
								<xsl:attribute name="title" select="'GO_FULLSCREEN'"/>
								<xsl:attribute name="lang" select="'def'"/>
								<i class="fa fa-expand"></i>
							</xsl:element>
						</div>
					</header>
					<div id="settings_cont">
						<xsl:if test="$headerInfo=true()">
							<div class="setting_row button_like" id="info_link">
								<div class="setting_row_title">
									<i class="fa fa-info-circle"></i>
									<span lang="def">PROJECT_INFO</span>
								</div>
							</div>	
						</xsl:if>
						
						<div class="setting_row button_like" id="biblio_link">
							<div class="setting_row_title">
								<i class="fa fa-book"></i>
								<span lang="def">BIBLIO</span>
							</div>
						</div>	
						
						<div class="setting_row">
							<div class="setting_row_title"><i class="fa fa-language"></i><span lang="def">LANGUAGES</span>:</div>
							<div class="setting_row_content">
								<img src="images/en.gif" class="flag active" data-value="en" lang="def" title="ENGLISH" alt="ENG"/>
								<img src="images/fr.gif" class="flag" data-value="fr" lang="def" title="FRENCH" alt="FR"/>
								<img src="images/ita.gif" class="flag" data-value="it" lang="def" title="ITALIAN"  alt="ITA"/>
								<img src="images/de.png" class="flag" data-value="de" lang="def" title="GERMAN"  alt="GER"/>						<img src="images/cs.png" class="flag" data-value="cs" lang="def" title="CZECH"  alt="CZE"/>		
							</div>
						</div>	
						
						<div class="setting_row button_like" id="keyboard_shortcuts_link">
							<div class="setting_row_title">
								<i class="fa fa-keyboard-o"></i>
								<span lang="def">KEYBOARD_SHORTCUTS</span>
							</div>
						</div>
					</div>
					<xsl:element name="section">
						<xsl:attribute name="id">central_wrapper</xsl:attribute>
						<xsl:if test="$bottom_navbar=true()">
							<xsl:attribute name="class">hasNavbar <xsl:value-of select="if($bottom_navbar_initial_status='expanded') then('navBarExpanded') else('navBarCollapsed')"/></xsl:attribute>
						</xsl:if>
						<xsl:element name="i">
							<xsl:attribute name="class" select="'fa fa-caret-up'"/>
							<xsl:attribute name="id" select="'header_collapse'"/>
							<xsl:attribute name="data-action" select="'collapse'"/>
							<xsl:attribute name="title" select="'TOGGLE_MENU'"/>
							<xsl:attribute name="lang" select="'def'"/>
						</xsl:element>
						<xsl:element name="div">
							<xsl:attribute name="class" select="'main_left_arrow'"/>
							<xsl:attribute name="onclick" select="'UnInitialize()'"/>
							<xsl:attribute name="title" select="'PREVIOUS_PAGE'"/>
							<xsl:attribute name="lang" select="'def'"/>
						</xsl:element>
						<xsl:element name="div">
							<xsl:attribute name="class" select="'main_right_arrow'"/>
							<xsl:attribute name="title" select="'NEXT_PAGE'"/>
							<xsl:attribute name="lang" select="'def'"/>
						</xsl:element>
						
						<xsl:if test="$image_frame=true() or count($edition_array) &gt; 1">
							<xsl:variable name="viewStatus" select="if($image_frame=false()) then 'width:0px; border-left-width:0px; border-right-width:0px;' else ''"/>
							<div id="main_left_frame" class="main_frame" style="{$viewStatus}">
								<xsl:element name="i">
									<xsl:attribute name="class" select="'fa fa-caret-up go-full-left'"/>
									<xsl:attribute name="id" select="'goFullScreenLeft'"/>
									<xsl:attribute name="title" select="'EXPAND_FRAME'"/>
									<xsl:attribute name="lang" select="'def'"/>
								</xsl:element>
								<header id="left_header" class="top-menu">
									<xsl:element name="i">
										<xsl:attribute name="class" select="'fa fa-times-circle closeFullScreen'"/>
										<xsl:attribute name="id" select="'closeFullScreenLeft'"/>
										<xsl:attribute name="title" select="'COLLAPSE_FRAME'"/>
										<xsl:attribute name="lang" select="'def'"/>
									</xsl:element>
									<div id="left_menu">
										<xsl:if test="$pp_selector_pos='left'">
											<xsl:element name="span">
												<xsl:attribute name="id" select="'span_pp_select'"/>
												<xsl:attribute name="class">
													<xsl:value-of select="'like_select left_menu'"/>
													<xsl:if test="$pp_selector_doc_grouping=true()">
														<xsl:value-of select="' groupByDoc'"/>
													</xsl:if>
													<xsl:if test="$pp_selector_doc_tooltip=true()">
														<xsl:value-of select="' optionDocTooltip'"/>
													</xsl:if>
												</xsl:attribute>
												<xsl:attribute name="title" select="'SELECTOR_PAGE'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<xsl:call-template name="div_select_build">
													<xsl:with-param name="html_div_class" select="'main_pp_select'"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:if test="$double_view=true()">
											<span id="span_dd_select" class="like_select" lang="def" title="SELECTOR_DOUBLE_PAGE">
												<xsl:call-template name="div_select_build">
													<xsl:with-param name="html_div_class" select="'main_dd_select'"/>
												</xsl:call-template>
											</span>
											<span id="thumb_elem-add" class="iconButtons">
												<xsl:element name="a">
													<xsl:attribute name="href" select="'javascript:void(0);'"/>
													<xsl:attribute name="class" select="'thumb_link'"/>
													<xsl:attribute name="title" select="'THUMBNAILS'"/>
													<xsl:attribute name="lang" select="'def'"/>
													<span lang="def">THUMBS</span>
													<i class="fa fa-th"></i>
												</xsl:element>
											</span>
										</xsl:if>
										<xsl:if test="count($edition_array) &gt; 1">
											<xsl:element name="span">
												<xsl:attribute name="id" select="'span_ee_select-add'"/>
												<xsl:attribute name="class"> like_select <xsl:if test="$edition_level_selector=false()"> hidden</xsl:if>
												</xsl:attribute>
												<xsl:attribute name="title" select="'SELECTOR_EDITION_LEVEL'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<xsl:call-template name="div_select_build">
													<xsl:with-param name="html_div_class" select="'main_ee_select'"/>
												</xsl:call-template>
											</xsl:element>
											<xsl:if test="$regesto=true()">
												<xsl:element name="span">
													<xsl:attribute name="class" select="'imageTopTool mainButtons toggleReg'"/>
													<xsl:attribute name="id" select="'switchReg-add'"/>
													<xsl:attribute name="value" select="'reg'"/>
													<xsl:attribute name="title" select="'REGESTO_TITLE'"/>
													<xsl:attribute name="lang" select="'def'"/>
													<span lang="def">REGESTO</span>
													<i class="fa fa-toggle-off"></i>
												</xsl:element>
											</xsl:if>
											<xsl:if test="$frontInfo=true()">
												<xsl:element name="span">
													<xsl:attribute name="class" select="'imageTopTool mainButtons toggleFront'"/>
													<xsl:attribute name="id" select="'switchFront-add'"/>
													<xsl:attribute name="value" select="'info'"/>
													<xsl:attribute name="title" select="'INFORMATION_ABOUT_THIS_TEXT'"/>
													<xsl:attribute name="lang" select="'def'"/>
													<span lang="def">INFO</span>
													<i class="fa fa-info"></i>
												</xsl:element>
											</xsl:if>
										</xsl:if>
										<xsl:if test="$image_frame=true()">
											<div id="image_menu">
												<!-- Buttons for thumbs and Viscoll will appear only if Bottom Navbar is not active -->
												<xsl:if test="$bottom_navbar=false()">													
													<xsl:if test="$thumbs_button=true()">
														<xsl:element name="span">
															<xsl:attribute name="class" select="'imageTopTool mainButtons thumb_link'"/>
															<xsl:attribute name="id" select="'thumb_elem'"/>
															<xsl:attribute name="value" select="'th'"/>
															<xsl:attribute name="title" select="'THUMBNAILS'"/>
															<xsl:attribute name="lang" select="'def'"/>
															<span lang="def">THUMBS</span>
															<i class="fa fa-th"></i>
														</xsl:element>
													</xsl:if>
													<xsl:if test="$viscoll_button=true()">
														<xsl:element name="span">
															<xsl:attribute name="class" select="'imageTopTool mainButtons viscoll_link'"/>
															<xsl:attribute name="id" select="'viscoll'"/>
															<xsl:attribute name="title" select="'VISCOLL'"/>
															<span lang="def">VISCOLL</span>
															<i class="fa evt-viscoll"></i>
														</xsl:element>
													</xsl:if>
												</xsl:if>
												<xsl:if test="$mag_button=true()">
													<xsl:element name="span">
														<xsl:attribute name="class" select="'imageTopTool mainButtons'"/>
														<xsl:attribute name="id" select="'switchMag'"/>
														<xsl:attribute name="value" select="'mag'"/>
														<xsl:attribute name="onclick" select="'magOn()'"/>
														<xsl:attribute name="title" select="'MAGNIFIER_LENS'"/>
														<xsl:attribute name="lang" select="'def'"/>
														<span lang="def">MAGNIFIER</span>
														<i class="fa evt-magnifier"></i>
													</xsl:element>
												</xsl:if>
												<xsl:if test="$hs_button=true()">
													<xsl:element name="span">
														<xsl:attribute name="class" select="'imageTopTool mainButtons'"/>
														<xsl:attribute name="id" select="'switchHS'"/>
														<xsl:attribute name="value" select="'HS'"/>
														<xsl:attribute name="onclick" select="'switchHS()'"/>
														<xsl:attribute name="title" select="'HOT_SPOTS'"/>
														<xsl:attribute name="lang" select="'def'"/>
														<span lang="def">HOTSPOTS</span>
														<i class="fa fa-circle-o"></i>
													</xsl:element>
												</xsl:if>
												<xsl:if test="$txtimg_link_button=true()">
													<xsl:element name="span">
														<xsl:attribute name="class" select="'imageTopTool mainButtons'"/>
														<xsl:attribute name="id" select="'switchITL'"/>
														<xsl:attribute name="value" select="'turn ITL on'"/>
														<xsl:attribute name="onclick" select="'switchITL()'"/>
														<xsl:attribute name="title" select="'IMAGE_TEXT_LINK'"/>
														<xsl:attribute name="lang" select="'def'"/>
														<span lang="def">IMAGE_TEXT</span>
														<i class="fa fa-chain-broken"></i>
													</xsl:element>
												</xsl:if>
												
												<!-- Integration by AB -->
												<xsl:if test="$image_frame=true() and $msDesc=true()">
													<xsl:element name="span">
														<xsl:attribute name="id" select="'switch_msDesc'"/>
														<xsl:attribute name="title" select="'MANUSCRIPT_DESCRIPTION'"/>
														<xsl:attribute name="lang" select="'def'"/>
														<xsl:attribute name="class">mainButtons <xsl:if test="$left_frame_default_content='info'"> active</xsl:if></xsl:attribute>
														<span lang="def">MS_DESC</span>
														<xsl:element name="i">
															<xsl:attribute name="class" select="'fa fa-info-circle'"/>
														</xsl:element>
													</xsl:element>
												</xsl:if>
												<!-- /end Integration by AB -->										
											</div>
										</xsl:if>
									</div>
								</header>
								<xsl:if test="$search=true()">
									<div id="search_cont-add" class="collapsed bottomBox searchContainer">
										<div id="search_header-add" class="bottomBoxHeader">
											<xsl:element name="span">
												<xsl:attribute name="id" select="'toggle_search_cont-add'"/>
												<xsl:attribute name="class" select="'mainButtons small toggleSearchButton'"/>
												<xsl:attribute name="data-boxsuffix" select="'-add'"/>
												<xsl:attribute name="title" select="'TOGGLE_SEARCH'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<i class='fa fa-angle-double-up'></i>
											</xsl:element>
											<xsl:element name="span">
												<xsl:attribute name="id" select="'keyboard_link-add'"/>
												<xsl:attribute name="class">mainButtons small searchKeyboardButton <xsl:if test="$virtual_keyboard_search=false()"> hidden</xsl:if></xsl:attribute>
												<xsl:attribute name="data-boxsuffix" select="'-add'"/>
												<xsl:attribute name="title" select="'TOGGLE_KEYBOARD'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<xsl:element name="i">
													<xsl:attribute name="class">fa fa-keyboard-o</xsl:attribute>
												</xsl:element>
											</xsl:element>
											<div id="tipue_search_input_div-add">
												<input type="text" id="tipue_search_input-add"  class="searchInput" data-boxsuffix="-add"/>
												<xsl:element name="i">
													<xsl:attribute name="class" select="'fa fa-close clear_input'"/>
													<xsl:attribute name="title" select="'CLEAR_SEARCH'"/>
													<xsl:attribute name="lang" select="'def'"/>
												</xsl:element>
											</div>
											<xsl:element name="span">
												<xsl:attribute name="id" select="'start_search-add'"/>
												<xsl:attribute name="class" select="'mainButtons small searchStart'"/>
												<xsl:attribute name="data-boxsuffix" select="'-add'"/>
												<xsl:attribute name="title" select="'START_SEARCH'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<i class='fa fa-search'></i>
											</xsl:element>
										</div>
										<div id="search_sub_header-add" class="bottomBoxSubHeader">
											<div id="search_query-add" class="searchQuery"><span lang="def">ENTER_YOUR_QUERY_INTO_THE_SEARCH_BOX_ABOVE</span></div>
											<div id="search_results-add" class="searchResults can-change-font-size"></div>
										</div>
										<div id="search_cont_results-add" class="bottomBoxContent">
											<div id="tipue_search_content-add" class="searchResultsContent"></div>
										</div>
										<div id="search_foot-add" class="bottomBoxFooter"></div>
									</div>	
								</xsl:if>
								
								<xsl:if test="count($edition_array) &gt; 1">
									<!-- Text frame bottom menu -->
									<div id="text_tool-add" class="bottom-menu hidden">
										<xsl:if test="$prose_verses_toggler=true()">
											<xsl:element name="span">
												<xsl:attribute name="id" select="'toggleVersesProseBtn-add'"/>
												<xsl:attribute name="class" select="'mainButtons'"/>
												<xsl:attribute name="data-active-status" select="'prose'"/>
												<xsl:attribute name="data-boxsuffix" select="''"/>
												<xsl:attribute name="onclick" select="'toggleProseVerses(this)'"/>
												<xsl:attribute name="title" select="'versi/prosa'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<span lang="def">VERSES</span>
												<i class="fa fa-align-left" aria-hidden="true"></i>				
											</xsl:element>
										</xsl:if>
										<xsl:if test="$search=true()">
											<xsl:element name="span">
												<xsl:attribute name="id" select="'search_link-add'"/>
												<xsl:attribute name="class" select="'mainButtons searchButton'"/>
												<xsl:attribute name="data-boxsuffix" select="'-add'"/>
												<xsl:attribute name="title" select="'OPEN_SEARCH'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<span lang="def">SEARCH</span>
												<i class="fa fa-search"></i>
											</xsl:element>
										</xsl:if>
										<xsl:if test="count($lists) > 0">
											<xsl:element name="span">
												<xsl:attribute name="id" select="'span_list_select-add'"/>
												<xsl:attribute name="class" select="'like_select filter'"/>
												<xsl:attribute name="title" select="'SELECTOR_ENTITIES'"/>
												<xsl:attribute name="lang" select="'def'"/>
												<div class="main_list_select">
													<span data-value="none" class="label_selected" lang="def">NO_SELECTION</span>
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
																	<span lang="def"><xsl:value-of select="name(.)"/></span>
																</xsl:element>
															</xsl:if>
														</xsl:for-each>
														<div class="option" data-value="all" lang="def">SELECT_ALL</div>
														<div class="option" data-value="clear" lang="def">CLEAR_SELECTION</div>
													</div>
												</div>
											</xsl:element>	
										</xsl:if>
										
										<span class="mainButtons small font-size-controller" data-action="decrease" lang="def" title="DECREASE_FONT_SIZE">
											<i class="fa fa-font"></i>
											<i class="fa fa-minus"></i>
										</span>
										<span class="mainButtons small font-size-controller" data-action="increase" lang="def" title="INCREASE_FONT_SIZE">
											<i class="fa fa-font"></i>
											<i class="fa fa-plus"></i>
										</span>
									</div>
								</xsl:if>
								<xsl:if test="$image_frame=true()">
									<xsl:if test="$document_navigation=true()">
										<span id="inside_left_arrow-add" lang="def" title="PREVIOUS_DOCUMENT"><i class="fa fa-chevron-up"></i></span>
										<span id="inside_right_arrow-add" lang="def" title="NEXT_DOCUMENT"><i class="fa fa-chevron-down"></i></span>
									</xsl:if>
									<!-- Integration by AB -->
									<xsl:if test="$image_frame=true() and $msDesc=true()">
										<xsl:element name="div">
											<xsl:attribute name="id">msDesc_cont</xsl:attribute>
											<xsl:attribute name="class">inner_frame <xsl:if test="$left_frame_default_content='info'"> open</xsl:if></xsl:attribute>
										</xsl:element>
									</xsl:if>
									<!-- /end Integration by AB -->									
									
									<div id="image_cont" class="inner_frame">
										<div id="image_fade">
											<div id="image_elem"></div>
										</div>
										<div id="image_loading">
											<i class="fa fa-refresh fa-spin"></i>
										</div>
										<div id="mag_image_elem"></div>
										
										<div id="image_tool" class="bottom-menu">
											<div id="spb">
												<xsl:element name="a">
													<xsl:attribute name="id" select="'zoom_orig'"/>
													<xsl:attribute name="class" select="'zoom_btn'"/>
													<xsl:attribute name="href" select="'javascript:void(0);'"/>
													<xsl:attribute name="title" select="'100%'"/>
													<xsl:attribute name="lang" select="'def'"/>
													<i class="evt-zoom1"></i>
												</xsl:element>
												<xsl:element name="a">
													<xsl:attribute name="id" select="'zoom_fit'"/>
													<xsl:attribute name="class" select="'zoom_btn'"/>
													<xsl:attribute name="href" select="'javascript:void(0);'"/>
													<xsl:attribute name="title" select="'FIT_TO_FRAME'"/>
													<xsl:attribute name="lang" select="'def'"/>
													<i class="fa evt-zoomfit"></i>
												</xsl:element>
												<xsl:element name="a">
													<xsl:attribute name="id" select="'zoom_out'"/>
													<xsl:attribute name="class" select="'zoom_btn'"/>
													<xsl:attribute name="href" select="'javascript:void(0);'"/>
													<xsl:attribute name="title" select="'ZOOM_OUT'"/>
													<xsl:attribute name="lang" select="'def'"/>
													<i class="fa evt-zoomminus"></i>
												</xsl:element>
												<div id="spb_cont">
													<div id="slider"/>
												</div>
												<xsl:element name="a">
													<xsl:attribute name="id" select="'zoom_in'"/>
													<xsl:attribute name="class" select="'zoom_btn'"/>
													<xsl:attribute name="href" select="'javascript:void(0);'"/>
													<xsl:attribute name="title" select="'ZOOM_IN'"/>
													<xsl:attribute name="lang" select="'def'"/>
													<i class="fa evt-zoomplus"></i>
												</xsl:element>
											</div>
											<div id="zval">
												<xsl:if test="$image_frame=true()">
													<span id="zvalint"><span id="val">0</span>%</span>
													<span id="zvalopz"/>
												</xsl:if>
												<xsl:if test="$image_frame=false()">
													<span lang="def">NO_IMAGE</span>
												</xsl:if>
											</div>
										</div>
										<input id="dimFit" type="hidden" value=""/>
										<input id="imgTit" type="hidden" value=""/>
										<div id="thumb_cont" class="inner_frame"></div>									
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
						
						
						<div id="{$id_right_frame}" class="main_frame">
							<xsl:element name="i">
								<xsl:attribute name="class" select="'fa fa-caret-up go-full-right'"/>
								<xsl:attribute name="id" select="'goFullScreenRight'"/>
								<xsl:attribute name="title" select="'EXPAND_FRAME'"/>
								<xsl:attribute name="lang" select="'def'"/>
							</xsl:element>
							<header id="right_header" class="top-menu">
								<div id="right_menu">
									<xsl:element name="span">
										<xsl:attribute name="id" select="'span_tt_select'"/>
										<xsl:attribute name="class" select="'like_select'"/>
										<xsl:attribute name="title" select="'SELECTOR_TEXT'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<xsl:call-template name="div_select_build">
											<xsl:with-param name="html_div_class" select="'main_tt_select'"/>
										</xsl:call-template>
									</xsl:element>
									<xsl:if test="$pp_selector_pos='right'">
										<xsl:element name="span">
											<xsl:attribute name="id" select="'span_pp_select'"/>
											<xsl:attribute name="class">
												<xsl:value-of select="'like_select right_menu'"/>
												<xsl:if test="$pp_selector_doc_grouping=true()">
													<xsl:value-of select="' groupByDoc'"/>
												</xsl:if>
												<xsl:if test="$pp_selector_doc_tooltip=true()">
													<xsl:value-of select="' optionDocTooltip'"/>
												</xsl:if>
											</xsl:attribute>
											<xsl:attribute name="title" select="'SELECTOR_PAGE'"/>
											<xsl:attribute name="lang" select="'def'"/>
											<xsl:call-template name="div_select_build">
												<xsl:with-param name="html_div_class" select="'main_pp_select'"/>
											</xsl:call-template>
										</xsl:element>
									</xsl:if>
									<xsl:element name="span">
										<xsl:attribute name="id" select="'span_ee_select'"/>
										<xsl:attribute name="title" select="'SELECTOR_EDITION_LEVEL'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<xsl:attribute name="class">like_select <xsl:if test="$edition_level_selector=false()"> hidden </xsl:if></xsl:attribute>
										<xsl:call-template name="div_select_build">
											<xsl:with-param name="html_div_class" select="'main_ee_select'"/>
										</xsl:call-template>
									</xsl:element>
									<!-- MODIFIED BY FS -->
									
									<xsl:if test="$regesto=true()">
										<xsl:element name="span">
											<xsl:attribute name="class">
												imageTopTool mainButtons toggleReg <xsl:if test="$right_frame_default_content='info'">active</xsl:if></xsl:attribute>
											<xsl:attribute name="id" select="'switchReg'"/>
											<xsl:attribute name="value" select="'reg'"/>
											<xsl:attribute name="title" select="'REGESTO'"/>
											<xsl:attribute name="lang" select="'def'"/>
											<span lang="def">REGESTO</span>
											<i class="fa fa-toggle-on"></i>
										</xsl:element>
									</xsl:if>
									<xsl:if test="$frontInfo=true()">
										<xsl:element name="span">
											<xsl:attribute name="class">imageTopTool mainButtons toggleFront <xsl:if test="$right_frame_default_content='info'">active</xsl:if></xsl:attribute>
											<xsl:attribute name="id" select="'switchFront'"/>
											<xsl:attribute name="value" select="'reg'"/>
											<xsl:attribute name="title" select="'INFORMATION_ABOUT_THIS_TEXT'"/>
											<xsl:attribute name="lang" select="'def'"/>
											<span lang="def">INFO</span>
											<i class="fa fa-info-circle"></i>
										</xsl:element>
									</xsl:if>
								</div>
								<xsl:element name="i">
									<xsl:attribute name="class" select="'fa fa-times-circle closeFullScreen'"/>
									<xsl:attribute name="id" select="'closeFullScreenRight'"/>
									<xsl:attribute name="title" select="'COLLAPSE_FRAME'"/>
									<xsl:attribute name="lang" select="'def'"/>
								</xsl:element>
							</header>
							<xsl:if test="$regesto=true()">
								<xsl:element name="div">
									<xsl:attribute name="id" select="'regesto_cont'"/>
									<xsl:attribute name="class">text-box can-change-font-size inner_frame <xsl:if test="$right_frame_default_content='info'"> open</xsl:if></xsl:attribute>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$frontInfo=true()">
								<xsl:element name="div">
									<xsl:attribute name="id" select="'front_cont'"/>
									<xsl:attribute name="class">text-box can-change-font-size inner_frame <xsl:if test="$right_frame_default_content='info'"> open</xsl:if></xsl:attribute>
								</xsl:element>
							</xsl:if>
							<div id="text_cont" class="text-box can-change-font-size inner_frame">
								<div id="text_elem">
									<div id="front_frame"></div>
									<div id="text_frame"></div>
								</div>
							</div>
							<xsl:if test="$search=true()">
								<div id="search_cont" class="collapsed bottomBox searchContainer">
									<div id="search_header" class="bottomBoxHeader">
										<xsl:element name="span">
											<xsl:attribute name="id" select="'toggle_search_cont'"/>
											<xsl:attribute name="class" select="'mainButtons small toggleSearchButton'"/>
											<xsl:attribute name="data-boxsuffix" select="''"/>
											<xsl:attribute name="title" select="'TOGGLE_SEARCH'"/>
											<xsl:attribute name="lang" select="'def'"/>
											<i class='fa fa-angle-double-up'></i>
										</xsl:element>
										<xsl:element name="span">
											<xsl:attribute name="id" select="'keyboard_link'"/>
											<xsl:attribute name="class">mainButtons small searchKeyboardButton <xsl:if test="$virtual_keyboard_search=false()"> hidden</xsl:if></xsl:attribute>
											<xsl:attribute name="data-boxsuffix" select="''"/>
											<xsl:attribute name="title" select="'TOGGLE_KEYBOARD'"/>
											<xsl:attribute name="lang" select="'def'"/>
											<xsl:element name="i">
												<xsl:attribute name="class">fa fa-keyboard-o</xsl:attribute>
											</xsl:element>
										</xsl:element>
										<div id="tipue_search_input_div">
											<input type="text" id="tipue_search_input"  class="searchInput" data-boxsuffix=""/>
											<xsl:element name="i">
												<xsl:attribute name="class" select="'fa fa-close clear_input'"/>
												<xsl:attribute name="title" select="'CLEAR_SEARCH'"/>
												<xsl:attribute name="lang" select="'def'"/>
											</xsl:element>
										</div>
										<xsl:element name="span">
											<xsl:attribute name="id" select="'start_search'"/>
											<xsl:attribute name="class" select="'mainButtons small searchStart'"/>
											<xsl:attribute name="data-boxsuffix" select="''"/>
											<xsl:attribute name="title" select="'START_SEARCH'"/>
											<xsl:attribute name="lang" select="'def'"/>
											<i class='fa fa-search'></i>
										</xsl:element>
									</div>
									<div id="search_sub_header" class="bottomBoxSubHeader">
										<div id="search_query" class="searchQuery"><span lang="def">ENTER_YOUR_QUERY_INTO_THE_SEARCH_BOX_ABOVE</span></div>
										<div id="search_results" class="searchResults"></div>
									</div>
									<div id="search_cont_results" class="bottomBoxContent">
										<div id="tipue_search_content" class="searchResultsContent can-change-font-size"></div>
									</div>
									<div id="search_foot" class="bottomBoxFooter"></div>
								</div>	
							</xsl:if>
							
							<div id="lists_cont" class="bottomBox">
								<div id="list_header" class="bottomBoxHeader">
									<xsl:element name="span">
										<xsl:attribute name="id" select="'toggle_list_cont'"/>
										<xsl:attribute name="class" select="'mainButtons small'"/>
										<xsl:attribute name="title" select="'TOGGLE_LISTS'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<i class='fa fa-angle-double-down'></i>
									</xsl:element>
									<div id="list_header_elements">
										<div id="list_header_elements_contents"></div>	
									</div>
									<span id="navListHeadersLx" class="mainButtons small no-margin"><i class='fa fa-angle-left'></i></span>
									<span id="navListHeadersRx" class="mainButtons small"><i class='fa fa-angle-right'></i></span>
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
									<span class="list_filter" data-filter-type="first_letter" data-value="J">J</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="K">K</span>
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
									<span class="list_filter" data-filter-type="first_letter" data-value="W">W</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="X">X</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="Y">Y</span>
									<span class="list_filter" data-filter-type="first_letter" data-value="Z">Z</span>
									<span lang="def" class="list_filter" data-filter-type="first_letter" data-value="*">ALL</span>
								</div>
								<div id="list_tools" class="bottomBoxContent">
									<xsl:call-template name="sortOptions"></xsl:call-template>
								</div>
							</div>
							
							<xsl:if test="$document_navigation=true()">
								<xsl:element name="span">
									<xsl:attribute name="id" select="'inside_left_arrow'"/>
									<xsl:attribute name="title" select="'PREVIOUS_DOCUMENT'"/>
									<xsl:attribute name="lang" select="'def'"/>
									<i class="fa fa-chevron-up"></i>
								</xsl:element>
								<xsl:element name="span">
									<xsl:attribute name="id" select="'inside_right_arrow'"/>
									<xsl:attribute name="title" select="'NEXT_DOCUMENT'"/>
									<xsl:attribute name="lang" select="'def'"/>
									<i class="fa fa-chevron-down"></i>
								</xsl:element>
							</xsl:if>
							<!-- Text frame bottom menu -->
							<div id="text_tool" class="bottom-menu">
								<xsl:if test="$prose_verses_toggler=true()">
									<xsl:element name="span">
										<xsl:attribute name="id" select="'toggleVersesProseBtn'"/>
										<xsl:attribute name="class" select="'mainButtons'"/>
										<xsl:attribute name="data-active-status" select="'prose'"/>
										<xsl:attribute name="data-boxsuffix" select="''"/>
										<xsl:attribute name="onclick" select="'toggleProseVerses(this)'"/>
										<xsl:attribute name="title" select="'versi/prosa'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<span lang="def">Versi</span>
										<i class="fa fa-align-left" aria-hidden="true"></i>				
									</xsl:element>
								</xsl:if>
								<xsl:if test="$search=true()">
									<xsl:element name="span">
										<xsl:attribute name="id" select="'search_link'"/>
										<xsl:attribute name="class" select="'mainButtons searchButton'"/>
										<xsl:attribute name="data-boxsuffix" select="''"/>
										<xsl:attribute name="title" select="'OPEN_SEARCH'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<span lang="def">SEARCH</span>
										<i class="fa fa-search"></i>
									</xsl:element>
								</xsl:if>
								<xsl:if test="$list_person=true() or $list_place=true() or $list_org=true() or $list_term=true() or $list_gloss=true() or $list_doc=true()">
									<xsl:element name="span">
										<xsl:attribute name="id" select="'list_link'"/>
										<xsl:attribute name="class" select="'mainButtons'"/>
										<xsl:attribute name="title" select="'OPEN_LISTS'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<span lang="def">LISTS</span>
										<i class="fa fa-list"></i>
									</xsl:element>
								</xsl:if>
								<xsl:if test="count($lists) > 0">
									<xsl:element name="span">
										<xsl:attribute name="id" select="'span_list_select'"/>
										<xsl:attribute name="class" select="'like_select filter'"/>
										<xsl:attribute name="title" select="'SELECTOR_ENTITIES'"/>
										<xsl:attribute name="lang" select="'def'"/>
										<div class="main_list_select">
											<span data-value="none" class="label_selected" lang="def">NO_SELECTION</span>
											<div class="open_select open_up">
												<i class="fa fa-sort-asc"></i>
											</div>
											<div class="option_container up">
												<xsl:for-each select="$lists">
													<xsl:element name="div">
														<xsl:attribute name="class">option </xsl:attribute>
														<xsl:attribute name="data-value"><xsl:value-of select="name(.)"/></xsl:attribute>
														<i class="fa fa-circle filter_color"></i>
														<span lang="def"><xsl:value-of select="name(.)"/></span>
													</xsl:element>
												</xsl:for-each>
												<div class="option" data-value="all" lang="def">SELECT_ALL</div>
												<div class="option" data-value="clear" lang="def">CLEAR_SELECTION</div>
											</div>
										</div>
									</xsl:element>
								</xsl:if>
								<span class="mainButtons small font-size-controller" data-action="decrease" title="DECREASE_FONT_SIZE" lang="def">
									<i class="fa fa-font"></i>
									<i class="fa fa-minus"></i>
								</span>
								<span class="mainButtons small font-size-controller" data-action="increase" title="INCREASE_FONT_SIZE" lang="def">
						<i class="fa fa-font"></i>
						<i class="fa fa-plus"></i>
							</span> 
						</div>
				</div>
					</xsl:element>
					
					
					<section id="central_button">
						<input id="folio_page_number" type="hidden" value=""/>
					</section>
					<div id="poweredBy">Powered by EVT <xsl:value-of select="$evtVersion"/></div>
					<!-- Creo il div che conterrà la barra di navigazione -->
					<xsl:if test="$bottom_navbar=true()">						
						<xsl:element name="div">
							<xsl:attribute name="id">BRnav</xsl:attribute>
							<xsl:attribute name="class"><xsl:value-of select="$bottom_navbar_initial_status"/></xsl:attribute>
								<div class="leftSideButtons">
									<!-- Sposto l'icona Thumbnails -->
									<xsl:if test="$thumbs_button=true()">
										<xsl:element name="span">
											<xsl:attribute name="class" select="'imageTopTool mainButtons thumb_link'"/>
											<xsl:attribute name="id" select="'thumb_elem'"/>
											<xsl:attribute name="value" select="'th'"/>
											<xsl:attribute name="title" select="'THUMBNAILS'"/>
											<!--<xsl:attribute name="lang" select="'def'"/>
											<span lang="def">THUMBS</span>-->
											<i class="fa fa-th"></i>
										</xsl:element>
									</xsl:if>
									<xsl:if test="$viscoll_button=true()">
										<xsl:element name="button">
											<xsl:attribute name="id" select="'viscoll'"/>
											<xsl:attribute name="class" select="'viscoll_link'"/>
											<xsl:attribute name="title" select="'VISCOLL'"/>
										</xsl:element>
									</xsl:if>
								</div>
								<div id="BRnavpos">
									<div id="BRpager">
									</div>
								</div>
								<!-- Conterrà la pagina sul totale -->
								<div id="pagenum">
								</div>
								<!-- Creo le icone per navigare  -->
								<div id="BRpage">
									<xsl:element name="button">
										<xsl:attribute name="id" select="'BRicon_book_left'"/>
										<i class="fa fa-arrow-left fa-lg"></i>
									</xsl:element>
									<xsl:element name="button">
										<xsl:attribute name="id" select="'BRicon_book_right'"/>
										<i class="fa fa-arrow-right fa-lg"></i>
									</xsl:element>
								</div>
								<!-- Pulsante per ridurre la barra -->
								<xsl:element name="div">
									<xsl:attribute name="id">BRnavCntlBtm</xsl:attribute>
									<xsl:attribute name="class">BRnavCntl <xsl:value-of select="if($bottom_navbar_initial_status='expanded') then('BRdn') else('BRup')"/></xsl:attribute>
									<xsl:element name="i">
										<xsl:attribute name="class">fa <xsl:value-of select="if($bottom_navbar_initial_status='expanded') then('fa-caret-down fa-lg') else('fa-caret-up fa-lg')"/></xsl:attribute>
									</xsl:element>
								</xsl:element>
						</xsl:element>
					</xsl:if>
					<footer>
						<p>2012 - 2015 @ EVT team – University of Pisa</p>
					</footer>
				</xsl:element>
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
