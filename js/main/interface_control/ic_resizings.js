/**
 * Interface Control jQuery
 * Functions Handling Resising events
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

/*= ADAPT HEIGHT OF TEXT CONTAINER =*/
function updateTextContHeight() {
	var mainContainer, centralWrapper;
	var mainContainerHeight, bottomBoxHeaderHeight;
	var new_container_height, old_container_height;

	centralWrapper = $('#central_wrapper');
	new_container_height = centralWrapper.height();
	new_container_height -= (centralWrapper.find('header').height() * 2);
	// $('.menu-box:visible').each(function(){
	//  new_container_height -= $(this).height();
	// });

	centralWrapper.find("div[id*='main_']").each(function() {
		// Se nel frame i box in basso sono tutti chiusi
		if ($(this).find('.bottomBoxOpened').length == 0) {
			// Ricalcolo l'altezza del frame in modo che riempia tutto lo spazio
			new_container_height = $(this).height();
			if (!$(this).find('header').hasClass('menuClosed')) {
				new_container_height -= $(this).find('header').height();
				if ($(this).find('.bottom-menu').length > 0) {
					new_container_height -= $(this).find('.bottom-menu').height();
				}
			}
			$(this).find('.text-box.height-changed')
				.removeClass('height-changed')
				.css({
					'height': new_container_height + 'px'
				});
		}
		// Invece se il box in basso del frame è aperto
		// ricalcolo l'altezza sulla base dell'header di tale box
		else {
			mainContainerHeight = $(this).height();
			bottomBoxHeaderHeight = $(this).find('.bottomBoxOpened .bottomBoxHeader:visible').height() + 2;

			if ($(this).find('header').hasClass('menuClosed')) {
				new_container_height = mainContainerHeight - bottomBoxHeaderHeight;
				$(this).find('.bottomBox:visible')
					.animate({
						height: mainContainerHeight + 'px'
					}, 'fast');
			} else {
				//old_container_height = $('#main_left_frame').height()-$('#left_header').height()-$('#image_tool').height();
				new_container_height = mainContainerHeight - bottomBoxHeaderHeight - ($(this).find('header').height() * 2);
			}

			// $('.text-box')
			//  .removeClass('height-changed')
			//  .css({'height': (new_container_height+bottomBoxHeaderHeight+2)+'px'});
			$(this)
				.find('.text-box')
				.each(function() {
					if (!$(this).hasClass('height-changed')) {
						$(this)
							.addClass('height-changed')
							.animate({
								'height': new_container_height
							}, 'fast');
					}
				});
		}
	});
}

