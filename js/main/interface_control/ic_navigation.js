/**
 * Interface Control jQuery
 * Functions Handling Interface Navigation
 * Version 0.3 (201601)
 *
 * Copyright (C) 2013-2017 the EVT Development Team.
 *
 * EVT 1 is free software: you can redistribute it
 * and/or modify it under the terms of the
 * GNU General Public License version 2
 * available in the LICENSE file (or see <http://www.gnu.org/licenses/>).
 *
 * EVT 1 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 *
 * @author RafMas
 * @since 2012 @to 2015
 *
 * @author Julia Kenny - JK
 * @from 2012 @to 2014
 *
 * @author ChiaraDipi - CDP
 * @since 2013
 *
 * @short-term Greta Musu - GM
 * (added functions for global navigation bar and support for Viscoll)
 * @in 2017/18
 **/

/*= UPDATE HASH =*/
function updateHash(tt_val, pp_val, ee_val) {
	var newHash = "doc=" + tt_val + "&page=" + pp_val;
	if ('#' + newHash !== window.location.hash) {
		window.location.hash = newHash;
	}
}

/*= SELECT PAGE ================================================================================= =*/
/*= - update single page selector label and select corresponding option                           =*/
/*= – update double  page selector label and select corresponding option                          =*/
/*= - add "inPage" class to document options referencing documents contained in the selected page =*/
function selectPP(current_page, pp_lab, tt_val) {
	var dd_opt, dd_val, dd_lab, dd_first_doc;

	// SELETTORE PAGINE E SELETTORE PAGINE DUPLICATO NEL FRAME SINISTRO
	$('#span_pp_select .label_selected, #span_pp_select-add .label_selected')
		.attr('data-value', current_page)
		.attr('data-first-doc', tt_val)
		.text(pp_lab);

	$("#span_pp_select .option[data-value!='" + current_page + "'], #span_pp_select-add .option[data-value!='" + current_page + "']")
		.removeClass('selected');

	$("#span_pp_select .option[data-value='" + current_page + "'], #span_pp_select-add .option[data-value='" + current_page + "']")
		.addClass('selected');

	// SELETTORE PAGINE BOOK READER
	$('#span_dd_select .option').removeClass('selected');

	dd_opt = $("#span_dd_select .option_container .option[data-value*='" + current_page + "']");
	dd_opt.addClass('selected');

	dd_val = dd_opt.attr('data-value');
	dd_lab = dd_opt.text();
	dd_first_doc = tt_val;

	$('#span_dd_select .label_selected')
		.attr('data-value', dd_val)
		.attr('data-first-doc', dd_first_doc)
		.text(dd_lab);
	$('.inPage').removeClass('inPage');


	// GESTIONE DOCUMENTI MULTIPLI SU STESSA PAGINA
	$("#span_tt_select .option[data-value='" + tt_val + "']").addClass('inPage');
	$("#span_tt_select-add .option[data-value='" + tt_val + "']").addClass('inPage');

	// #CDP. Add scroll to elemento

	$("#span_tt_select .option[data-first-page='" + current_page + "'], #span_tt_select-add .option[data-first-page='" + current_page + "']")
		.addClass('inPage');

	if ($("#span_tt_select").find('.inPage').length > 1) {
		var actual_label = $('#span_tt_select .label_selected').text();
		$('#span_tt_select .label_selected, #span_tt_select-add .label_selected').text(actual_label);
	}
}

/*= SELECT DOCUMENT ================ =*/
/*= - update document selector label =*/
function selectTT(current_doc) {
	var current_doc_lab = $("#span_tt_select .option_container .option[data-value='" + current_doc + "']").text();
	// SELETTORE TESTI E SELETTORE TESTI DUPLICATO NEL FRAME SINISTRO
	$('#span_tt_select .label_selected, #span_tt_select-add .label_selected')
		.attr('data-value', current_doc)
		.text(current_doc_lab);

	// GESTIONE DOCUMENTI MULTIPLI SU STESSA PAGINA
	var pp_first_doc_val = $("#span_pp_select .option_container .option.selected").attr('data-first-doc');
	$("#span_tt_select .option[data-value='" + pp_first_doc_val + "'], #span_tt_select-add .option[data-value='" + pp_first_doc_val + "']")
		.addClass('inPage');
	$("#span_tt_select .option_container .option[data-value='" + current_doc + "'], #span_tt_select-add .option_container .option[data-value='" + current_doc + "']")
		.addClass('selected')
		.addClass('inPage')
		.siblings('.selected')
		.removeClass('selected');

	if ($("#span_tt_select").find('.inPage').length > 1) {
		var actual_label = $('#span_tt_select .label_selected').text();
		$('#span_tt_select .label_selected').text(actual_label);
		$('#span_tt_select-add .label_selected').text(actual_label);
	}

	var currentDocElem = $('.doc.current');
	currentDocElem.removeClass('current').addClass('not_current');
	$(".doc[data-doc='" + current_doc + "']").removeClass('not_current').addClass('current');
	if (currentDocElem.length > 0 && currentDocElem.position() !== undefined) {
		$('#text_cont, #text_cont-add').scrollTop(currentDocElem.position().top);
	}
}

