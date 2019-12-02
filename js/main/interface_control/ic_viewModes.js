/**
 * Interface Control jQuery
 * Functions Handling Mode View Changes
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

/*= OPEN IMAGE/TEXT VIEW MODE =*/
function openTxtImgMode() {
	var mainLeftFrame = $('#main_left_frame');
	mainLeftFrame.show();
	var selectTToptions = $('.main_tt_select div.option_container div.option'),
		selectPPoptions = $('.main_pp_select div.option_container div.optionGroup div.option');
	if (selectTToptions.hasClass('ui-state-disabled') && selectPPoptions.hasClass('ui-state-disabled')) {
		selectTToptions.removeClass('ui-state-disabled');
		bindTTselectClick();
		selectPPoptions.removeClass('ui-state-disabled');
		bindPPselectClick();
	}

	var ppSelector = $('#span_pp_select'),
		ttSelector = $('#span_tt_select');
	updateHash(ttSelector.find('.label_selected').attr('data-value'),
		ppSelector.find('.label_selected').attr('data-value'), "");

	$("#txtimg_link")
		.addClass("current_mode")
		.siblings()
		.removeClass("current_mode");

	if ($('#span_ee_select .label_selected').attr('data-value').indexOf('translation') < 0) {
		$('.like_select.filter').removeClass('not_active');
	}

	// Nascondo pulsanti visibili solo nelle altre modalità
	$("#text_cont-add").remove();
	$("#span_ee_select-add").hide();

	// Se il regesto è nel box di sinistra, lo sposto a destra
	var regestoCont = $('#main_left_frame').find('#regesto_cont');
	if (regestoCont) {
		var current_font_size;
		if ($('#text_cont').attr('data-font-size') && $('#text_cont').attr('data-font-size') != '') {
			current_font_size = parseFloat($('#text_cont').attr('data-font-size'));
		} else {
			current_font_size = parseFloat($('#text_cont').css('font-size'));
		}

		regestoCont
			.css({
				'font-size': current_font_size + 'px',
				'line-height': (current_font_size + 10) + 'px'
			})
			.attr('data-font-size', current_font_size)
			.detach()
			.insertAfter("#right_header");
		if (regestoCont.text().trim() === '') {
			regestoCont.hide();
		}
	}

	// $('.secondary_toggler.active').trigger('click');
	$('.secondary_toggler.disabled').removeClass('disabled');

	var switchReg = $('#switchReg');
	if (!switchReg.hasClass('disabled')) {
		switchReg.show();
		var regestoCont = $('#regesto_cont');
		if (regestoCont) {
			var listsCont = $('#lists_cont');
			if (listsCont && listsCont.is(':visible')) {
				var testo_cont_height;
				testo_cont_height = $('#text_cont').height();

				regestoCont.css('height', testo_cont_height + 'px');
			}

			if (switchReg.hasClass('active')) {
				if (!regestoCont.is(':visible')) {
					//regestoCont.show('drop',  {direction: 'up'}, 'linear');
					regestoCont.show();
				}
			} else {
				regestoCont.hide();
			}
		}
	}

	$("#span_dd_select").hide();

	// Risistemo gli eventuali selettori spostati precedentemente
	var rightMenu = $("#right_menu");
	if ($("#left_menu").find("#span_pp_select").length == 0 && ppSelector.hasClass('left_menu')) {
		ppSelector.detach().prependTo('#left_menu');
		if (optionTooltipInPages) {
			ppSelector.find('.option_tooltip').css({
				'opacity': '0.8'
			});
		}
	} else if (rightMenu.find("#span_pp_select").length == 0 && ppSelector.hasClass('right_menu')) {
		ppSelector.detach().prependTo(rightMenu);
		if (optionTooltipInPages) {
			ppSelector.find('.option_tooltip').css({
				'opacity': '0.8'
			});
		}
	}

	if (rightMenu.find("#span_tt_select").length == 0) {
		ttSelector.detach().prependTo('#right_menu');
	}
	if (rightMenu.find("#span_ee_select").length == 0 && $("#span_ee_select").find('.option').length > 0) {
		$('#span_ee_select').detach().insertAfter(ttSelector);
	}

	if (!ttSelector.is(':visible')) {
		ttSelector.show();
	}
	if (!ppSelector.is(':visible')) {
		ppSelector.show();
	}

	mainLeftFrame.css({
		'width': '49.8%'
	})
	// , function () {
		document.getElementById("main_right_frame").style.display = "block";
		document.getElementById("right_menu").style.display = "block";
		document.getElementById("text_cont").style.display = "block";
		document.getElementById("image_tool").style.display = "block";
		document.getElementById("image_cont").style.display = "block";
		document.getElementById("image_menu").style.display = "inline";
		document.getElementById("image_elem").style.display = "block";

		var timeoutTxtImg = setTimeout(function () {
			$('#zoom_fit').trigger('click');
			resizeButtonsAndSelects();
			updateLinesWidth($('#main_right_frame'));
			clearTimeout(timeoutTxtImg);
		}, 42);
	// });

	$("#mag").show();
	$('#switchITL').show();
	$('#switchHS').show();

	$('#text_tool-add').hide().addClass('hidden');

	$('#search_cont-add').hide();

	var insideRightArrow = $('#inside_right_arrow'),
		insideLeftArrow = $('#inside_left_arrow');
	if (insideLeftArrow.length > 0 || insideRightArrow.length > 0) {
		insideLeftArrow
			.unbind('click')
			.click(function () {
				if (!$(this).hasClass('disabled')) {
					navDoc("left");
				}
			});

		insideRightArrow
			.unbind('click')
			.click(function () {
				if (!$(this).hasClass('disabled')) {
					navDoc("right");
				}
			});
	}


	$('#right_header.menuClosed').hide();

	$('#zvalint').show();

	fitFrame();

	$('#header_collapse').animate({
		left: "50%",
		marginLeft: "-10px"
	});

	$('.go-full-right:not(:visible)').show();

	if ($("#switchITL i").hasClass('fa fa-chain')) {
		if (!$("#switchITL").hasClass('inactive')) {
			Initialize();
		}
	} /*Add by JK for ITL*/
	if ($("#switchHS i").hasClass('fa fa-dot-circle-o')) {
		if (!$("#switchHS").hasClass('inactive')) {
			InitializeHS();
		}
	} /*Add by JK for HS*/

	$('.go-full-left.onWhite').removeClass('onWhite');

	$('#span_pp_select-add, #span_tt_select-add').remove();

	if ($('#search_link-add').hasClass('active')) {
		closeSearchBox(0, '-add');
	}
	createSliderTxtImg(); // Invoco la funzione che crea lo slider al click sul TxtImg
}

