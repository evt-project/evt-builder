/**
 * Interface Control jQuery
 * Functions Handling Generic Elements Bindings
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
 * @short-term Greta Musu - GM
 * (added functions for global navigation bar and support for Viscoll)
 * @in 2017/18
 *
 * @short-term Chiara De Martin - CDM
 * (added support for chronological index of documents)
 * @in 2017/18
 **/

/*= BIND GENERIC OPTION HOVER EVENT =*/
function bindOptionHover() {
	$('.like_select .option_container .option').hover(function () {
		$('.hovered').removeClass('hovered');
		var parentSelect = $(this).parents('.like_select'),
			parent_title = parentSelect.attr('title');
		parentSelect.attr('data-title', parent_title);
		parentSelect.attr('title', '');
	}, function () {
		var oldParentSelect = $(this).parents('.like_select'),
			old_parent_title = oldParentSelect.attr('data-title');
		oldParentSelect
			.attr('title', old_parent_title)
			.removeAttr('data-title');
	});
}

/*= BIND EVENT TO OPEN OPTION CONTAINER OF SELECTS =*/
function bindOpenSelectClick() {
	/* Apertura option container dei selettori a tendina */
	$(".open_select").click(function () {
		$('.hovered').removeClass('hovered');
		if (!$(this).parents('.like_select').hasClass('not_active')) {
			if (!($(".option_container").is(':animated'))) {
				if ($('.option_container:visible').parents('.like_select').attr('id') !== $(this).parents('.like_select').attr('id')) {
					$('.option_container.up:visible').animate({
						top: '-5px',
						height: "toggle"
					}, 0);
					$('.option_container.down:visible').animate({
						height: "toggle"
					}, 0);
				}
				var siblingOptionContainer = $(this).siblings('.option_container');
				if ($(this).hasClass('open_up')) {
					if (siblingOptionContainer.is(':visible')) {
						siblingOptionContainer.animate({
							top: '-5px',
							height: "toggle"
						}, 0);
					} else {
						var top = "-" + siblingOptionContainer.attr('data-toggle-top') + "px";
						siblingOptionContainer.animate({
							top: top,
							height: "toggle"
						}, 0);
					}
				} else {
					siblingOptionContainer.animate({
						scrollTop: 0,
						height: "toggle"
					}, 0, function () {
						var optionSelected = $(this).find('.option.selected'),
							optionSelectedPosition = optionSelected.position();
						var scroll = optionSelectedPosition !== undefined ? optionSelectedPosition.top : undefined;
						if (scroll !== undefined) {
							siblingOptionContainer.animate({
								scrollTop: scroll
							}, 0);
						}
					});
				}
			}
		}
	});
}

/*= BIND GENERIC OPTION CLICK EVENT ============================================== =*/
/*= General event on click on ".option":                                           =*/
/*= - it select the element clicked and unselect the others.                       =*/
/*= - it closes the ".like_select".                                                =*/
/*= - If it is a filter, it is possible to select more than one ".option" element. =*/
function bindOptionClick() {
	$(".like_select .option_container .option").click(function () {
		var thisSelect = $(this).parents('.like_select');
		if (!$(this).hasClass('groupTitle') && (!$(this).hasClass('selected')) && (!thisSelect.hasClass('filter'))) {
			var option_sel_value, option_sel_label;
			option_sel_value = $(this).attr('data-value');
			option_sel_label = $(this).text();
			thisSelect
				.find('.label_selected')
				.attr('data-value', option_sel_value)
				.text(option_sel_label)
				.trigger('change');

			/*if ($(this).parents('.option_container').parent().attr("class") === "main_tt_select"){
			    newText = $(this).attr('title');
			    $(this).parents('.option_container').prev().prev().text(cropLongTextLabel(newText, 12)).attr("data-value", newText).trigger('change'); // .label_selected
			}
			else{
			    newText = $(this).text();
			    if ($(this).parents('.option_container').parent().attr("class") !== "main_pp_select"){
			        $(this).parents('.option_container').prev().prev().text(newText).attr("data-value", newPage).trigger('change'); // .label_selected
			    }
			}*/

			var thisOptionContainer = $(this).parents('.option_container');
			thisSelect
				.find(".option[data-value!='" + option_sel_value + "']")
				.removeClass('selected');
			$(this)
				.addClass('selected');

			if (thisOptionContainer.is(':visible')) {
				if (thisOptionContainer.hasClass('up')) {
					thisOptionContainer.animate({
						top: '-5px',
						height: "toggle"
					}, 0, function () {
						// updateSelectLength(thisSelect);
						thisOptionContainer.css('min-width', thisSelect.width() - 10);
					});
				} else {
					thisOptionContainer.animate({
						height: "toggle"
					}, 0, function () {
						// updateSelectLength(thisSelect);
						thisOptionContainer.css('min-width', thisSelect.width() - 10);
					});
				}
			}
		}
	});
}