/*= SELECT DOCUMENT IN PAGE ============= =*/
/*= to handle multiple documents per page =*/
function selectDocumentInPage(elem) {
	var tt_val, tt_lab, doc_title, current_doc_title, pp_val;
	if ($(elem).parents("div[id*='frame']").find('.doc').length > 1 &&
		$(elem).hasClass('not_current')) {

		doc_title = $(elem).attr('title');
		current_doc_title = $(".doc.current").attr('tempTitle');

		$(".doc.current")
			.attr('title', current_doc_title)
			.removeAttr('tempTitle')
			.removeClass('current')
			.addClass('not_current');

		$(elem)
			.attr('tempTitle', doc_title)
			.removeAttr('title')
			.removeClass('not_current')
			.addClass('current');

		tt_val = $(elem).attr('data-doc');
		tt_lab = $("#span_tt_select .option[data-value='" + tt_val + "']").text();
		pp_val = $("#span_pp_select .label_selected").attr('data-value');
		// updateRegestoContent(tt_val);
		// updateFrontContent(tt_val);
		updateHash(tt_val, pp_val, "");
		var currentDocElem = $('.doc.current');
		if (currentDocElem.length > 0 && currentDocElem.position() !== undefined) {
			$('#text_cont, #text_cont-add').scrollTop(currentDocElem.position().top);
		}
	}
}