/*= ADAPT WIDTH OF SELECTs DEPENDING ON THEIR WIDER OPTION CHILD =*/
function updateSelectLength(elem) {
	var widthSel, widthOpt;
	widthSel = $(elem).outerWidth();

	// // Calcolo la larghezza del div figlio di .like_select
	// widthSel = $(elem).find('div').width();
	// // Calcolo la larghezza del div.option_container, aggiungendo 10 per via del padding
	// widthOpt = $(elem).find('.option_container').width()+10;
	// // Se la larghezza del contenitore esterno è maggiore di quella delle option aggiorno l'option_container e ristemo il genitore
	// if(widthSel > widthOpt){

	//  // Imposto la larghezza dell'option container secondo quella del div figlio di .like_select
	//  $(elem)
	//      .find('.option_container')
	//          .css('width', widthSel)
	//          .attr('data-first-load-width', widthSel);

	//  // Ricalcolo la dimensione dell'option_container, sempre aggiungendo 10 per il padding
	//  widthOpt = $(elem).find('.option_container').width()+10;
	//  // Se la nuova dimensione di option_container è maggiore di quella del div figlio di .like_select
	//  // (Ovvero se le opzioni "sbordano")
	//  // Aggiorno nuovamente la larghezza del div .like_select sulla base della nuova larghezza di option_container
	//  if(widthSel < widthOpt){
	//      // $(elem)
	//      //  .css('width', widthOpt)
	//      //  .attr('data-first-load-width', widthOpt);
	//  }
	// }
	// // Se altrimenti il contenitore delle option è più largo in partenza aggiorno il genitore
	// else {

	//  // imposto la larghezza di .like_select sulla base di quella di option_container,
	//  // aggiungendo 14 per via del div per l'apertura
	//  // $(elem)
	//  //  .css('width', widthOpt+14)
	//  //  .attr('data-first-load-width', widthOpt+14);
	//  // Poi aggiorno la dimensione dell'option_container, aggiungendo i 4px che mi permettono di allinearla al div figlio di .like_select
	//  $(elem)
	//      .find('.option_container')
	//          .css('width', widthOpt+4)
	//          .attr('data-first-load-width', widthOpt+4);
	// }
	// Riporto la position di option_container ad absolute per rendere corretto il posizionamento all'apertura
    var elemOptionContainer = $(elem).find('.option_container');
	if (elemOptionContainer.hasClass('up')) {
		var height;
		height = elemOptionContainer.height() + 6;
		elemOptionContainer.attr('data-toggle-top', height);
	}

	if ($(elem).attr('id') === 'span_ee_select') {
		var widthEE, optEE;
		widthEE = $('#span_ee_select').find('div').width();
		optEE = $('#span_ee_select').find('.option_container').width();

		// $('#span_ee_select-add')
		//  .css('width', widthEE)
		//  .attr('data-first-load-width', widthEE);
		$('#span_ee_select-add')
			.addClass('widthChanged')
			.find('.option_container')
			.removeAttr('style')
			.css('width', optEE)
			.attr('data-first-load-width', optEE);
	}
	if ($(elem).attr('id') === 'span_dd_select') {
		var widthPP, optPP;
		if ($('#imgd_link').hasClass('current_mode')) {
			var optCont = $('#span_dd_select').find('.option_container');
			optCont.css({
				'width': '-moz-max-content',
				'position': 'relative',
				'visibility': 'hidden',
				'display': 'block'
			});

			widthPP = $('#span_dd_select').find('div').width() * 1.5 - 5;
			optPP = $('#span_dd_select').find('.option_container').width() * 1.5;
			widthSel = optCont.width() * 1.2;
		} else {
			widthPP = $('#span_pp_select').find('div').width() * 1.5 - 5;
			optPP = $('#span_pp_select').find('.option_container').width() * 1.5;
		}
		$('#span_dd_select')
			.addClass('widthChanged')
			.find('.option_container')
			.removeAttr('style')
			.css('width', widthSel)
			.attr('data-first-load-width', widthSel);

		if (optionTooltipInPages) {
			if ($(elem).find('.option_tooltip_dd').length > 0) {
				$(elem).find('.option_tooltip_dd').css({
					'left': widthSel + 1,
					'min-width': widthSel
				});
			}
		}
	}
	if ($(elem).attr('id') === 'span_tt_select') {
		if (optionTooltipInPages) {
			if ($('#span_pp_select').find('.option_tooltip').length > 0) {
				$('#span_pp_select').find('.option_tooltip').css({
					'min-width': widthSel - 50
				});
			}
		}
	}
	if ($(elem).attr('id') === 'span_pp_select') {
		if (optionTooltipInPages) {
			if ($(elem).find('.option_tooltip').length > 0) {
				$(elem).find('.option_tooltip').css({
					'left': widthSel + 1
				});
			}
		}
	}
	if ($(elem).attr('id') === 'span_list_select-add') {
		widthSel = $('#span_list_select').find('.option_container').width() + 10;
	}

	$(elem).find('.option_container').css({
		"width": "-moz-max-content",
		"min-width": widthSel - 10,
		"position": "absolute",
		"visibility": "visible",
		"display": "none"
	});
}

/*= RESIZE UPPER TOOLBAR DEPENDING ON AVAILABLE BUTTONS =*/
function resizeGlobalTopBar() {
	var interface_tools_width = $('#cont_interface_tools').width(),
		botleftconcave_width = $('.botleftconcave').width(),
		concave_width = $('.concave').width(),
		extTop = $('.extTop').width();
	var diff = interface_tools_width - botleftconcave_width + 10;
	$('.botleftconcave').width(botleftconcave_width + diff);
	$('.concave').width(concave_width + diff);
	$('.extTop').width(extTop + diff);
}

