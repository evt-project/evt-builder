/**
 * Interface Control jQuery
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
 * @since 2012
 *
 * @author Julia Kenny - JK
 * @from 2012 @to 2014
 *
 * @author ChiaraDipi - CDP
 * @since 2013
 *
 * @short-term coauthor Luca Sarri – LS
 * (added and modified plugin for different languages)
 * @in 2015
 *
 * @short-term Alessandro Barsi – AB
 * (added functions for manuscript, text and project info)
 * @in 2015
 *
 * @short-term Ilaria Tiezzi -IT
 * (added functions for project info)
 * @in 2016
 *
 * @short-term Greta Musu - GM
 * (added functions for global navigation bar and support for Viscoll)
 * @in 2017/18
 *
 * @short-term Rocco Russo - RR
 * (added functions for verses/prose mode feature)
 * @in 2017/18
 *
 * @short-term Chiara De Martin - CDM
 * (added support for chronological index of documents)
 * @in 2017/18
 **/

/*jslint browser: true*/
/*global $, jQuery, alert */

/* Variabili generiche*/
var fulltogg;
var first_pp, last_pp;
var first_dd, last_dd;
var groupingPagesByDoc, optionTooltipInPages;
var image_ext;
var arrayPages = [];
var LISTS_MODEL = {
	_xmlSource: undefined
};

function hideGlobalLoading(idMsgToRemove) {
	var elToRemove = $('#'+idMsgToRemove);
	if (elToRemove) {
		elToRemove.remove();
	}
	
	if ($('#loading_msg').children().length === 1) {
		$('#global_loading').hide();
	}
}
function addLoadingMsg(keyMsg, id) {
	$('<div/>')
		.attr('id', id)
		.text(window.lang.convert(keyMsg, window.lang.currentLang))
		.appendTo('#loading_msg');
}

window.lang = new jquery_lang_js();
window.lang.run();
$(function() {
	image_ext = $('#global_wrapper').attr('data-image-extension') || 'jpg';
	"use strict";

	//IT: Setting variabili generiche
	fulltogg = false;
	//var pp_temp_val=$(".main_pp_select").val();

	$.ajaxSetup({
		contentType: 'text/html;charset=utf-8'
	});
	$.ajaxSetup({
		'beforeSend': function(xhr) {
			xhr.overrideMimeType('text/html; charset=utf-8');
		}
	});

	groupingPagesByDoc = $('.groupByDoc').length > 0;
	optionTooltipInPages = $('.optionDocTooltip').length > 0;

	window.lang.run();
	addLoadingMsg('LOADING_STRUCTURE', 'loading_structure_msg');

	loadStructureAndPrepareUI(groupingPagesByDoc, optionTooltipInPages).then(function () {
		hideGlobalLoading('msDesc_prep_msg');
	});
	

	$(document).ready(function() {
		concludeUIinit().then(function() {
			console.log('concludeUIinit then');
			hideGlobalLoading('ui_init_msg');
		});

		window.onerror = function myErrorHandler(errorMsg, url, lineNumber,  column, errorObj) {
			if (errorMsg == 'BigImageError') {
				try {
					var errorMsg = window.lang.convert('ERROR_LOADING_HI_IMAGE', window.lang.currentLang);
					var lens = document.getElementsByClassName('zoomPreload')[0];
					lens.textContent = errorMsg;
					if ($('.current_mode').attr('id') === 'txtimg_link' || $('.current_mode').attr('id') === 'imgd_link') {
						alert(errorMsg);
					}
					$('.zoomWrapperImage')
						.addClass('bigImageError')
						.attr('data-error-msg', errorMsg);
					if (magnifierON) {
						document.getElementById('switchMag').click();
					}
				} catch (e) {}
			} else {
				console.log('Error: ' + errorMsg + ' Script: ' + url + ' Line: ' + lineNumber
    						+ ' Column: ' + column + ' StackTrace: ' +  errorObj);
			}
			return true;
		}
	});
});

function setCookie(cname, cvalue, exdays) {
	var d = new Date();
	d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
	var expires = "expires=" + d.toUTCString();
	document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
	var name = cname + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') c = c.substring(1);
		if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
	}
	return '';
}