/*= GO TO PAGE =*/
function gotopage(pp_val, pp_lab, state) {
	var edition, edition_add;
	var current_font_size;
	//N.B. i caricamenti delle immagini si attivano grazie agli eventi change dei label_selected in iviewer_config
	edition = $("#span_ee_select .main_ee_select .label_selected").attr('data-value').toLowerCase();
	// $('#span_pp_select .label_selected').trigger('change');

	var attrFontSize = $('#text_cont').attr('data-font-size');
	if (attrFontSize !== '' && attrFontSize !== undefined) {
		current_font_size = parseFloat(attrFontSize);
	} else {
		current_font_size = parseFloat($('#text_cont').css('font-size'));
	}

	var pageLoadedCallback = function (status, current_font_size) {
		if (status === 'error') {
			if ($('#text_elem .errorMsg').length === 0) {
				var errorMsg = window.lang.convert('ERROR_LOADING_TEXT', window.lang.currentLang);
				$('<span class="errorMsg">')
					.text(errorMsg)
					.appendTo('#text_elem');
			}
		} else {
			if (!isNaN(current_font_size)) {
				$('#text_cont')
					.css({
						'font-size': current_font_size + 'px',
						'line-height': (current_font_size + 10) + 'px'
					});
			}
			//IT: Attiva occorrenza in lista
			var right_frame = $('#main_right_frame');
			if (right_frame.find('.list').length > 0 &&
				right_frame.find('.list_element.list_element_opened').length > 0) {
				right_frame.find('.selected_from_list').removeClass('selected_from_list');
				right_frame.find('.list_element_opened').each(function () {
					var ref;
					ref = $(this).attr('id');
					$("#text span[data-ref='" + ref + "']").addClass('selected_from_list');
				});
			}
			// if (!$('#imgd_link').hasClass('current_mode')) {
			// 	updateLinesWidth(right_frame);
			// }
			
			//IT: Riattiva filtri attivi
			updateEntitiesFiltered(right_frame);

			//IT: controlla se la pagine ha gli elementi necessari allo strumento ITL
			if ($('#text_elem .Area').length) {
				if ($('#switchITL').hasClass('inactive') || $('#switchITL').hasClass('likeInactive')) {
					enableITLbutton();
				}
			} else {
				if ($('#switchITL i ').hasClass('fa-circle-o')) disableITLbutton();
				else $('#switchITL').addClass('likeInactive');
			}
			//IT: controlla se la pagine ha gli elementi necessari allo strumento HS
			if ($('#text_elem .Annotation').length) {
				if ($('#switchHS').hasClass('inactive') || $('#switchHS').hasClass('likeInactive')) {
					enableHSbutton();
				}
			} else {
				if ($('#switchHS i ').hasClass('fa-circle-o')) disableHSbutton();
				else $('#switchHS').addClass('likeInactive');
			}

			// Aggiorna eventi sul click negli elementi del text
			var textCont = $('#text_cont');
			var current_tt, current_doc_elem, current_doc_title;
			current_tt = $('#span_tt_select .option_container .option.selected').attr('data-value');
			textCont.find(".doc[data-doc!='" + current_tt + "']").addClass('not_current');
			current_doc_elem = textCont.find(".doc[data-doc='" + current_tt + "']");
			current_doc_title = current_doc_elem.attr('title');

			current_doc_elem
				.attr('tempTitle', current_doc_title)
				.removeAttr('title')
				.addClass('current');
			if (textCont.find('.doc').length > 0) {
				if (textCont.find('.doc.current').length > 0 && textCont.find('.doc.current').position() !== undefined) {
					textCont.scrollTop(textCont.find('.doc.current').position().top);
				}

				textCont.find(".doc").unbind('click').click(function () {
					selectDocumentInPage(this);
				});
			} else {
				$('#text').addClass('doc').addClass('current').attr('data-doc', current_tt);
			}

			$("img").error(function () {
				$(this)
					.unbind("error")
					.attr("src", "images/no-image.png")
					.css('opacity', '0.3');
				if ($(this).parent('.tooltip')) {
					$(this).css({
						'width': '100px'
					});
				}
			});

			InitializePopup();
			InitializeRefs();
			InitializeSearch();
			transformBrs();
			// Riattiva prosa/versi
			var proseVersesToggler = $("#toggleVersesProseBtn");
			if (proseVersesToggler) {
				var activeStatus = proseVersesToggler.attr("data-active-status");
				var frame = proseVersesToggler.closest(".main_frame");
				if (activeStatus === "prose") {
					viewProse(frame);
				} else if (activeStatus === "verses") {
					viewVerses(frame);
				}
			}

			if ($('.selected_from_list').length > 0) {
				$('#text_cont.reachingOccurence')
					.scrollTop($('.selected_from_list').position().top)
					.removeClass('reachingOccurence');
			}
			updateLinesWidth($('#main_right_frame'));
			updateLinesWidth($('#main_left_frame'));
			/* Integration by LS */
			window.lang.run();
			/* /end Integration by LS */
		}
		// IT: Se ci si trova nella modalità Thumb, chiude la schermata e visualizza l'immagine
		closeSecondaryImageContentOpened('gotopage', false)
	};

	var pageLoadedCallbackAdd = function (status, current_font_size) {
		if (status === 'error') {
			if ($('#text_elem-add .errorMsg').length === 0) {
				var errorMsg = window.lang.convert('ERROR_LOADING_TEXT', window.lang.currentLang);
				$('<span class="errorMsg">')
					.text(errorMsg)
					.appendTo('#text_elem-add');
			}
		} else {
			$('#text_cont-add')
				.css({
					'font-size': current_font_size + 'px',
					'line-height': (current_font_size + 10) + 'px'
				});
			//IT: Attiva occorrenza in lista
			var left_frame = $('#main_left_frame');
			if (left_frame.find('.list').length > 0 &&
				left_frame.find('.list_element.list_element_opened').length > 0) {

				left_frame.find('.selected_from_list').removeClass('selected_from_list');
				left_frame.find('.list_element_opened').each(function () {
					var ref;
					ref = $(this).attr('id');
					$("#text span[data-ref='" + ref + "']").addClass('selected_from_list');
				});
			}
			if (!$('#imgd_link').hasClass('current_mode')) {
				updateLinesWidth(left_frame);
			}
			//IT: Riattiva filtri attivi
			left_frame
				.find('.like_select.filter')
				.find('.option.selected')
				.removeClass('selected')
				.trigger('click');

			// Aggiorna eventi sul click negli elementi del text
			var current_tt, current_doc_title;
			var textContAdd = $('#text_cont-add');
			current_tt = $('#span_tt_select-add .option_container .option.selected').attr('data-value');

			if (textContAdd.find('.doc').length <= 0) {
				textContAdd
					.find('#text')
					.addClass('doc')
					.addClass('current')
					.attr('data-doc', current_tt);
			} else {
				textContAdd.find(".doc[data-doc!='" + current_tt + "']").addClass('not_current');
				current_doc_title = textContAdd.find(".doc[data-doc='" + current_tt + "']").attr('title');

				textContAdd.find(".doc[data-doc='" + current_tt + "']")
					.attr('tempTitle', current_doc_title)
					.removeAttr('title')
					.addClass('current');

				if ($('#text_cont-add:visible .doc').length > 0) {
					textContAdd.scrollTop(textContAdd.find('.doc.current').position().top);

					textContAdd.find(".doc").unbind('click').click(function () {
						selectDocumentInPage(this);
					});
				}
			}

			InitializePopup();
			InitializeRefs();
			InitializeSearch();
			transformBrs();
			// Riattiva prosa/versi
			var proseVersesToggler = $("#toggleVersesProseBtn-add");
			if (proseVersesToggler) {
				var activeStatus = proseVersesToggler.attr("data-active-status");
				var frame = proseVersesToggler.closest(".main_frame");
				if (activeStatus === "prose") {
					viewProse(frame);
				} else if (activeStatus === "verses") {
					viewVerses(frame);
				}
			}

			/* Integration by LS */
			window.lang.run();
			/* /end Integration by LS */
		}
	};

	var frontFrame = $('#text_elem #front_frame');
	frontFrame.empty();
	var tt_val = $(".main_tt_select .label_selected").attr("data-value");
	if ($(".main_pp_select .option[data-value='" + pp_val + "']").attr('data-has-front') === 'true') {
		if (edition !== "translation") {
			frontFrame
				.attr('data-page', pp_val)
				.load("data/output_data/" + edition + "/page_" + pp_val + "-front_" + edition + ".html #text_frame #text",
					function (response, status, xhr) {
						pageLoadedCallback(status, current_font_size);
					});
		}
	}

	var re = /doc=/;
	var hash_parts = location.hash.substr(1).split('&');
	var ind = hash_parts.indexOf((function () {
		var i;
		for (i in hash_parts)
			if (re.test(hash_parts[i]))
				return hash_parts[i];
	})());
	var transText = hash_parts && hash_parts[ind] ? hash_parts[ind].replace(/doc=/ig, "") : ""; //TODO: check better way to retrieve current text id
	if (edition === "translation") {
		frontFrame
			.attr('data-page', pp_val)
			.load("data/output_data/" + edition + "/translation_" + transText + ".html #text_frame #text",
				function (response, status, xhr) {
					pageLoadedCallback(status, current_font_size);
				});
	} else {
		$('#text_elem #text_frame')
			.attr('data-page', pp_val)
			// .empty()
			.load("data/output_data/" + edition + "/page_" + pp_val + "_" + edition + ".html #text_frame #text",
				function (response, status, xhr) {
					pageLoadedCallback(status, current_font_size);
				});
	}

	// IT: Aggiorna l'indirizzo del frame secondario per il testo
	var frontFrameAdd = $('#text_elem-add #front_frame-add');
	if ($("#text_cont-add").length > 0) { //SISTEMARE
		edition_add = $("#span_ee_select-add .option_container .option.selected").attr('data-value');
		edition_add = edition_add !== undefined ? edition_add.toLowerCase() : edition_add;

		frontFrameAdd.empty();
		if ($(".main_pp_select .option[data-value='" + pp_val + "']").attr('data-has-front') === 'true') {
			if (edition_add !== "translation") {
				frontFrameAdd
					.load("data/output_data/" + edition_add + "/page_" + pp_val + "-front_" + edition_add + ".html #text_frame #text",
						function (response, status, xhr) {
							pageLoadedCallbackAdd(status, current_font_size);
						});
			}
		}
		if (edition_add === "translation") {
			$('#text_elem-add #text_frame-add')
				// .empty()
				.load("data/output_data/" + edition_add + "/translation_" + transText + ".html #text_frame #text",
					function (response, status, xhr) {
						pageLoadedCallbackAdd(status, current_font_size);
					});
		} else if (edition_add !== undefined) {
			$('#text_elem-add #text_frame-add')
				// .empty()
				.load("data/output_data/" + edition_add + "/page_" + pp_val + "_" + edition_add + ".html #text_frame #text",
					function (response, status, xhr) {
						pageLoadedCallbackAdd(status, current_font_size);
					});
		}

		// IT: Aggiorna le informazioni all'interno dell'etichetta destra
		$('#zvalopz')
			.text($("input[name=edition_r-add]:checked").val())
			.hide()
			.fadeIn(200);
	}
}