/*= BIND GLOBAL WRAPPER MOUSE DOWN EVENT =*/
function bindGlobarWrapperMouseDown() {
	$("#global_wrapper").on('mousedown', function (e) {
		if (($(e.target).closest(".like_select").length === 0) && !($(".option_container").is(':animated'))) {
			var optionContainerVisible = $('.option_container:visible');
			if (optionContainerVisible.hasClass('up')) {
				optionContainerVisible.animate({
					top: '-5px',
					height: "toggle"
				}, 0);
			} else {
				optionContainerVisible.animate({
					height: "toggle"
				}, 0);
			}
		}

		if ($(e.target).parents("#settings_cont").length === 0 &&
			!$("#settings_cont").is(':animated') &&
			$(e.target).parents("#settings_link").length === 0 &&
			$(e.target).attr('id') !== 'settings_link') {
			if ($('#settings_cont').is(':visible')) {
				$('#settings_link').trigger('click');
			}
		}
	});
}

/*= BIND BUTTONS CLICK EVENT =*/
function bindBtnClick() {
	// GENERIC BUTTONS
	$('#left_menu .mainButtons').click(function () {
		if (!$(this).hasClass('inactive')) {
			$(this).siblings().removeClass('active');
		}
	});

	// MAGNIFIER, HOTSPOT, ITL BUTTONS
	$('#switchMag, #switchHS, #switchITL').click(function () {
		if (!$(this).hasClass('likeInactive')) {
			var msDescSwitcher = $('#switch_msDesc');
			if (msDescSwitcher.length > 0 && msDescSwitcher.hasClass('active')) {
				msDescSwitcher.trigger('click');
			}
			var thumbsSwitcher = $('#thumb_elem');
			if (thumbsSwitcher.length > 0 && thumbsSwitcher.hasClass('active')) {
				thumbsSwitcher.removeClass('active');
			}
		}
	});

	// THUMBNAILS BUTTON
	$(".thumb_link").click(function () {
		var getThumbsSrc;
		if (!$(this).hasClass('disabled')) {
			loadThumbs();
			
			var msDescCont = $('#msDesc_cont');
			if (msDescCont.length > 0 && msDescCont.is(':visible')) {
				$('#switch_msDesc').removeClass('active');
				msDescCont.hide();
			}
			if (magnifierON == false) {
				var imageElem = $("#image_elem");
				if ($("#image_loading").css('display') !== "none") {
					$("#image_loading").hide()
				}
				if (imageElem.css('display') === "none") {
					imageElem.show();
					$("#image_fade").show();
					if (!$('#left_header').hasClass('menuClosed')) {
						$("#image_tool").show();
					}
					$("#thumb_cont").hide();
				} else {
					imageElem.hide();
					$("#image_fade").hide();
					$("#image_tool").hide();
					$("#thumb_cont").show();
				}
			} else { //modalità magnifier attivo JK
				var magImageElem = $("#mag_image_elem");
				if (magImageElem.css('display') === "none") {
					magImageElem.show();
					$("#image_tool").show();
					$("#thumb_cont").hide();
					$('#switchMag').addClass('active');
				} else {
					magImageElem.hide();
					$("#image_tool").hide();
					$("#thumb_cont").show();
				}
			}
			
			$(this).toggleClass('active');
			// Passaggio da viscoll a thumbnails
			if ($('#thumb_elem').hasClass('active')) {
				$('#BRpager').slider("option", "disabled", false); // Riabilito lo slider
				$('#BRicon_book_left').prop("disabled", false);
				$('#BRicon_book_right').prop("disabled", false);
				$('.main_tt_select div.option_container div.option').removeClass('ui-state-disabled');
				bindTTselectClick();
				$('.main_pp_select div.option_container div.optionGroup div.option').removeClass('ui-state-disabled');
				bindPPselectClick();
				$('#span_dd_select.like_select div.main_dd_select div.option_container div.option').removeClass('ui-state-disabled');
				bindDDselectClick();
				// Al click sulle thumbnails se viscoll ha class active (cioè è attivo), gli tolgo la classe e tolgo l'iframe
				if ($('#viscoll').hasClass('active')) {
					$('#viscoll').removeClass('active');
					$('iframe').remove();
					$('#thumb_cont').show();
					$("#image_elem").hide();
					$("#image_fade").hide();
					$("#image_tool").hide();
				}
			}
		}
	});
}

