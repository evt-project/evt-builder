/**
 * Interface Control jQuery
 * Functions Handling Search Elements
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
 * author Jacopo Pugliese – JP
 * @from 2013 @to 2015
 *
 * @author ChiaraDipi - CDP
 * @since 2013
 *
 * @short-term Federica Spinelli - FS
 * (added support for translation as third edition level)
 * @in 2017
 *
 **/

/*= INITIALIZE SEARCH =*/
function InitializeSearch() {
	if ($('#search_cont').is(':visible')) {
		if ($('#search_cont').hasClass('collapsed')) {
			$('#tipue_search_input').trigger('keyup');
		}
	}
	if ($('#search_cont-add').is(':visible')) {
		$('#tipue_search_input-add').trigger('keyup');

	}
}

/*= TOGGLE SEARCH CONTAINER =*/
function toggleSearchCont(toggler) {
	var search_cont = $(toggler).parents('.searchContainer'),
		search_input = search_cont.find('.searchInput'),
		search_query = search_cont.find('.searchQuery'),
		search_startButton = search_cont.find('.searchStart'),
		search_keyboardButton = search_cont.find('.searchKeyboardButton');
	search_cont_results = search_cont.find('.searchResultsContent');
	var boxSuffix = $(toggler).attr('data-boxsuffix'),
		listSelector = $('#span_list_select' + boxSuffix);

	if (search_cont.hasClass('collapsed')) {
		$('#start_search' + boxSuffix).trigger('dblclick');
		search_cont.removeClass('collapsed')
		if (search_input.val() != '' &&
			search_query.attr('data-value') != search_input.val() &&
			$.trim(search_cont_results.text()) == '') {
			search_startButton.trigger('click');
		}
		// else {
		var top, mainContainerHeight;
		top = 0;
		mainContainerHeight = search_cont.parents("div[id*='main_']").outerHeight();
		if (search_cont.parents("div[id*='main_']").find('.top-menu').hasClass('menuClosed')) {
			top = -search_cont.parents("div[id*='main_']").find('.top-menu').outerHeight();
			search_cont.css('height', mainContainerHeight + 'px');

		}
		search_cont.animate({
			top: top + 'px'
		}, 400);
		$(toggler).find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');

		if (listSelector.length > 0 && !listSelector.hasClass('not_active')) {
			listSelector.addClass('not_active').css('opacity', '0.5');
		}
		// }
	} else {
		scrollDownSearchContainer(400, search_cont);
		$(toggler).find('.fa').removeClass('fa-angle-double-down').addClass('fa-angle-double-up');

		if (listSelector.length > 0 && listSelector.hasClass('not_active')) {
			var switchRegBtn = $('#switchReg');
			if (switchRegBtn.length > 0 && !switchRegBtn.hasClass('disabled')) {
				if (!switchRegBtn.hasClass('active')) {
					listSelector.removeClass('not_active').css('opacity', '1');
				}
			} else {
				listSelector.removeClass('not_active').css('opacity', '1');
			}
		}
	}
	if (search_keyboardButton.hasClass('active')) {
		search_keyboardButton.trigger('click');
	}
	InitializeSearch();
}

/*= COLLAPSE SEARCH CONTAINER =*/
function scrollDownSearchContainer(speed, searchCont) {
	var newTop;
	var mainContainerHeight, bottomBoxHeaderHeight;

	mainContainerHeight = searchCont.parents("div[id*='main_']").outerHeight();
	bottomBoxHeaderHeight = searchCont.find('.bottomBoxHeader').outerHeight();

	if ($('#right_header').hasClass('menuClosed')) {
		newTop = mainContainerHeight - (bottomBoxHeaderHeight * 2) - 16;
	} else {
		var bottomMenuHeight;
		bottomMenuHeight = $('#text_tool').outerHeight();
		newTop = mainContainerHeight - (bottomMenuHeight * 2) - bottomBoxHeaderHeight - 6;
	}
	searchCont
		.addClass('collapsed')
		.animate({
			top: newTop + 'px'
		}, speed);
}

/*= SET SEARCH CONTAINER CLOSED POSITION =*/
function setSearchClosedPosition(boxSuffix) {
	var newTop;
	var mainContainerHeight, bottomBoxHeaderHeight;
	if (boxSuffix == undefined) {
		boxSuffix = '';
	}
	mainContainerHeight = $('#main_right_frame').height();
	if ($('#main_right_frame').hasClass('full')) {
		bottomBoxHeaderHeight = $('#search_header').height() + 4;
	} else {
		bottomBoxHeaderHeight = $('#search_header').height() + 4;
	}

	if ($('#right_header').hasClass('menuClosed')) {
		newTop = mainContainerHeight - (bottomBoxHeaderHeight * 2) - 8;
	} else {
		var bottomMenuHeight;
		bottomMenuHeight = $('#text_tool').height();
		newTop = mainContainerHeight - (bottomMenuHeight * 2) - bottomBoxHeaderHeight;
	}

	$('#search_cont' + boxSuffix)
		.addClass('collapsed')
		.css({
			top: newTop + 'px'
		});

	$('#toggle_search_cont' + boxSuffix + ' .fa')
		.removeClass('fa-angle-double-down')
		.addClass('fa-angle-double-up');
}

