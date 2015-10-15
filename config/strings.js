/* ***************** */
/* INTERFACE STRINGS */
/* ***************** */

// Customization of strings used in interface for buttons, titles and messages used in interface
// if you want the system to use the default one just leave the value blank/empty

var STRINGS = {
    /* ******* */
    /* BUTTONS */
    /* ******* */
    'single_text_mode_title': 'Single Text mode', // default: 'Single Text mode'
    'image_text_mode_title': 'Image|Text mode', // default: 'Image|Text mode'
    'text_text_mode_title': 'Text|Text mode', // default: 'Text|Text mode'
    'bookreader_mode_title': 'Bookreader mode', // default: 'Bookreader mode'
    'teiHeader_button_title': 'Project Info', // default: 'Project Info'
    'goFullscreen_button_title': 'Fullscreen', // default: 'Fullscreen'
    'toggleMenu_button_title': 'Toggle menu', // default: 'Toggle menu'
    'previousPage_button_title': 'Previous Folio', // default: 'Previous Folio'
    'nextPage_button_title': 'Next Folio', // default: 'Next Folio'
    'previousText_button_title': 'Previous Text', // default: 'Previous Text'
    'nextText_button_title': 'Next Text', // default: 'Next Text'
    'expandFrame_button_title': 'Expand Frame', // default: 'Expand Frame'
    'collapseFrame_button_title': 'Collapse Frame', // default: 'Collapse Frame'

    'thumbs_button_label': 'Thumbs', // default: 'Thumbs'
    'thumbs_button_title': 'Thumbnails', // default: 'Thumbnails'
    
    'magnifier_button_label': 'Magnifier', // default: 'Magnifier'
    'magnifier_button_title': 'Magnifying lens', // default: 'Magnifying lens'
    
    'hs_button_label': 'HotSpot', // default: 'HotSpot'
    'hs_button_title': 'Hot spot', // default: 'Hot spot'
    
    'itl_button_label': 'TextLink', // default: 'TextLink'
    'itl_button_title': 'Image-Text link', // default: 'Image-Text link'
    
    'fitToFrame_button_title': 'Fit To Frame', // default: 'Fit To Frame'
    
    'zoomOut_button_title': 'Zoom Out', // default: 'Zoom Out'
    'zoomIn_button_title': 'Zoom In', // default: 'Zoom In'

    'toggleLists_button_title': 'Toggle Lists', // default: 'Toggle Lists'
    'lists_button_label': 'Lists', // default: 'Lists'
    'lists_button_title': 'Lists', // default: 'Lists'
    
    'regesto_button_label': 'Regesto', // default: 'Regesto'
    'regesto_button_title': 'Regesto', // default: 'Regesto'
    
    'front_button_label': 'Front', // default: 'Front'
    'front_button_title': 'Front', // default: 'Front'
    
    'msDesc_button_label': 'MS Info', // default: 'MS Info'
    'msDesc_button_title': 'Manuscript Information', // default: 'Manuscript Information'

    'decrease_font_size': 'Decrease font size', // default: 'Decrease font size'
    'increase_font_size': 'Increase font size', // default: 'Increase font size'
    
    /* ******** */
    /* SELECTOR */
    /* ******** */
    'pp_selector_title': 'Folio', // default: 'Folio'
    'tt_selector_title': 'Text', // default: 'Text'
    'ee_selector_title': 'Edition Level', // default: 'Edition Level'

    /* ****** */
    /* SEARCH */
    /* ****** */
    'search_button_label': 'Search', // default: 'Search'
    'search_button_title': 'Search', // default: 'Search'
    'toggleSearch_button_title': 'Toggle Search', // default: 'Toggle Search'
    'toggleKeyboard_button_title': 'Toggle Keyboard', // default: 'Toggle Keyboard'
    'clearSearch_button_title': 'Clear Search', // default: 'Clear Search'
    'startSearch_button_title': 'Start Search', // default: 'Start Search'
    'emptySearchAlertMsg': 'Enter your query into the search box above!', // default: 'Enter your query into the search box above!',
    'show_results_for': 'Showing results for the word ', // default: 'Showing results for '
    'search_for': 'Search for', // default: 'Search for'
    'we_have_found': 'We have found', // default: 'We have found'
    'one_result': '1 result', // default: '1 result'
    'results': 'results', // default: 'results'
    'in_the': 'in the', // default: 'in the'
    'edition': 'edition', // default: 'edition'
    'found_in': 'found in', // defualt: 'found in'
    'page': 'page', // default: 'page'
    'nothing_found': 'Nothing found', // default: 'Nothing found',
    'common_word_ignored_msg': 'Common words are largely ignored', // default: 'Common words are largely ignored'
    'search_too_short': 'Search too short', // default: 'Search too short'
    'more_char_alert': 'Should be one character or more', // default: 'Should be one character or more'
    'should_be': 'Should be', // default: 'Should be'
    'caracters_or_more': 'caracters or more', // default: 'caracters or more'

    /* ***** */
    /* LISTS */
    /* ***** */
    'list_person_label': 'List of People', // default: 'List of People'
    'list_place_label': 'List of Places', // default: 'List of Places'
    'entitiesSelector_title': 'Entities', // default: 'Entities'
    'noSelection_label': 'No selection', // default: 'No selection'
    'selectAll_label': 'Select All', // default: 'Select All'
    'clearSelection_label': 'Clear selection', // default: 'Clear selection'

    /* *********** */
    /* HEADER INFO */
    /* *********** */
    'hi_author_section_label': 'Text author', // default: 'Text author'
    'hi_principal_section_label': 'Principal investigator', // default: 'Principal investigator'
    'hi_publicationStmt_section_label': 'Publication information', // default: 'Publication information'
    'hi_publisher_section_label': 'Publisher', // default: 'Publisher'
    'hi_pubPlace_section_label': 'Publication place', // default: 'Publication place'
    'hi_date_section_label': 'Date', // default: 'Date'
    'hi_availability_section_label': 'Availability', // default: 'Availability'
    'hi_editionStmt_section_label': 'Text edition', // default: 'Text edition'
    'hi_edition_section_label': 'Edition', // default: 'Edition'
    'hi_encodingDesc_section_label': 'Encoding description', // default: 'Encoding description'
    'hi_projectDesc_section_label': 'Description', // default: 'Description'
    'hi_correction_section_label': 'Corrections', // default: 'Corrections'
    'hi_normalization_section_label': 'Normalization', // default: 'Normalization'
    'hi_segmentation_section_label': 'Text segmentation', // default: 'Text segmentation'
    'hi_hyphenation_section_label': 'Hyphenation', // default: 'Hyphenation'
    'hi_samplingDecl_section_label': 'Sampling methods', // default: 'Sampling methods'
    'hi_profileDesc_section_label': 'Text description', // default: 'Text description'
    'hi_language_section_label': 'Language', // default: 'Language'
    'hi_textClass_section_label': 'Text classification', // default: 'Text classification'
    'hi_revisionDesc_section_label': 'Revisions', // default: 'Revisions'
    
    /* ********************** */
    /* MANUSCRIPT DESCRIPTION */
    /* ********************** */
    'msd_msIdentifier_section_label': 'Current location', // default: 'Current location'
    'msd_repository_section_label': 'Location', // default: 'Location'
    'msd_collection_section_label': 'Collection', // default: 'Collection'
    'msd_idno_section_label': 'Code', // default: 'Code'
    'msd_msName_section_label': 'Name', // default: 'Name'
    'msd_msContents_section_label': 'Contents', // default: 'Contents'
    'msd_msContent_summary_section_label': 'Summary', // default: 'Summary'
    'msd_textLang_section_label': 'Language', // default: 'Language'
    'msd_msItems_section_label': 'Texts', // default: 'Texts'
    'msd_incipit_section_label': 'Incipit', // default: 'Incipit'
    'msd_explicit_section_label': 'Explicit', // default: 'Explicit'
    'msd_physDesc_section_label': 'Physical description', // default: 'Physical description'
    'msd_support_section_label': 'Material', // default: 'Material'
    'msd_extent_section_label': 'Extent', // default: 'Extent'
    'msd_collation_section_label': 'Collation', // default: 'Collation'
    'msd_condition_section_label': 'Condition', // default: 'Condition'
    'msd_foliation_section_label': 'Pages numbering', // default: 'Pages numbering'
    'msd_general_supportDesc_section_label': 'Support description', // default: 'Support description'
    'msd_layout_section_label': 'Layout', // default: 'Layout'
    'msd_layoutDesc_summary_section_label': 'Overview', // default: 'Overview'
    'msd_handDesc_section_label': 'Writing', // default: 'Writing'
    'msd_decoDesc_section_label': 'Decoration', // default: 'Decoration'
    'msd_history_section_label': 'Manuscript history', // default: 'Manuscript history'
    'msd_history_summary_section_label': 'Summary', // default: 'Summary'
    'msd_origin_section_label': 'Origin', // default: 'Origin'
    'msd_acquisition_section_label': 'Acquisition', // default: 'Acquisition'
    'msd_provenance_section_label': 'Provenance', // default: 'Provenance'
    'msd_adminInfo_section_label': 'Additional informations', // default: 'Additional informations'
    'msd_surrogates_section_label': 'Additional materials', // default: 'Additional materials'

    /* ************** */
    /* USEFUL STRINGS */
    /* ************** */
    'noImage_alert_msg': 'No Image', // default: 'No Image'
    'noElements_alert_msg': 'No elements.', // default: 'No elements.'
    'pageMissing_alert_msg': 'miss', // default: 'miss'
    'goToDocument_prefix_text': 'Go to Text', // default: 'Go to Text'
    'occurrences_plural_text': 'occurrences', // default: 'occurrences'
    'occurrences_singular_text': 'occurrence', // default: 'occurrence'
    'no_occurrence': 'No matches found', // default: 'No occurrences found'
    'text_plural_msg': 'Documenti', // default: 'Documenti'
    'text_singular_msg': 'Documento', // default: 'Documento'
    'occurrences_loc_page': 'Fol.', // default: 'Fol.'
    'occurrences_loc_doc': 'Doc.', // default: 'Doc.'
    'noSelection_msg': 'No selection', // default: 'No selection'
    'multiSelection_msg': 'Multi selection' // default: 'Multi selection'
};