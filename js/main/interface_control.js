/**
 * 
 * Interface Control jQuery
 * Version 0.2 (201312)
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * 
 * @author RafMas 
 * @since 2012
 *
 **/

/*jslint browser: true*/
/*global $, jQuery, alert */
/*
	gotoedition, gotopage, 
	updateSelectLength, 
	UnInitialize, UnInitializeHS, 
	chooseZoomMag, setMagHeight,
	checkAnnPosHS
	enableITLbutton, disableITLbutton,
	enableHSbutton,	disableHSbutton,
	ITLon, HSon,
	Initialize, InitializeHS,
	fitFrame, preload
*/

$(function() {

	"use strict";

	//IT: Setting variabili generiche
	var keycount, fulltogg;
	var first_pp, last_pp;
	var first_dd, last_dd;
	keycount = 0;
	fulltogg = false;
	//var pp_temp_val=$(".main_pp_select").val();

	$.ajaxSetup({
		contentType: 'text/html;charset=utf-8'
	});
	$.ajaxSetup({
		'beforeSend' : function(xhr) {
			xhr.overrideMimeType('text/html; charset=utf-8');
		}
	});


	$.ajax({
		type: "GET",
		url: "data/output_data/structure.xml",
		dataType: "xml",
		success: function(xml) {
			//Edition
			$(xml).find('editions edition').each(function(){
				var current_id = $(this).text();
				$('.main_ee_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_id)
				);
			});
			$(".main_ee_select .option_container div:first-child").addClass( "selected" );

			$('.main_ee_select .label_selected')
				.text($('.main_ee_select .option_container div:first').text())
				.attr("id_value", $('.main_ee_select .option_container div:first').text());


			first_pp = $(xml).find('pages pair pb').first().text();
			last_pp = $(xml).find('pages pair pb').last().text();

			var f_pair, l_pair;
			f_pair = $(xml).find('pages pair').first().children('pb').eq(0).text();
			l_pair = $(xml).find('pages pair').first().children('pb').eq(1).text()
			first_dd = f_pair + "-" + l_pair;

			f_pair = $(xml).find('pages pair').last().children('pb').eq(0).text();
			l_pair = $(xml).find('pages pair').last().children('pb').eq(1).text()
			last_dd = f_pair + "-" + l_pair;

			//Group_dd
			$(xml).find('textpage text').each(function(){
				var text_ref;
				var group_elem;

				text_ref = $(this).attr('n').replace(/\s+/g, '');
				group_elem = $('<div/>')
								.attr("id", "optGrp_value_"+text_ref)
								.addClass('optionGroup')
								.append($('<span>').text(text_ref));

				$('.main_dd_select .option_container').append(group_elem);
			});

			//Page_dd
			$(xml).find('pages pair').each(function(){
				var current_id, first_page_d, second_page_d;
				var current_label, first_label_d, second_label_d;
				var first_text_ref, second_text_ref;

				first_page_d = $(this).children('pb').eq(0).text();
				first_label_d = $(this).children('pb').eq(0).attr("n");
				second_page_d = $(this).children('pb').eq(1).text();
				second_label_d = $(this).children('pb').eq(1).attr("n");
				current_id = "";
				current_label = "";

				first_text_ref = $(xml)
					.find('textpage text')
					.find('pb:contains("'+first_page_d+'")')
					.parent().attr('n');
				first_text_ref = first_text_ref.replace(/\s+/g, '');

				
				
				if (second_page_d !== ""){
					current_id = first_page_d+"-"+second_page_d;
					current_label = first_label_d+"-"+second_label_d;

					second_text_ref = $(xml)
					.find('textpage text')
					.find('pb:contains("'+second_page_d+'")')
					.parent().attr('n');
					second_text_ref = second_text_ref.replace(/\s+/g, '');

					if(first_text_ref !== second_text_ref){
						$('.main_dd_select #optGrp_value_'+second_text_ref).append(
		    				$('<div/>')
		    					.attr("id", "value_"+current_id)
								.addClass('option')
								.text(current_label)
		    			);
	    			}
				}
				else{
					current_id = first_page_d+"-";
					current_label = first_label_d+"-";
				}
				
				$('.main_dd_select #optGrp_value_'+first_text_ref).append(
    				$('<div/>')
    					.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_label)
    			);			
				
			});
			$('.main_dd_select .option_container div:first-child').addClass('selected');
			$('.main_dd_select .label_selected')
				.text($('.main_dd_select .option_container div:first').text())
				.attr("id_value", $('.main_dd_select .option_container div:first').attr("id").substr(6));


			//Text and Page
			$(xml).find('textpage text').each(function(){
				var current_id, current_label;
				current_label = $(this).attr("n");
				current_id = current_label.replace(/\s+/g, '');
				$('.main_tt_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_label)
				);
				
				$('.main_pp_select .option_container').append(
				    $('<div/>')
    						.attr("id", "optGrp_value_"+current_id)
    						.addClass('optionGroup')
    						.append($('<span>').text(current_label))
				);
				
				$(this).find('pb').each(function(){
    				var page_current_id = $(this).text();
    				var page_current_label = $(this).attr("n");
    				// current_id = current_id.replace(/\./g,'\\\\.');
    				$('.main_pp_select #optGrp_value_'+current_id).append(
    					$('<div/>')
    						.attr("id", "value_"+page_current_id)
    						.addClass('option')
    						.text(page_current_label)
    				);
				})
			});
			$('.main_tt_select .option_container div:first-child').addClass('selected');
			$('.main_tt_select .label_selected')
				.text($('.main_tt_select .option_container div:first').text())
				.attr("id_value", $('.main_tt_select .option_container div:first').text());
            
            $('.main_pp_select .option_container div:first-child').addClass('selected');
			$('.main_pp_select .label_selected')
				.text($('.main_pp_select .option_container .optionGroup:first div:first').text())
				.attr("id_value", $('.main_pp_select .option_container .optionGroup:first div:first').attr("id").substr(6));
				
			/* Gestione eventi */

			$(".label_selected").on('change',function(){
				var current_id;
				current_id = $(this).attr("id_value");
				current_id = current_id.replace(/\s+/g, '');
				current_id = current_id.replace(/\./g, '\\.');
				
				$(this).siblings(".option_container")
					.find("#value_"+current_id)
					.addClass("selected")
					.siblings().removeClass('selected')
					.parent().siblings().find('.option').removeClass('selected');
			});

			$(".main_ee_select .label_selected").on('change',function(){
				var temp_frame, temp_parent;
				temp_frame = "";
				temp_parent = "";
				if($(this).parent().parent().attr("id") === "span_ee_select-add"){
					temp_frame = "text_elem-add";
					temp_parent = "text_cont-add";
				} else{
					temp_frame = "text_elem";
					temp_parent = "text_cont";
				}
				gotoedition(location.hash.replace( /^#/, '' ),$(this).text().toLowerCase(),temp_frame,temp_parent);
			});
			$(".main_pp_select .label_selected").on('change',function(){
				//var tt_val_temp = $(".main_tt_select").find('.option.selected').attr("id").substr(6);
				var tt_val_temp, pp_val_temp, parent_temp;
				tt_val_temp = $(".main_tt_select .label_selected").text();
				pp_val_temp = $('.main_pp_select .label_selected').attr("id_value");
				parent_temp = $(xml)
					.find('text pb:contains('+pp_val_temp+')')
					.parent()
					.attr("n");
				if(!parent_temp){
					$(".main_tt_select .label_selected").text("(Text)").attr("id_value", "(Text)");
				} else
					if(parent_temp !== tt_val_temp){
						$(".main_tt_select .label_selected").text(parent_temp).attr("id_value", parent_temp);//.trigger("change");
						$(".main_tt_select .label_selected").siblings(".option_container")
							.find("#value_"+parent_temp.replace(/\s+/g, ''))
							.addClass("selected")
							.siblings().removeClass('selected');
					}
			});

			$(".main_dd_select .label_selected").on('change',function(){
				window.location.hash = $(this).attr("id_value");
			});

			$(".main_pp_select").on('txtimg_mode',function(){
				var newhash = $(".main_dd_select .label_selected").attr("id_value").match('.*(?=-)');
				window.location.hash = newhash;
			});
			
			$(".main_dd_select").on('imgd_thumb',function(){
				var hash, temp_pp, first_page, second_page, newhash;
				var first_page_lab, second_page_lab, newlab;
				hash = location.hash;
				temp_pp = hash.replace( /^#/, '' );
				first_page = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(0).text();
				second_page = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(1).text();

				first_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(0).attr("n");
				second_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(1).attr("n");
				//alert(first_page+"-"+second_page);
				newhash = first_page+"-"+second_page;
				newlab = first_page_lab+"-"+second_page_lab;
				$(".main_dd_select .label_selected").text(newlab).attr("id_value", newhash).trigger('change');
				//window.location.hash = newhash;
			});

			$(".main_dd_select").on('imgd_mode',function(){
				var temp_pp, first_page, second_page, newhash;
				var first_page_lab, second_page_lab, newlab;
				temp_pp = $(".main_pp_select .label_selected").attr("id_value");
				first_page = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(0).text();
				first_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(0).attr("n");
				second_page = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(1).text();
				second_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(1).attr("n");
				//alert(first_page+"-"+second_page);
				newhash = first_page+"-"+second_page;
				newlab = first_page_lab+"-"+second_page_lab;
				$(".main_dd_select .label_selected").text(newlab).attr("id_value", newhash).trigger('change');
				//window.location.hash = newhash;

			});

			$(".main_tt_select .label_selected").on('change',function(){
				var tt_val_temp, first_page;
				tt_val_temp = $(this).text();
				first_page = $(xml)
					.find('text[n="'+tt_val_temp+'"]')
					.find(":first-child")
					.text();
				window.location.hash = first_page;
				//$(".main_pp_select .label_selected").text(first_page).trigger("change");
			});

			$(".open_select").click(function(){
				if (!($(".option_container").is(':animated'))){
					if($('.option_container:visible').parents('.like_select').attr('id') !== $(this).parents('.like_select').attr('id')){
						$('.option_container:visible').animate({height:"toggle"}, 400);
					}
					$(this).siblings('.option_container').animate({height:"toggle"}, 400);
				}
			});
			
			$(".main_pp_select .option_container .option").click(function(){
				if(! $(this).hasClass('selected')){
					var newPage = $(this).attr('id').substr(6);
					//gotopage(newPage, "none");
					window.location.hash = newPage;
					//$(this).parent().animate({height:"toggle"}, 400);
				}
				
			});
			$(".option").click(function(){
				if(! $(this).hasClass('selected')){
					var newPage, newText;
					newPage = $(this).attr('id').substr(6);
					newText = $(this).text();
					//alert($(this).parents('.option_container').prev().prev().attr("id_value"));
					if ($(this).parents('.option_container').parent().attr("class") === "main_tt_select"){
						$(this).parents('.option_container').prev().prev().text(newText).attr("id_value", newText).trigger('change'); // .label_selected
					}
					else{
						// WTF: main_dd_select
						if ($(this).parents('.option_container').parent().attr("class") !== "main_pp_select"){
							$(this).parents('.option_container').prev().prev().text(newText).attr("id_value", newPage).trigger('change'); // .label_selected
						}
					}
					$(this).parents('.option_container').animate({height:"toggle"}, 400);
					//$("#value_" + newPage).addClass("selected").siblings().removeClass('selected');
				}
			});

			$('.like_select').each(function(){
				updateSelectLength(this);
			});
			
			$("#global_wrapper").on('mousedown', function (e) {
				if ( ($(e.target).closest(".like_select").length === 0) && !($(".option_container").is(':animated')) ) {
					$('.option_container:visible').animate({height:"toggle"}, 400);
				}
			});
			/* / Gestione eventi */


			/* HASH CHANGE - ba.bbq plugin */
				// IT: Associa un evento a windows.onhashchange; quando l'hash cambia, ottiene il suo valore per usarlo in diverse funzioni
				$(window).hashchange( function(){
					var hash, newhash, current_page, checkpp, checkdd, pp_lab, dd_lab;
					var dd_page, temp_search;

					hash = location.hash;
					current_page = hash.replace( /^#/, '' );
					//var checkpp = $(xml).find('text pb:contains('+current_page+')').text();
					checkpp = $(xml).find('pages pb:contains('+current_page+')').text();
					pp_lab = $(xml).find('pages pb:contains('+current_page+')').attr("n");
					
					dd_page = current_page.replace(/\./g, '\\.');
					temp_search = "value_"+dd_page;
					checkdd = $(".main_dd_select").find(".option[id*="+temp_search+"]"); // .attr("id").substr(6)

					$(".main_left_arrow").removeClass("arrow_left_disable");
					$(".main_right_arrow").removeClass("arrow_right_disable");

					if((current_page === first_pp) || (current_page === first_dd)){
						$(".main_left_arrow").addClass("arrow_left_disable");
					}
					if((current_page === last_pp) || (current_page === last_dd)){
						$(".main_right_arrow").addClass("arrow_right_disable");
					}

					
					if(hash && (checkpp !== "") && ($("#imgd_link").attr("class") !== "current_mode")){
						UnInitialize(); //Add by JK for ITL
						UnInitializeHS(); //Add by JK for HS
						$("#mag_image_elem").empty(); // Add by JK for Mag
						if($('#switchMag i').hasClass('fa-search-plus')){magnifierON=true;}
						gotopage(current_page, pp_lab, "none");
						//chooseZoomMag(); // Add by JK for Mag				
					} else{
						// alert(!checkdd);
						if ($("#imgd_link").attr("class") !== "current_mode"){
							newhash = hash.match('.*(?=-)');
							if(newhash !== null){
								window.location.hash = newhash;
							}
							else{
								window.location.hash = $(".main_pp_select .label_selected").attr("id_value");
							}
						}
					}
					if($('#txt_single').attr('class')==="current_mode"){ $('#header_collapse').css("left",'15px'); }
					// IT: Cambia il titolo della pagina in base all'hash
					//document.title = 'The hash is ' + ( hash.replace( /^#/, '' ) || 'blank' ) + '.';
				});
				// IT: L'evento viene attivato quando cambia l'hash della pagina
				$(window).hashchange();
			/* / HASH CHANGE - ba.bbq plugin */
		}
	});


	//---
	
	// IT: Imposta l'etichetta dell'edizione, al primo caricamento della index
	//$('#edval span').text($("input[name=edition_r]:checked").val());	
	
	
	/* Funzioni */

	// IT: Gestisce il cambio pagina e gli eventi correlati
	function gotopage(pp_val, pp_lab, state){
		var edition, edition_add; 
		//N.B. i caricamenti delle immagini si attivano grazie agli eventi change dei label_selected in iviewer_config
		edition = $("#span_ee_select .main_ee_select .label_selected").text().toLowerCase();
		$(".main_pp_select .label_selected").text(pp_lab).attr("id_value", pp_val).trigger("change");
		$('#text_elem').load("data/output_data/"+edition+"/page_"+pp_val+"_"+edition+".html #text_frame", function(){
			//IT: controlla se la pagine ha gli elementi necessari allo strumento ITL
			if ($('#text_elem .Area').length){
				if($('#switchITL').hasClass('inactive') || $('#switchITL').hasClass('likeInactive')){
					enableITLbutton();
				}
			} else {
				if($('#switchITL i ').hasClass('fa-circle-o')) disableITLbutton();
			     else $('#switchITL').addClass('likeInactive');
			}
			//IT: controlla se la pagine ha gli elementi necessari allo strumento HS
			if ($('#text_elem .Annotation').length){
				if($('#switchHS').hasClass('inactive') || $('#switchHS').hasClass('likeInactive')){
					enableHSbutton();
				}
			} else {
			     if($('#switchHS i ').hasClass('fa-circle-o')) disableHSbutton();
			     else $('#switchHS').addClass('likeInactive');
			}
		});
		
		$('#text_cont').animate({
			scrollTop: 0
		});
		if($('.current_mode').attr('id') === 'txttxt_link'){
			$('#text_cont-add').animate({ scrollTop: 0 });
		}
		
		/*$('#text_elem').load('pagina.html', function() {
			alert('Load was performed.');
		});*/
		
		// IT: Aggiorna l'indirizzo del frame secondario per il testo
		if ($("#text_cont-add").length > 0){ //SISTEMARE
			edition_add=$("#span_ee_select-add .option_container .option.selected").text().toLowerCase();

			$('#text_elem-add').load("data/output_data/"+edition_add+"/page_"+pp_val+"_"+edition_add+".html #text_frame");
				
			// IT: Aggiorna le informazioni all'interno dell'etichetta destra	
			$('#zvalopz')
				.text($("input[name=edition_r-add]:checked").val())
				.hide()
				.fadeIn(200);
		}
		
		// IT: Aggiorna le informazioni all'interno delle etichette			
		$('#central_page_number span').text(pp_val);
		/*$('#edval span')
			.hide()
			.fadeIn(200);*/

		//$("#iviewerImage").attr("src", "images/null.jpg"); // Loading...
		//$('#folio_page_number').val(pp_val).change(); // IT: Questo attiva l'evento nel file js/plugin/jquery.iviewer config
		
		// preload([
		// 	'images/single/'+$('.main_pp_select .option_container .option.selected').prev().text()+'.jpg',
		// 	'images/single/'+$('.main_pp_select .option_container .option.selected').next().text()+'.jpg'
		// ]);

		// IT: Se ci si trova nella modalit Thumb, chiude la schermata e visualizza l'immagine
		if($("#thumb_cont").css('display') === "block"){
			$(".thumb_link").trigger('click');
		}
	}
	// IT: Gestisce il cambio edizione nel frame testuale
	function gotoedition(pp_val, pp_el, frame_id, parent_id){
		if (ITLon === true){
			UnInitialize(true);
		} //Add by JK for ITL
		if (HSon === true){
			UnInitializeHS(true);
		} //Add by JK for HS
		$('#'+frame_id).load("data/output_data/"+pp_el+"/page_"+pp_val+"_"+pp_el+".html #text_frame",
			function() {
				// IT: se il pulsante ITL è attivo e non sono in modalità txttxt, attiva ITL
				if ($("#switchITL i").hasClass('fa fa-chain')){
					if(!($('.current_mode').attr('id') === 'txttxt_link')){
						Initialize();
					}
				} /*Add by JK for ITL*/
				if ($("#switchHS i").hasClass('fa fa-dot-circle-o')){
					if(!($('.current_mode').attr('id') === 'txttxt_link')){
						InitializeHS();
					}
				} /*Add by JK for HS*/
			}
		);

        var pp_el_upp = pp_el;
		pp_el_upp = pp_el_upp.toLowerCase().replace(/\b[a-z]/g, function(letter) {
			return letter.toUpperCase();
		});

		// IT: Gestisce la scrittura nell'etichetta destra o sinistra a seconda del frame caricato
		/*if (frame_id.indexOf("-add")>-1) {
			$('#zvalopz').text(pp_el_upp);
		} else{
			$('#edval span').text(pp_el_upp);
		}*/
	}
	// IT: Un preload basilare per la navigazione delle immagini
	function preload(arrayOfImages) {
		$(arrayOfImages).each(function(){
			$('<img/>')[0].src = this;
		});
	}

	function arrow(toward){ //duplicata temporaneamente in jquery.rafmas-keydown
		var d_page, l_page;
		var current_pp;
		if ($("#imgd_link").attr("class") !== "current_mode"){
			current_pp = $('.main_pp_select .option_container .option.selected').attr("id").substr(6);
			if (toward === "left" && current_pp !== first_pp){
				if($('.main_pp_select .option_container .option.selected').prev().attr("id")!=undefined){
					window.location.hash = $('.main_pp_select .option_container .option.selected').prev().attr("id").substr(6);
				} else if($('.main_pp_select .option_container .option.selected').parent().prev()){
				    window.location.hash = $('.main_pp_select .option_container .option.selected').parent().prev().find('.option:last').attr("id").substr(6);
				}
			}
			if (toward === "right" && current_pp !== last_pp){
				if($('.main_pp_select .option_container .option.selected').next().attr("id")!==undefined){
					window.location.hash = $('.main_pp_select .option_container .option.selected').next().attr("id").substr(6);
				} else if($('.main_pp_select .option_container .option.selected').parent().next()){
				    window.location.hash = $('.main_pp_select .option_container .option.selected').parent().next().find('.option:first').attr("id").substr(6);
				}
			}
		} else {
			current_pp = $('.main_dd_select .option_container .option.selected').attr("id").substr(6);
			if (toward === "left" && current_pp !== first_dd){
				if($('.main_dd_select .option_container .option.selected').prev().attr("id")!=undefined){
					d_page = $('.main_dd_select .option_container .option.selected').prev().attr("id").substr(6);
					l_page = $('.main_dd_select .option_container .option.selected').prev().text();
					$(".main_dd_select .label_selected").text(l_page).attr("id_value", d_page).trigger("change");
					//window.location.hash = $('.main_dd_select .option_container .option.selected').prev().attr("id").substr(6);
				} else {
				    d_page = $('.main_dd_select .option_container .option.selected').parent().prev().find('.option:last').attr("id").substr(6);
					l_page = $('.main_dd_select .option_container .option.selected').parent().prev().find('.option:last').text();
					$(".main_dd_select .label_selected").text(l_page).attr("id_value", d_page).trigger("change");
				    //window.location.hash = $('.main_pp_select .option_container .option.selected').parent().prev().find('.option:last').attr("id").substr(6);
				}
			}
			if (toward === "right" && current_pp !== last_dd){
				if($('.main_dd_select .option_container .option.selected').next().attr("id")!=undefined){
					d_page = $('.main_dd_select .option_container .option.selected').next().attr("id").substr(6);
					l_page = $('.main_dd_select .option_container .option.selected').next().text();
					$(".main_dd_select .label_selected").text(l_page).attr("id_value", d_page).trigger("change");
					//window.location.hash = $('.main_dd_select .option_container .option.selected').next().attr("id").substr(6);
				} else {
				    d_page = $('.main_dd_select .option_container .option.selected').parent().next().find('.option:first').attr("id").substr(6);
					l_page = $('.main_dd_select .option_container .option.selected').parent().next().find('.option:first').text();
					$(".main_dd_select .label_selected").text(l_page).attr("id_value", d_page).trigger("change");
				    //window.location.hash = $('.main_pp_select .option_container .option.selected').parent().next().find('.option:first').attr("id").substr(6);
				}
			}
		}
	}

	// Gestione lunghezza delle select sulla base della option più lunga
	function updateSelectLength(elem){
		var widthSel, widthOpt, widthEE, optEE;
		// Calcolo la larghezza del div figlio di .like_select
		widthSel = $(elem).find('div').width();
		// Calcolo la larghezza del div.option_container, aggiungendo 10 per via del padding 
		widthOpt = $(elem).find('.option_container').width()+10;
		// Se la larghezza del contenitore esterno è maggiore di quella delle option aggiorno l'option_container e ristemo il genitore	
		if(widthSel > widthOpt){
			
			// Imposto la larghezza dell'option container secondo quella del div figlio di .like_select
			$(elem).find('.option_container').css('width', widthSel);

			// Ricalcolo la dimensione dell'option_container, sempre aggiungendo 10 per il padding
			widthOpt = $(elem).find('.option_container').width()+10;
			// Se la nuova dimensione di option_container è maggiore di quella del div figlio di .like_select
			// (Ovvero se le opzioni "sbordano")
			// Aggiorno nuovamente la larghezza del div .like_select sulla base della nuova larghezza di option_container
			if(widthSel < widthOpt){
				$(elem).css('width', widthOpt);
			}
		}
		// Se altrimenti il contenitore delle option è più largo in partenza aggiorno il genitore
		else {
			
			// imposto la larghezza di .like_select sulla base di quella di option_container, 
			// aggiungendo 14 per via del div per l'apertura
			$(elem).css('width', widthOpt+14);
			// Poi aggiorno la dimensione dell'option_container, aggiungendo i 4px che mi permettono di allinearla al div figlio di .like_select
			$(elem).find('.option_container').css('width', widthOpt+4);
		}
		// Riporto la position di option_container ad absolute per rendere corretto il posizionamento all'apertura
		$(elem).find('.option_container').css("position", "absolute");
		$(elem).find('.option_container').css("visibility", "visible");
		$(elem).find('.option_container').css("display", "none");

		if(elem.id === 'span_ee_select'){
			widthEE = $('#span_ee_select').find('div').width();
			optEE = $('#span_ee_select').find('.option_container').width();
			$('#span_ee_select-add').find('.option_container').removeAttr('style');
			$('#span_ee_select-add').css('width', widthEE);
			$('#span_ee_select-add').find('.option_container').css('width', optEE);
			$('#span_ee_select-add').addClass('widthChanged');
		}
		else if(elem.id === 'span_pp_select'){
			widthEE = $('#span_pp_select').find('div').width()*1.5;
			optEE = $('#span_pp_select').find('.option_container').width()*1.5;
			$('#span_dd_select').find('.option_container').removeAttr('style');
			$('#span_dd_select').css('width', widthEE);
			$('#span_dd_select').find('.option_container').css('width', optEE+5);
			//$('#span_dd_select').addClass('widthChanged');
		}
		
	}

	function goFullScreenLeft(){
		var height_full, width_full,
			margin_left, margin_top,
			widthSel, widthOpt,
			left_headerHeight;

		//Se ITL è attivo, disattivalo. Disabilita il pulsante.
		if(ITLon){
			UnInitialize();
		}
		disableITLbutton();

		$('.zoomWindow').hide();
        $('.zoomPup').hide();
		if($('#header_collapse').hasClass('fa-caret-down')){
			$("#header_collapse").trigger('click');
		}
		$('#header_collapse').toggle();
		$("#main_left_frame").toggleClass("full");
		height_full = ($(window).height() > $("body").height()) ? $(window).height()-4 : $("body").height();
		width_full = ($(window).width()>$("#global_wrapper").width()) ? $(window).width()-4 : $("#global_wrapper").width()-4;
		// 4 è l'altezza totale dei bordi di sinistra e destra
		margin_left = -($('#main_left_frame').offset().left);
		margin_top = -($('#main_left_frame').offset().top);
		
		//cambia dimensione elementi per Mag //Add for Mag
		left_headerHeight = $('#left_header').height();
        $('#mag_image_elem').css({'margin-top': left_headerHeight+'px', 'height': height_full-left_headerHeight+'px'});
        $('.zoomWindow').css({left: (width_full - $(".zoomWindow").width())/2+'px'});
        $('.zoomPup').css({left: (width_full - $(".zoomPup").width())/2+'px'});
        
		$('#main_left_frame').animate({
			width: width_full,
			height: height_full,
			top: margin_top,
			left: margin_left,
			minWidth: "1021px"
		}, 700, function(){
			$('#left_header .closeFullScreen').toggle();
			$('.zoomWindow').show(0); //Add for mag
			//$('#header_collapse').animate({opacity: 1});
			fitFrame();
		});
		$('.go-full-left').toggle();
		//$('#switchITL:visible').hide();
		$('#switchITL').addClass('inactive');
		
		if(($('#span_ee_select-add').is('visible'))&&!$('#span_ee_select-add').hasClass('widthChanged')){
			$('#span_ee_select-add').addClass('widthChanged');
			$('#span_ee_select-add .option_container').removeAttr('style');

			$('#span_ee_select-add').each(function(){
				widthSel = $(this).width();
				widthOpt = $(this).find('.option_container').width()+10;
				if(widthSel > (widthOpt+24)){
					$(this).find('.option_container').css('width', widthSel-10);
					//alert("widthSel"); 
				} else {
					$(this).css('width', widthOpt+24);
					$(this).find('.option_container').css('width', widthOpt+14);
					//alert("widthOpt");
				}
			});
		}

	}

	function closeFullScreenLeft(){
		//$('#header_collapse').animate({opacity: 0});
		$("#main_left_frame").toggleClass("full");
		$('.zoomWindow').hide();
		$('.zoomPup').hide();
		//caso in cui si passa a fullscreen dalla visualizzazione a doppia pagina
		if($('#main_right_frame').css("display") === "none"){
			$('#main_left_frame').animate({
				width: "99.5%",
				height: "100%",
				top: "0px",
				left: "0px",
				minWidth: "0px"
			}, 700, function(){
				$('#left_header .closeFullScreen').toggle();
				$('.go-full-left').toggle();
				//$('#header_collapse').removeAttr('style');
				$('#header_collapse').toggle();
				//Add for Mag
				setMagHeight();
				$('.zoomWindow').show();
				fitFrame();
			});
		} else {
			$('#main_left_frame').animate({
				width: "49.8%",
				height: "100%",
				top: "0px",
				left: "0px",
				minWidth: "0px"
			}, 700, function(){
				$('#left_header .closeFullScreen').toggle();
				$('.go-full-left').toggle();
				//$('#header_collapse').removeAttr('style');
				$('#header_collapse').toggle();
				//Add for Mag
				setMagHeight();
				$('.zoomWindow').show();
				checkAnnPosHS(); //Add for HS
				fitFrame();
			});
			$('#switchITL').show();
			//Se ITL è impostato su attivo, attiva il collegamento. Abilita il pulsante.
			if ($('#switchITL i ').hasClass('fa fa-chain')){ //Add by JK for ITL
				Initialize();
			}
			enableITLbutton();
		}

		//$('#span_dd_select').hide();
	}

	function goFullScreenRight(){
		var height_full, width_full, margin_right, margin_left, margin_top;

		if (ITLon){ //Add by JK for ITL
			UnInitialize();
		}
		if (HSon){ //Add by JK for HS
			UnInitialize();
		}
		if($('#header_collapse').hasClass('fa-caret-down')){
			$("#header_collapse").trigger('click');
		}
		$('#header_collapse').toggle();
		
		// Aggiunta di suffisso nel caso di testo a unico frame
		var suffix="";
		if($('#main_right_frame-single').length>0)    suffix='-single';

		// Gestione del full screen per browser webkit
		if ($.browser.webkit) {
			height_full = ($(window).height() > $("body").height()) ? $(window).height()-4 : $("body").height();
			width_full = ($(window).width()>$("#global_wrapper").width()) ? $(window).width()-4 : $("#global_wrapper").width()-4;
			// 4 è l'altezza totale dei bordi di sinistra e destra
			margin_right = -($(window).width()-($('#main_right_frame'+suffix).offset().left+$('#main_right_frame'+suffix).width())-4);
			margin_top = -($('#main_right_frame'+suffix).offset().top);
			$("#main_right_frame"+suffix).toggleClass("full");
			$('#main_right_frame'+suffix).animate({
				width: width_full,
				height: height_full,
				marginTop: margin_top,
				right:margin_right,
				minWidth: "1021px"
			}, 700, function(){
				fitFrame();
				$('#right_header .closeFullScreen').toggle();
			});
			$("#main_right_frame"+suffix).css('position', 'absolute');
			$('.go-full-right').toggle();
			
		} else {
			height_full = ($(window).height() > $("body").height()) ? $(window).height()-4 : $("body").height();
			width_full = ($(window).width()>$("#global_wrapper").width()) ? $(window).width()-4 : $("#global_wrapper").width()-4;
			// 4 è l'altezza totale dei bordi di sinistra e destra
			margin_right = -($(window).width()-($('#main_right_frame'+suffix).offset().left+$('#main_right_frame'+suffix).width())-4);
			margin_top = -($('#main_right_frame'+suffix).offset().top);
			margin_left = -($('#main_right_frame'+suffix).offset().left);
			$("#main_right_frame"+suffix).toggleClass("full");

			$('#main_right_frame'+suffix).animate({
				width: width_full,
				height: height_full,
				marginTop: margin_top,
				left: margin_left,
				right:margin_right,
				minWidth: "1021px"
			}, 700, function(){
				fitFrame();
				$('#right_header .closeFullScreen').toggle();
			});
			
			$('.go-full-right').toggle();
		}

	}

	function closeFullScreenRight(){
		var widthLeft;

		if ($('#switchITL i ').hasClass('fa fa-chain')){ //Add by JK for ITL
			Initialize();
		}
		if ($('#switchHS i ').hasClass('fa fa-dot-circle-o')){ //Add by JK for HS
			InitializeHS();
		}
		
		// Aggiunta di suffisso nel caso di testo a unico frame
		var suffix="";
		if($('#main_right_frame-single').length>0)    suffix='-single';
		
		// Gestione del full screen per browser webkit
		if ($.browser.webkit) {
			if($('#main_right_frame-single').length>0)
			     widthLeft = $('#central_wrapper').width();
			else 
			     widthLeft = $('#main_left_frame').width()-4;
			$('#main_right_frame'+suffix).animate({
				width: widthLeft,
				height: "100%",
				marginTop: "0px",
				right: "0px",
				minWidth: "0px"
			}, 700, function(){
				fitFrame();
				$('#main_right_frame'+suffix).removeAttr("style");
				$('#right_header .closeFullScreen, #header_collapse').toggle();
				$('#main_right_frame'+suffix).toggleClass("full");
				$('.go-full-right').toggle();
			});
		} else {
			if($('#main_right_frame-single').length>0)
			     widthLeft = $('#central_wrapper').width();
			else
			     widthLeft = $('#main_left_frame'+suffix).width()-3;
			$('#main_right_frame'+suffix).animate({
				width: widthLeft,
				height: "100%",
				marginTop: "0px",
				left: "0px",
				minWidth: "0px"
			}, 700, function(){
				fitFrame();
				$('#main_right_frame'+suffix).removeAttr("style");
				$('#right_header .closeFullScreen,  #header_collapse').toggle();
				$('#main_right_frame'+suffix).toggleClass("full");
				$('.go-full-right').toggle();
			});
		}

	}

	function fitFrame(){
		if($('#left_header').hasClass('menuClosed')){
			$('#text_cont, #text_cont-add, #thumb_cont')
				.css('height', '100%');
		} else {
			$('#text_cont, #text_cont-add, #thumb_cont')
				.css('height', '100%')
				.css('height', '-=42px');
		}
	}

	/* / Funzioni */
	
	
	/* Gestione click */
	$("#home_title").click(function(){
		window.location="index.html";
	});

	$(".main_left_arrow").click(function(){
		arrow("left");
	});
	$(".main_right_arrow").click(function(){
		arrow("right");
	});
	
	$("#main_left_menu").click(function(){
		if($("#main_left_menu-openlink").css('display') !== "none"){
			$("#main_left_frame header").show('slide', {direction: 'left'}, 1000);
			$("#main_left_frame-single header").show('slide', {direction: 'left'}, 1000);
			$("#main_left_menu-openlink").toggle();
			$("#main_left_menu-closelink").toggle();
			keycount = 1;
		} else{
			$("#main_left_frame header").hide('slide', {direction: 'left'}, 1000);
			$("#main_left_frame-single header").hide('slide', {direction: 'left'}, 1000);
			$("#main_left_menu-openlink").toggle();
			$("#main_left_menu-closelink").toggle();
			keycount = 0;
		}
	});
			
	$("#main_right_menu").click(function(){
		if($("#main_right_menu-openlink").css('display') !== "none"){
			$("#main_right_frame header").show('slide', {direction: 'right'}, 1000);
			$("#main_right_menu-openlink").toggle();
			$("#main_right_menu-closelink").toggle();
			keycount = 0;
		} else{
			$("#main_right_frame header").hide('slide', {direction: 'right'}, 1000);
			$("#main_right_menu-openlink").toggle();
			$("#main_right_menu-closelink").toggle();
			keycount = 1;
		}
	});

	$(".thumb_link").click(function(){
		if (magnifierON == false){  //modalità zoom attivo JK
            if($("#image_loading").css('display')!=="none"){$("#image_loading").hide()}
            if($("#image_elem").css('display') === "none"){
				$("#image_elem").show();
				$("#image_fade").show();
				if(!$('#left_header').hasClass('menuClosed')){
					$("#image_tool").show();
				}
				$("#thumb_cont").hide();
			} else{
				$("#image_elem").hide();
				$("#image_fade").hide();
				$("#image_tool").hide();
				$("#thumb_cont").show();
			}
		}else {                  //modalità magnifier attivo JK
			if($("#mag_image_elem").css('display') === "none"){
				$("#mag_image_elem").show();
				$("#image_tool").show();
				$("#thumb_cont").hide();
			} else{
				$("#mag_image_elem").hide();
				$("#image_tool").hide();
				$("#thumb_cont").show();
			}
		}
	});

	$(".thumb_single").click(function(){
		if(magnifierON){
			window.location.hash = $(this).attr('id').replace( '_small', '' );
		} else{
			$("#image_elem").show();
			$("#image_fade").show();
			window.location.hash = $(this).attr('id').replace( '_small', '' );
			
			if ($("#imgd_link").attr("class") === "current_mode"){
				$(".main_dd_select").trigger("imgd_thumb");
			}

			$(".thumb_link").trigger('click');
		}
	});	
	
	// MODE -
	$("#txtimg_link").click(function(){
		if($(this).attr("class") !== "current_mode"){
			if ($("#imgd_link").attr("class") === "current_mode"){
				$(".main_pp_select").trigger("txtimg_mode");
			}

			$("#txtimg_link").addClass("current_mode").siblings().removeClass("current_mode");
			//$("#imgd_link").removeClass("current_mode");
			//$("#imgimg_link").removeClass("current_mode");
			//$("#txttxt_link").removeClass("current_mode");

			//$("#image_cont-add").remove();
			
			$("#text_cont-add").remove();
			$("#span_ee_select-add").hide();

			$("#span_dd_select").hide();
			
			$("#main_right_frame").show();
			$("#main_left_frame").animate({
				'width': '49.8%'
			}, function(){
				$("#right_menu").show();
				$("#text_cont").show();
			});

			$("#mag").show();
			$("#image_menu").show();
			$('#switchITL').show();
			$('#switchHS').show();
			$("#image_cont").show();
			if($('#right_header').hasClass('menuClosed')){
				$('#right_header').hide();
			}
			
			$('#thumb_elem').show();
			$('#zvalint').show();
			//$('#zvalopz').text("");

			fitFrame();
			
			$('#header_collapse').animate({
     			left: "50%",
     			marginLeft: "-10px"
     		});
     
     		if(! $('.go-full-right').is(':visible')){
     			$('.go-full-right').show();
     		}
     		if ($("#switchITL i").hasClass('fa fa-chain')){
     			if(!$("#switchITL").hasClass('inactive')){
     				Initialize();
     			}
             }/*Add by JK for ITL*/
     		if ($("#switchHS i").hasClass('fa fa-dot-circle-o')){
                 if(!$("#switchHS").hasClass('inactive')){
     				InitializeHS();
                 }
             }/*Add by JK for HS*/
             
             if($('.go-full-left').hasClass('onWhite')){
     			$('.go-full-left').removeClass('onWhite');
             }
		}
	});
	/*$("#imgimg_link").click(function(){
		if($(this).attr("class")!="current_mode"){
			$("#imgimg_link").addClass("current_mode");
			$("#txttxt_link").removeClass("current_mode");			
			$("#txtimg_link").removeClass("current_mode");	

			$("#text_menu").hide();
			$("#text_cont").hide();
			
			$("#image_menu").show();
			$("#image_cont").show();
			
			
			$('#image_cont')
				.clone()
				.attr("id", "image_cont-add")
				.insertAfter("#left_header")
			;
							
		}
	});*/
	$("#txttxt_link").click(function(){
		var main_text_edition, first_new_edition, second_new_edition, noMenu_height;

		if($(this).attr("class") !== "current_mode"){
			UnInitialize();//Add by JK for ITL
			UnInitializeHS();//Add by JK for HS
			
			if ($("#imgd_link").attr("class") === "current_mode"){
				$(".main_pp_select").trigger("txtimg_mode");
			}

			$("#txttxt_link").addClass("current_mode").siblings().removeClass("current_mode");
			//$("#imgd_link").removeClass("current_mode");
			//$("#txtimg_link").removeClass("current_mode");
			//$("#imgimg_link").removeClass("current_mode");

			$("#image_menu").hide();
			$("#mag").hide();
			$("#image_cont").hide();
			$("#span_dd_select").hide();
			

			$("#main_right_frame").show();
			if($('#right_header').hasClass('menuClosed')){
				$('#right_header').hide();
			}
 			$("#main_left_frame").animate({
				width: '49.8%',
				borderLeftWidth: '2px',
				borderRightWidth: '2px'
			}, function(){
				$("#right_menu").show();
				$("#text_cont").show();
			});

			$('#text_cont')
				.clone()
				.attr("id", "text_cont-add")
				.insertAfter("#left_header")
			;
			$('#text_cont-add>#text_elem')
				.attr("id", "text_elem-add")
			;

			//$('#zvalint').hide(); //SISTEMARE
			//$('#zvalopz').text($("input[name=edition_r]:checked").val());			
			$('#span_ee_select-add').css({display: "inline-block"});
			//$("#span_ee_select-add").show();

			main_text_edition = $('#span_ee_select .main_ee_select .label_selected').text();
			first_new_edition = $('.main_ee_select .option_container').children('.option').eq(0).text();
			second_new_edition = $('.main_ee_select .option_container').children('.option').eq(1).text();
			if (main_text_edition === first_new_edition){
				$("#span_ee_select-add .main_ee_select .label_selected").text(second_new_edition).attr("id_value", second_new_edition).trigger("change");
			} else{
				$("#span_ee_select-add .main_ee_select .label_selected").text(first_new_edition).attr("id_value", first_new_edition).trigger("change");
			}

			fitFrame();
			
			if(!$('#span_ee_select-add').hasClass('widthChanged')){
    			$('#span_ee_select-add').addClass('widthChanged');
    			$('#span_ee_select-add .option_container').removeAttr('style');
    
    			$('#span_ee_select-add').each(function(){updateSelectLength(this);});
    		}
    		$('#header_collapse').animate({
    			left: "50%",
    			marginLeft: "-10px"
    		});
    		if(! $('.go-full-right').is(':visible')){
    			$('.go-full-right').show();
    		}
    		if($('#left_header').hasClass('menuClosed')){
    			noMenu_height = $('#image_cont').height()+42;
    			$('#text_cont, #text_cont-add').css({
    				"top": "-42px",
    				"height": noMenu_height
    			});
    			$('.go-full-left').addClass('onWhite');
    		}
		}
	});

	$("#imgd_link").click(function(){
		if($(this).attr("class") !== "current_mode"){
			UnInitialize(); //Add by JK for ITL
			UnInitializeHS(); //Add by JK for HS
			$("#imgd_link").addClass("current_mode").siblings().removeClass("current_mode");
			//$("#txtimg_link").removeClass("current_mode");
			//$("#imgimg_link").removeClass("current_mode");
			//$("#txttxt_link").removeClass("current_mode");

			//alert($(".main_pp_select .label_selected").text());
			$(".main_dd_select").trigger("imgd_mode");


			$("#right_menu").hide();
			$("#main_left_frame").animate({
				'width': '99.5%'
			} //, 800
			, function(){
				$("#main_right_frame").hide();
			});

			//$("#image_cont-add").remove();
			$("#text_cont-add").remove();
			$("#span_ee_select-add").hide();

			//$("#text_cont").hide();

			$("#mag").show();
			$("#image_menu").show();
			$("#image_cont").show();
			$('#span_dd_select').css({display: "inline-block"});
			$('#switchITL').hide();
			$('#switchHS').hide();
			//$('#thumb_elem').hide();

			fitFrame();
			
			if(!$('#span_dd_select').hasClass('widthChanged')){
    			$('#span_dd_select').addClass('widthChanged');
    			$('#span_dd_select .option_container').removeAttr('style');
    
    			$('#span_dd_select').each(function(){ updateSelectLength(this);});
    		}
    		$('#header_collapse').animate({
    			left: "100%",
    			marginLeft: "-30px"
    		});
    		$('.go-full-right').hide();
    		if($('.go-full-left').hasClass('onWhite')){
    			$('.go-full-left').removeClass('onWhite');
            }
		}
	});
	
	$("#txt_single").click(function(){
	    if($(this).attr("class") !== "current_mode"){
	       $("#txt_single").addClass("current_mode").siblings().removeClass("current_mode");
	       $('#main_left_frame').animate({
	           width: '0px',
	           borderLeftWidth: '0px',
	           borderRightWidth: '0px'
	       }, function(){
	          $("#text_cont-add").remove(); 
	       });
	       $('#header_collapse').animate({
	          left: '15px' 
	       });
	    }
	});
	// /MODE -

	$("#header_collapse").click(function(){
		var noMenu_height;
		if (magnifierON === false){
			$('#image_tool').slideToggle().toggleClass('menuClosed');
		}
		// Modifico colore dell'icona .go-full-right che altrimenti non si vedrebbe
		$('.go-full-right').toggleClass('onWhite');
		
		// Gestione menu sinistro: chiudo/apro + aggiungo/tolgo la classe menuClosed
		$('#left_header').toggle('blind').toggleClass('menuClosed');
		// Se è aperto il text di sinistra modifico colore dell'icona go-full-left che altrimenti non si vedrebbe
		if($('#text_cont-add').css('display') === 'block'){
			$('.go-full-left').toggleClass('onWhite');
		}
		setMagHeight(); //Add for Mag
		// se ho appena chiuso il menu di sinistra
		if($('#left_header').hasClass('menuClosed')){
			// Modifico le dimensioni del testo di sinistra per riempire il box
			noMenu_height = $('#image_cont').height();
			$('#text_cont-add, #thumb_cont').animate({
				top: "-42px",
				height: noMenu_height
			});
		} else {
			// altrimenti (se ho appena aperto il menu sx)
			// Risistemo il box del testo a sinistra
			$('#text_cont-add, #thumb_cont').animate({
				top: "0px"
			});
		}

		// Gestione menu destro: chiudo/apro + aggiungo/tolgo la classe menuClosed
		$('#right_header').toggle('blind').toggleClass('menuClosed');
		// Se ho appena chiuso il menu di destra
		if($('#right_header').hasClass('menuClosed')){
			$('#text_cont, #text_cont-add').animate({
				height: "100%"
			});
		} else {
			noMenu_height = $('#image_cont').height()+42;
			/*$('#text_cont, #text_cont-add, #thumb_cont').animate({ //non funzia
				height: "calc(100% - 42px)",
				height: "-webkit-calc(100% - 42px)",
				height: "-moz-calc(100% - 42px)"
			});*/
			$('#text_cont, #text_cont-add, #thumb_cont')
				.css('height', '-=42px')
				.css('height', '100%');
		}

		// Modifico lo stile e la posizione dell'icona
		if($('#header_collapse').hasClass('fa-caret-up')){
			if($(".closeFullScreen:visible").length>0){
				$('#header_collapse').animate({
					top: "-75px"
				});
			} else {
				$('#header_collapse').animate({
					top: "-8px"
				});
			}
			$('#header_collapse').removeClass('fa-caret-up').addClass('fa-caret-down');
		} else {
			if($(".closeFullScreen:visible").length>0){
				$('#header_collapse').animate({
					top: "-39px"
				});
			} else {
				$('#header_collapse').animate({
					top: "23px"
				});
			}
			$('#header_collapse').removeClass('fa-caret-down').addClass('fa-caret-up');
		}
		if(!$('#span_ee_select-add').hasClass('widthChanged')){
			$('#span_ee_select-add').addClass('widthChanged');
			$('#span_ee_select-add .option_container').removeAttr('style');
			$('#span_ee_select-add').each(function(){updateSelectLength(this);});
		}
		
	});
	
	$("#goFullScreenLeft").click(function(){
		goFullScreenLeft();
	});
	$("#goFullScreenRight").click(function(){
		goFullScreenRight();
	});
	$("#closeFullScreenLeft").click(function(){
		closeFullScreenLeft();
	});
	$("#closeFullScreenRight").click(function(){
		closeFullScreenRight();
	});
	$("#search_link").click(function(){
		alert("Coming soon in 2014");
	});
	/* / Gestione click */
	
	/*$("#text_copy").live("click", function(){
		..codice qui..
	});*/

	$(window).bind('resize', function(e){
		var height_full, width_full, leftCss, newLeft, rightR, leftR;
		window.resizeEvt;
		if($('.full')){
			height_full = ($(window).height()>$("body").height()) ? $(window).height()-4 : $("body").height();
			width_full = $(window).width()-4;
			$('.full').css({
				"height": height_full,
				"width": width_full
			});
			setMagHeight();
			$(window).resize(function(){
				clearTimeout(window.resizeEvt);
				fitFrame();
				window.resizeEvt = setTimeout(function()
				{
					leftCss = $('.full').css("left").replace(/[^-\d\.]/g, '');
					newLeft = leftCss - ($('.full').offset().left);
					$('.full').css("left", newLeft);

					if($('#main_right_frame').hasClass('full')){
						rightR = -(($('.go-full-right').offset().left)-($('.go-full-right').position().left));
						$('.go-full-right').css("right", rightR);
					}
					else{
						if($('#main_left_frame').hasClass('full')){
							leftR = -(($('.go-full-left').offset().left)-($('.go-full-left').position().left));
							$('.go-full-left').css("left", leftR);
						}
					}
				}, 300);
			});
		}
	});

});