/*= CLOSE SEARCH CONTAINER =*/
function closeSearchBox(speed, boxSuffix) {
	$('#search_cont' + boxSuffix).removeClass('bottomBoxOpened');
	$('#search_link' + boxSuffix).removeClass('active');
	var closeDiv = function () {
		return $('#search_cont' + boxSuffix).hide('slide', {
			direction: 'down'
		}, 'linear', speed);
	};

	$.when(closeDiv()).done(function () {
		setSearchClosedPosition(boxSuffix);
	});
	updateTextContHeight();

	if ($('#keyboard' + boxSuffix).is(':visible')) {
		$('#keyboard_link' + boxSuffix).trigger('click');
	}

	$('#text_cont' + boxSuffix + ' .highlight').removeClass('highlight');
}

/*= OPEN SEARCH CONTAINER =*/
function openSearchBox(speed, boxSuffix) {
	var searchCont = $('#search_cont' + boxSuffix);
	searchCont.addClass('bottomBoxOpened');
	$('#search_link' + boxSuffix).addClass('active');

	var openDivSearch = function () {
		var newSearchContTop = searchCont.parents("div[id*='main_']").outerHeight() - ($('#text_tool' + boxSuffix).outerHeight() * 2) - $('#search_header' + boxSuffix).outerHeight() - 6;
		searchCont.css({
			'top': newSearchContTop + 'px'
		});

		return searchCont.show();
	};

	$.when(openDivSearch()).done(function () {
		updateTextContHeight();
	});
	if (searchCont.hasClass('collapsed')) {
		var switchRegBtn = $('#switchReg' + boxSuffix);
		if (switchRegBtn.length > 0 && !switchRegBtn.hasClass('disabled')) {
			if (switchRegBtn.hasClass('active') && $('#txtimg_link').hasClass('current_mode')) {
				switchRegBtn.trigger('click');
			}
		}
	}
	var searchInput = $('#tipue_search_input' + boxSuffix);
	if (searchInput.val() != '') {
		searchInput.trigger('keyup');
	}
	searchInput.focus();
}

/* ************ */
/* CLICK EVENTS */
/* ************ */
function onSearchButtonClick(elem) {
	var boxSuffix = $(elem).attr('data-boxsuffix') || '',
		searchCont = $('#search_cont' + boxSuffix),
		listSelect = $('#span_list_select' + boxSuffix),
		switchRegBtn = $('#switchReg' + boxSuffix);
	var speed;
	if (searchCont.hasClass('collapsed')) {
		speed = 'fast';
	} else {
		speed = 'slow';
	}

	// BOX RICERCA APERTO
	if (searchCont.is(":visible")) {
		closeSearchBox(speed, boxSuffix);
		updateTextContHeight();

		if (listSelect.length > 0) {
			// Se ho il regesto...
			if ((switchRegBtn.length > 0) &&
				(!switchRegBtn.hasClass('disabled'))) {
				// ...e il regesto non è aperto
				if (!switchRegBtn.hasClass('active')) {
					// attivo il selettore dei filtri
					listSelect.removeClass('not_active').css('opacity', '1');
				}
			} else {
				listSelect.removeClass('not_active').css('opacity', '1');
			}
		}
	} else {
		var listsBtn = $('#list_link' + boxSuffix),
			switchFrontBtn = $('#switchFront' + boxSuffix);
		if (listsBtn.length > 0 && listsBtn.hasClass('active')) {
			closeListsBox('fast');
		}
		// Se ho il regesto, questo non è disabilitato e c'è un solo livello di edizione...
		if ((switchRegBtn.length > 0) &&
			(!switchRegBtn.hasClass('disabled')) &&
			($('#span_ee_select .option').length == 1)) {
			// ...e questo è attivo e siamo nella modalità testo immagine
			if (switchRegBtn.hasClass('active') && $('#txtimg_link').hasClass('current_mode')) {
				// chiudo il regesto
				$('#regesto_cont' + boxSuffix).hide();
				switchRegBtn.removeClass('active');
			}
		}

		// Se ho il front
		if ((switchFrontBtn.length > 0) &&
			(!switchFrontBtn.hasClass('disabled'))) {
			// chiudo il front
			$('#front_cont' + boxSuffix).hide();
			switchFrontBtn.removeClass('active');
		}
		openSearchBox(speed, boxSuffix);

		if (!searchCont.hasClass('collapsed')) {
			if (listSelect.length > 0) {
				listSelect.addClass('not_active').css('opacity', '0.5');
			}
		}
	}
}

