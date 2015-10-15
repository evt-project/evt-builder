<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">
	
	<xd:doc type="stylesheet">
		<xd:short>
			EN: This file collects variables for the labels texts of the interface
			IT: Questo file è una collezione di variabili configurabili, che vengono utilizzati negli altri moduli per la generazione dei testi delle etichette.
		</xd:short>
	</xd:doc>
	
	<xsl:variable name="noImage_alert_msg" select="'No Image'"/>
	
	<!-- ####### -->
	<!-- BUTTONS -->
	<!-- ####### -->
	
	<xsl:variable name="single_text_mode_title" select="'Single Text mode'"/>
	<xsl:variable name="image_text_mode_title" select="'Image|Text mode'"/>
	<xsl:variable name="text_text_mode_title" select="'Text|Text mode'"/>
	<xsl:variable name="bookreader_mode_title" select="'Bookreader mode'"/>
	<xsl:variable name="teiHeader_button_title" select="'Project Info'"/>
	<xsl:variable name="goFullscreen_button_title" select="'Fullscreen'"/>
	<xsl:variable name="toggleMenu_button_title" select="'Toggle menu'"/>
	<xsl:variable name="previousPage_button_title" select="'Previous Folio'"/>
	<xsl:variable name="nextPage_button_title" select="'Next Folio'"/>
	<xsl:variable name="previousText_button_title" select="'Previous Text'"/>
	<xsl:variable name="nextText_button_title" select="'Next Text'"/>
	
	<xsl:variable name="expandFrame_button_title" select="'Expand Frame'"/>
	<xsl:variable name="collapseFrame_button_title" select="'Collapse Frame'"/>
	<xsl:variable name="pp_selector_title" select="'Folio'"/>
	<xsl:variable name="tt_selector_title" select="'Text'"/>
	<xsl:variable name="ee_selector_title" select="'Edition Level'"/>
	
	<xsl:variable name="thumbs_button_label" select="'Thumbs'"/>
	<xsl:variable name="thumbs_button_title" select="'Thumbnails'"/>
	
	<xsl:variable name="magnifier_button_label" select="'Magnifier'"/>
	<xsl:variable name="magnifier_button_title" select="'Magnifying lens'"/>
	
	<xsl:variable name="hs_button_label" select="'HotSpot'"/>
	<xsl:variable name="hs_button_title" select="'Hot spot'"/>
	
	<xsl:variable name="itl_button_label" select="'TextLink'"/>
	<xsl:variable name="itl_button_title" select="'Image-Text link'"/>

	<xsl:variable name="fitToFrame_button_title" select="'Fit To Frame'"/>
	<xsl:variable name="zoomOut_button_title" select="'Zoom Out'"/>
	<xsl:variable name="zoomIn_button_title" select="'Zoom In'"/>
	
	<!-- ###### -->
	<!-- SEARCH -->
	<!-- ###### -->
	<xsl:variable name="search_button_label" select="'Search'"/>
	<xsl:variable name="search_button_title" select="'Search'"/>
	<xsl:variable name="toggleSearch_button_title" select="'Toggle Search'"/>
	<xsl:variable name="toggleKeyboard_button_title" select="'Toggle Keyboard'"/>
	<xsl:variable name="clearSearch_button_title" select="'Clear Search'"/>
	<xsl:variable name="startSearch_button_title" select="'Start Search'"/>
	<xsl:variable name="emptySearchAlertMsg" select="'Enter your query into the search box above!'"/>
	
	<!-- ##### -->
	<!-- LISTS -->
	<!-- ##### -->
	<xsl:variable name="entitiesSelector_title" select="'Entities'"/>
	<xsl:variable name="noSelection_label" select="'No selection'"/>
	<xsl:variable name="selectAll_label" select="'Select All'"/>
	<xsl:variable name="clearSelection_label" select="'Clear selection'"/>
	
	<xsl:variable name="toggleLists_button_title" select="'Toggle Lists'"/>
	<xsl:variable name="lists_button_label" select="'Lists'"/>
	<xsl:variable name="lists_button_title" select="'Lists'"/>
	
	<!-- EN: Label and title for button of Regesto -->
	<!-- IT: Testo etichetta per il pulsante del Regesto e il valore del suo attributo title -->
	<!-- default: 'Regesto' -->
	<xsl:variable name="regesto_button_label" select="'Regesto'"/>
	<xsl:variable name="regesto_button_title" select="'Regesto'"/>
	
	<!-- EN: Label and title for button of Front -->
	<!-- IT: Testo etichetta per il pulsante del Front e il valore del suo attributo title -->
	<!-- default: 'Front' -->
	<xsl:variable name="front_button_label" select="'Front'"/>
	<xsl:variable name="front_button_title" select="'Front'"/>
	
	<!-- EN: Label and title for button of MsDesc -->
	<!-- IT: Testo etichetta per il pulsante del msDesc e il valore del suo attributo title -->
	<!-- default: 'Front' -->
	<xsl:variable name="msDesc_button_label" select="'MS Info'"/>
	<xsl:variable name="msDesc_button_title" select="'Manuscript Information'"/>
	
	<!-- EN: Customize persons list label -->
	<!-- IT: Personalizza etichetta lista persone -->
	<!-- default: Persons List -->
	<xsl:param name="list_person_label" select="'List of People'"/>
	
	<!-- EN: Customize places list label -->
	<!-- IT: Personalizza etichetta lista luoghi -->
	<!-- default: Places List -->
	<xsl:param name="list_place_label" select="'List of Places'"/>
	
	<!-- ########################### -->
	<!-- HEADER INFO SECTIONS LABELS -->
	<!-- ########################### -->
	
	<!-- author -->
	<!-- default: 'Text author:' -->
	<xsl:param name="hi_author_section_label" select="'Text author'"/>
	
	<!-- principal -->
	<!-- default: 'Principal investigator:' -->
	<xsl:param name="hi_principal_section_label" select="'Principal investigator'"/>
	
	<!-- publicationStmt-->
	<!-- default: 'Publication information' -->
	<xsl:param name="hi_publicationStmt_section_label" select="'Publication information'"/>
	
	<!-- publisher -->
	<!-- default: 'Publisher:' -->
	<xsl:param name="hi_publisher_section_label" select="'Publisher'"/>
	
	<!-- pubPlace -->
	<!-- default: 'Publication Place:' -->
	<xsl:param name="hi_pubPlace_section_label" select="'Publication place'"/>
	
	<!-- date -->
	<!-- default: 'Date:' -->
	<xsl:param name="hi_date_section_label" select="'Date'"/>
	
	<!-- availability -->
	<!-- default: 'Availability:' -->
	<xsl:param name="hi_availability_section_label" select="'Availability'"/>
	
	<!-- editionStmt -->
	<!-- default: 'Text edition:' -->
	<xsl:param name="hi_editionStmt_section_label" select="'Text edition'"/>
	
	<!-- edition -->
	<!-- default: 'Edition:' -->
	<xsl:param name="hi_edition_section_label" select="'Edition'"/>
	
	<!-- encodingDesc -->
	<!-- default: 'Encoding description:' -->
	<xsl:param name="hi_encodingDesc_section_label" select="'Encoding description'"/>
	
	<!-- projectDesc -->
	<!-- default: 'Description:' -->
	<xsl:param name="hi_projectDesc_section_label" select="'Description'"/>
	
	<!-- correction -->
	<!-- default: 'Corrections:' -->
	<xsl:param name="hi_correction_section_label" select="'Corrections'"/>
	
	<!-- normalization -->
	<!-- default: 'Normalization:' -->
	<xsl:param name="hi_normalization_section_label" select="'Normalization'"/>
	
	
	<!-- segmentation -->
	<!-- default: 'Text segmentation:' -->
	<xsl:param name="hi_segmentation_section_label" select="'Text segmentation'"/>
	
	<!-- hyphenation -->
	<!-- default: 'Hyphenation:' -->
	<xsl:param name="hi_hyphenation_section_label" select="'Hyphenation'"/>
	
	<!-- samplingDecl -->
	<!-- default: 'Sampling methods:' -->
	<xsl:param name="hi_samplingDecl_section_label" select="'Sampling methods'"/>
	
	<!-- profileDesc -->
	<!-- default: 'Text description' -->
	<xsl:param name="hi_profileDesc_section_label" select="'Text description'"/>
	
	<!-- langUsage -->
	<!-- default: 'Language:' -->
	<xsl:param name="hi_language_section_label" select="'Language'"/>
	
	<!-- textClass -->
	<!-- default: 'Text classification:' -->
	<xsl:param name="hi_textClass_section_label" select="'Text classification'"/>
	
	<!-- revisionDesc -->
	<!-- default: 'Revisions' -->
	<xsl:param name="hi_revisionDesc_section_label" select="'Revisions'"/>
	
	<!-- ####################### -->
	<!-- MS DESC SECTIONS LABELS -->
	<!-- ####################### -->
	<!-- msIdentifier -->
	<!-- default: 'Current location' -->
	<xsl:param name="msd_msIdentifier_section_label" select="'Current location'"/>
	
	<!-- repository -->
	<!-- default: 'Location' -->
	<xsl:param name="msd_repository_section_label" select="'Location'"/>
	
	<!-- collection -->
	<!-- default: 'Collection' -->
	<xsl:param name="msd_collection_section_label" select="'Collection'"/>
	
	<!-- idno -->
	<!-- default: 'Code' -->
	<xsl:param name="msd_idno_section_label" select="'Code'"/>
	
	<!-- msName -->
	<!-- default: 'Name' -->
	<xsl:param name="msd_msName_section_label" select="'Name'"/>
	
	<!-- msContents -->
	<!-- default: 'Contents' -->
	<xsl:param name="msd_msContents_section_label" select="'Contents'"/>
	
	<!-- msContent summary -->
	<!-- default: 'Summary' -->
	<xsl:param name="msd_msContent_summary_section_label" select="'Summary'"/>
	
	<!-- textLang -->
	<!-- default: 'Language' -->
	<xsl:param name="msd_textLang_section_label" select="'Language'"/>
	
	<!-- msItems -->
	<!-- default: 'Texts' -->
	<xsl:param name="msd_msItems_section_label" select="'Texts'"/>
	
	<!-- incipit -->
	<!-- default: 'Incipit' -->
	<xsl:param name="msd_incipit_section_label" select="'Incipit'"/>
	
	<!-- explicit -->
	<!-- default: 'Explicit' -->
	<xsl:param name="msd_explicit_section_label" select="'Explicit'"/>
	
	<!-- physDesc -->
	<!-- default: 'Physical description' -->
	<xsl:param name="msd_physDesc_section_label" select="'Physical description'"/>
	
	<!-- support -->
	<!-- default: 'Material' -->
	<xsl:param name="msd_support_section_label" select="'Material'"/>
	
	<!-- extent -->
	<!-- default: 'Extent' -->
	<xsl:param name="msd_extent_section_label" select="'Extent'"/>
	
	<!-- collation -->
	<!-- default: 'Collation' -->
	<xsl:param name="msd_collation_section_label" select="'Collation'"/>
	
	<!-- condition -->
	<!-- default: 'Condition' -->
	<xsl:param name="msd_condition_section_label" select="'Condition'"/>
	
	<!-- foliation -->
	<!-- default: 'Pages numbering' -->
	<xsl:param name="msd_foliation_section_label" select="'Pages numbering'"/>
	
	<!-- general support description -->
	<!-- default: 'Support description' -->
	<xsl:param name="msd_general_supportDesc_section_label" select="'Support description'"/>
	
	<!-- layout -->
	<!-- default: 'Layout' -->
	<xsl:param name="msd_layout_section_label" select="'Layout'"/>
	
	<!-- layoutDesc summary -->
	<!-- default: 'Overview' -->
	<xsl:param name="msd_layoutDesc_summary_section_label" select="'Overview'"/>
	
	<!-- handDesc -->
	<!-- default: 'Writing' -->
	<xsl:param name="msd_handDesc_section_label" select="'Writing'"/>
	 
	<!-- decoDesc -->
	<!-- default: 'Decoration' -->
	<xsl:param name="msd_decoDesc_section_label" select="'Decoration'"/>
	
	<!-- history -->
	<!-- default: 'Manuscript history' -->
	<xsl:param name="msd_history_section_label" select="'Manuscript history'"/>
	
	<!-- history summary -->
	<!-- default: 'Summary' -->
	<xsl:param name="msd_history_summary_section_label" select="'Summary'"/>
	
	<!-- origin -->
	<!-- default: 'Origin' -->
	<xsl:param name="msd_origin_section_label" select="'Origin'"/>
	
	<!-- acquisition -->
	<!-- default: 'Acquisition' -->
	<xsl:param name="msd_acquisition_section_label" select="'Acquisition'"/>
	
	<!-- provenance -->
	<!-- default: 'Provenance' -->
	<xsl:param name="msd_provenance_section_label" select="'Provenance'"/>
	
	<!-- adminInfo -->
	<!-- default: 'Additional informations' -->
	<xsl:param name="msd_adminInfo_section_label" select="'Additional informations'"/>
	
	<!-- surrogates -->
	<!-- default: 'Additional materials' -->
	<xsl:param name="msd_surrogates_section_label" select="'Additional materials'"/> 
</xsl:stylesheet>
