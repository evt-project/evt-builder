/**
 * Interface Control jQuery
 * Functions Handling Single Boxes Fullscreen events
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
 * @short-term Federica Spinelli - FS
 * (added support for translation as third edition level)
 * @in 2017
 *
 **/

/*= EXPAND LEFT FRAME =*/
function goFullScreenLeft() {
	var height_full, width_full,
		margin_left, margin_top,
		widthSel, widthOpt,
		left_headerHeight;

	//Se ITL è attivo, disattivalo. Disabilita il pulsante.
	if (ITLon) {
		UnInitialize();
	}
	disableITLbutton();

	$('.zoomWindow').hide();
	$('.zoomPup').hide();

	$('#header_collapse').toggle();
	var mainLeftFrame = $("#main_left_frame"),
		globalWrapper = $("#global_wrapper"),
		globalWrapper_height = globalWrapper.height(),
		globalWrapper_width = globalWrapper.width();
	mainLeftFrame.toggleClass("full");
	height_full = ($(window).height() > globalWrapper_height) ? $(window).height() - 4 : globalWrapper_height - 4;
	width_full = ($(window).width() > globalWrapper_height) ? $(window).width() - 4 : globalWrapper_height - 4;
	// 4 è l'altezza totale dei bordi di sinistra e destra
	margin_left = -(mainLeftFrame.offset().left);
	margin_top = -(mainLeftFrame.offset().top);

	//cambia dimensione elementi per Mag //Add for Mag
	left_headerHeight = $('#left_header').height();
	$('#mag_image_elem').css({
		'margin-top': left_headerHeight + 'px',
		'height': height_full - left_headerHeight + 'px'
	});
	$('.zoomWindow').css({
		left: (width_full - $(".zoomWindow").width()) / 2 + 'px'
	});
	$('.zoomPup').css({
		left: (width_full - $(".zoomPup").width()) / 2 + 'px'
	});

	if (mainLeftFrame.find('#regesto_cont').length > 0) {
		$('#regesto_cont').animate({
			'height': height_full - 84
		}, 700);
	} else {
		fitFrame();
	}
	if (mainLeftFrame.attr('data-menu-state') == 'collapsed') {
		expandMenu(mainLeftFrame, height_full);
	}
	var textWidth;
	var isTxtTxtCurrentMode = $('#txttxt_link').hasClass('current_mode');
	mainLeftFrame.animate({
		width: width_full,
		height: height_full,
		top: margin_top,
		left: margin_left,
		minWidth: "1021px"
	}, 700, function () {
		$('#left_header .closeFullScreen').toggle();
		$('.zoomWindow').show(0); //Add for mag
		//$('#header_collapse').animate({opacity: 1});
		if (isTxtTxtCurrentMode) {
			var text_cont = $('#main_left_frame').find('#text');
			text_cont.css('display', 'inline-block');
			updateLinesWidth(mainLeftFrame);
			var textWidth = text_cont.outerWidth();
			text_cont.css({
				'margin-left': -(textWidth / 2) + 'px',
				'display': 'inline-block'
			});
		}
		resizeButtonsAndSelects();

	});

	fitBottomBoxHeightAndPosition('left', height_full);
	$('.go-full-left').toggle();
	//$('#switchITL:visible').hide();
	$('#switchITL').addClass('inactive');

	var textContAdd = $('#text_cont-add');
	textContAdd.removeAttr('style');
	var currentFontSize = textContAdd.attr('data-font-size');
	textContAdd.css({
		'font-size': currentFontSize + 'px'
	});
	if (isTxtTxtCurrentMode) {
		var text_cont = $('#main_left_frame').find('#text');
		text_cont.css('display', 'inline-block');
		updateLinesWidth(mainLeftFrame);
		textWidth = text_cont.outerWidth();
		text_cont.css({
			'left': '50%',
			'position': 'relative',
			'margin-left': -(textWidth / 2) + 'px'
		});
	}

	var spanEEselectAdd = $('#span_ee_select-add');
	if ((spanEEselectAdd.is(':visible')) && !spanEEselectAdd.hasClass('widthChanged')) {
		spanEEselectAdd
			.addClass('widthChanged')
			.find('.option_container')
			.removeAttr('style');

		spanEEselectAdd
			.each(function () {
				var thisOptionContainer = $(this).find('.option_container');
				widthSel = $(this).width();
				widthOpt = thisOptionContainer.width() + 10;
				if (widthSel > (widthOpt + 24)) {
					thisOptionContainer.css('width', widthSel - 10);
				} else {
					$(this).css('width', widthOpt + 24);
					thisOptionContainer.css('width', widthOpt + 14);
				}
			});
	}

	// Gestione selettori
	if (!$('#imgd_link').hasClass("current_mode")) {
		if ($('#left_menu').find('.main_pp_select').length == 0) {
			$('#span_pp_select').detach().prependTo('#left_menu').css('display', 'inline-block');
		}
		if ($('#left_menu').find('.main_tt_select').length == 0) {
			$('#span_tt_select').detach().prependTo('#left_menu').css('display', 'inline-block');
		}
	}
}