/*= RESIZE BUTTONS AND SELECTS DEPENDING ON AVAILABLE SPACE =*/
function resizeButtonsAndSelects() {
	/* ========= */
	/* TOP MENUS */
	/* ========= */

	/*= LEFT FRAME =*/
	var leftMenu = $('#left_menu')
	leftHeader = $('#left_header'),
		leftHeaderBtns = leftHeader.find('.mainButtons'),
		leftHeaderSelects = leftHeader.find('.like_select');
	leftMenu.css('width', 'auto');
	leftMenu
		.clone()
		.attr('id', 'left_menu_copy')
		.css({
			'width': 'auto',
			'opacity': '0',
			'position': 'fixed'
		})
		.appendTo(leftHeader);
	var leftMenuCopy = $('#left_menu_copy');
	leftMenuCopy.find('.small:visible').removeClass('small').find('span').show();

	if (leftMenuCopy.outerWidth() >= leftHeader.innerWidth()) {
		leftHeaderBtns
			.addClass('small')
			.find('span').hide();

		if (leftMenu.outerWidth() > leftHeader.innerWidth()) {
			var diff = leftMenu.outerWidth() - leftHeader.innerWidth();
			var remove_width = diff / leftHeaderSelects.length;
			leftHeaderSelects.each(function() {
				var new_width = $(this).outerWidth() - remove_width;
				$(this).css({
					'width': new_width
				});
			});
		} else {
			leftHeaderSelects.each(function() {
				var reset_width = $(this).attr('data-first-load-width');
				$(this).css({
					'width': reset_width
				});
			});
		}
	} else {
		leftHeaderBtns
			.removeClass('small')
			.find('span').show();

		leftHeaderSelects.each(function() {
			var reset_width = $(this).attr('data-first-load-width');
			$(this).css({
				'width': reset_width
			});
		});
	}
	leftMenuCopy.remove();
	leftMenu.css('width', '100%');


	/*= RIGHT FRAME =*/
	var rightMenu = $('#right_menu'),
		rightHeader = $('#right_header')
	rightHeaderBtns = rightHeader.find('.mainButtons'),
		rightHeaderSelects = rightHeader.find('.like_select');
	rightMenu.css('width', 'auto');
	if (rightMenu.outerWidth() >= rightHeader.innerWidth() - 30) {
		rightHeaderBtns
			.addClass('small')
			.find('span').hide();
	} else {
		rightHeaderBtns
			.removeClass('small')
			.find('span').show();
	}
	if (rightMenu.outerWidth() >= rightHeader.innerWidth() - 30) {
		var diff = rightMenu.outerWidth() - (rightHeader.innerWidth() - 30);
		var remove_width = diff / rightHeaderSelects.length;
		if (remove_width > 0) {
			rightHeaderSelects.each(function() {
				var new_width = $(this).outerWidth() - remove_width;

				$(this).find('.label_selected').css({
					'width': new_width
				});

			});
			rightHeaderBtns
				.addClass('small')
				.find('span').hide();
		}
	} else {
		rightHeaderSelects.each(function() {
			$(this).css({
				'width': 'auto'
			});
		});
	}
	rightMenu.css('width', '100%');

	/* ============ */
	/* BOTTOM MENUS */
	/* ============ */

	/*= LEFT FRAME =*/
	var leftTextTool = $('#text_tool-add'),
		leftTextToolBtns = leftTextTool.find('.mainButtons'),
		leftTextToolSelect = leftTextTool.find('.like_select');
	leftTextTool.css('width', 'auto');
	if (leftTextTool.outerWidth() >= rightHeader.innerWidth() - 30) {
		leftTextToolBtns
			.addClass('small')
			.find('span').hide();
	} else {
		leftTextToolBtns
			.removeClass('small')
			.find('span').show();
	}
	if (leftTextTool.outerWidth() >= rightHeader.innerWidth() - 30) {
		var diff = leftTextTool.outerWidth() - (rightHeader.innerWidth() - 30);
		var remove_width = diff / leftTextToolSelect.length;
		if (remove_width > 0) {
			leftTextToolSelect.each(function() {
				var new_width = $(this).outerWidth() - remove_width;
				$(this).find('.label_selected').css({
					'width': new_width
				});

			});
			leftTextToolBtns
				.addClass('small')
				.find('span').hide();
		}
	} else {
		leftTextToolSelect.each(function() {
			$(this).css({
				'width': 'auto'
			});
		});
	}
	leftTextTool.css('width', '100%');

	/*= RIGHT FRAME =*/
	var rightTextTool = $('#text_tool'),
		rightTextToolBtns = rightTextTool.find('.mainButtons'),
		rightTextToolSelect = rightTextTool.find('.like_select');
	rightTextTool.css('width', 'auto');
	if (rightTextTool.outerWidth() >= rightHeader.innerWidth() - 30) {
		rightTextToolBtns
			.addClass('small')
			.find('span').hide();
	} else {
		rightTextToolBtns
			.removeClass('small')
			.find('span').show();
	}
	if (rightTextTool.outerWidth() >= rightHeader.innerWidth() - 30) {
		var diff = rightTextTool.outerWidth() - (rightHeader.innerWidth() - 30);
		var remove_width = diff / rightTextToolSelect.length;
		if (remove_width > 0) {
			rightTextToolSelect.each(function() {
				var new_width = $(this).outerWidth() - remove_width;
				$(this).find('.label_selected').css({
					'width': new_width
				});

			});
			rightTextToolBtns
				.addClass('small')
				.find('span').hide();
		}
	} else {
		rightTextToolSelect.each(function() {
			$(this).css({
				'width': 'auto'
			});
		});
	}
	rightTextTool.css('width', '100%');
}

