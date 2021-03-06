/**
 * Interface Control jQuery
 * Functions Handling Global Menu Elements and Events
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
 * @short-term coauthor Luca Sarri – LS
 * (added and modified plugin for different languages)
 * @in 2015
 **/


/*= CLOSE GLOBAL MENU =*/
function collapseMenu(frame, height) {
	$('.top-menu:not(.menuClosed)').hide('blind').addClass('menuClosed');
	$('.bottom-menu:not(.menuClosed)').slideUp().addClass('menuClosed');

	var bottomBoxHeader_height = 0;
	var topMenu_height;
	var bottomBoxOpened_visible = frame.find('.bottomBoxOpened:visible');
	if (!frame.is(':visible')) {
		frame.css({
			'display': 'block',
			'visibility': 'hidden'
		});
		topMenu_height = frame.find('.top-menu').outerHeight();
		if (bottomBoxOpened_visible.length) {
			bottomBoxHeader_height = bottomBoxOpened_visible.find('.bottomBoxHeader').outerHeight();
		}
		frame.css({
			'display': 'none',
			'visibility': 'visible'
		});
	} else {
		topMenu_height = frame.find('.top-menu').outerHeight();
		if (bottomBoxOpened_visible.length) {
			bottomBoxHeader_height = bottomBoxOpened_visible.find('.bottomBoxHeader').outerHeight();
		}
	}

	frame.find('.inner_frame:not(.full-height)').animate({
		height: height - bottomBoxHeader_height,
		top: -topMenu_height
	});
	frame.find('.inner_frame.full-height').animate({
		height: height - bottomBoxHeader_height,
		top: 0
	});
	frame.find('.bottomBoxOpened:not(.collapsed)').animate({
		height: height,
		top: -topMenu_height
	});
	frame.find('.bottomBoxOpened.collapsed').each(function() {
		var bottomBox_newTop = height - ($(this).find('.bottomBoxHeader').outerHeight() * 2) - 11;
		$(this).animate({
			top: bottomBox_newTop + 'px'
		});
	});

	if (magnifierON === true) {
		magnifierReady();
	}
}

/*= OPEN GLOBAL MENU =*/
function expandMenu(frame, height) {
	$('.top-menu.menuClosed:not(.hidden)').show('blind');
	$('.bottom-menu.menuClosed:not(.hidden)').slideToggle("slow");
	$('.top-menu.menuClosed, .bottom-menu.menuClosed').removeClass('menuClosed');

	var bottomBoxHeader_height = 0;
	var topMenu_height;
	var bottomBoxOpened_visible = frame.find('.bottomBoxOpened:visible');
	if (!frame.is(':visible')) {
		frame.css({
			'display': 'block',
			'visibility': 'hidden'
		});
		topMenu_height = frame.find('.top-menu').outerHeight();
		if (bottomBoxOpened_visible.length) {
			bottomBoxHeader_height = bottomBoxOpened_visible.find('.bottomBoxHeader').outerHeight();
		}
		frame.css({
			'display': 'none',
			'visibility': 'visible'
		});
	} else {
		topMenu_height = frame.find('.top-menu').outerHeight();
		if (bottomBoxOpened_visible.length) {
			bottomBoxHeader_height = bottomBoxOpened_visible.find('.bottomBoxHeader').outerHeight();
		}
	}

	var withMenu_height = height - (topMenu_height * 2);
	frame.find('.inner_frame:not(#image_cont):not(.full-height)').animate({
		height: withMenu_height - bottomBoxHeader_height,
		top: 0
	});
	frame.find('.inner_frame.full-height').animate({
		height: height - topMenu_height,
		top: topMenu_height
	});
	frame.find('#image_cont').animate({
		height: (withMenu_height + topMenu_height),
		top: 0
	});
	frame.find('.bottomBoxOpened:not(.collapsed)').animate({
		height: withMenu_height,
		top: 0
	});
	frame.find('.bottomBoxOpened.collapsed').each(function() {
		var bottomBox_newTop = withMenu_height - $(this).find('.bottomBoxHeader').outerHeight() - 2;
		$(this).animate({
			top: bottomBox_newTop + 'px'
		});
	});

	if (magnifierON === true) {
		magnifierReady();
	}
}