/*= REDUCE LEFT FRAME IF EXPANDED =*/
function closeFullScreenLeft() {
	var mainLeftFrame = $('#main_left_frame');
	//$('#header_collapse').animate({opacity: 0});
	$('.zoomWindow').hide();
	$('.zoomPup').hide();
	//caso in cui si passa a fullscreen dalla visualizzazione a doppia pagina
	if (mainLeftFrame.attr('data-menu-state') == 'collapsed') {
		collapseMenu(mainLeftFrame, $('#central_wrapper').innerHeight());
	}
	if ($('#main_right_frame').css("display") === "none") {
		mainLeftFrame.animate({
			width: "99.5%",
			height: "100%",
			top: "0px",
			left: "0px",
			minWidth: "0px"
		}, 700, function () {
			fitFrame();
			updateLinesWidth(mainLeftFrame);
			mainLeftFrame.removeClass("full");
			$('#left_header .closeFullScreen, #header_collapse').toggle();
			$('.go-full-left').toggle();
			setMagHeight(); //Add for Mag
			$('.zoomWindow').show();
			checkAnnPosHS(); //Add for HS
		});
	} else {
		mainLeftFrame.animate({
			width: "49.8%",
			height: "100%",
			top: "0px",
			left: "0px",
			minWidth: "0px"
		}, 700, function () {
			fitFrame();
			mainLeftFrame
				.removeClass("full")
				.removeAttr("style");
			updateLinesWidth(mainLeftFrame);
			$('#left_header .closeFullScreen, #header_collapse').toggle();
			$('.go-full-left').toggle();
			setMagHeight(); //Add for Mag
			$('.zoomWindow').show();
			checkAnnPosHS(); //Add for HS
			resizeButtonsAndSelects();
		});
		var switchITL = $('#switchITL');
		switchITL.show();
		//Se ITL è impostato su attivo, attiva il collegamento. Abilita il pulsante.
		if (switchITL.find('i').hasClass('fa fa-chain') && !switchITL.hasClass('likeInactive')) { //Add by JK for ITL
			Initialize();
		}
		enableITLbutton();
		if ($('#txttxt_link').hasClass('current_mode')) {
			$('#text_cont-add').find('#text').removeAttr('style');
		}
	}

	//$('#span_dd_select').hide();
	// Gestione selettori
	if ($('#txtimg_link').hasClass("current_mode")) {
		if ($('#span_pp_select').hasClass('right_menu') && $('#right_menu').find('#span_pp_select').length == 0) {
			$('#span_pp_select').detach().prependTo('#right_menu');
		} else if ($('#span_pp_select').hasClass('left_menu') && $('#left_menu').find('#span_pp_select').length == 0) {
			$('#span_pp_select').detach().prependTo('#left_menu');
		}
		if ($('#right_menu').find('#span_tt_select').length == 0) {
			$('#span_tt_select').detach().prependTo('#right_menu');
		}
	}
}

/*= EXPAND RIGHT FRAME =*/
function goFullScreenRight() {
	var height_full, width_full, margin_right, margin_left, margin_top;

	if (ITLon) { //Add by JK for ITL
		UnInitialize();
	}
	if (HSon) { //Add by JK for HS
		UnInitialize();
	}
	// Aggiunta di suffisso nel caso di testo a unico frame
	var suffix = '';
	if ($('#main_right_frame-single').length > 0) {
		suffix = '-single';
	}

	var mainRightFrame = $('#main_right_frame' + suffix);
	mainRightFrame.addClass("full");

	if (mainRightFrame.attr('data-menu-state') == 'collapsed') {
		expandMenu(mainRightFrame, $('#central_wrapper').innerHeight());
	}
	$('#header_collapse').toggle();
	var left_frame_width, offset_left;
	if ($('#txt_single').length > 0 && $('#txt_single').hasClass('current_mode')) {
		margin_left = -($('#central_wrapper').offset().left);
		left_frame_width = $('#central_wrapper').outerWidth();
		offset_left = 0;
	} else {
		margin_left = -($('#main_left_frame').offset().left);
		left_frame_width = $('#main_left_frame').outerWidth();
		offset_left = left_frame_width;
		mainRightFrame.css({
			'position': 'absolute',
			'left': offset_left + 'px',
			'width': left_frame_width + 'px'
		});
	}
	var globalWrapper = $("#global_wrapper"),
		globalWrapper_height = globalWrapper.height(),
		globalWrapper_width = globalWrapper.width();
	height_full = ($(window).height() > globalWrapper_height) ? $(window).height() - 4 : globalWrapper_height - 4;
	width_full = ($(window).width() > globalWrapper_width) ? $(window).width() - 4 : globalWrapper_width - 4;
	// 4 è l'altezza totale dei bordi di sinistra e destra
	margin_right = -($(window).width() - (mainRightFrame.offset().left + mainRightFrame.width()) - 4);
	margin_top = -(mainRightFrame.offset().top);
	var textWidth;
	mainRightFrame.animate({
		width: width_full,
		height: height_full,
		marginTop: margin_top,
		left: margin_left,
		right: 0,
		minWidth: "1021px",
	}, 700, function () {

		updateLinesWidth(mainRightFrame);
		$('#right_header .closeFullScreen').toggle();
		textWidth = $('#text_cont').find('#text').css('display', 'inline-block').outerWidth();
		$('#text_cont').find('#text').css({
			'margin-left': -(textWidth / 2) + 'px',
			'display': 'display: inline-block;'
		});
		resizeButtonsAndSelects();
	});
	textWidth = $('#text_cont').find('#text').css('display', 'inline-block').outerWidth();
	$('#text_cont')
		.css('overflow-x', 'hidden')
		.find('#text')
		.css({
			'left': '50%',
			'position': 'relative',
			'margin-left': -(textWidth / 2) + 'px'
		});

	$('.go-full-right').toggle();

	fitBottomBoxHeightAndPosition('right', height_full);
	// fitFrame();
	// Gestione selettori
	if ($('#right_menu').find('.main_pp_select').length == 0) {
		$('#span_pp_select').detach().prependTo('#right_menu');
	}
	if ($('#right_menu').find('.main_tt_select').length == 0) {
		$('#span_tt_select').detach().prependTo('#right_menu');
	}
}