/*= ADAPT HEIGHT AND POSITION OF BOTTOM BOX (USED FOR SEARCH RESULTS AND LISTS) =*/
function fitBottomBoxHeightAndPosition(boxSuffix, height_full) {
	var mainFrame = $("div[id*='main_" + boxSuffix + "_frame']");
	if (mainFrame.find('.bottomBoxOpened').length > 0) {
		mainFrame.find('.bottomBoxOpened').each(function() {
			if ($(this).hasClass('collapsed')) {
				$(this).animate({
					'top': height_full - 119,
					'height': height_full - 85
				}, 700);
				// 118 = altezza menu in alto e menu in basso + altezza header liste + 1px
			} else {
				$(this).animate({
					'height': height_full - 85
				}, 700);
			}
		});

		mainFrame.find("div[id*='text_cont'], div[id*='regesto_cont'], div[id*='front_cont']").animate({
			'height': height_full - 118
		}, 700);
	} else {
		mainFrame.find('.bottomBox:visible').animate({
			'height': height_full - 85
		}, 700);
		mainFrame.find("div[id*='text_cont'], div[id*='regesto_cont'], div[id*='front_cont']").animate({
			'height': height_full - 85
		}, 700);
	}
}

/*= FIT FRAME =*/
function fitFrame() {
	var noMenu_height;
	var noMenu_height_left, noMenu_height_right;
	if ($('.full').length > 0) {
		noMenu_height = $('.full').height();
	} else {
		noMenu_height = $('#central_wrapper').outerHeight();
	}
	noMenu_height_left = noMenu_height;
	noMenu_height_right = noMenu_height;
	var mainLeftFrame = $('#main_left_frame'),
		mainRightFrame = $('#main_right_frame');
	// Se menu chiuso
	if ($('#left_header').hasClass('menuClosed')) {
		$('#lists_cont, #search_cont')
			.css('height', noMenu_height);

		if (mainLeftFrame.find('.bottomBox:visible').length > 0) {
			noMenu_height_left -= mainLeftFrame.find('.bottomBox:visible').first().find('.bottomBoxHeader').first().outerHeight();
		}
		if (mainRightFrame.find('.bottomBox:visible').length > 0) {
			noMenu_height_right -= mainRightFrame.find('.bottomBox:visible').first().find('.bottomBoxHeader').first().outerHeight();
		}

		if (mainRightFrame.find('#regesto_cont').length > 0 ||
			mainRightFrame.find('#front_cont').length > 0) {
			// LEFT FRAME
			mainLeftFrame
				.find('#text_cont-add, #regesto_cont-add, #front_cont-add, #thumb_cont')
				.css('height', noMenu_height_left);
			// RIGHT FRAME
			mainRightFrame
				.find('#text_cont, #regesto_cont, #front_cont')
				.css('height', noMenu_height_right);
		} else {
			// LEFT FRAME
			mainLeftFrame
				.find('#text_cont-add, #regesto_cont-add, #thumb_cont')
				.css('height', noMenu_height_left + 33);

			// RIGHT FRAME
			mainRightFrame
				.find('#regesto_cont, #front_cont')
				.css('height', noMenu_height + 33);

			mainRightFrame
				.find('#text_cont')
				.css('height', noMenu_height);

		}
		if ($('.bottomBox:visible').hasClass('collapsed')) {

		}
		$('.bottomBox.collapsed:visible').each(function() {
			var bottomBox_newTop = noMenu_height - (mainRightFrame.find('.bottomBox:visible').find('.bottomBoxHeader').outerHeight() * 2) - 11;
			$(this).css('top', bottomBox_newTop + 'px');
		});
	}
	// Se menu aperto
	else {
		if ($('.bottom-menu').length > 0) {
			noMenu_height = noMenu_height - $('.top-menu').first().outerHeight() - $('.bottom-menu').first().outerHeight();
		} else {
			noMenu_height = noMenu_height - $('.top-menu').first().outerHeight();
		}
		if ($('.bottomBox').length > 0 && $('.bottomBox:visible').length > 0) {
			$('.bottomBox').css('height', noMenu_height);
		}
		noMenu_height_left = noMenu_height;
		if (mainLeftFrame.find('.bottomBox').length > 0 &&
			mainLeftFrame.find('.bottomBox:visible').length > 0) {
			noMenu_height_left = noMenu_height_left - mainLeftFrame.find('.bottomBox:visible').find('.bottomBoxHeader').outerHeight() - 1;
		}

		noMenu_height_right = noMenu_height;
		if (mainRightFrame.find('.bottomBox').length > 0 &&
			mainRightFrame.find('.bottomBox:visible').length > 0) {
			noMenu_height_right = noMenu_height_right - mainRightFrame.find('.bottomBox:visible').find('.bottomBoxHeader').outerHeight() - 1;
		}

		$('.bottomBox.collapsed:visible').each(function() {
			$(this).css('top', noMenu_height - $('.bottomBox:visible').find('.bottomBoxHeader').outerHeight() - 2);
		});

		// LEFT FRAME
		mainLeftFrame.find('#text_cont-add, #regesto_cont, #regesto_cont-add, #front_cont-add')
			.css('height', noMenu_height_left);

		// RIGHT FRAME
		mainRightFrame.find('#text_cont, #regesto_cont, #front_cont')
			.css('height', noMenu_height_right);
	}
}