/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND SETTINGS BUTTON CLICK EVENT =*/
function bindSettingsBtnClick() {
	$('#settings_link').unbind("click").click(function() {
		$(this).toggleClass('active');
		var settingsCont = $('#settings_cont');
        if (settingsCont.is(':visible')) {
			settingsCont.animate({
				height: "toggle"
			}, 0);
		} else {
			settingsCont.animate({
				height: "toggle"
			}, 0);
		}
	});
}

/*= INITIALIZE LANG AND BIND FLAG BUTTONS CLICK EVENT =*/
function initializeLang() {
	var spanEEselect = $('#span_ee_select'),
		spanEEselectAdd = $('#span_ee_select-add'),
		spanDDselect = $('#span_dd_select'),
		spanLISTselect = $('#span_list_select');
	$('.flag').unbind("click").click(function() {
		if (!$(this).hasClass('active')) {
			var lang = $(this).attr('data-value');
			$('.flag.active').removeClass('active');
			window.lang.change(lang);
			$(this).addClass('active');
			$('#settings_link').trigger('click');
		}

		// Translate edition level label
		translateEEselectedLabel();
		translateLabelInChronologicalIndex();
		if (spanEEselect !== undefined && spanEEselect.length > 0) {
			updateSelectLength(spanEEselect);
		}
		if (spanEEselectAdd !== undefined && spanEEselectAdd.length > 0) {
			updateSelectLength(spanEEselectAdd);
		}
		if (spanDDselect !== undefined && spanDDselect.length > 0) {
			updateSelectLength(spanDDselect);
		}
		if (spanLISTselect !== undefined && spanLISTselect.length > 0) {
			updateSelectLength(spanLISTselect);
		}
	});
	window.lang.run();
	if (window.lang.currentLang === 'undefined') {
		window.lang.change('en');
	} else {
		$('.flag.active').removeClass('active');
		$(".flag[data-value='" + window.lang.currentLang + "']").addClass('active');
	}
	if (spanEEselect !== undefined && spanEEselect.length > 0) {
		updateSelectLength(spanEEselect)
	}
	if (spanEEselectAdd !== undefined && spanEEselectAdd.length > 0) {
		updateSelectLength(spanEEselectAdd)
	}
	if (spanDDselect !== undefined && spanDDselect.length > 0) {
		updateSelectLength(spanDDselect)
	}
	if (spanLISTselect !== undefined && spanLISTselect.length > 0) {
		updateSelectLength(spanLISTselect);
	}
}
/* TEMPORARY*/
function translateLabelInChronologicalIndex() {
	var sortingOrderButton = $('#sortingOrder span');
	sortingOrderButton
		.text(window.lang.convert(sortingOrderButton.attr('data-lang'), window.lang.currentLang));
	var toggleRegestoInListBtns = $('.toggleRegestoInList');
	toggleRegestoInListBtns.each(function() {
		$(this).text(window.lang.convert($(this).attr('data-lang'), window.lang.currentLang));
	})
}

function translateEEselectedLabel() {
	var firstEE = $('#span_ee_select .option_container .selected').attr('data-value');
	if (firstEE) {
		$('#span_ee_select .label_selected')
			.text(window.lang.convert(firstEE.toUpperCase(), window.lang.currentLang));
	}

	var firstEE_add = $('#span_ee_select-add .option_container .selected').attr('data-value');
	if (firstEE_add) {
		$('#span_ee_select-add .label_selected')
			.text(window.lang.convert(firstEE_add.toUpperCase(), window.lang.currentLang));
	}
}
/*= BIND TOGGLE SHORTCUTS BUTTON CLICK EVENT =*/
function bindShortcutsBtnClick() {
	var keyboardShortcutsCont = $('#keyboard_shortcuts_cont'),
        keyboardShortcuts = $('#keyboard_shortcuts_link');
        keyboardShortcuts.unbind("click").click(function() {
        $(this).toggleClass('active');
		if (keyboardShortcutsCont.is(':visible')) {
			keyboardShortcutsCont.hide('fade', 0);
		} else {
			keyboardShortcutsCont.show('fade', 0);
		}
		$('#settings_link.active').trigger('click');
	});

	keyboardShortcutsCont.unbind("click").click(function(event) {
		if ($(event.target).parents('#close_keyboard_shortcuts_cont').length > 0) {
			keyboardShortcuts.trigger('click');
		} else {
			if (!$(event.target).is('#keyboard_shortcuts')) {
				if ($(event.target).parents('#keyboard_shortcuts').length <= 0) {
					keyboardShortcuts.trigger('click');
				}
			}
		}
	});
}