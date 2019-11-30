/**
 * Interface Control jQuery
 * Functions Handling Feature to toggle Verses/Prose mode on text
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
 * @short-term Rocco Russo - RR
 * (added functions for verses/prose mode feature)
 * @in 2017/18
 *
 **/

function toggleProseVerses(el) {
	var frame = $(el).closest(".main_frame");
	var activeStatus = $(el).attr("data-active-status");

	if (activeStatus === "prose") { // Then VIEW VERSES
		viewVerses(frame);
		$(el).html('<span lang="def">PROSE</span> <i class="fa fa-align-justify" aria-hidden="true"></i>');
		$(el).attr("data-active-status", "verses");
	} else if (activeStatus === "verses") { // Then VIEW PROSE
		viewProse(frame);
		$(el).html('<span lang="def">VERSES</span> <i class="fa fa-align-left" aria-hidden="true"></i>');
		$(el).attr("data-active-status", "prose");
	}
	updateLinesWidth(frame);
	window.lang.run();
}

function initializeProse() {
	var lb = document.getElementsByClassName("lb");
	for (var i = 1; i < lb.length; i++) {
		if (lb[i].getAttribute('data-rend') !== 'empty') {
			$(lb[i]).html("<br />");
		}
	}
}

function viewVerses(frame) {
	frame.attr("data-prose-verses-status", "verses");
	var spazio = frame.find(".spazio");
	var numeri = frame.find(".cerchio");
	var numeriP = frame.find(".dipl-lineN, .interp-lineN");
	var lb = frame.find(".lb");

	frame.find(".dipl-lineN+.dipl-left, .interp-lineN+.interp-left").css('display', 'inline');

	for (var i = 1; i < lb.length; i++) {
		if (lb[i].getAttribute('data-rend') !== 'empty') {
			$(lb[i]).html("");
		}
	}

	for (var i = 0; i < numeri.length; i++) {
		$(numeri[i]).css("visibility", "hidden");
		if ((parseInt($(numeri[i]).text()) % 5 === 0)) {
			$(numeri[i]).addClass("lineNumberPoetry");
		}
	}

	for (var i = 0; i < numeriP.length; i++) {
		$(numeriP[i]).css("display", "none");
	}

	for (var i = 1; i < spazio.length; i++) {
		if (spazio[i].getAttribute('data-rend') !== 'empty') {		
			$(spazio[i]).html("<br />");
		}
	}
}

function viewProse(frame) {
	frame.attr("data-prose-verses-status", "prose");
	var spazio = frame.find(".spazio");
	var numeri = frame.find(".cerchio");
	var numeriP = frame.find(".dipl-lineN, .interp-lineN");
	var lb = frame.find(".lb");

	frame.find(".dipl-lineN+.dipl-left, .interp-lineN+.interp-left").css('display', 'inline-table');

	for (var i = 1; i < lb.length; i++) {
		if ($(lb[i]).text()) {
			if (lb[i].getAttribute('data-rend') !== 'empty') {
				$(lb[i]).html("<br />");
			}
		}
	}

	for (var i = 1; i < spazio.length; i++) {
		if (spazio[i].getAttribute('data-rend') !== 'empty') {
			$(spazio[i]).html("");
		}
	}

	for (var i = 0; i < numeri.length; i++) {
		$(numeri[i]).css("visibility", "visible");
		$(numeri[i]).removeClass("lineNumberPoetry");
	}

	for (var i = 0; i < numeriP.length; i++) {
		$(numeriP[i]).css("display", "inline");
	}
}