/*= CHANGE EDITION IN TEXTUAL FRAME =*/
function gotoedition(pp_val, ee_val, pp_el, frame_id) {
	var tt_val;
	tt_val = $('#span_tt_select .label_selected').attr('data-value');
	if (ITLon === true) {
		UnInitialize(true);
	} //Add by JK for ITL
	if (HSon === true) {
		UnInitializeHS(true);
	} //Add by JK for HS

	var editionLoadedCallback = function (status) {
		if (status === 'error') {
			var elem = $('#' + frame_id + " div[id*='text_elem']");
			if (elem.find(".errorMsg").length === 0) {
				var errorMsg = window.lang.convert('ERROR_LOADING_TEXT', window.lang.currentLang);
				$('<span class="errorMsg">')
					.text(errorMsg)
					.appendTo(elem);
			}
		} else {
			if ($('#' + frame_id).find('.doc').length <= 0) {
				$('#' + frame_id)
					.find('#text')
					.addClass('doc')
					.addClass('current')
					.attr('data-doc', tt_val);
			} else {
				$('#' + frame_id + " .doc[data-doc!='" + tt_val + "']").addClass('not_current');
			}

			// IT: se il pulsante ITL è attivo e non sono in modalità txttxt, attiva ITL
			if ($("#switchITL i").hasClass('fa fa-chain')) {
				if ($('.current_mode').attr('id') !== 'txttxt_link') {
					Initialize();
				}
			} /*Add by JK for ITL*/
			if ($("#switchHS i").hasClass('fa fa-dot-circle-o')) {
				if ($('.current_mode').attr('id') !== 'txttxt_link') {
					InitializeHS();
				}
			} /*Add by JK for HS*/

			if (!$('#imgd_link').hasClass('current_mode')) {
				updateLinesWidth($('#main_right_frame'));
				updateLinesWidth($('#main_left_frame'));
			}

			var current_doc = $('#span_tt_select .label_selected').attr('data-value');
			var currentDocElem = $(".doc[data-doc='" + current_doc + "']");
			if (currentDocElem.length > 0) {
				currentDocElem.addClass('current');
			}

			InitializePopup();
			InitializeRefs();
			InitializeSearch();
			transformBrs();
			// Riattiva prosa/versi
			var frame = $("#" + pp_el).parents("div[id*='frame']");
			var proseVersesToggler = frame.find("[id*='toggleVersesProseBtn']");
			if (proseVersesToggler) {
				var activeStatus = proseVersesToggler.attr("data-active-status");
				if (activeStatus === "prose") {
					viewProse(frame);
				} else if (activeStatus === "verses") {
					viewVerses(frame);
				}
			}

			$("#text_cont .doc, #text_cont-add .doc").unbind('click').click(function () {
				selectDocumentInPage(this);
			});
			var ppElSelect = $("#" + pp_el).parents("div[id*='frame']").find('.like_select.filter');
			if (ppElSelect) {
				ppElSelect
					.find('.option_container .option.selected')
					.removeClass('selected')
					.trigger('click');

			}
			updateLinesWidth($('#main_right_frame'));
			updateLinesWidth($('#main_left_frame'));
			/* Integration by LS */
			window.lang.run();
			/* /end Integration by LS */
		}
	};

	var ppElFrontFrame = $("#" + pp_el + " div[id*='front_frame']");
	ppElFrontFrame.empty();
	if ($(".main_pp_select .option[data-value='" + pp_val + "']").attr('data-has-front') === 'true') {
		if (ee_val !== "translation") {
			ppElFrontFrame
				.attr('data-page', pp_val)
				.load("data/output_data/" + ee_val + "/page_" + pp_val + "-front_" + ee_val + ".html #text_frame #text",
					function (response, status, xhr) {
						editionLoadedCallback(status);
					});
		}
	}

	if (ee_val === "translation") {
		var currentText = $('#span_tt_select .label_selected').data('value');
		$("#" + pp_el + " div[id*='text_frame']")
			// .empty()
			.load("data/output_data/" + ee_val + "/translation_" + currentText + ".html #text_frame #text",
				function (response, status, xhr) {
					editionLoadedCallback(status);
				}
			);
	} else {
		$("#" + pp_el + " div[id*='text_frame']")
			// .empty()
			.load("data/output_data/" + ee_val + "/page_" + pp_val + "_" + ee_val + ".html #text_frame #text",
				function (response, status, xhr) {
					editionLoadedCallback(status);
				}
			);
	}

	var pp_el_upp = pp_el;
	pp_el_upp = pp_el_upp.toLowerCase().replace(/\b[a-z]/g, function (letter) {
		return letter.toUpperCase();
	});

	// IT: Gestisce la scrittura nell'etichetta destra o sinistra a seconda del frame caricato
	/*if (frame_id.indexOf("-add")>-1) {
	    $('#zvalopz').text(pp_el_upp);
	} else{
	    $('#edval span').text(pp_el_upp);
	}*/
}

/*= BASIC PRELOAD FOR IMAGES NAVIGATION =*/
function preload(arrayOfImages) {
	$(arrayOfImages).each(function () {
		$('<img/>')[0].src = this;
	});
}

