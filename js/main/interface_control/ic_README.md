Recap of functions defined for interface control, 
organized in different ic_*.js file


# ======================================== #

ic_generic_bindings.js

# BIND EVENT...
    - ...GENERIC OPTION ON HOVER     : bindOptionHover()
    - ...OPEN OPTION CONTAINERS      : bindOpenSelectClick()
    - ...GENERIC OPTION CLICK        : bindOptionClick()
    - ...GLOBAL WRAPPER MOUSE DOWN   : bindGlobarWrapperMouseDown()
    - ...BUTTONS CLICK               : bindBtnClick()
    - ...FONT SIZE BUTTONS CLICK     : bindFontSizeControllerBtnClick()
    - ...COLLAPSE MENU BUTTONS CLICK : bindCollapseMenuBtnClick()
# INITIALIZE REF HYPERLINKS : InitializeRefs()
# INITIALIZE POPUPs         : InitializePopup()

# ======================================== #

ic_global_menu.js

# CLOSE GLOBAL MENU                     : collapseMenu(frame, height)
# OPEN GLOBAL MENU                      : expandMenu(frame, height)
# BIND SETTINGS BUTTON CLICK EVENT      : bindSettingsBtnClick()
# INITIALIZE LANG, BIND FLAG BTNs CLICK : initializeLang()
# BIND TOGGLE SHORTCUTS BUTTON CLICK    : bindShortcutsBtnClick()

# ======================================== #

ic_internal_fullscreen.js

# EXPAND LEFT FRAME              : goFullScreenLeft()
# REDUCE LEFT FRAME IF EXPANDED  : closeFullScreenLeft()
# EXPAND RIGHT FRAME             : goFullScreenRight()
# REDUCE RIGHT FRAME IF EXPANDED : closeFullScreenRight()
# BIND GO FULLSCREEN BTNs CLICK  : bindInternalFullscreenBtnClick()

# ======================================== #

ic_lists.js

# UPDATE HIGHLIGHTED ENTITIES IN TEXT                   : updateEntitiesFiltered(frame)
# TOGGLE LISTS CONTAINER                                : toggleListCont(toggler)
# CLOSE LISTS CONTAINER                                 : closeListsBox(speed)
# OPEN LISTS CONTAINER                                  : openListsBox(speed)
# HANDLE NAVIGATION LIST ELEMENTS PER LETTER            : filterListElements(filter)
# OPEN SINGLE LIST                                      : openList(elem, listName)
# SHOW LIST ELEMENT OCCURRENCES                         : showListElementOccurrences(elem, listName)
# PREPARE LIST ELEMENT OCCURRENCES                      : prepareOccurrencesList(elem, listName)
# GO TO OCCURRECE PAGE                                  : goToOccurrencePage(elem, pb, doc)
# COLLAPSE LISTS CONTAINER                              : scrollDownListContainer(speed)
# SHOW ITEM FROM TEXT INTO LIST                         : showItemInList(id_ref)
# INITIALIZE LINK BETWEEN TEXT TRIGGER AND LIST ELEMENT : InitializeLinkTextList()
# BIND TOGGLE LISTS BUTTON CLICK EVENT                  : bindListsBtnClick()

# ======================================== #

ic_navigation.js

# UPDATE HASH                         : updateHash(tt_val, pp_val, ee_val)
# SELECT PAGE                         : selectPP(current_page, pp_lab, tt_val)
# SELECT DOCUMENT                     : selectTT(current_doc)
# SELECT DOCUMENT IN PAGE             : selectDocumentInPage(elem)
# GO TO PAGE                          : gotopage(pp_val, pp_lab, state)
# CHANGE EDITION IN TEXTUAL FRAME     : gotoedition(pp_val, ee_val, pp_el, frame_id)
# BASIC PRELOAD FOR IMAGES NAVIGATION : preload(arrayOfImages)
# HANDLE DOCUMENT NAVIGATION          : navDoc(toward)
# HANDLE PAGES NAVIGATION             : arrow(toward)
# SIMULATE EXCHANGE OF EDITION LEVELS : selectOther(other_to_select, other_ee_select, page, doc, other_frame)
# BIND ON OPTION CLICK EVENT...
    - SELECT PAGE          : bindPPselectClick()
    - SELECT DOCUMENT      : bindTTselectClick()
    - SELECT DOUBLE PAGE   : bindDDselectClick()
    - SELECT EDITION LEVEL : bindEEselectClick() 
    - FILTER               : bindFilterOptionClick()
    - THUMBNAIL            : bindThumbClick()
    - ARROWS BUTTONS       : bindArrowsBtnsClick()