/*= REDUCE RIGHT FRAME IF EXPANDED =*/
function closeFullScreenRight() {
	var widthLeft;

	if ($('#switchITL i ').hasClass('fa fa-chain')) { //Add by JK for ITL
		Initialize();
	}
	if ($('#switchHS i ').hasClass('fa fa-dot-circle-o')) { //Add by JK for HS
		InitializeHS();
	}

	// Aggiunta di suffisso nel caso di testo a unico frame
	var suffix = "";
	if ($('#main_right_frame-single').length > 0) suffix = '-single';

	var mainRightFrame = $('#main_right_frame' + suffix);
	if (mainRightFrame.attr('data-menu-state') == 'collapsed') {
		collapseMenu(mainRightFrame, $('#central_wrapper').innerHeight());
	}
	var left_frame_width, offset_left;
	if ($('#txt_single').length > 0 && $('#txt_single').hasClass('current_mode')) {
		left_frame_width = $('#central_wrapper').outerWidth();
		offset_left = 0;
	} else {
		left_frame_width = $('#main_left_frame').outerWidth();
		offset_left = left_frame_width;
	}
	$('#text_cont').find('#text').removeAttr('style');
	mainRightFrame.animate({
		left: offset_left + 'px',
		width: left_frame_width + 'px',
		height: "100%",
		marginTop: "0px",
		minWidth: "0px"
	}, 700, function () {

		updateLinesWidth(mainRightFrame);
		fitFrame();
		mainRightFrame
			.removeClass("full")
			.removeAttr("style");
		$('#right_header .closeFullScreen, #header_collapse').toggle();
		$('.go-full-right').toggle();
		resizeButtonsAndSelects()
	});
	// Gestione selettori
	if (!$('#txttxt_link').hasClass("current_mode")) {
		if ($('#span_pp_select').hasClass('right_menu') && $('#right_menu').find('#span_pp_select').length == 0) {
			$('#span_pp_select').detach().prependTo('#right_menu');
		} else if ($('#span_pp_select').hasClass('left_menu') && $('#left_menu').find('#span_pp_select').length == 0) {
			$('#span_pp_select').detach().prependTo('#left_menu');
		}
		if (!$('#switchReg').hasClass('disabled') && $('#span_ee_select .option').length <= 1) {
			if ($('#left_menu').find('#span_tt_select').length == 0) {
				$('#span_tt_select').detach().prependTo('#left_menu');
			}
		}
	} else {
		if ($('#span_pp_select').hasClass('right_menu') && $('#right_menu').find('#span_pp_select').length == 0) {
			$('#span_pp_select').detach().prependTo('#right_menu');
		} else if ($('#span_pp_select').hasClass('left_menu') && $('#left_menu').find('#span_pp_select').length == 0) {
			$('#span_pp_select').detach().prependTo('#left_menu');
		}
	}
}

/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND GO FULLSCREEN BTNs CLICK EVENT =*/
function bindInternalFullscreenBtnClick() {
	// goFullScreenLeft
	$("#goFullScreenLeft").unbind("click").click(function () {
		goFullScreenLeft();
	});
	// goFullScreenRight
	$("#goFullScreenRight").unbind("click").click(function () {
		goFullScreenRight();
	});

	// closeFullScreenLeft
	$("#closeFullScreenLeft").unbind("click").click(function () {
		closeFullScreenLeft();
	});

	// closeFullScreenRight
	$("#closeFullScreenRight").unbind("click").click(function () {
		closeFullScreenRight();
	});
}