/*= HANDLE DOCUMENT NAVIGATION =*/
function navDoc(toward) {
	var current_tt, new_tt, current_pp, new_pp, new_tt_val;
	current_tt = $('#span_tt_select').find('.option.selected');
	current_pp = $('#span_pp_select').find('.option.selected').attr('data-value');

	if (toward === "left") {
		new_tt = current_tt.prev();
	} else if (toward === "right") {
		new_tt = current_tt.next();
	}

	new_pp = new_tt.attr('data-first-page');
	new_tt_val = new_tt.attr('data-value');
	if ($(".doc[data-doc='" + new_tt_val + "']").length > 0 &&
		$(".optionGroup[data-doc-group='" + new_tt_val + "']").find(".option[data-value='" + current_pp + "']").length > 0) {
		//$(".doc[data-doc='"+new_tt_val+"']").trigger('click');
		//selectTT(new_tt_val);
		$('#text_cont').scrollTop($('.doc.current').position().top);
		updateHash(new_tt_val, current_pp, "");
	} else {
		new_tt.trigger('click');
	}
	var insideLeftArrow = $('#inside_left_arrow'),
		insideLeftArrowAdd = $('#inside_left_arrow-add'),
		insideRightArrow = $('#inside_right_arrow'),
		insideRightArrowAdd = $('#inside_right_arrow-add');
	if (insideLeftArrow.length > 0 || insideRightArrow.length > 0) {
		if (new_tt.prev().length <= 0) {
			insideLeftArrow.addClass('disabled');
			insideLeftArrowAdd.addClass('disabled');
		} else {
			insideLeftArrow.removeClass('disabled');
			insideLeftArrowAdd.removeClass('disabled');
		}

		if (new_tt.next().length <= 0) {
			insideRightArrow.addClass('disabled');
			insideRightArrowAdd.addClass('disabled');
		} else {
			insideRightArrow.removeClass('disabled');
			insideRightArrowAdd.removeClass('disabled');
		}
	}
}

/*= HANDLE PAGES NAVIGATION =*/
function arrow(toward) { //duplicata temporaneamente in jquery.rafmas-keydown
	var d_page, l_page;
	var current_pp, current_opt;
	var new_pp_opt;
	var new_pp_val, new_pp_lab, new_tt_val;
	var current_tt_val, current_tt_first_page;

	if (!$("#imgd_link").hasClass("current_mode")) {
		if (groupingPagesByDoc) {
			if (toward === "left") {
				current_opt = $('.main_pp_select .option_container .option.selected:first');
				current_pp = current_opt.attr("data-value");

				if (current_opt.prev().hasClass('option')) {
					new_pp_opt = current_opt.prev();
					moveSlider(current_pp, new_pp_opt);
				}
				// se la pagina corrente e' la prima di un gruppo
				else if (current_opt.prev().is('span')) {
					// se il gruppo della pagina corrente non e' il primo gruppo
					if (current_opt.parent().prev().length > 0) {
						// seleziono l'ultima pagina del gruppo precedente
						new_pp_opt = current_opt.parent().prev().find('.option:last');
						moveSlider(current_pp, new_pp_opt);
					}
				}
			}
			if (toward === "right") {
				current_opt = $('.main_pp_select .option_container .option.selected:last');
				current_pp = current_opt.attr("data-value");
				// se la pagina corrente non e' l'ultima di un gruppo
				if (current_opt.next().length > 0 && current_opt.next().hasClass('option')) {
					new_pp_opt = current_opt.next();
					moveSlider(current_pp, new_pp_opt);
				} else {
					// se il gruppo della pagina corrente non e' l'ultimo
					if (current_opt.parent().next().length > 0) {
						// seleziono l'ultima pagina del gruppo precedente
						new_pp_opt = current_opt.parent().next().find('.option:first');
						moveSlider(current_pp, new_pp_opt);
					}
				}
			}
		} else {
			current_opt = $('.main_pp_select .option_container .option.selected');
			current_pp = current_opt.attr("data-value");
			if (toward === "left" && !$(current_opt).is(":first-child")) {
				new_pp_opt = current_opt.prev();
				moveSlider(current_pp, new_pp_opt);
			}
			if (toward === "right" && !$(current_opt).is(":last-child")) {
				new_pp_opt = current_opt.next();
				moveSlider(current_pp, new_pp_opt);
			}
		}
		if (new_pp_opt !== null && new_pp_opt !== undefined) {
			new_tt_val = new_pp_opt.attr('data-first-doc'); // primo documento contenuto.
		}
	} else {
		$('#span_dd_select .label_selected').attr('data-last-hash-txtimg', '');
		current_opt = $('.main_dd_select .option_container .option.selected');
		current_pp = current_opt.attr('data-value');
		if (toward === "left" && !$(current_opt).is(":first-child")) {
			new_pp_opt = current_opt.prev();
		}
		if (toward === "right" && !$(current_opt).is(":last-child")) {
			new_pp_opt = current_opt.next();
		}
		if (new_pp_opt !== null && new_pp_opt !== undefined) {
			new_tt_val = new_pp_opt.attr('data-first-page-first-doc'); // primo documento contenuto.
		}
	}
	if (new_pp_opt !== null && new_pp_opt !== undefined) {
		new_pp_val = new_pp_opt.attr('data-value'); // id pagina cliccata
		new_pp_lab = new_pp_opt.text();

		current_tt_val = $(".main_tt_select .label_selected").attr("data-value");
		current_tt_first_page = $(".main_tt_select .option_container .option.selected").attr('data-first-page');
		if (current_tt_first_page === new_pp_val) {
			updateHash(current_tt_val, new_pp_val, "");
		} else {
			updateHash(new_tt_val, new_pp_val, "");
		}
	}
}

function moveSlider(current_pp, new_pp_opt) {
	//console.log(current_pp + new_pp_opt);
	var val, new_val;
	var new_pp_opt_val = new_pp_opt.attr("data-value");
	var brPagerElem = $("#BRpager");
	if (new_pp_opt_val < current_pp) { // Se il valore della nuova pagina è minore di quella corrente
		//Va' a sinistra
		val = brPagerElem.slider("value");
		new_val = val - 1;
		brPagerElem.slider("value", new_val);
	} else { // Altrimenti muove lo slider a destra
		//Va' a destra
		val = brPagerElem.slider("value");
		new_val = val + 1;
		brPagerElem.slider("value", new_val);
	}
}