function loopOverThumbsGroup(countThumbs, thumbsElems) {
	for (var i = 0; i < 15 && countThumbs < thumbsElems.length; i++) {
		var thumbEl = thumbsElems[countThumbs];
		if (thumbEl.getAttribute('data-state') == 'to-load' || thumbEl.getAttribute('src') == undefined || thumbEl.getAttribute('src') == '') {
			if (thumbEl.getAttribute('data-src') !== undefined) {
				thumbEl.setAttribute('src', thumbEl.getAttribute('data-src'));
				thumbEl.setAttribute('data-state', 'loaded');
			}
		}
		countThumbs++;
	}
	return countThumbs;
}
function loadThumbs() {
	var countThumbs = 0;
	var thumbsElems = $('.thumb_single_img[data-state="to-load"]');
	var getThumbsSrc;
	if (thumbsElems && thumbsElems.length > 0) {
		countThumbs = loopOverThumbsGroup(countThumbs, thumbsElems);
		getThumbsSrc = setInterval(function () {
			countThumbs = loopOverThumbsGroup(countThumbs, thumbsElems);
			if (countThumbs == thumbsElems.length || !$('.thumb_link').hasClass('active')) {
				clearInterval(getThumbsSrc);
			}
		}, 2000);
	}
	return getThumbsSrc;
}

/*= BIND FONT SIZE CONTROLLER BUTTONS CLICK EVENT =*/
function bindFontSizeControllerBtnClick() {
	$('.font-size-controller').click(function () {
		var action = $(this).attr('data-action');
		var sizeCtrl = $(this);
		if (!$(this).hasClass('inactive')) {
			$(this).parents("div[id*='_frame']").find('.can-change-font-size').each(function () {
				var currentFontSize, currentFontSizeNum, newFontSize;
				currentFontSize = $(this).css('font-size');
				currentFontSizeNum = parseFloat(currentFontSize, 10);
				if (action == 'increase') {
					newFontSize = currentFontSizeNum * 1.1;
				} else {
					newFontSize = currentFontSizeNum * 0.9;
				}
				if (newFontSize < 40 && newFontSize > 12) {
					$(this).css({
						'font-size': newFontSize,
						'line-height': (newFontSize + 12) + 'px'
					});
				}

				var thisFrame = $(this).parents("div[id*='_frame']");
				if ((parseFloat(newFontSize, 10) * 1.1) >= 40) {
					thisFrame.find("[data-action='increase']").addClass('inactive');
				} else {
					thisFrame.find("[data-action='increase']").removeClass('inactive');
				}
				if ((parseFloat(newFontSize, 10) * 0.9) <= 12) {
					thisFrame.find("[data-action='decrease']").addClass('inactive');
				} else {
					thisFrame.find("[data-action='decrease']").removeClass('inactive');
				}

				$(this).attr('data-font-size', newFontSize);

				var lineNwidth = $('.dipl-lineN:last').outerWidth();
				var textInnerWidt = $(this).parents("div[id*='_frame']").find("div[id*='text_cont']").innerWidth() * 85 / 100;
				$(this).find('.dipl-left, .interp-left').each(function () {
					$(this).css({
						'max-width': (textInnerWidt - lineNwidth - 43) + 'px'
					});
				});
			});

			var frameWidth;
			if ($(this).parent().attr('id') == 'text_tool-add') {
				frameWidth = $('#text_cont-add').find('#text').outerWidth();
				$('.full').find('#text_cont-add #text').css({
					'position': 'absolute',
					'left': '50%',
					'margin-left': -(frameWidth / 2) + 'px'
				});
			} else {
				frameWidth = $('#text').outerWidth();
				$('.full').find('#text').css({
					'position': 'absolute',
					'left': '50%',
					'margin-left': -(frameWidth / 2) + 'px'
				});
			}
		}
	});

	$('#decrease_font_size').click(function () {
		var currentFontSize, currentFontSizeNum, newFontSize;
		currentFontSize = $('#text_frame, #front_frame').css('font-size');
		currentFontSizeNum = parseFloat(currentFontSize, 10);

		$('#text_frame, #front_frame').css({
			'font-size': newFontSize,
			'line-height': (newFontSize + 10) + 'px'
		});
	});
}

