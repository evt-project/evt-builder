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
	
	<!-- ####### -->
	<!-- BUTTONS -->
	<!-- ####### -->

	<!-- EN: Label for button of Regesto -->
	<!-- IT: Testo etichetta per il pulsante del Regesto -->
	<!-- default: 'Regesto' -->
	<xsl:variable name="regesto_button_label" select="'Regesto'"/>
	
	<!-- EN: Label for button of Front -->
	<!-- IT: Testo etichetta per il pulsante del Front -->
	<!-- default: 'Front' -->
	<xsl:variable name="front_button_label" select="'Front'"/>
	
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