/*= SIMULATE TRIGGER CLICK EVENT ON OPTION TO HANDLE EXCHANGE OF EDITION LEVELS IN TEXT-TEXT VIEW MODE =*/
function selectOther(other_to_select, other_ee_select, page, doc, other_frame) {
	gotoedition(page, doc, other_to_select.attr('data-value').toLowerCase(), other_frame);
	other_to_select.addClass('selected')
		.siblings('.option').removeClass('selected');
	other_ee_select.find('.label_selected')
		.attr('data-value', other_to_select.attr('data-value').toLowerCase())
		.text(other_to_select.text())
		.trigger('change');
}

/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND SELECT PAGE EVENT ON OPTION CLICK =*/
function bindPPselectClick() {
	/* Recupera gli identificativi (e la label) della pagina selezionata e del primo documento in essa contenuto.
	   Aggiorna l'hash che provoca il reload della pagina.
	*/
	$(".main_pp_select .option_container .option").unbind("click").click(function () {
		if (!$(this).hasClass('selected')) {
			var new_pp_val, new_pp_lab, new_tt_val;
			var current_tt_val, current_tt_first_page;

			new_pp_val = $(this).attr('data-value'); // id pagina cliccata
			new_pp_lab = $(this).text();
			new_tt_val = $(this).attr('data-first-doc'); // primo documento contenuto.

			/* Se il documento correntemente selezionato (current_tt_val) è contenuto nella pagina in questione,
			   aggiorno il contenuto testuale non con il primo documento della pagina, ma con quello corrispondente current_tt_val.
			   Altrimenti aggiorno con il primo documento della pagina. */
			current_tt_val = $(".main_tt_select .label_selected").attr("data-value");
			current_tt_first_page = $(".main_tt_select .option_container .option.selected").attr('data-first-page');
			var current_page = $(".main_pp_select .label_selected").attr("data-value");
			if (current_tt_first_page === new_pp_val) {
				updateHash(current_tt_val, new_pp_val, "");
				moveSliderSelector(current_page, new_pp_val);
			} else {
				updateHash(new_tt_val, new_pp_val, "");
				moveSliderSelector(current_page, new_pp_val);
			}
			$(this).removeClass('selected');
		}
	});
}

function moveSliderSelector(current_pp, new_pp_val) {
	//alert(current_pp + new_pp_val);
	if (new_pp_val < current_pp) { // Se il valore della nuova pagina è minore di quella corrente
		//Va' a sinistra
		for (var i in arrayPages) {
			if (new_pp_val === arrayPages[i].id) { // Deve prendere l'indice dell'elemento dell'array corrispondente alla pagina cliccata
				//alert(arrayPages[i].id + i);
				$("#BRpager").slider("value", i);
			}
		}
	} else { // Altrimenti muove lo slider a destra
		//Va' a destra"
		for (var i in arrayPages) {
			if (new_pp_val === arrayPages[i].id) {
				//alert(arrayPages[i].id + i);
				$("#BRpager").slider("value", i);
			}
		}
	}
}

/*= BIND SELECT DOCUMENT EVENT ON OPTION CLICK =*/
function bindTTselectClick() {
	$('.main_tt_select .option_container .option').click(function () {
		if (!$(this).hasClass('selected')) {
			$(this).addClass('selected');
			var new_tt_opt, new_tt_val, new_tt_first_page;
			var current_pp_val;

			var tt_val_temp, first_page;

			new_tt_opt = $(this);
			new_tt_val = $(this).attr('data-value');
			new_tt_first_page = new_tt_opt.attr('data-first-page');

			current_pp_val = $('#span_pp_select .label_selected').attr('data-value');

			/* Se la prima pagina del documento non è la corrente,
			    aggiorno il contenuto del frame testuale con quello della pagina in qustione.
			    Altrimenti aggiorno solo le info legate al testo.
			*/
			if (current_pp_val !== new_tt_first_page) {
				var new_tt_first_page_lab;
				new_tt_first_page_lab = $("#span_pp_select .option_container ")
					.find(".option[data-value='" + new_tt_first_page + "']").text();
				moveSliderSelectorTT(current_pp_val, new_tt_first_page);
			} else {
				$("#text_cont .doc[data-doc!='" + new_tt_val + "']").hide();
			}
			updateHash(new_tt_val, new_tt_first_page, "");
			$(this).removeClass('selected');
		}
	});
}

function moveSliderSelectorTT(current_pp_val, new_tt_first_page) {
	//alert(current_pp + new_pp_val);
	if (new_tt_first_page < current_pp_val) { // Se il valore della nuova pagina del documento di riferimento è minore di quella corrente
		//Va' a sinistra
		for (var i in arrayPages) {
			if (new_tt_first_page === arrayPages[i].id) { // Deve prendere l'indice dell'elemento dell'array corrispondente alla pagina cliccata
				//alert(arrayPages[i].id + i);
				$("#BRpager").slider("value", i);
			}
		}
	} else { // Altrimenti muove lo slider a destra
		//Va' a destra"
		for (var i in arrayPages) {
			if (new_tt_first_page === arrayPages[i].id) {
				//alert(arrayPages[i].id + i);
				$("#BRpager").slider("value", i);
			}
		}
	}
}