/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND VIRTUAL KEYBOARD BUTTON CLICK EVENT =*/
function bindKeyboardBtnClick() {
	$('.searchKeyboardButton').click(function () {
		if (!$(this).hasClass('inactive') && $('.keyboardSearch').length > 0) {
			var numKeys, newKeyboardHeight, newKeyboardWidth;
			var search_cont, keyboard;
			var keyHeight, keyWidth;

			search_cont = $(this).parents('.searchContainer:first');
			keyboard = search_cont.find('.keyboardSearch');
			numKeys = $(keyboard).find('.key').length;
			keyHeight = $(keyboard).find('.key').outerHeight();
			keyWidth = $(keyboard).find('.key').outerWidth();
			if (numKeys % 9 == 0) {
				newKeyboardHeight = (numKeys / 9) * keyHeight + 1;
			} else {
				newKeyboardHeight = (Math.floor(numKeys / 9) * keyHeight) + 1 + keyHeight;
			}

			newKeyboardWidth = 9 * keyWidth + 1;

			if (!search_cont.hasClass('collapsed')) {
				keyboard.addClass('openDown');
				var offsetTop = $(this).parents('.bottomBoxHeader').outerHeight() + 2;
				keyboard.css({
					'top': offsetTop,
					'height': newKeyboardHeight,
					'width': newKeyboardWidth
				});
			} else {
				keyboard.removeClass('openDown');
				if (numKeys % 9 == 0) {
					offsetTop = ((numKeys / 9) * keyHeight) + 2;
				} else {
					offsetTop = (Math.floor(numKeys / 9) * keyHeight) + 2 + keyHeight;
				}
				keyboard.css({
					'top': -offsetTop,
					'height': newKeyboardHeight,
					'width': newKeyboardWidth
				});
			}
			keyboard.toggle();
			$(this).toggleClass('active');
		}
	});
}

function bindCaseSensitiveBtnClick() {
	$('.searchCaseSensitiveButton').unbind('click').click(function () {
		$(this).toggleClass('active');
		var suffix = $(this).attr('data-boxsuffix');
		setTimeout(function () {
			if ($('#search_cont'+suffix).hasClass('collapsed')) {
				$('#tipue_search_input' + suffix).trigger('keyup')
			} else {
				$('#start_search' + suffix).trigger('dblclick');
			}
		});
	});
}

function bindSearchBtnsClick() {
	$('.searchButton').click(function (event) {
		onSearchButtonClick(this);
	});

	$('.toggleSearchButton').click(function () {
		toggleSearchCont(this);
	});

	$('.searchInput').keyup(function (event) {
		if ($(this).val() != '') {
			$(this).addClass('clearable');
		} else {
			$(this).removeClass('clearable');
		}
	});

	$('.clear_input').click(function (event) {
		$(this).prev().val('').removeClass('clearable');
		var searchCont = $(this).parents('.searchContainer');
		searchCont
			.find('.tipue_search_results_count, .searchResultsContent, .bottomBoxFooter div').empty();
		searchCont
			.find('.searchQuery')
			.empty()
			.append('<span lang="' + window.lang.currentLang + '">' + window.lang.convert('ENTER_YOUR_QUERY_INTO_THE_SEARCH_BOX_ABOVE', window.lang.currentLang) + '</span>');
		$(this).parents("div[id*='frame']").find('.highlight').removeClass('highlight');
	});

	$('.searchInput').keyup(function (e) {
		var boxSuffix = $(this).attr('data-boxsuffix');
		if ($("#search_cont" + boxSuffix).hasClass('bottomBoxOpened')) {
			$('#text_elem' + boxSuffix).unhighlight();
			var input_text_value = $(this).val();
			var word_array = input_text_value.split(' ');
			var caseSensitive = false;
			if ($('#search_case_sensitive_toggler'+boxSuffix).hasClass('active')) {
					caseSensitive = true;
			}
			for (var i = 0; i < word_array.length; i++) {
				$('#text_elem' + boxSuffix).highlight(word_array[i], { caseSensitive: caseSensitive });
			}
		}
	});

	if ($('#search_cont').length > 0) {
		setSearchClosedPosition();
	}

	// Open Keyboard
	if ($('.searchKeyboardButton').length > 0) {
		bindKeyboardBtnClick();
	}

	if ($('.searchCaseSensitiveButton').length > 0) {
		bindCaseSensitiveBtnClick();
	}
}