/*= CROP LONG TEXT LABELS =*/
function cropLongTextLabel(text_label, min_char_num) {
	if (text_label.length > min_char_num) {
		text_label = text_label.substr(0, min_char_num - 3) + "...";
	}
	return text_label;
}

/*= UPDATE WIDTH OF LINES WITH LINE NUMBER =*/
function updateLinesWidth(mainFrameElem) {
	var textInnerWidt = mainFrameElem.find("div[id*='text_cont']").innerWidth() * 85 / 100;
	mainFrameElem.find('.dipl-lineN+.dipl-left, .interp-lineN+.interp-left, .trad-lineN+.trad-left').each(function() {
		var lineNwidth = $(this).prev().outerWidth();
		$(this).css({
			'max-width': (textInnerWidt - lineNwidth - 43) + 'px',
			'display': 'inline'
		});
	});
}
/* ******************** */
/* WINDOW RESIZE EVENTS */
/* ******************** */
$(function() {
	$(window).bind('resize', function(e) {
		var height_full, width_full, leftCss, newLeft, rightR, leftR;
		// window.resizeEvt;
		if ($('.full') != null) {
			height_full = ($(window).height() > $("body").height()) ? $(window).height() - 4 : $("body").height();
			width_full = $(window).width() - 4;
			$('.full').css({
				"height": height_full,
				"width": width_full
			});
			setMagHeight();
			resizeButtonsAndSelects();
			showHideListsNavBtn();
			fitFrame();
			// clearTimeout(window.resizeEvt);
			// window.resizeEvt = setTimeout(function()
			// {
			if ($('.full').length > 0) {
				leftCss = $('.full').css("left").replace(/[^-\d\.]/g, '');
				newLeft = leftCss - ($('.full').offset().left);
				$('.full').css("left", newLeft);
			}
			if ($('#main_right_frame').hasClass('full')) {
				rightR = -(($('.go-full-right').offset().left) - ($('.go-full-right').position().left));
				$('.go-full-right').css("right", rightR);
			} else {
				if ($('#main_left_frame').hasClass('full')) {
					leftR = -(($('.go-full-left').offset().left) - ($('.go-full-left').position().left));
					$('.go-full-left').css("left", leftR);
				}
			}
			// }, 300);
		}
		//updateTextContHeight();
		//scrollDownListContainer(0);
	});
});