/*= BIND SELECT DOUBLE PAGE EVENT ON OPTION CLICK =*/
function bindDDselectClick() {
	$('.main_dd_select .option_container .option').click(function () {
		var pp_val, pp_lab, tt_val, first_page_id;
		var arrayPagePairs = [];
		$('.main_dd_select .option_container .option').each(function () {
			var pageId = $(this).attr('data-value');
			arrayPagePairs.push(pageId);
		});
		pp_val = $(this).attr('data-value') || ''; // pagine cliccate
		tt_val = $(this).attr('data-first-page-first-doc') || '';
		pp_lab = $(this).text() || '';
		$('#span_dd_select .label_selected')
			.attr("data-value", pp_val)
			.attr("data-first-doc", tt_val)
			.attr('data-last-hash-txtimg', '')
			.text(pp_lab);
		first_page_id = pp_val.split("+")[0];
		$("#span_pp_select .option_container .option[data-value='" + first_page_id + "']").trigger('click');
		moveSliderSelectorDD(arrayPagePairs, pp_val);
		updateHash(tt_val, pp_val, "");
		$(this).removeClass('selected');
	});
}

function moveSliderSelectorDD(arrayPagePairs, pp_val) {
	var j = 0,
		found = false;
	while (j < arrayPagePairs.length && !found) {
		if (arrayPagePairs[j].indexOf(pp_val) !== -1) { // Se nell'elemento esiste una stringa uguale a pp_val
			//alert(arrayPagePairs[j]);
			$('#BRpager').slider({ // Modifico lo slider e il valore prende l'elemento in indice j
				min: 0,
				max: arrayPagePairs.length - 1,
				value: j
			});
			found = true;
		}
		j++;
	}
}

/* BIND SELECT EDITION LEVEL EVENT ON OPTION CLICK / SWITCH ON/OFF REGESTO */
function bindEEselectClick() {
	$('.main_ee_select .option_container .option').click(function () {
		if (!$(this).hasClass('selected')) {
			var regesto_button, regesto_cont;
			var contextual_frame, contextual_parent;
			var other_frame, other_parent;
			var other_ee_select, other_ee_select_val;
			var pp_val, ee_val;
			var tt_val;

			pp_val = $('#span_pp_select .label_selected').attr('data-value');
			tt_val = $('#span_pp_select .label_selected').attr('data-first-doc');
			ee_val = $(this).attr('data-value').toLowerCase();

			contextual_frame = "";
			contextual_parent = "";

			other_frame = "";
			other_parent = "";

			// Se ho cliccato su un elemento del selettore di sinistra
			if ($(this).parents(".like_select").attr("id") === "span_ee_select-add") {
				// Dovrò agire sul regesto a sinistra...
				regesto_button = "#switchReg-add";
				regesto_cont = "#regesto_cont-add";

				// ...sui contenitori testuali di sinistra...
				contextual_frame = "text_elem-add";
				contextual_parent = "text_cont-add";

				// ... e sui selettori e contenitori testuali di destra
				other_ee_select = "span_ee_select";

				other_frame = "text_elem";
				other_parent = "text_cont";

				var rightFrameOptionSelected = $('#main_right_frame .like_select.filter').find('.option.selected');
				if (rightFrameOptionSelected.length > 0) {
					rightFrameOptionSelected.each(function () {
						var left_filter = "#" + $(this).parents('.like_select').attr('id') + "-add";
						if ($(left_filter).find('.label_selected').attr('data-value') === 'none') {
							var value = $(this).attr('data-value');
							$(left_filter)
								.find(".option[data-value='" + value + "']")
								.addClass('selected');
						}
					});
				}
			}
			// Se ho cliccato su un elemento del selettore di destra
			else {
				// Dovrò agire sul regesto a destra...
				regesto_button = "#switchReg";
				regesto_cont = "#regesto_cont";
				// ...sui contenitori testuali di sinistra...
				contextual_frame = "text_elem";
				contextual_parent = "text_cont";

				// ... e sui selettori e contenitori testuali di destra
				other_ee_select = "span_ee_select-add";

				other_frame = "text_elem-add";
				other_parent = "text_cont-add";

			}
			try {
				other_ee_select_val = $('#' + other_ee_select).find('.label_selected').attr('data-value').toLowerCase();
			} catch (e) { }

			// Faccio un controllo sul livello di edizione da attivare sul frame corrente
			// e se sto passando all'edizione diplomatica disattivo i filtri e le liste
			// Commentato da FS mostra filtri e liste anche in edizione diplomatica
			if ((ee_val !== 'translation')) {
				$("#" + contextual_parent)
					.parents("div[id*='frame']")
					.find('.like_select.filter')
					.css('opacity', "1")
					.removeClass('not_active');
			} else {
				$("#" + contextual_parent)
					.parents("div[id*='frame']")
					.find('.like_select.filter')
					.css('opacity', "0.5")
					.addClass('not_active');
			}

			var verseProseBtn = $('#toggleVersesProseBtn');
			if (verseProseBtn) {
				if ((ee_val === 'diplomatic') || (ee_val === 'interpretative')) {
					verseProseBtn.show();
				} else {
					verseProseBtn.hide();
				}
			}
			// Se ho il regesto, e questo è aperto, lo chiudo
			if ($(regesto_cont).length > 0 && $(regesto_cont).is(":visible")) {
				$(regesto_button).trigger('click');
			}

			// Se sto selezionando lo stesso livello attivo nell'altro frame
			if (other_ee_select_val === ee_val) {
				// Cerco un nuovo elemento da selezionare nell'altro frame
				// e me ne salvo il valore
				var other_ee_elem_to_select, other_ee_val;
				other_ee_elem_to_select = $('#' + other_ee_select).find(".option[data-value!='" + ee_val + "']:first");
				other_ee_val = other_ee_elem_to_select.attr('data-value').toLowerCase();

				$('#' + other_ee_select)
					.find(".option[data-value='" + other_ee_val + "']").addClass('selected')
					.siblings('.option')
					.removeClass('selected');

				$('#' + other_ee_select)
					.find('.label_selected')
					.attr('data-value', other_ee_val)
					.text(other_ee_elem_to_select.text())
					.trigger('change');

				// Se il valore dell'elemento da selezionare nell'altro frame non è indefinito né vuoto
				if (other_ee_val !== undefined && other_ee_val !== '') {

					// Se sto attivando l'edizione diplomatica nell'altro frame
					// Disattivo le liste e i filtri
					// Commentto da FS - Mostra filtri e liste anche in ed diplomatica
					if ((other_ee_val !== 'translation') &&
						(!$("#" + other_parent).parents("div[id*='frame']").find('.toggleReg').hasClass('active'))) {
						$("#" + other_parent)
							.parents("div[id*='frame']")
							.find('.like_select.filter')
							.css('opacity', "1")
							.removeClass('not_active');
					} else {
						$("#" + other_parent)
							.parents("div[id*='frame']")
							.find('.like_select.filter')
							.css('opacity', "0.5")
							.addClass('not_active');
					}
					// carico nell'altro frame il nuovo livello di edizione trovato
					gotoedition(pp_val, other_ee_val, other_frame, other_parent);
				} else {
					// altrimenti...
					gotoedition(pp_val, ee_val, contextual_frame, contextual_parent);
				}
			}
			// Altrimenti lascio stare l'altro frame così com'è
			// e carico nel frame contestuale al click il testo del livello di edizione selezionato
			gotoedition(pp_val, ee_val, contextual_frame, contextual_parent);
		}
	});
}

