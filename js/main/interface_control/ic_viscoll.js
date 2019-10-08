function loadViscollContent() {
	var id_idno = $('.viscoll_idno').attr('id');
	if (id_idno !== undefined && ($('#viscoll_cont').attr('data-idno') !== id_idno || $('#viscoll_cont').children().length === 0)) {
		$('#viscoll_cont').load("data/output_data/viscoll/" + id_idno + "/" + id_idno + ".html #quires_cont", function () {
			window.lang.run();
			$('#viscoll_cont').attr('data-idno', id_idno);
			$('.quireset').each(function() {
				if ($(this).find('.fancybox img').length === 0) {
					$(this).append('<div class="quires_empty_images" lang="' + window.lang.currentLang + '">' + window.lang.convert('NO_INFO', window.lang.currentLang) + '</div>');
				}
			});
			$('.fancybox').each(function() {
				if ($(this).find('img').length === 1) {
					$(this).siblings('.quireUnitInfo').find('.spacer, .num-right').remove();
				}
			});
			var imageExt = $('#global_wrapper').attr('data-image-extension') || 'jpg';
			$('.fancybox img').click(function(element) {
				var dataPage = $(this).attr('data-page');
				if (dataPage) {
					var fileName = dataPage.split("/").pop();
					var pageId = fileName.replace('.' + imageExt, '');
					var pageEl = $('.main_pp_select .option[data-value="'+pageId+'"]');
					if (pageEl) {
						var docId = pageEl.attr('data-first-doc');
						updateHash(docId, pageId, '');
					}
				}
			});
			$(".quires_toggler").click(function () {
				if ($(this).attr('data-status') === 'expanded') {
					$(this).text(window.lang.convert('SHOW_ALL_QUIRES', window.lang.currentLang));
					$(".quireset").hide(400);
					$(this).attr('data-status', 'collapsed');
				} else {
					$(this).text(window.lang.convert('HIDE_ALL_QUIRES', window.lang.currentLang));
					$(".quireset").show(400);	
					$(this).attr('data-status', 'expanded');
				}
			});
		});
	}
}
function bindViscollClick(array) {
	//alert(array);
	$('#viscoll').unbind('click').click(function () {
		if (!$(this).hasClass('disabled')) {
			if ($(this).hasClass('active')) { // HIDE
				closeSecondaryImageContentOpened('viscollClick', true);
				$(this).removeClass('active');
			} else { // SHOW
				loadViscollContent();
				openSecondaryImageContent('viscoll_cont', '#viscoll');
			}
		}
	});
}

function isImgOk(img) {
	var isImageOk;
	if (img.is(':visible')) { // Se l'immagine è visibile
		isImageOk = true;
		//alert("E' stata caricata");
	} else {
		isImageOk = false;
		//alert("Non è stata caricata");
	}
	return isImageOk;
}

function emptyImageControl() {
	// Nel file XSLT ho aggiunto una variabile (emptyImage) che permette di aggiungere lo <span> anche quando l'immagine non è stata inserita
	var i = 0;
	$("#viscoll_iframe").load(function () { // Se il frame è stato caricato
		var fancy = $("#viscoll_iframe").contents().find(".fancybox"); // Trovo tutti gli elementi a con classe .fancybox
		//console.log(fancy);
		while (i != fancy.length) {
			var elem = fancy[i];
			var sibling = elem.nextSibling;
			var text_node = sibling.nodeValue;
			if (elem.childNodes.length == 0) {
				$('<img src="../../../../images/empty-image.jpg" height="145"/><img src="../../../../images/empty-image.jpg" height="145"/>').appendTo(elem);
			}
			i++;
		}
	});
}

function iframeNavigation(array) {
	var arrayImg = [];
	// Caso base (pagina selezionata)
	var page_selected = window.parent.$(".main_pp_select .option_container .optionGroup .selected"); // Prendo l'elemento con classe .selected dalla pagina genitore
	var page_selected_text = page_selected.text();

	$("#viscoll_iframe").load(function () {
		$('img', frames['viscoll_iframe'].document).bind("click", function () { // Al click sull'elemento img nel frame
			var alt = $(this).attr('alt');
			if (page_selected_text == alt) { // Se la pagina cliccata è quella che era selezionata
				returnImgTxtMode(page_selected_text);
			} else {
				var pageElem, pageId, docId;
				if ($('#mode_switch #txtimg_link').hasClass('current_mode')) {
					pageElem = $("#span_pp_select [data-label*='" + alt + "']");
					docId = pageElem ? pageElem.attr('data-first-doc') : undefined;
				} else if ($('#mode_switch #imgd_link').hasClass('current_mode')) {
					pageElem = $("#span_dd_select [data-label*='" + alt + "']");
					docId = pageElem ? pageElem.attr('data-first-page-first-doc') : undefined;
				}
				if (pageElem) {
					pageId = pageElem.attr('data-value');
				}
				if (pageId && docId) {
					$('#viscoll').removeClass('active');
					$('iframe').remove();
					$("#image_elem").show();
					$("#image_fade").show();
					$("#image_tool").show();
					$('#BRpager').slider("option", "disabled", false);
					$('#BRicon_book_left').prop("disabled", false); /* GM: riabilito anche le frecce direzionali */
					$('#BRicon_book_right').prop("disabled", false);
					var sliderIndex,
						i = 0;
					while (sliderIndex === undefined && i < array.length) { // Scorro l'array per trovare l'elemento uguale alla pagina cliccata
						if (array[i].id.indexOf(pageId) >= 0) {
							sliderIndex = i;
						} else {
							i++;
						}
					}
					if (sliderIndex !== undefined) {
						$('#BRpager').slider("value", sliderIndex); // Aggiorno lo slider alla pagina cliccata
					}
					updateHash(docId, pageId, '');
				}
			}
		});
	});

}

function returnImgTxtMode(page_selected_text) {
	if ($('#mode_switch #txtimg_link').hasClass('current_mode')) {
		$('#viscoll').removeClass('active');
		$('iframe').remove();
		$("#image_elem, #image_fade, #image_tool").show();
		$('#BRpager').slider("option", "disabled", false);
		$('#BRicon_book_left, #BRicon_book_right').prop("disabled", false); /* GM: riabilito anche le frecce direzionali */
	} else if ($('#mode_switch #imgd_link').hasClass('current_mode')) {
		$('#viscoll').removeClass('active');
		$('iframe').remove();
		$("#image_elem, #image_fade, #image_tool").show();
		$('#BRpager').slider("option", "disabled", false);
		$('#BRicon_book_left, #BRicon_book_right').prop("disabled", false); /* GM: riabilito anche le frecce direzionali */
	}
}