/*= BIND COLLAPSE MENU BUTTONS CLICK EVENT =*/
function bindCollapseMenuBtnClick() {
	$('#header_collapse').click(function () {
		var noMenu_height, withMenu_height;
		var topMenu_height, bottomMenu_height;
		var bottom_box_frame, bottom_box_visible;
		var action;
		action = $(this).attr('data-action');
		/* COLLAPSE MENUS*/
		if (action == 'collapse') {
			$('.main_frame').each(function () {
				noMenu_height = $(this).innerHeight();
				$(this).attr('data-menu-state', 'collapsed');
				collapseMenu($(this), noMenu_height);
			});
			// Modifico colore dell'icona .go-full-right che altrimenti non si vedrebbe
			$('.go-full-right').addClass('onWhite');
			// Se è aperto il text di sinistra modifico colore dell'icona go-full-left che altrimenti non si vedrebbe
			if ($('#text_cont-add').is(':visible') || $('#msDesc_cont').is(':visible')) {
				$('.go-full-left').toggleClass('onWhite');
			}
			setMagHeight(); //Add for Mag
			$(this).attr('data-action', 'expand');
		}
		/* EXPAND MENUS*/
		else if (action == 'expand') {
			$('.main_frame').each(function () {
				noMenu_height = $(this).innerHeight();
				$(this).attr('data-menu-state', 'expanded');
				expandMenu($(this), noMenu_height);
			});
			$('.go-full-right').removeClass('onWhite');
			if ($('#text_cont-add').is(':visible') || $('#msDesc_cont').is(':visible')) {
				$('.go-full-left').removeClass('onWhite');
			}
			setMagHeight(); //Add for Mag
			$(this).attr('data-action', 'collapse');
		}

		// GM: Se viscoll è attivo non si deve vedere image_tool
		if ($('#viscoll').hasClass('active')) {
			$("#image_tool").hide();
		}

		// Modifico lo stile e la posizione dell'icona
		if ($(this).hasClass('fa-caret-up')) {
			if ($(".closeFullScreen:visible").length > 0) {
				$(this).animate({
					top: "-75px"
				});
			} else {
				$(this).animate({
					top: "-8px"
				});
			}
			$(this).removeClass('fa-caret-up').addClass('fa-caret-down');
		} else {
			if ($(".closeFullScreen:visible").length > 0) {
				$(this).animate({
					top: "-39px"
				});
			} else {
				$(this).animate({
					top: "23px"
				});
			}
			$(this).removeClass('fa-caret-down').addClass('fa-caret-up');
		}

		$('.like_select:visible').each(function () {
			if (!$(this).hasClass('widthChanged')) {
				$(this).addClass('widthChanged');
				$(this).find('.option_container').removeAttr('style');
				updateSelectLength($(this));
			}
		});
	});
}