/*= BIND FILTER OPTION CLICK EVENT =============================== =*/
/*= General event on click on ".option" in a ".filter.like_select" =*/
function bindFilterOptionClick() {
	$(".like_select.filter .option_container .option").unbind("click").click(function () {
		var thisOptionContainer = $(this).parents('.option_container');
		var classToBeActived, newLabel, newLabelVal, filtersActive;
		classToBeActived = $(this).attr('data-value');
		if (classToBeActived === 'clear') { //pulisci selezione
			$(this).siblings('.option').removeClass('selected');
			//$(this).addClass('selected');
			$(this).parents("div[id*='frame']").find('.list_active').removeClass('list_active');
			// se "pulisci selezione" l'etichetta prende "No selection"
			newLabel = 'NO_SELECTION';
			newLabelVal = "clear";
		} else if (classToBeActived === 'all') { //seleziona tutto
			//$(this).addClass('selected');
			$(this).siblings('.option').each(function () {
				classToBeActived = $(this).attr('data-value');
				if (classToBeActived !== 'clear') {
					$(this).addClass('selected');
					$(this).parents("div[id*='frame']").find("." + classToBeActived).addClass('list_active');
				}
				$(this).siblings(".option[data-value='clear']").removeClass('selected');
			});
			newLabel = 'MULTI_SELECTION';
			newLabelVal = "multi";
		} else {
			$(this).toggleClass('selected');
			$(this).parents("div[id*='frame']").find("." + classToBeActived).toggleClass('list_active');
			$(this).siblings(".option[data-value='clear']").removeClass('selected');
			$(this).siblings(".option[data-value='all']").removeClass('selected');

			var thisSelectCurrentSelected = thisOptionContainer.find('.option.selected');
			filtersActive = thisOptionContainer.find('.option.selected').length;
			switch (filtersActive) {
				case 1:
					newLabel = thisOptionContainer.find('.option.selected').attr('data-value');
					newLabelVal = thisOptionContainer.find('.option.selected').attr('data-value');
					break;
				case 0:
					newLabel = "NO_SELECTION";
					newLabelVal = "clear";
					break;
				default:
					newLabel = "MULTI_SELECTION";
					newLabelVal = "multi";
					break;
			}
		}
		// newLabel = window.lang.convert(newLabelVal, window.lang.currentLang);
		thisOptionContainer
			.siblings('.label_selected')
			.attr('lang', 'def')
			.text(newLabel);
		thisOptionContainer.siblings('.label_selected').attr('data-value', newLabelVal);
		window.lang.run();
	});
}

/*= BIND THUMBNAIL CLICK EVENT =*/
function bindThumbClick() {
	$(".thumb_single").unbind("click").click(function () {
		var tt_val, pp_val;
		var current_tt_val, current_tt_first_page;
		pp_val = $(this).attr('data-value');
		tt_val = $(this).attr('data-first-doc');

		var current_pp_val = $(".main_pp_select .label_selected").attr("data-value");
		current_tt_val = $(".main_tt_select .label_selected").attr("data-value");
		current_tt_first_page = $(".main_tt_select .option_container .option.selected").attr('data-first-page');

		if (current_tt_first_page === pp_val) {
			updateHash(current_tt_val, pp_val, "");
		} else {
			updateHash(tt_val, pp_val, "");
		}
		// if(current_pp_val === pp_val){
		//$("#thumb_elem").trigger('click');
		// }

		if (!magnifierON) {
			$("#image_elem").show();
			$("#image_fade").show();

			if ($("#imgd_link").hasClass("current_mode")) {
				$(".main_dd_select").trigger("imgd_thumb");
			}
		}
	});
}

/*= BIND ARROWS BUTTONS CLICK EVENT =*/
function bindArrowsBtnsClick() {
	// Go to previous page;
	$(".main_left_arrow , #BRicon_book_left").unbind("click").click(function () {
		arrow("left");
	});
	// Go to next page;
	$(".main_right_arrow , #BRicon_book_right").unbind("click").click(function () {
		arrow("right");
	});

	// Go to text
	if ($('#inside_left_arrow').length > 0 || $('#inside_right_arrow').length > 0) {
		$("#inside_left_arrow, #inside_left_arrow-add").unbind("click").click(function () {
			navDoc("left");
		});
		$("#inside_right_arrow, #inside_right_arrow-add").unbind("click").click(function () {
			navDoc("right");
		});
	}
}