/*= OPEN TEXT/TEXT VIEW MODE =*/
function openTxtTxtMode() {
	console.time('openTxtTxtMode');

	$("#txttxt_link")
		.addClass("current_mode")
		.siblings()
		.removeClass("current_mode");

	var translationOpts = $(".option[data-value='translation']");
	if (translationOpts) {
		translationOpts.show();
	}

	var thumbsViscollBtns = $("#thumb_elem, #viscoll");
	if (thumbsViscollBtns) {
		thumbsViscollBtns.addClass("disabled");
	}

	var ppSelector = $('#span_pp_select'),
		ttSelector = $('#span_tt_select');
	updateHash(ttSelector.find('.label_selected').attr('data-value'),
		ppSelector.find('.label_selected').attr('data-value'), "");

	var noMenu_height;
	UnInitialize(); //Add by JK for ITL
	UnInitializeHS(); //Add by JK for HS

	closeSecondaryImageContentOpened('openTxtTxtMode', false);

	createSliderTxtTxt();

	// Nascondo menu, pulsanti e selettori relativi alle immagini /bookreader
	$("#image_menu, #mag, #image_cont, #msDesc_cont, #span_dd_select").hide();

	// GESTIONE NAVIGAZIONE DOCUMENTO
	var insideLeftArrow = $('#inside_left_arrow'),
		insideRightArrow = $('#inside_right_arrow');
	if (insideLeftArrow.length > 0 || insideRightArrow.length > 0) {
		insideLeftArrow.show();
		insideRightArrow.show();
	}

	// GESTIONE SELETTORI PAGINE E DOCUMENTO
	$('#span_pp_select:not(:visible)').show();
	$('#span_tt_select:not(:visible)').show();

	// GESTIONE MENU STRUMENTI TESTO BOX SINISTRO
	$('#text_tool-add:not(.menuClosed)').show();
	$('#text_tool-add').removeClass('hidden');

	// Se i menu erano stati chiusi in modalità bookreader,
	// chiudo quello di destra...che magari era rimasto aperto.
	$('#right_header.menuClosed').hide();
	var hiddenRightFrame = $("#main_right_frame:not(:visible)");

	var mainLeftFrame = $('#main_left_frame');
	var mainRightFrame = $('#main_right_frame');
	// Mostro il box di sinistra,
	if (mainLeftFrame && mainLeftFrame.length > 0) {
		mainLeftFrame[0].style.width = '49.8%';
		mainLeftFrame[0].style.borderLeftWidth = '2px';
		mainLeftFrame[0].style.borderRightWidth = '2px';
	}
	// mainLeftFrame.css({
	// 	width: '49.8%',
	// 	borderLeftWidth: '2px',
	// 	borderRightWidth: '2px'
	// });
	// GESTIONE PASSAGGIO BOOKREADER --> TXT-TXT
	// Se il box di destra non e' aperto, lo apro
	if (hiddenRightFrame && hiddenRightFrame.length > 0) {
		hiddenRightFrame[0].style.display = 'block';
	}

	// - fine gestione passaggio bookreader --> txttxt

	// Clono il contenuto testuale del box di destra, nel box di sinistra
	// aggiungendo "-add" agli identificativi degli elementi principali
	$('#text_cont')
		.clone()
		.attr("id", "text_cont-add")
		.insertAfter("#left_header");
	$('#text_cont-add>#text_elem')
		.attr("id", "text_elem-add");
	var textElemAdd = $('#text_elem-add');
	textElemAdd.find('#text_frame')
		.attr('id', 'text_frame-add')
		.find('#text')
		.attr('id', 'text-add')
		.css('display', 'inline-block');
	textElemAdd.find('#front_frame')
		.attr('id', 'front_frame-add')
		.find('#text')
		.attr('id', 'text-add')
		.css('display', 'inline-block');
	if ($('#text_cont-add .doc').length > 0) {
		var currentDocEl = $('#text_cont-add .doc.current'),
			scrollTop = currentDocEl && currentDocEl.position() ? currentDocEl.position().top : 0;
		$('#text_cont-add').scrollTop(scrollTop);
	}

	// Aggiorno (eventualmente) le dimensioni del selettore delle edizioni nel menu di sinistra
	if (!$('#left_header').hasClass('menuClosed')) {
		var eeSelectorAdd = $('#span_ee_select-add');
		if (!eeSelectorAdd.hasClass('widthChanged')) {
			eeSelectorAdd.addClass('widthChanged');
			eeSelectorAdd.find('.option_container').removeAttr('style');
			updateSelectLength(eeSelectorAdd);
		}
	}
	// Aggiorno (eventualmente) le dimensioni del selettore delle liste nel menu di sinistra
	if (!$('#text_tool-add').hasClass('menuClosed')) {
		var listSelectAdd = $('#span_list_select-add');
		if (!listSelectAdd.hasClass('widthChanged')) {
			listSelectAdd.addClass('widthChanged');
			listSelectAdd.find('.option_container').removeAttr('style');
			updateSelectLength(listSelectAdd);
		}
	}

	// Se ho il REGESTO e un solo livello di edizione
	var regestoCont = $('#regesto_cont');
	if (regestoCont && !regestoCont.hasClass('disable') && $("#span_ee_select").find('.option').length == 1) {
		$('#regesto_cont:not(:visible)').show();

		// Se il contanitore del regesto non è nel box di sinistra lo sposto da destra a sinistra
		if ($('#main_left_frame').find('#regesto_cont').length <= 0) {
			regestoCont
				.detach()
				.insertAfter("#left_header");
			var listsCont = $('#lists_cont'),
				searchCont = $('#search_cont');
			if ((listsCont && listsCont.is(':visible')) ||
				(searchCont && searchCont.is(':visible'))) {
				var new_regesto_height, list_header_height;
				list_header_height = $('#list_header').height() || $('#search_header').height();
				new_regesto_height = regestoCont.height() + list_header_height + 4;
				regestoCont.css({
					'height': new_regesto_height
				});
			}
		}

		// ...nascondo il pulsante del Regesto dal menu di destra
		$('#switchReg').hide();
		// ... e il regesto a sinistra
		// if ( $("#switchReg").hasClass('active') ) {
		//     $('#switchReg').trigger('click').addClass('active');
		// }
		//$('#regesto_cont').hide('drop',  {direction: 'up'}, 'linear');

		// ...nascondo il pulsante del Regesto dal menu di sinistra e il toggle in fondo al regesto di sinistra
		$('#switchReg-add').hide();

		// ...aggiorno l'etichetta nel menu di sinistra col testo "Regesto"
		$('#span_ee_select-add')
			.css({
				display: "none"
			})
			.find('.label_selected')
			.attr('data-value', 'regesto')
			.text('Regesto')
			.trigger('change');

		// Sposto il selettore dei testi a sinistra
		// if ( $('#left_menu').find('#span_tt_select').length == 0 ){
		//  $('#span_tt_select').detach().prependTo('#left_menu').css({'display':'inline-block'});
		// } else {
		//  if ( !$('#span_tt_select').is(':visible') ){
		//      $('#span_tt_select').show();
		//  }
		// }

		//$('#inside_left_arrow, #inside_right_arrow').hide();
		//$('#inside_left_arrow-add, #inside_right_arrow-add').show();
	} else {
		$('#span_ee_select-add')
			.css({
				display: "inline-block"
			})
			.find('.selected').removeClass('selected');
		var current_right_edition = $('#span_ee_select').find('.label_selected').attr('data-value');
		//$("#span_ee_select-add .option_container .option[data-value='translation']:first").trigger('click');
		$("#span_ee_select .option_container .option[data-value='critical']:first").trigger('click');
		$("#span_ee_select-add .option_container .option[data-value!='" + current_right_edition + "']:first").trigger('click');
		// ADD BY FS
		// Imposto i valori di default per la modalità txtxtx


		// DUPLICO PULSANTI DI NAVIGAZIONE PRESENTI NEL FRAME DI DESTRA
		var spanPpSelect = $('#span_pp_select');
		if (spanPpSelect.hasClass('right_menu')) {
			spanPpSelect
				.clone(true)
				.attr('id', 'span_pp_select-add')
				.prependTo('#left_menu')
				.css('display', 'inline-block');
		} else {
			spanPpSelect
				.clone(true)
				.attr('id', 'span_pp_select-add')
				.insertAfter('#span_tt_select')
				.css('display', 'inline-block');
		}

		$('#span_tt_select')
			.clone(true)
			.attr('id', 'span_tt_select-add')
			.prependTo('#left_menu')
			.css('display', 'inline-block');
	}

	$('#header_collapse').css({
		left: "50%",
		marginLeft: "-10px"
	});

	$('.go-full-right:not(:visible)').show();

	if ($('#left_header').hasClass('menuClosed')) {
		noMenu_height = $('#image_cont').height();
		$('#text_cont-add').css({
			"top": "-42px",
			"height": noMenu_height
		});
		$('#text_cont').css({
			"height": noMenu_height
		});
		$('.go-full-left').addClass('onWhite');
	}

	if (!regestoCont.hasClass('disable') &&
		$("#span_ee_select").find('.option').length == 1 &&
		regestoCont.text().trim() === '') {
		$('#main_left_frame').hide();
		$('#header_collapse').css({
			left: "100%",
			marginLeft: "-30px"
		});
	}

	fitFrame();
	InitializePopup();
	InitializeRefs();
	InitializeSearch();
	transformBrs();
	updateSelectLength($('#span_ee_select-add'));
	resizeButtonsAndSelects();
	console.timeEnd('openTxtTxtMode');
}