/*= INITIALIZE REF HYPERLINKS =*/
function InitializeRefs() {
	$('.ref[data-target]').unbind('click').click(function () {
		var type = $(this).attr('data-type'),
			target = $(this).attr('data-target').replace('#', '');
		if (type == 'doc') {
			var targetTToption = $('#span_tt_select').find(".option[data-value='" + target + "']");
			if (targetTToption.length == 0) {
				alert(window.lang.convert('TEXT_NOT_AVAILABLE', window.lang.currentLang));
			} else {
				if ($('#span_tt_select').find(".label_selected").attr("data-value") != target) {
					targetTToption.trigger('click');
				}
			}
			$(this).parents('.bottomBoxOpened').find("[id*='toggle']").trigger('click');
		} else {
			var targetElem = $('#' + target);
			if (targetElem.length > 0) {
				targetElem.addClass('highlight');
				$('#generalBiblio_content').scrollTop(0);
				$('#biblio_link').trigger('click');
			} else {
				alert(window.lang.convert('NO_REF', window.lang.currentLang));
			}
		}
	});
}

/*= INITIALIZE POPUPs (INLINE NOTEs, NAMED ENTITIES DETAILS, ...) =*/
function InitializePopup() {
	$('.popup').unbind('hover').hover(function (e) {
		if ($('.doc').length < 0 || $(this).parents('.doc').hasClass('current')) {
			e.stopPropagation();
			$(this).addClass('over');
			var thisPopup = $(this).parents('.popup');
			if (thisPopup.length > 0) {
				thisPopup.removeClass('over');
			}
		}
	}, function () {
		if ($('.doc').length < 0 || $(this).parents('.doc').hasClass('current')) {
			var thisPopup = $(this).parents('.popup');
			if (thisPopup.length > 0) {
				thisPopup.addClass('over');
			}
			$(this).removeClass('over');
		}
	});

	$('.tooltip').unbind('click').click(function (e) {
		if ($(this).hasClass('opened')) {
			e.stopPropagation();
		}
	});
	$('.trigger').unbind("click").click(function (e) {
		if ($('.doc').length <= 0 ||
			$(this).parents('.doc').hasClass('current') ||
			$(this).parents("div[id*='regesto_cont']").length > 0 ||
			$(this).parents("div[id*='front_cont']").length > 0) {
			e.stopPropagation();
			var popup, trigger, tooltip, before;
			popup = $(this).parent('.popup');
			trigger = popup.find('.trigger');
			tooltip = popup.find('> .tooltip');
			before = tooltip.find('> .before');

			if (tooltip.hasClass('opened')) {
				popup.removeClass('opened');
				tooltip
					.removeAttr('style')
					.removeClass('opened')
					.hide()
					.find('> .before')
					.removeAttr('style');
			} else {
				$('.tooltip.opened')
					.removeClass('opened')
					.toggle()
					.find('> .before')
					.removeAttr('style');
				$('.popup.opened')
					.removeClass('opened');

				if ($(this).parent('.popup').find('> .tooltip')) {
					$(this)
						.parent('.popup')
						.find('> .tooltip')
						.removeClass('opened')
						.toggle()
						.find('> .before')
						.removeAttr('style');
				}

				popup.addClass('opened');
				tooltip
					.addClass('opened')
					.show();

				var triggerHeight, triggerTop, triggerLeft, triggerWidth;
				triggerHeight = trigger.css('font-size').substr(0, 2) * 1 + 1;

				triggerTop = trigger.offset() !== undefined ? trigger.offset().top : 0;
				triggerLeft = trigger.position() !== undefined ? trigger.position().left : 0;
				triggerWidth = trigger.width();

				var tooltipTop = tooltip.offset() !== undefined ? tooltip.offset().top : 0;

				var x = e.clientX;
				var y = e.clientY;

				var tooltipRealWidth, tooltipRealHeight;
				tooltip.css('position', 'relative');
				tooltipRealWidth = tooltip.width();

				if (tooltipRealWidth > 300) {
					tooltip.css({
						'width': '300px',
						'max-width': '300px'
					});
				}
				tooltip.css({
					'position': 'absolute'
				});
				tooltipRealWidth = tooltip.width();
				tooltipRealHeight = tooltip.height();


				// Sposto il tooltip, prima allineando la metà al punto in cui ho cliccato
				// poi spostandolo a sinistra se supera il margine destro del contenitore
				// o a destra se supera il margine sinistro.
				var left, tooltipNewLeft;
				left = x - (tooltipRealWidth / 2);
				tooltip.offset({
					top: y + 20,
					left: left
				});

				var containerWidth, tooltipLeft, marginRightText;
				if (popup.parents("div[id*='frame']").hasClass('full')) {
					containerWidth = $('#text_cont').width();
					marginRightText = 50;
				} else {
					containerWidth = $('#text').width();
					marginRightText = $('#text').position() !== undefined ? $('#text').position().left : 0;
				}
				tooltipLeft = tooltip.position() !== undefined ? tooltip.position().left : 0;

				if (tooltipLeft + tooltipRealWidth > containerWidth) {
					tooltip.css({
						'right': marginRightText + "px"
					});
				}
				tooltipRealWidth = tooltip.width();



				// Se supera a destra il margine destro del contenitore....
				tooltipNewLeft = tooltip.position() !== undefined ? tooltip.position().left : 0;
				if (tooltipNewLeft + tooltipRealWidth > containerWidth) {
					var diff = (tooltipNewLeft + tooltipRealWidth) - containerWidth;
					//var newLeft = $(this).find('> .tooltip').offset().left - diff + marginRightText;
					tooltipNewLeft = left - diff + marginRightText;
					tooltip.offset({
						left: tooltipNewLeft
					});
				}

				// Se supera a sinistra il margine sinistro del contenitore...
				var offsetLeftText;
				if (popup.parents("div[id*='frame']").hasClass('full')) {
					offsetLeftText = $('#text_cont').offset() !== undefined ? $('#text_cont').offset().left : 0;
				} else {
					offsetLeftText = $('#text').offset() !== undefined ? $('#text').offset().left : 0;
				}

				if (left < offsetLeftText) {
					tooltip.offset({
						left: offsetLeftText
					});
				}

				// Riposiziono l'elemento .before
				var beforeWidth, beforeNewLeft;
				var beforeMarginRight, tooltipMarginRight;
				beforeNewLeft = x;
				beforeWidth = before.width();
				beforeMarginRight = x + beforeWidth;
				tooltipMarginRight = tooltip.offset() !== undefined ? tooltip.offset().left + tooltip.width() : tooltip.width();
				if (beforeMarginRight > tooltipMarginRight) {
					var diff = (beforeMarginRight - tooltipMarginRight);
					beforeNewLeft = x - diff;
				}
				before.offset({
					left: beforeNewLeft - 5
				});

				// Riposizionamento se supera il margine inferiore del contenitore
				var tooltipOffsetBottom, containerHeight;
				tooltipOffsetBottom = tooltip.offset() !== undefined ? tooltip.offset().top + tooltip.height() : 0;
				containerHeight = $('#text_cont').offset() !== undefined ? $('#text_cont').offset().top + $('#text_cont').height() - 42 : $('#text_cont').height() - 42;

				if (tooltipOffsetBottom > containerHeight) {
					var tooltipMoveToTop = triggerHeight + tooltip.height() + before.height() + 8;
					var tooltipNewTop = before.offset() !== undefined ? before.offset().top - tooltipMoveToTop : tooltipMoveToTop;
					tooltip.offset({
						top: tooltipNewTop
					});

					var beforeNewTop = tooltip.height() + 8;
					before
						.offset({
							left: beforeNewLeft - 10
						})
						.css({
							"top": beforeNewTop + "px",
							"transform": "rotate(180deg)"
						});
				}
				tooltipRealWidth = tooltip.width();
				if (tooltipRealWidth > 300) {
					tooltip.css({
						'width': '300px',
						'max-width': '300px'
					});
				}

				$(this).focus();

				return false;
			}
		}
	});


	$(document).click(function () {
		$('.over').removeClass('over');
		$('.opened').removeClass('opened');
		$('.popup').find('> .tooltip').hide();
		$(this).hide();
	});


	InitializeLinkTextList();
}