function bindViscollClick(array) {
	//alert(array);
	$('#viscoll').unbind('click').click(
		function() {
			// Se thumbnails ha class active gliela tolgo e la nascondo (passaggio thumbnails - viscoll)
			var thumbsBtn = $("#thumb_elem");
			var thumbsOpened = false;
			if (thumbsBtn) {
				thumbsOpened = thumbsBtn.hasClass('active');
				if (thumbsOpened) {
					thumbsBtn.removeClass('active');
					document.getElementById("thumb_cont").style.display = 'none';
				}
			}

			// Se viscoll ha class active (è già stato cliccato) gliela tolgo e mostro gli altri elementi
			if ($('#viscoll').hasClass('active')) {
				$('#viscoll').removeClass('active');
				$('iframe').remove();
				$("#image_elem").show();
				$("#image_fade").show();
				$("#image_tool").show();
				$('#BRpager').slider("option", "disabled", false);
				$('#BRicon_book_left').prop("disabled", false);
				$('#BRicon_book_right').prop("disabled", false);
				$('.main_tt_select div.option_container div.option').removeClass('ui-state-disabled');
				bindTTselectClick();
				$('.main_pp_select div.option_container div.optionGroup div.option').removeClass('ui-state-disabled');
				bindPPselectClick();
				$('#span_dd_select.like_select div.main_dd_select div.option_container div.option').removeClass('ui-state-disabled');
				bindDDselectClick();
			} else {
				//$("#image_tool").hide(); /* A volte lo nasconde e a volte no, perchè? => è jQuery che a volte si incarta */
				document.getElementById("image_tool").style.display = "none";
				var img = $('#iviewerImage');
				var loaded_img = isImgOk(img); // Se l'immagine è stata caricata
				if (loaded_img === true || thumbsOpened === true) {
					// Altrimenti gli aggiungo la class active e nascondo gli altri elementi
					var viscoll = $('#viscoll').addClass('active');
					$("#image_elem").hide();
					$("#image_fade").hide();
					//Nascondo #image_tool sopra (spostato)
					$('#BRpager').slider("option", "disabled", true);
					$('#BRicon_book_left').prop("disabled", true);
					$('#BRicon_book_right').prop("disabled", true);
					$('.main_tt_select div.option_container div.option').addClass('ui-state-disabled').unbind('click');
					$('.main_pp_select div.option_container div.optionGroup div.option').addClass('ui-state-disabled').unbind('click');
					$('#span_dd_select.like_select div.main_dd_select div.option_container div.option').addClass('ui-state-disabled').unbind('click');

					var id_idno = $('.viscoll_idno').attr('id');
					//$('#image_cont').load("data/output_data/viscoll/"+id_idno+"/"+id_idno+".html");
					$('<iframe></iframe>').appendTo('#image_cont');
					$("iframe").attr({
						"id": "viscoll_iframe",
						"name": "viscoll_iframe",
						"src": "data/output_data/viscoll/" + id_idno + "/" + id_idno + ".html",
						"min-width": "436px",
						"width": "100%",
						"height": "100%",
						"scrolling": "auto",
						"overflow": "auto",
						"overflow-x": "hidden",
						"position": "absolute",
						"top": "0px"
					});
					emptyImageControl();
				}
			}
			iframeNavigation(array);
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
	$("#viscoll_iframe").load(function() { // Se il frame è stato caricato
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

	$("#viscoll_iframe").load(function() {
		$('img', frames['viscoll_iframe'].document).bind("click", function() { // Al click sull'elemento img nel frame
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