/*= OPEN BOOKREADER VIEW MODE =*/
function openBookreaderMode() {
	var mainLeftFrame = $('#main_left_frame');
	mainLeftFrame.show();
	var spanDDselectOptions = $('#span_dd_select.like_select div.main_dd_select div.option_container div.option');

	if (spanDDselectOptions) {
		spanDDselectOptions.removeClass('ui-state-disabled');
		bindDDselectClick();
	}

	UnInitialize(); //Add by JK for ITL
	UnInitializeHS(); //Add by JK for HS


	if ($('#search_link-add').hasClass('active')) {
		closeSearchBox(0, '-add');
	}

	$("#imgd_link").addClass("current_mode").siblings().removeClass("current_mode");

	$(".main_dd_select").trigger("imgd_mode");

	createSliderBookreader();

	$('#span_pp_select, #span_tt_select').hide();

	if ($('#main_left_frame').find('#regesto_cont')) {
		$('#regesto_cont').hide();
	}
	$("#switchReg-add").hide();
	$('#text_tool-add').hide().addClass('hidden');

	var ddSelector = $('#span_dd_select');

	// $("#right_menu").hide();
	mainLeftFrame.css({
		'width': '99.5%'
	});//, 800
		// ,
		// function () {
			$("#main_right_frame").hide();
			ddSelector.css({
				display: "inline-block"
			});
			updateSelectLength(ddSelector);
			fitFrame();
			document.getElementById("image_tool").style.display = "block";
			document.getElementById("image_cont").style.display = "block";
			document.getElementById("image_menu").style.display = "inline";
			document.getElementById("image_elem").style.display = "block";
			var timeoutBookreader = setTimeout(function () {
				$('#zoom_fit').trigger('click');
				resizeButtonsAndSelects();
				clearTimeout(timeoutBookreader);
			}, 42);
		// });

	//$("#image_cont-add").remove();
	$("#text_cont-add").remove();
	$("#span_ee_select-add").hide();

	//$("#text_cont").hide();

	$("#mag").show();
	$('#switchITL').hide();
	$('#switchHS').hide();

	$('#header_collapse').css({
		left: "100%",
		marginLeft: "-30px"
	});
	$('.go-full-right').hide();
	$('.go-full-left.onWhite').removeClass('onWhite');

	$('#span_pp_select-add, #span_tt_select-add').remove();

	$('.secondary_toggler.disabled').removeClass('disabled');
}