# ======================================== #

ic_prefatoryMatter.js

# OPEN FRONT INFO CONTAINER                              : show_front(front_container, front)
# CLOSE FRONT INFO CONTAINER                             : hide_front(front_cont, front)
# UPDATE FRONT INFO CONTENT DEPENDING ON DOCUMENT        : updateFrontContent(current_doc)
# TOGGLE FRONT INFO CONTAINER                            : toggleFront(front_cont)
# OPEN REGESTO CONTAINER                                 : show_regesto(regesto_container, regesto)
# CLOSE REGESTO CONTAINER                                : hide_regesto(regesto_cont, regesto)
# UPDATE REGESTO CONTENT DEPENDING ON DOCUMENT           : updateRegestoContent(current_doc)
# TOGGLE REGESTO CONTAINER                               : toggleReg(cont)
# BIND MS DESC BUTTON CLICK EVENT                        : bindMsDescBtnClick() 
# BIND TEXT INFO BUTTON CLICK EVENT                      : bindTextInfoBtnClick() 
# BIND HEADER TEXT INFO BUTTON CLICK EVENT               : bindHeaderInfoBtnClick() 
# BIND BIBLIOGRAPHY REFERENCE IN TEXT CLICK EVENT        : bindBiblioRefClick() 
# BIND BIBLIOGRAPHY BUTTON CLICK EVENT                   : bindBiblioBtnClick() 
# BIND TOGGLE FRONT INFO (OR REGESTO) BUTTON CLICK EVENT : bindToggleFrontBtnClick()

# ======================================== #

ic_resizings.js

# ADAPT HEIGHT OF TEXT CONTAINER                               : updateTextContHeight()
# ADAPT WIDTH OF SELECTs DEPENDING ON THEIR WIDER OPTION CHILD : updateSelectLength(elem)
# RESIZE UPPER TOOLBAR DEPENDING ON AVAILABLE BUTTONS          : resizeGlobalTopBar() 
# RESIZE BUTTONS AND SELECTS DEPENDING ON AVAILABLE SPACE      : resizeButtonsAndSelects() 
# ADAPT HEIGHT AND POSITION OF BOTTOM BOX                      : fitBottomBoxHeightAndPosition(boxSuffix, height_full)
# FIT FRAME                                                    : fitFrame() 
# CROP LONG TEXT LABELS                                        : cropLongTextLabel(text_label, min_char_num)
# UPDATE WIDTH OF LINES WITH LINE NUMBER                       : updateLinesWidth(mainFrameElem)

# ======================================== #

ic_search.js

# INITIALIZE SEARCH                        : InitializeSearch()
# TOGGLE SEARCH CONTAINER                  : toggleSearchCont(toggler)
# COLLAPSE SEARCH CONTAINER                : scrollDownSearchContainer(speed, searchCont)
# SET SEARCH CONTAINER CLOSED POSITION     : setSearchClosedPosition(boxSuffix)
# CLOSE SEARCH CONTAINER                   : closeSearchBox(speed, boxSuffix) 
# OPEN SEARCH CONTAINER                    : openSearchBox(speed, boxSuffix) 
# SEARCH BUTTON CLICK                      : onSearchButtonClick(elem) & bindSearchBtnsClick()
# BIND VIRTUAL KEYBOARD BUTTON CLICK EVENT : bindKeyboardBtnClick() 

# ======================================== #

ic_viewModes.js

# OPEN IMAGE/TEXT VIEW MODE           : openTxtImgMode()
# OPEN TEXT/TEXT VIEW MODE            : openTxtTxtMode() 
# OPEN BOOKREADER VIEW MODE           : openBookreaderMode()
# OPEN SINGLE TEXT VIEW MODE          : openTxtSingleMode()
# BIND VIEW MODES BUTTONS CLICK EVENT : bindViewModesBtnsClick()