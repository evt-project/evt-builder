function bindViscollClick(array) {
	//alert(array);
	$('#viscoll').unbind('click').click(
        function(){
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
				$('#BRpager').slider( "option", "disabled", false );
				$('#BRicon_book_left').prop("disabled", false);
				$('#BRicon_book_right').prop("disabled", false);
			} else {
				//$("#image_tool").hide(); /* A volte lo nasconde e a volte no, perchè? => è jQuery che a volte si incarta */
				document.getElementById("image_tool").style.display = "none";
				var img = $('#iviewerImage');
				var loaded_img = isImgOk(img);  // Se l'immagine è stata caricata
				if(loaded_img === true || thumbsOpened === true) {
					// Altrimenti gli aggiungo la class active e nascondo gli altri elementi
					var viscoll = $('#viscoll').addClass('active');
					$("#image_elem").hide();
					$("#image_fade").hide();
					//Nascondo #image_tool sopra (spostato)
					$('#BRpager').slider( "option", "disabled", true );
					$('#BRicon_book_left').prop("disabled", true);
					$('#BRicon_book_right').prop("disabled", true);

					var id_idno = $('.viscoll_idno').attr('id');
					//$('#image_cont').load("data/output_data/viscoll/"+id_idno+"/"+id_idno+".html");
					$('<iframe></iframe>').appendTo('#image_cont');
					$("iframe").attr({
						"id": "viscoll_iframe",
						"name": "viscoll_iframe",
						"src": "data/output_data/viscoll/"+id_idno+"/"+id_idno+".html",
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

function isImgOk (img) {
    var isImageOk;
    if (img.is(':visible')) { // Se l'immagine è visibile
		isImageOk = true;
		//alert("E' stata caricata");
	}else{
		isImageOk = false;
		//alert("Non è stata caricata");
	}
	return isImageOk;
}

function emptyImageControl() {
// Nel file XSLT ho aggiunto una variabile (emptyImage) che permette di aggiungere lo <span> anche quando l'immagine non è stata inserita
	var i = 0;
	$("#viscoll_iframe").load(function () {  // Se il frame è stato caricato
		var fancy = $("#viscoll_iframe").contents().find(".fancybox"); // Trovo tutti gli elementi a con classe .fancybox
		//console.log(fancy);
		while(i != fancy.length) {
			var elem = fancy[i];
			var sibling = elem.nextSibling;
			var text_node = sibling.nodeValue;
			if(elem.childNodes.length == 0) {
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
	//alert(page_selected.text());
	var page_selected_text = page_selected.text();

	/*var frame = document.getElementById('viscoll_iframe').contentWindow.document;
	console.log(frame);
	var page_frame = frame.childNodes;
	console.log(page_frame);
	var figlio_html = page_frame[2];
	console.log(figlio_html);
	var figli_html = figlio_html.childNodes;
	console.log(figli_html);
	var x = figli_html[0];
	console.log(x);
	var body = x.nextElementSibling;
	console.log(body);*/

	/*var iframe = window.frames['viscoll_iframe'].document;
	console.log(iframe);*/

    $("#viscoll_iframe").load(function () {
		$('img', frames['viscoll_iframe'].document).bind("click",function(){ // Al click sull'elemento img nel frame
			var alt = $(this).attr('alt');
			//alert(alt);

			if(page_selected_text == alt) { // Se la pagina cliccata è quella che era selezionata
				returnImgTxtMode(page_selected_text);
			}else{
				window.parent.$(".main_pp_select .option_container .optionGroup div").each(function() { // Prendo tutti i div
					var pageId = $(this).attr('data-value');  // La variabile pageId prende fol_215v
					var pageLabel = $(this).text(); // La variabile pageLabel prende 215v
					var docId = $(this).attr('data-first-doc');
					//console.log(pageId);
					//console.log(pageLabel);
					if(pageLabel == alt) { // Se pageLabel è uguale ad alt (all'elemento cliccato)
						var id = pageId;
						var label = pageLabel;
						var firstDoc = docId;
						if($('#mode_switch #txtimg_link').hasClass('current_mode')) {
							//alert("ciao");
							$('#viscoll').removeClass('active');
							$('iframe').remove();
							$("#image_elem").show();
							$("#image_fade").show();
							$("#image_tool").show();
							$('#BRpager').slider( "option", "disabled", false );
							$('#BRicon_book_left').prop("disabled", false); /* GM: riabilito anche le frecce direzionali */
							$('#BRicon_book_right').prop("disabled", false);
							for(i in array) { // Scorro l'array per trovare l'elemento uguale alla pagina cliccata
								if(id == array[i].id) {
									//alert(id + array[i]);
									$('#BRpager').slider("value", i); // Aggiorno lo slider alla pagina cliccata
								}
							}
						}
						updateHash(firstDoc, id, '');
					}

				});
			}


			/*var i, j, x, z;
			console.log(frames["viscoll_iframe"].document.body);
			var body = frames["viscoll_iframe"].document.body; // Prendo l'elemento body
			var quires_cont = body.childNodes[1]; // Prendo il div con id quires_cont (che è in posizione 1 all'interno del DOM)
			console.log(quires_cont);
			var figli_quires_cont = quires_cont.childNodes; // Prendo tutti i figli di quires_cont
			console.log(figli_quires_cont);
			for(i = 0; i<=figli_quires_cont.length; i++) {  // Scorro i figli
				x = figli_quires_cont[i]; // Prendo il figlio in posizione i
				var x_className = x.className;  // Prendo il nome della sua classe
				if(x_className == "quireset") { // Se il nome della classe è uguale a "quireset"
					var figli_quireset = x.childNodes; // Prendo i figli di quireset
					console.log(figli_quireset);
					var img1 = figli_quireset[3]; // Prendo l'elemento in posizione 3 (cioè img1)
					var img2 = figli_quireset[5]; // Prendo l'elemento in poszione 5 (cioè img2)
					console.log(img1);
					console.log(img2);
					if(img1) { // Se img1 esiste
						var figli_img1 = img1.childNodes; // Prendo i figli
						var img1_text = figli_img1[1].nodeValue; // Prendo il valore del figlio in posizione 1
						//alert(img1_text);
						if(img1_text == page_text) {
							alert(img1_text + page_text);
							returnImgTxtMode();
						}
					}
					if(img2) { // Se img2 esiste
						var figli_img2 = img2.childNodes; // Prendo i figli
						var img2_text = figli_img2[1].nodeValue; // Prendo il valore del figlio in posizione 1
						console.log(img2_text);
					}*/
		});
    });

}

function returnImgTxtMode(page_selected_text) {
	if($('#mode_switch #txtimg_link').hasClass('current_mode')) {
		$('#viscoll').removeClass('active');
		$('iframe').remove();
		$("#image_elem").show();
		$("#image_fade").show();
		$("#image_tool").show();
		$('#BRpager').slider( "option", "disabled", false );
		$('#BRicon_book_left').prop("disabled", false); /* GM: riabilito anche le frecce direzionali */
		$('#BRicon_book_right').prop("disabled", false);
	}
}