/*= OPEN SINGLE TEXT VIEW MODE =*/
function openTxtSingleMode() {
	$("#txt_single").addClass("current_mode").siblings().removeClass("current_mode");
	closeSecondaryImageContentOpened('openTxtSingleMode', false);
	$('#main_left_frame').animate({
		width: '0px',
		borderLeftWidth: '0px',
		borderRightWidth: '0px'
	}, function () {
		$("#text_cont-add").remove();
		var timeoutTxtSingle = setTimeout(function () {
			resizeButtonsAndSelects();
			updateLinesWidth($('#main_right_frame'));
			clearTimeout(timeoutTxtSingle);
		}, 42);
	});
	$('#header_collapse').animate({
		left: '15px'
	});
}
/*= MOSTRA VIRTUALE VIEW MODE =*/



/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND VIEW MODES BUTTONS CLICK EVENT =*/
function bindViewModesBtnsClick() {
	// TOGGLE TXT IMG MODE VIEW
	$("#txtimg_link").unbind('click').click(function () {
		if (!$(this).hasClass("current_mode")) {
			openTxtImgMode();
		}
	});

	// TOGGLE TXT TXT MODE VIEW
	$("#txttxt_link").unbind('click').click(function () {
		if (!$(this).hasClass("current_mode")) {
			openTxtTxtMode();
		}
	});

	// TOGGLE BOOKREADER MODE VIEW
	$("#imgd_link").unbind('click').click(function () {
		if (!$(this).hasClass("current_mode")) {
			openBookreaderMode();
		}
	});

	// TOGGLE TXT SINGLE MODE VIEW
	$("#txt_single").unbind('click').click(function () {
		if (!$(this).hasClass("current_mode")) {
			openTxtSingleMode();
		}
	});
}