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
 **/

/*jslint browser: true*/
/*global $, jQuery, alert */

/* Variabili generiche*/
var fulltogg;
var first_pp, last_pp;
var first_dd, last_dd;
var groupingPagesByDoc, optionTooltipInPages;

$(function() {
	window.lang = new jquery_lang_js();

	"use strict";

	//IT: Setting variabili generiche
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

	groupingPagesByDoc = $('.groupByDoc').length > 0;
	optionTooltipInPages = $('.optionDocTooltip').length > 0;

	$.ajax({
		type: "GET",
		url: "data/output_data/structure.xml",
		dataType: "xml",
		success: function(xml) {
			/* =================== */
			/* LOAD EDITION LEVELS */
			$(xml).find('editions edition').each(function(){
				var current_id = $(this).text();
				$('.main_ee_select .option_container').append(
					$('<div/>')
						.attr("data-value", current_id.toLowerCase())
						.addClass('option')
						.text(current_id)
				);
			});
			
			// Se ho solo un livello di edizioni e non ho il regesto il pulsante TXT-TXT non serve più
			if( $(xml).find('editions edition').length <= 1 && $(xml).find('regesto').length < 1){
				$('#txttxt_link').remove();
				$('div.concave, div.extTop').css('width', '200px');
				$('div.botleftconcave').css('width', '176px');
			} else if ( $(xml).find('editions edition').length > 1 ) {
				$('#span_ee_select, #span_ee_select-add').removeClass('hidden');
			} 
			// Se ho il regesto e un solo livello di edizione
			if ( $(xml).find('regesto').length > 0 && $(xml).find('editions edition').length == 1 ) {
				// Rimuovo i pulsanti dal menu inferiore perché inutili
				// (ricerca, liste, filtri)
				$('#search_link-add, #list_link-add, #span_list_select-add').remove();
				$('.font-size-controller').css('top', '7px');
				// Rimuovo il pulsante per aprire il selettore dei livelli di edizione
				// in quanto non è necessario
				$('#span_ee_select').find('.open_select').remove();
				$('#span_ee_select').find('.label_selected').css('margin-right', '4px');
			}
			$(".main_ee_select .option_container div:first-child").addClass( "selected" );

			$('.main_ee_select .label_selected')
				.text($('.main_ee_select .option_container div:first').text())
				.attr("data-value", $('.main_ee_select .option_container div:first').attr('data-value'))
				.trigger('change');

			/* ==/ LOAD EDITION LEVELS */
			/* ======================= */
			
			/* =============== */
			/* LOAD PAGE PAIRS */
			first_pp = $(xml).find('pages pair pb').first().text();
			last_pp = $(xml).find('pages pair pb').last().text();
			
			var f_pair, l_pair;
			f_pair = $(xml).find('pages pair').first().children('pb').eq(0).text();
			l_pair = $(xml).find('pages pair').first().children('pb').eq(1).text()
			first_dd = f_pair + "+" + l_pair;

			f_pair = $(xml).find('pages pair').last().children('pb').eq(0).text();
			l_pair = $(xml).find('pages pair').last().children('pb').eq(1).text()
			last_dd = f_pair + "+" + l_pair;

			// if ( groupingPagesByDoc ) {
			// 	//Group_dd
			// 	$(xml).find('textpage text').each(function(){
			// 		var text_ref, group_elem;
			// 		text_ref = $(this).attr('n').replace(/\s+/g, '');
			// 		group_elem = $('<div/>')
			// 						.attr("data-first-doc-group", text_ref)
			// 						.addClass('optionGroup')
			// 						.append($('<span>').text(text_ref));
			// 		$('.main_dd_select .option_container').append(group_elem);
			// 	});
			// }

			$(xml).find('pages pair').each(function() {
				var current_id, first_page_d, second_page_d;
				var current_label, first_label_d, second_label_d;
				var first_text_ref, second_text_ref;

				first_page_d = $(this).children('pb').eq(0).text();
				first_label_d = $(this).children('pb').eq(0).attr("n") != "" ? $(this).children('pb').eq(0).attr("n") : first_page_d;
				second_page_d = $(this).children('pb').eq(1).text();
				second_label_d = $(this).children('pb').eq(1).attr("n") != "" ? $(this).children('pb').eq(1).attr("n") : second_page_d;
				
				current_id = "";
				current_label = "";
				
				first_text_ref = $(xml)
					.find('textpage text')
					.find('pb:contains("'+first_page_d+'")')
					.parent().attr('n');
				if (first_text_ref === undefined) {
					first_text_ref = $(xml)
						.find('textpage text')
						.find("pb[n='"+first_page_d+"']")
						.parent().attr('n');
				}
				first_text_ref = first_text_ref.replace(/\s+/g, '');

				if (second_page_d !== "") {
					current_id = first_page_d+"+"+second_page_d;
					current_label = first_label_d+" - "+second_label_d;
					// if (groupingPagesByDoc) {
					//	second_text_ref = $(xml)
					// 						.find('textpage text')
					// 						.find('pb:contains("'+second_page_d+'")')
					// 						.parent().attr('n');
					// 	second_text_ref = second_text_ref.replace(/\s+/g, '');

					// 	if(first_text_ref !== second_text_ref){
					// 		$(".main_dd_select [data-first-doc-group='"+second_text_ref+"']").append(
					//			$('<div/>')
			  		//				.attr("data-value", current_id)
			  		// 				.attr("data-first-page-first-doc", first_text_ref)
					// 				.addClass('option')
					// 				.text(current_label)
					// 		);
		   			//	}
		   			// }
				}
				else {
					current_id = first_page_d;
					if ( first_label_d.substr(-1).toLowerCase() == 'v' ) {
						current_label = first_label_d+" - (<span lang='def'>PAGE_MISSING</span>)";	
					} else {
						current_label = "(<span lang='def'>PAGE_MISSING</span>) - "+ first_label_d;
					}
				}

				// if (groupingPagesByDoc) {
				// 	$(".main_dd_select [data-first-doc-group='"+first_text_ref+"']").append(
   				//  	$('<div/>')
	   			//			.attr("data-value", current_id)
	   			//			.attr("data-first-page-first-doc", first_text_ref)
				// 			.addClass('option')
				// 			.text(current_label)
	   			//	);
				// } else {
					$('.main_dd_select .option_container').append(
	    				$('<div/>')
	    					.attr("data-value", current_id)
	    					.attr("data-first-page-first-doc", first_text_ref)
							.addClass('option')
							.append(current_label)
	    			);
				// }
			});
			$('.main_dd_select .option_container div.option:first-child').addClass('selected');
			$('.main_dd_select .label_selected')
				.text($('.main_dd_select .option_container div.option:first').text())
				.attr("data-value", $('.main_dd_select .option_container div.option:first').attr("data-value"))
				.attr("data-first-doc", $('.main_dd_select .option_container div.option:first').attr("data-first-page-first-doc"));

			/* ==/ LOAD PAGE PAIRS */
			/* =================== */

			/* ==================== */
			/* LOAD TEXTS AND PAGES */
			$(xml).find('textpage text').each(function() {
				var current_n, current_id, current_label, first_page_id;
					current_n = $(this).attr("n");
					current_label = $(this).attr("label");
					current_id = current_n.replace(/\s+/g, '');
					first_page_id = $(this).find(":first-child").text();

				$('.main_tt_select .option_container').append(
					$('<div/>')
						.attr("data-value", current_id)
						.attr("data-first-page", first_page_id)
						.attr("data-real-label", current_label)
						.attr("title", current_label)
						.addClass('option')
						// GENERAL COMMAND .text(cropLongTextLabel(current_label, 12))
						// SOLO X PELAVICINO
						.text(cropLongTextLabel(current_label, 20))
				);

				if (groupingPagesByDoc) {
					$('.main_pp_select .option_container').append(
					    $('<div/>')
	    						.attr("data-first-doc-group", current_id)
	    						.addClass('optionGroup')
	    						.append($('<span>').text(current_label))
					);
				}
				$(this).find('pb').each(function(){
					var page_current_id = $(this).text();
    				var page_current_label = $(this).attr("n");
    				if( groupingPagesByDoc || (!groupingPagesByDoc && $(".main_pp_select .option_container .option[data-value='"+page_current_id+"']").length <= 0)) {
    					var newOption = $('<div/>')
				    						.attr("data-value", page_current_id)
				    						.attr("data-first-doc", current_id)
				    						.addClass('option')
				    						.text(page_current_label);
    					if (groupingPagesByDoc) {
    						$(".main_pp_select [data-first-doc-group='"+current_id+"']").append(newOption);
    					} else {
    						$('.main_pp_select .option_container').append(newOption);
    					}
    				}

    				if ( $("#thumb_cont figure[data-value='"+page_current_id+"']" ).length <= 0 ) {
    					var figure = $('<figure/>')
		    					.addClass('thumb_single')
		    					.attr('data-value', page_current_id)
		    					.attr('data-first-doc', current_id);
		    			
		    			$('<img />')
		    				.attr('src', 'data/input_data/images/single/'+page_current_id+'_small.jpg')
		    				.appendTo(figure);
		    			
		    			$('<figcaption />')
		    				.text(page_current_label)
		    				.appendTo(figure);

		    			$('#thumb_cont').append(figure);

		    			$("img").error(function () {
						  $(this)
						  	.unbind("error")
						  	.attr("src", "images/no-image.png")
						  	.css('opacity', '0.3');
						});
    				}
				});
			});
			
			$('.main_tt_select .option_container div.option:first-child').addClass('selected');
			$('.main_tt_select .label_selected')
				.text($('.main_tt_select .option_container div.option:first').text())
				.attr("data-value", $('.main_tt_select .option_container div.option:first').attr('data-value'));
			
			$('.main_pp_select .option_container div.option:first-child').addClass('selected');
			$('.main_pp_select .label_selected')
				.text($('.main_pp_select .option_container div.option:first').text())
				.attr("data-value", $('.main_pp_select .option_container .option:first').attr("data-value"))
				.attr("data-first-doc", $('.main_pp_select .option_container .option:first').attr("data-first-doc"));
			
			/* ==/ LOAD TEXTS AND PAGES */
			/* ======================== */

			/* ============== */
			/* GESTIONE LISTE */
			if( $(xml).find('liste').children().length > 0 ){
				$('#toggle_list_cont')
					.click(function(){
						// console.log(' # toggle_list_cont click #');
						toggleListCont(this);
					});

				$('.list_filter').click(function() {
					// console.log(' # list_filter click #');
					filterListElements(this);
				});
				
				$(xml).find('liste').children().each(function(){
					var listName, listLabel;
					listName = $(this).get(0).tagName;
					listLabel = $(this).text();
					$('<div />')
						.attr('id', 'list_'+listName)
						.addClass('list')
						.appendTo('#lists_cont')
					;
					$('<span />')
						.addClass('labelList')
						.attr('id', 'header_'+listName)
						.attr('lang', 'def')
						.text(listLabel)
						.click(function(){
							// console.log(' # labelList click #');
							openList(this, listName);
						})
						.appendTo('#list_header');
					$('#lists_cont').find('.list').first().addClass('list_opened').show();
					$('#lists_cont').find('.labelList').first().addClass('active');
					$('.list_filter').first().trigger('click');

					$('#list_'+listName).load("data/output_data/liste/"+listName+".html #"+listName, function(){

						if ( $('#list_'+listName).find('li').length == 0 ) {
							$('#list_'+listName).remove();
							$('#header_'+listName).remove();

							if ( $('#list_header').find('.labelList').length == 0 ) {
								$('#lists_cont').remove();
								$('#list_link').remove();
							}
						} else {
							$('#list_'+listName)
								.find('.list_element').find('.toggle_list_element, .entity_name').click(function(){
									// console.log(' # toggle_list_element click #');
									showListElementOccurrences($(this).parent(), listName);
								});
						}
						/* Integration by LS */
				        if ( $("[lang!='"+window.lang.currentLang+"']").length > 0 ) {
				        	window.lang.update(window.lang.currentLang);
				        }
				        /* /end Integration by LS */
				        InitializeRefs();
				        $('.list_filter:first').trigger('click');
					});
				});
				if ($.browser.safari) {
					$('#list_header .labelList').css('top', '1px');
				} else if ($.browser.webkit) {
					$('#list_header .labelList').css('top', '-8.5px');
				}
			} else {
				$('#lists_cont').remove();
				$('#list_link').remove();
			}

			/* ==/ GESTIONE LISTE */
			/* ================== */

			/* ========================= */
			/* GESTIONE EVENTI POST AJAX */
			/* Gestione eventi per elementi creati in base alla lettura del file structure.xml */

			/* Lanciato dal click sulla thumbnail */
			/* Recupera l'identificativo della pagina di sx e di quella di dx dall'hash se impostato 
			   (altrimenti dal selettore delle pagine singole)
			   e aggiorna l'hash che poi provocherà il caricamento della nuova immagine */
			$(".main_dd_select").on('imgd_thumb',function(){
				// console.log(' # main_dd_select on imgd_thumb #');
				var hash_parts, temp_pp, temp_tt, first_page, second_page, newhash;
				var first_page_lab, second_page_lab, newlab;
				
				hash_parts = new Array();
				hash_parts = location.hash.substr(1).split('&');
				if ( hash_parts != "" ) {
					for (var i = 0; i < hash_parts.length; i++) {
					    if(hash_parts[i].indexOf("page") === 0) {
					        temp_pp = hash_parts[i].substr(5);
					    }
					    else if(hash_parts[i].indexOf("doc") === 0) {
					     	temp_tt = hash_parts[i].substr(4);   
					    }
					}
				} else {
					temp_pp = $('.main_pp_select .option_container .option:first-child').attr('data-value');
					temp_tt = $('.main_pp_select .option_container .option:first-child').attr('data-first-doc');
				}

				// first page of bookreader
				first_page = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(0).text();
				first_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(0).attr("n");
				first_page_lab = first_page_lab != "" ? first_page_lab : first_page;

				// second page of bookreader
				second_page = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(1).text();
				second_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
					.children()
					.eq(1).attr("n");
				second_page_lab = second_page_lab != "" ? second_page_lab : second_page;

				if (typeof(second_page_lab) == 'undefined'){
					newhash = first_page;
					second_page_lab = "(miss)";
				} else {
					newhash = first_page+"+"+second_page;
				}
				newlab = first_page_lab+" - "+second_page_lab;
				$(".main_dd_select .label_selected")
					.text(newlab)
					.attr("data-value", newhash)
					.attr("data-first-doc", temp_tt);

				window.location.hash = "doc="+temp_tt+"&page="+newhash;
			});
			
			/* Lanciato sul click della modalità bookreader */
			/* Recupera l'identificativo della pagina di sx e di quella di dx dal selettore delle pagine singole
			   e aggiorna l'hash che poi provocherà il caricamento della nuova immagine */
			$(".main_dd_select").on('imgd_mode',function(){
				// console.log(' # main_dd_select on imgd_mode #');
				var temp_pp, temp_tt, first_page, second_page, newhash;
				var first_page_lab, second_page_lab, newlab;
				temp_pp = $(".main_pp_select .label_selected").attr("data-value");
				temp_tt = $(".main_pp_select .label_selected").attr("data-first-doc");

				// first page of bookreader
				first_page = $(xml)
					.find('pair:contains('+temp_pp+')')
						.children()
							.eq(0).text();
				first_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
						.children()
							.eq(0).attr("n");
				first_page_lab = first_page_lab != "" ? first_page_lab : first_page;
				
				// second page of bookreader
				second_page = $(xml)
					.find('pair:contains('+temp_pp+')')
						.children()
							.eq(1).text();
				second_page_lab = $(xml)
					.find('pair:contains('+temp_pp+')')
						.children()
							.eq(1).attr("n");
				second_page_lab = second_page_lab != "" ? second_page_lab : second_page;
				if (typeof(second_page_lab) == 'undefined'){
					newhash = first_page;
					second_page_lab = "(miss)";
				} else {
					newhash = first_page+"+"+second_page;
				}
				
				newlab = first_page_lab+" - "+second_page_lab;
				$(".main_dd_select .label_selected")
					.text(newlab)
					.attr("data-value", newhash)
					.attr("data-first-doc", temp_tt)
				;
				updateHash(temp_tt, newhash);
			});

			/* APERTURA TOOLTIP PAGE */
			/* Recupera gli identificativi della pagina selezionata e del primo documento in essa contenuto. 
			   Ricerca gli altri testi che iniziano sulla stessa pagina 
			   e aggiorna il contenuto del tooltip con tale elenco. */
			
			if ( optionTooltipInPages ) {
				$('<span/>')
					.addClass('option_tooltip')
					.prependTo('.main_pp_select');

				$('<span/>')
					.addClass('option_tooltip_dd')
					.prependTo('.main_dd_select');			
				
				$(".main_pp_select .option_container .option").hover(function(e) {
					var first_doc, pp_val, tt_val, temp_tt, docs;
					
					pp_val = $(this).attr('data-value');
					tt_val = $(this).attr('data-first-doc');
					docs = "";
					if ( groupingPagesByDoc ) {
						$(this).parents('.main_pp_select').find(".option[data-value='"+pp_val+"']").each(function(){
							if($(this).attr('data-value') != tt_val){
								var temp_tt_val;
								temp_tt_val = $(this).parents('.optionGroup').attr('data-first-doc-group');
								temp_tt = $("#span_tt_select .option[data-value='"+temp_tt_val+"']").attr('data-real-label');
								docs += "<span>"+temp_tt+"</span>";
							}
						});
						if ($(this).parents('.main_pp_select').find(".option[data-value='"+pp_val+"']").length == 1) {	
							docs = '<span lang="'+window.lang.currentLang+'">'+window.lang.convert('DOCUMENT', window.lang.currentLang)+'</span>'+docs;
						} else {
							docs = '<span lang="'+window.lang.currentLang+'">'+window.lang.convert('DOCUMENTS', window.lang.currentLang)+'</span>'+docs;
						}
					} else {
						first_doc = "<span>"+$("#span_tt_select .option_container .option[data-value='"+tt_val+"']").attr('data-real-label')+"</span>";
						$("#span_tt_select .option_container .option[data-first-page='"+pp_val+"']").each(function(){
							if($(this).attr('data-value') != tt_val){
								temp_tt = $(this).attr('data-real-label');
								docs += "<span>"+temp_tt+"</span>";
							}
						});
						if (docs == "") {	
							docs = '<span lang="'+window.lang.currentLang+'">'+window.lang.convert('DOCUMENT', window.lang.currentLang)+'</span>'+first_doc;
						} else {
							docs = '<span lang="'+window.lang.currentLang+'">'+window.lang.convert('DOCUMENTS', window.lang.currentLang)+'</span>'+first_doc+docs;
						}
					}
					$(this).parents('.main_pp_select').find(".option_tooltip")
						.append(docs)
						.show()
						.offset({ top: ($(this).offset().top) });

				}, function(){
					$(this).parents('.main_pp_select').find(".option_tooltip")
						.empty()
						.hide()
					;
				});
				if ( groupingPagesByDoc ) {
					$(".main_dd_select .option_container .option").hover(function(e) {
						var first_doc, pp_vals, tt_vals, temp_tt, docs;
						pp_vals = $(this).attr('data-value').split('+');
						
						tt_vals = [];

						for(var i = 0; i < pp_vals.length; i++) {
							if ( pp_vals[i] != '' && pp_vals[i] != '(<span lang="'+window.lang.currentLang+'">'+window.lang.convert('PAGE_MISSING', window.lang.currentLang)+'</span>)' ) {
								$("#span_pp_select .option[data-value='"+pp_vals[i]+"']").each(function(){
									var temp_tt_val;
									temp_tt_val = $(this).parents('.optionGroup').attr('data-first-doc-group');
									temp_tt = $("#span_tt_select .option[data-value='"+temp_tt_val+"']").attr('data-real-label');
									if ( tt_vals[tt_vals.length-1] != temp_tt ) {
										tt_vals.push(temp_tt);
									}
									// docs += "<span>"+temp_tt+"</span>";
								});
							} 
						}

						if ( tt_vals.length == 1 ) {	
							docs = '<span lang="'+window.lang.currentLang+'">'+window.lang.convert('DOCUMENT', window.lang.currentLang)+'</span>'+tt_vals[0];
						} else {
							docs = '<span lang="'+window.lang.currentLang+'">'+window.lang.convert('DOCUMENTS', window.lang.currentLang)+'</span>';
							for(var i = 0; i < tt_vals.length; i++ ) {
								docs += '<span>'+tt_vals[i]+'</span>';
							}
						}

						$("#span_dd_select .option_tooltip_dd")
							.append(docs)
							.show()
							.offset({ top: ($(this).offset().top) });

					}, function(){
						$("#span_dd_select .option_tooltip_dd")
							.empty()
							.hide()
						;
					});
				}
			}

			/* SELECT PAGE */
			/* Recupera gli identificativi (e la label) della pagina selezionata e del primo documento in essa contenuto.  
			   Aggiorna l'hash che provoca il reload della pagina.
			*/
			$(".main_pp_select .option_container .option").click(function(){
				// console.log(' # main_pp_select option click #');
				if(! $(this).hasClass('selected')){
					var new_pp_val, new_pp_lab, new_tt_val;
					var current_tt_val, current_tt_first_page;
					
					new_pp_val = $(this).attr('data-value'); // id pagina cliccata
					new_pp_lab = $(this).text(); 
					new_tt_val = $(this).attr('data-first-doc'); // primo documento contenuto.
					
					/* Se il documento correntemente selezionato (current_tt_val) è contenuto nella pagina in questione, 
				   	   aggiorno il contenuto testuale non con il primo documento della pagina, ma con quello corrispondente current_tt_val.
				   	   Altrimenti aggiorno con il primo documento della pagina. */
					current_tt_val = $(".main_tt_select .label_selected").attr("data-value"); 
					current_tt_first_page = $(".main_tt_select .option_container .option.selected").attr('data-first-page');
					if(current_tt_first_page === new_pp_val){
						updateHash(current_tt_val, new_pp_val, "");
					} else {
						updateHash(new_tt_val, new_pp_val, "");
					}
					$(this).removeClass('selected');
				}
			});

			/* SELECT TEXT */
			$('.main_tt_select .option_container .option').click(function() {
				// console.log(' # main_tt_select option click #');
				if(! $(this).hasClass('selected')){
					$(this).addClass('selected');
					var new_tt_opt, new_tt_val, new_tt_first_page;
					var current_pp_val;

					var tt_val_temp, first_page;
					
					new_tt_opt = $(this);
					new_tt_val = $(this).attr('data-value');
					new_tt_first_page = new_tt_opt.attr('data-first-page');

					current_pp_val = $('#span_pp_select .label_selected').attr('data-value');
					
					/* Se la prima pagina del documento non è la corrente, 
						aggiorno il contenuto del frame testuale con quello della pagina in qustione.
						Altrimenti aggiorno solo le info legate al testo.
					*/
					if (current_pp_val != new_tt_first_page) {
						var new_tt_first_page_lab;
						new_tt_first_page_lab = $("#span_pp_select .option_container ")
													.find(".option[data-value='"+new_tt_first_page+"']").text();
					} else {
						$("#text_cont .doc[data-doc!='"+new_tt_val+"']").hide();
					}
					updateHash(new_tt_val, new_tt_first_page, "");
					$(this).removeClass('selected');
				}
			});

			/* SELECT EDITION LEVEL / SWITCH ON/OFF REGESTO */
			$('.main_ee_select .option_container .option').click(function(){
				// console.log(' # main_ee_select option click #');
				if ( ! $(this).hasClass('selected') ) {
					var regesto_button, regesto_cont;
					var contextual_frame, contextual_parent;
					var other_frame, other_parent;
					var other_ee_select, other_ee_select_val;
					var pp_val, ee_val;
    				var tt_val
    				
    				pp_val = $('#span_pp_select .label_selected').attr('data-value');
    				tt_val = $('#span_pp_select .label_selected').attr('data-first-doc');
    				ee_val = $(this).attr('data-value').toLowerCase();

    				contextual_frame = "";
    				contextual_parent = "";

    				other_frame = "";
    				other_parent = "";
					
					// Se ho cliccato su un elemento del selettore di sinistra
					if ($(this).parents(".like_select").attr("id") === "span_ee_select-add") {
						// Dovrò agire sul regesto a sinistra...
						regesto_button = "#switchReg-add";
						regesto_cont = "#regesto_cont-add";

						// ...sui contenitori testuali di sinistra...
						contextual_frame = "text_elem-add";
    					contextual_parent = "text_cont-add";

    					// ... e sui selettori e contenitori testuali di destra
						other_ee_select = "span_ee_select";

    					other_frame = "text_elem";
						other_parent = "text_cont";

    					if ( $('#main_right_frame .like_select.filter').find('.option.selected').length > 0 ) {
							$('#main_right_frame .like_select.filter').find('.option.selected').each(function() {
								var left_filter = "#"+$(this).parents('.like_select').attr('id')+"-add"; 
								if ( $(left_filter).find('.label_selected').attr('data-value') == 'none' ){
									var value = $(this).attr('data-value');
									$(left_filter)
										.find(".option[data-value='"+value+"']")
										.addClass('selected');
								}
							});
						}
					} 
					// Se ho cliccato su un elemento del selettore di destra
					else {
						// Dovrò agire sul regesto a destra...
						regesto_button = "#switchReg";
						regesto_cont = "#regesto_cont";
						// ...sui contenitori testuali di sinistra...
						contextual_frame = "text_elem";
    					contextual_parent = "text_cont";

    					// ... e sui selettori e contenitori testuali di destra
						other_ee_select = "span_ee_select-add";

						other_frame = "text_elem-add";
						other_parent = "text_cont-add";

					}
					other_ee_select_val = $('#'+other_ee_select).find('.label_selected').attr('data-value').toLowerCase();
					
					// Faccio un controllo sul livello di edizione da attivare sul frame corrente
					// e se sto passando all'edizione diplomatica disattivo i filtri e le liste
					if ( ee_val != 'diplomatic' ){ 
						$("#"+contextual_parent)
							.parents("div[id*='frame']")
								.find('.like_select.filter')
									.css('opacity', "1")
									.removeClass('not_active'); 
					} else {
						$("#"+contextual_parent)
							.parents("div[id*='frame']")
								.find('.like_select.filter')
									.css('opacity', "0.5")
									.addClass('not_active'); 
					}
				
					// Se ho il regesto, e questo è aperto, lo chiudo
					if ($(regesto_cont).length > 0 && $(regesto_cont).is(":visible")) {
						$(regesto_button).trigger('click');
					}

					// Se sto selezionando lo stesso livello attivo nell'altro frame
    				if ( other_ee_select_val === ee_val ) {
    					// Cerco un nuovo elemento da selezionare nell'altro frame
    					// e me ne salvo il valore
    					var other_ee_elem_to_select, other_ee_val;
    					other_ee_elem_to_select = $('#'+other_ee_select).find(".option[data-value!='"+ee_val+"']:first");
    					other_ee_val = other_ee_elem_to_select.attr('data-value').toLowerCase();

    					$('#'+other_ee_select)
							.find(".option[data-value='"+other_ee_val+"']").addClass('selected')
							.siblings('.option')
							.removeClass('selected');
						
						$('#'+other_ee_select)
		    						.find('.label_selected')
		    							.attr('data-value', other_ee_val)
		    							.text(other_ee_elem_to_select.text())
		    							.trigger('change');

    					// Se il valore dell'elemento da selezionare nell'altro frame non è indefinito né vuoto
    					if ( other_ee_val != undefined && other_ee_val != '' ) {
    						
    						// Se sto attivando l'edizione diplomatica nell'altro frame
    						// Disattivo le liste e i filtri
							if ( (other_ee_val != 'diplomatic') && (!$("#"+other_parent).parents("div[id*='frame']").find('.toggleReg').hasClass('active'))) {
								$("#"+other_parent)
									.parents("div[id*='frame']")
									.find('.like_select.filter')
										.css('opacity', "1")
										.removeClass('not_active'); 
							} else {
								$("#"+other_parent)
									.parents("div[id*='frame']")
										.find('.like_select.filter')
											.css('opacity', "0.5")
											.addClass('not_active'); 
							}
							// carico nell'altro frame il nuovo livello di edizione trovato
	    					gotoedition(pp_val, other_ee_val, other_frame, other_parent);
    					} 
    					else {
    						// altrimenti...
    						gotoedition(pp_val, ee_val, contextual_frame, contextual_parent);
    					}
    				}
    				// Altrimenti lascio stare l'altro frame così com'è 
					// e carico nel frame contestuale al click il testo del livello di edizione selezionato
    				gotoedition(pp_val, ee_val, contextual_frame, contextual_parent);
				}
			});
			
			/* SELECT DOUBLE PAGE NAVIGATION */
			$('.main_dd_select .option_container .option').click(function(){
				// console.log(' # main_dd_select option click #');
				var pp_val, pp_lab, tt_val, first_page_id;
				pp_val = $(this).attr('data-value');
				tt_val = $(this).attr('data-first-page-first-doc');
				pp_lab = $(this).text();
				$('#span_dd_select .label_selected')
					.attr("data-value", pp_val)
					.attr("data-first-doc", tt_val)
					.attr('data-last-hash-txtimg', '')
					.text(pp_lab);
				first_page_id = pp_val.split("+")[0];
				$("#span_pp_select .option_container .option[data-value='"+first_page_id+"']").trigger('click');				
				updateHash(tt_val, pp_val, "");
				$(this).removeClass('selected');
			});

			/* CLICK SU OPTION IN SELECT */
			/* General event on click on ".option" in a ".filter" ".like_select" */
			$(".like_select.filter .option_container .option").click(function(){
				// console.log(' # like_select.filter option click #');
				var classToBeActived, newLabel, newLabelVal, filtersActive;
				classToBeActived = $(this).attr('data-value');
				if (classToBeActived == 'clear') { //pulisci selezione
				    $(this).siblings('.option').removeClass('selected');
				    //$(this).addClass('selected');
				    $(this).parents("div[id*='frame']").find('.list_active').removeClass('list_active');
				    // se "pulisci selezione" l'etichetta prende "No selection"
			        newLabel = 'NO_SELECTION';
			        newLabelVal = "clear";
				} else if (classToBeActived == 'all') { //seleziona tutto
				    //$(this).addClass('selected');
				    $(this).siblings('.option').each(function(){
				        classToBeActived = $(this).attr('data-value');
				        if (classToBeActived != 'clear') {
				            $(this).addClass('selected');
				            $(this).parents("div[id*='frame']").find("."+classToBeActived).addClass('list_active');
				        } 
				        $(this).siblings(".option[data-value='clear']").removeClass('selected');
				    });
				    newLabel = 'MULTI_SELECTION';
				    newLabelVal = "multi";
				} else {
				   	$(this).toggleClass('selected');
					$(this).parents("div[id*='frame']").find("."+classToBeActived).toggleClass('list_active');
					$(this).siblings(".option[data-value='clear']").removeClass('selected');
					$(this).siblings(".option[data-value='all']").removeClass('selected');
				   
				   	filtersActive = $(this).parents('.option_container').find('.option.selected').length;
				   	switch(filtersActive){
				       	case 1:
				                newLabel = $(this).parents('.option_container').find('.option.selected').attr('data-value');
				                newLabelVal = $(this).parents('.option_container').find('.option.selected').attr('data-value');
				                break;
				       	case 0:
				                newLabel = "NO_SELECTION";
				                newLabelVal = "clear";
				                break;
				       	default:
				                newLabel = "MULTI_SELECTION";
				                newLabelVal = "multi";
				                break;
				   	}
				}
				// newLabel = window.lang.convert(newLabelVal, window.lang.currentLang);
				$(this).parents('.option_container')
							.siblings('.label_selected')
							.attr('lang', 'def')
							.text(newLabel);
				$(this).parents('.option_container').siblings('.label_selected').attr('data-value', newLabelVal);
				window.lang.run();
			});
			
			/* General event on click on ".option". It select the element clicked and unselect the others. 
				it closes the ".like_select". If it is a filter, it is possible to select more than one ".option" element. */
			$(".like_select .option_container .option").click(function(){
				// console.log(' # like_select option click #');
				if( (!$(this).hasClass('selected')) && (! $(this).parents('.like_select').hasClass('filter'))){
					var option_sel_value, option_sel_label;

					option_sel_value = $(this).attr('data-value');
					option_sel_label = $(this).text();
					$(this).parents('.like_select')
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
						// WTF: main_dd_select
						if ($(this).parents('.option_container').parent().attr("class") !== "main_pp_select"){
							$(this).parents('.option_container').prev().prev().text(newText).attr("data-value", newPage).trigger('change'); // .label_selected
						}
					}*/

					$(this).parents('.like_select')
						.find(".option[data-value!='"+option_sel_value+"']")
							.removeClass('selected');
					$(this)
						.addClass('selected');
					if ($(this).parents('.option_container').is(':visible')) {
						if($(this).parents('.option_container').hasClass('up')){
					       $(this).parents('.option_container').animate({
	    				       top: '-5px',
	    				       height:"toggle"
	    				   }, 400);
						} else {
						    $(this).parents('.option_container').animate({height:"toggle"}, 400);
						}
					}
				}
			});
			
			/* General event on hover on ".option". */
			
			$('.like_select .option_container .option').hover(function(){
				$('.hovered').removeClass('hovered');
				var parent_title = $(this).parents('.like_select').attr('title');
					$(this).parents('.like_select').attr('data-title', parent_title);
					$(this).parents('.like_select').attr('title', '');
			}, function(){
				var old_parent_title = $(this).parents('.like_select').attr('data-title');
				$(this).parents('.like_select')
								.attr('title', old_parent_title)
								.removeAttr('data-title');
			});

			$('.like_select').each(function(){
				updateSelectLength(this);
			});
			
			$("#global_wrapper").on('mousedown', function (e) {
				if ( ($(e.target).closest(".like_select").length === 0) && !($(".option_container").is(':animated')) ) {
					if($('.option_container:visible').hasClass('up')){
				       $('.option_container:visible').animate({
    				       top: '-5px',
    				       height:"toggle"
    				   }, 400);
					} else {
					    $('.option_container:visible').animate({height:"toggle"}, 400);
					}
				}

				if ( $(e.target).parents("#settings_cont").length === 0 && 
					 ! $("#settings_cont").is(':animated') &&
					 $(e.target).parents("#settings_link").length === 0 &&
					 $(e.target).attr('id') !== 'settings_link' ) {
					if ( $('#settings_cont').is(':visible') ) {
						$('#settings_link').trigger('click');
					}
				}
			});

			/* ========================= */
			/* CLICK SU SINGOLA THUMBNAIL */
			$(".thumb_single").click(function(){
				// console.log(' # thumb_single click #');
				var tt_val, pp_val;
				var current_tt_val, current_tt_first_page;
				pp_val = $(this).attr('data-value');
				tt_val = $(this).attr('data-first-doc');
				
				var current_pp_val = $(".main_pp_select .label_selected").attr("data-value"); 
				current_tt_val = $(".main_tt_select .label_selected").attr("data-value"); 
				current_tt_first_page = $(".main_tt_select .option_container .option.selected").attr('data-first-page');
				
				if(current_tt_first_page === pp_val){
					updateHash(current_tt_val, pp_val, "");
				} else {
					updateHash(tt_val, pp_val, "");
				}
				// if(current_pp_val === pp_val){
					$("#thumb_elem").trigger('click');
				// }

				if ( ! magnifierON ){
					$("#image_elem").show();
					$("#image_fade").show();
					
					if ( $("#imgd_link").hasClass("current_mode")) {
						$(".main_dd_select").trigger("imgd_thumb");
					}
				}
			});	
			
			/* ****************** */
			/* Integrazione by AB */
			/* ****************** */
			
			/* ====================== */
			/* MANUSCRIPT DESCRIPTION */
			if (($(xml).find('msDesc').length > 0) && ($(xml).find('msDesc').attr('active')==1)){
			    $('#msDesc_cont').load("data/output_data/prefatory_matter/ms_desc.html #msDesc", function(){
			    	if ( $('#msDesc_cont').is(':empty') ) {
				    	$('#switch_msDesc, #msDesc_cont').remove();
				    	resizeButtonsAndSelects();
				    } else {
				    	$('#switch_msDesc').click(function(){
				    		// console.log(' # switch_msDesc click #');
					    	if ( $("#thumb_elem").hasClass('active') ) {
					    		$("#thumb_elem").trigger('click');
					    	}
					        
					        if ( $('#msDesc_cont').is(':visible') ) {
					            $('#msDesc_cont').hide('drop', {direction:'up'}, 'linear', function(){
					            	$('#msDesc_cont').removeClass('open');
					            	if(!$('#left_header').hasClass('menuClosed')){
										$("#image_tool").show();
									} else {
										$("#image_tool").hide();
									}
					            });
					            $('#switch_msDesc').removeClass('active');
					            $('#image_tool').removeClass('hidden');
					        } else {
					            $('#msDesc_cont').show('drop', {direction:'up'}, 'linear', function(){
					            	$('#msDesc_cont').addClass('open');	
					            	$("#image_tool").hide();
					            });
					            $('#switch_msDesc').addClass('active');
					            $('#image_tool').addClass('hidden');
					        }
					    });
				    }
				    /* Integration by LS */
			        if ($("[lang!='"+window.lang.currentLang+"']").length > 0) {
			        	window.lang.run();
			        }
			        /* /end Integration by LS */
			    });
			}
			
			/* ============ */
			/* FRONT MATTER */
			if (($(xml).find('headerInfo').length > 0) && ($(xml).find('headerInfo').attr('active')==1)){
			    $('#headerInfo_cont').load("data/output_data/prefatory_matter/header_info.html #headerInfo", function(){
			    	/* Integration by LS */
			        if ($("[lang!='"+window.lang.currentLang+"']").length > 0) {
			        	window.lang.run();  
			        }
			        /* /end Integration by LS */
			        if ($('#generalFront_content').text().trim() == '') {
				    	$('#generalFront_content').remove();
				    }
			    });
			    $('#info_link').click(function(){
			    	$(this).toggleClass('active');
			    	// console.log(' # info_link click #');
			        if($('#headerInfo_cont').is(':visible')){
			            $('#headerInfo_cont').hide('fade', 'slow');
			        } else {
			            $('#headerInfo_cont').show('fade', 'slow');
			        }
			        $('#settings_link.active').trigger('click');
			    });

			    $('#headerInfo_cont').click(function(event){
			    	// console.log(' # headerInfo_cont click #');
			    	if ( $(event.target).parents('#close_header_info_cont').length > 0 ) {
		    			$('#info_link').trigger('click');
		    		} else {
		    			if ( !$(event.target).is('#headerInfo') ) {
				    		if ( $(event.target).parents('#headerInfo').length <= 0 ) {
				    			$('#info_link').trigger('click');
				    		}
						}
		    		}
			    });
			}

			/* *********************** */
			/* Fine integrazione by AB */
			/* *********************** */

			/* ==/ GESTIONE EVENTI POST AJAX */
			/* ============================= */

			/* =========================== */
			/* HASH CHANGE - ba.bbq plugin */
				// IT: Associa un evento a windows.onhashchange; quando l'hash cambia, ottiene il suo valore per usarlo in diverse funzioni
				$(window).hashchange( function(){
					var hash_parts, newhash, current_doc_el, current_doc, current_page, checkpp, checkdd, pp_lab, dd_lab;
					var dd_page, temp_search;

					hash_parts = new Array();
					hash_parts = location.hash.substr(1).split('&');
					if ( hash_parts != "" ) {
						for (var i = 0; i < hash_parts.length; i++) {
						    if(hash_parts[i].indexOf("page") === 0) { //begins with "page"
						        current_page = hash_parts[i].substr(5);
						    	if (current_page.indexOf("+") > 0) {
						    		current_page = current_page.substr(0, current_page.indexOf("+"));
						    	}
						    }
						    else if(hash_parts[i].indexOf("doc") === 0) { //begins with "doc"
						     	current_doc = hash_parts[i].substr(4);   
						    }
						}
					} else {
						current_page = $('.main_pp_select .option_container div.option:first').attr('data-value');
						current_doc = $('.main_pp_select .option_container div.option:first').attr('data-first-doc');
					}

					if ( $("#regesto_cont").length > 0 ) { 
						updateRegestoContent(current_doc);
 					}

 					if ( $("#front_cont").length > 0 ) { 
						updateFrontContent(current_doc);
 					}

					//current_page = hash.replace( /^#/, '' );
					//var checkpp = $(xml).find('text pb:contains('+current_page+')').text();
					checkpp = $(xml).find('pages pb:contains('+current_page+')').text();
					
					pp_lab = $(xml).find('pages pb:contains('+current_page+')').attr("n") != "" ? $(xml).find('pages pb:contains('+current_page+')').attr("n") : $(xml).find('pages pb:contains('+current_page+')').text();

					dd_page = current_page.replace(/\./g, '\\.');

					temp_search = dd_page;
					
					checkdd = $(".main_dd_select").find(".option[data-value*='"+temp_search+"']"); // .attr("id").substr(6)

					$(".main_left_arrow").removeClass("arrow_left_disable");
					$(".main_right_arrow").removeClass("arrow_right_disable");

					if((current_page === first_pp) || (current_page === first_dd)){
						$(".main_left_arrow").addClass("arrow_left_disable");
					}
					if((current_page === last_pp) || (current_page === last_dd)){
						$(".main_right_arrow").addClass("arrow_right_disable");
					}
					current_doc_el = $("#span_tt_select .option[data-value='"+current_doc+"']");
					
					if ( $('#inside_left_arrow').length > 0 || $('#inside_right_arrow').length > 0) {
						var prefixText = window.lang.convert('GO_TO_TEXT', window.lang.currentLang);
						if (current_doc_el.prev().text()  != "" ) {
							$('#inside_left_arrow').attr('title', prefixText+' '+current_doc_el.prev().text());
						} else {
							$('#inside_left_arrow').attr('title', '');
						}
					
						if (current_doc_el.next().text() != ""){
							$('#inside_right_arrow').attr('title', prefixText+' '+current_doc_el.next().text());
						} else {
							$('#inside_right_arrow').attr('title', '');
						}
					}
					
					if( (checkpp !== "") && ( !$("#imgd_link").hasClass("current_mode")) ) {
						UnInitialize(); //Add by JK for ITL
						UnInitializeHS(); //Add by JK for HS
						$("#mag_image_elem").empty(); // Add by JK for Mag
						if($('#switchMag i').hasClass('fa-search-plus')){
						  magnifierON = true;
					    }

						if ( current_page != $('#text_elem').attr('data-page') ){
							// necessario per la navigazione per documenti in una stessa pagina
							gotopage(current_page, pp_lab, "none"); 
						}
						//window.location.hash = "doc="+current_doc+"&page="+current_page;
						//chooseZoomMag(); // Add by JK for Mag				
					} else {
						$('#span_dd_select .label_selected').trigger('change');
						$("#mag_image_elem").empty(); // Add by JK for Mag
						if($('#switchMag i').hasClass('fa-search-plus')){
						  magnifierON = true;
						}
					}
					selectPP(current_page, pp_lab, current_doc);
					selectTT(current_doc);
					// Aggiorna frecce navigazione per documento
					if ( $('#inside_right_arrow').length > 0 || $('#inside_right_arrow').length > 0 ){
						if ( $('#span_tt_select .option_container .option:first-child').hasClass('selected') ) {
							$('#inside_left_arrow, #inside_left_arrow-add').addClass('disabled');
						} else {
							$('#inside_left_arrow, #inside_left_arrow-add').removeClass('disabled');
						}	
						if ($('#span_tt_select .option_container .option:last-child').hasClass('selected')){
							$('#inside_right_arrow, #inside_right_arrow-add').addClass('disabled');
						} else {
							$('#inside_right_arrow, #inside_right_arrow-add').removeClass('disabled');
						}
					}
					if( $('#txt_single').hasClass("current_mode")) { 
						$('#header_collapse').css("left",'15px'); 
					}
					// IT: Cambia il titolo della pagina in base all'hash
					// document.title = 'The hash is ' + ( hash.replace( /^#/, '' ) || 'blank' ) + '.';
				    // resizeButtonsAndSelects();
				});
				/* //= HASH CHANGE - ba.bbq plugin */
				/* =============================== */

				// IT: Al primo caricamento aggiorno l'id della pagina in modo che indichi pagina singola
				var first_hash_parts = new Array();
				first_hash_parts = location.hash.substr(1).split('&');
				if ( first_hash_parts != "" ) {
					var first_hash_pp, first_hash_doc;
					for (var i = 0; i < first_hash_parts.length; i++) {
					    if(first_hash_parts[i].indexOf("page") === 0) { //begins with "page"
					        first_hash_pp = first_hash_parts[i].substr(5);
					    	if (first_hash_pp.indexOf("+") > 0) {
					    		first_hash_pp = first_hash_pp.substr(0, first_hash_pp.indexOf("+"));
							} 
					    } else if(first_hash_parts[i].indexOf("doc") === 0) { //begins with "doc"
					     	first_hash_doc = first_hash_parts[i].substr(4);   
					    }
					} 
					// controllo che i riferimenti a documento e pagina
					// siano effettivamente relativi all'edizione corrente
					if ( $("#span_tt_select .option[data-value='"+first_hash_doc+"']").length < 1 || 
						 $("#span_pp_select .option[data-value='"+first_hash_pp+"']").length < 1 ) {
						window.location.hash = '';
					} else {
						$(window).hashchange();		
					}
				} else {
					// IT: L'evento viene attivato quando cambia l'hash della pagina
					$(window).hashchange();	
				}
		}
	});

	$(document).ready(function(){
		// console.log(' # DOCUMENT READY #');
		resizeGlobalTopBar();
		
		$('.mainButtons').each(function(){
			var full_button_width = $(this).outerWidth();
			$(this).attr('data-full-width', full_button_width);
		});

		// Sistemo interfaccia per Safari
		if ($.browser.safari) {
			$('#toggle_list_cont, #toggle_search_cont, #start_search, #toggle_search_cont-add, #start_search-add, #keyboard_link, #keyboard_link-add').css('top', '-1px');
		}

		$(".like_select.filter").each(function(){
			if ( $(this).find('.option_container .option').length <= 2 ) { // ci sono solo gli elementi "Seleziona tutto" e "Pulisci selezione"
				$(this).remove();
			}
		});

		$('#keyboard_shortcuts_link').click(function(){
			$(this).toggleClass('active');
	    	// console.log(' # info_link click #');
	        if($('#keyboard_shortcuts_cont').is(':visible')){
	            $('#keyboard_shortcuts_cont').hide('fade', 'slow');
	        } else {
	            $('#keyboard_shortcuts_cont').show('fade', 'slow');
	        }
	        $('#settings_link.active').trigger('click');
		});

		$('#keyboard_shortcuts_cont').click(function(event){
	    	// console.log(' # keyboard_shortcuts_cont click #');
	    	if ( $(event.target).parents('#close_keyboard_shortcuts_cont').length > 0 ) {
    			$('#keyboard_shortcuts_link').trigger('click');
    		} else {
    			if ( !$(event.target).is('#keyboard_shortcuts') ) {
		    		if ( $(event.target).parents('#keyboard_shortcuts').length <= 0 ) {
		    			$('#keyboard_shortcuts_link').trigger('click');
		    		}
				}
    		}
	    });
		/* *********************** */
		/* Gestione click e eventi */
		/* *********************** */
		/* ======= */
		/* GENERAL */
			$("#home_title").click(function(){
				window.location="index.html";
			});
			// SELECTORS
			/* Apertura option container dei selettori a tendina */
			$(".open_select").click(function(){
				$('.hovered').removeClass('hovered');
				// console.log(' # open_select click #');
				if ( !$(this).parents('.like_select').hasClass('not_active') ){
					if (!($(".option_container").is(':animated'))){
						if($('.option_container:visible').parents('.like_select').attr('id') !== $(this).parents('.like_select').attr('id')){
							$('.option_container.up:visible').animate({
								top: '-5px',
								height:"toggle"
							}, 400); 
							$('.option_container.down:visible').animate({height:"toggle"}, 400);   
						}
						if($(this).hasClass('open_up')){
							if ($(this).siblings('.option_container').is(':visible')) {
								$(this).siblings('.option_container').animate({
									top: '-5px',
									height:"toggle"
								}, 400);
							} else {
								var top = "-" + $(this).siblings('.option_container').attr('data-toggle-top') + "px";
								$(this).siblings('.option_container').animate({
									top: top,
									height:"toggle"
								}, 400);
							}
						} else {
							$(this).siblings('.option_container').animate({
								height:"toggle"
							}, 400, function(){
								var height = $(this).find('.option').height();
								var selected = $(this).find('.option.selected').index();    
								var scroll = (height*1.5)*selected;
								$(this).animate({
									scrollTop: scroll
								}, 400);
							});
	                    }
	                }
	            }
	        });

			// BUTTONS
			$('#left_menu .mainButtons').click(function(){
				if ( ! $(this).hasClass('inactive') ) {
					$(this).siblings().removeClass('active');
				}
			});
			$('#switchMag, #switchHS, #switchITL').click(function(){
				// console.log(' # switch mag/hs/itl click #');
				var msDescSwitcher = $('#switch_msDesc');
				if ( msDescSwitcher.length > 0 && msDescSwitcher.hasClass('active') ) {
					msDescSwitcher.trigger('click');
				}
				var thumbsSwitcher = $('#thumb_elem');
				if ( thumbsSwitcher.length > 0 && thumbsSwitcher.hasClass('active') ) {
					thumbsSwitcher.removeClass('active');
				}
			});

			// Collapse menus
			$('#header_collapse').click(function(){
				// console.log(' # header_collapse click #');
				var noMenu_height, withMenu_height;
				var topMenu_height, bottomMenu_height;
				var bottom_box_frame, bottom_box_visible;
				var action;
				action = $(this).attr('data-action');
				/* COLLAPSE MENUS*/
				if (action == 'collapse') {
					$('.main_frame').each(function(){
						noMenu_height = $(this).innerHeight();
						$(this).attr('data-menu-state', 'collapsed');
						collapseMenu($(this), noMenu_height);
					});	
					// Modifico colore dell'icona .go-full-right che altrimenti non si vedrebbe
					$('.go-full-right').addClass('onWhite');
					// Se è aperto il text di sinistra modifico colore dell'icona go-full-left che altrimenti non si vedrebbe
					if ( $('#text_cont-add').is(':visible') || $('#msDesc_cont').is(':visible') ) {
						$('.go-full-left').toggleClass('onWhite');
					}
					setMagHeight(); //Add for Mag
					$(this).attr('data-action', 'expand');
				} 
				/* EXPAND MENUS*/
				else if ( action == 'expand') {
					$('.main_frame').each(function(){
						noMenu_height = $(this).innerHeight();
						$(this).attr('data-menu-state', 'expanded');
						expandMenu($(this), noMenu_height);
					});	
					$('.go-full-right').removeClass('onWhite');
					if ( $('#text_cont-add').is(':visible') || $('#msDesc_cont').is(':visible') ){
						$('.go-full-left').removeClass('onWhite');
					}
					setMagHeight(); //Add for Mag
					$(this).attr('data-action', 'collapse');
				}

				// Modifico lo stile e la posizione dell'icona
				if($(this).hasClass('fa-caret-up')){
					if($(".closeFullScreen:visible").length>0){
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
					if($(".closeFullScreen:visible").length>0){
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
				
				$('.like_select:visible').each(function(){
						if (!$(this).hasClass('widthChanged')) {
							$(this).addClass('widthChanged');
							$(this).find('.option_container').removeAttr('style');
							updateSelectLength($(this));
						}
				});
			});
			
			// goFullScreenLeft
			$("#goFullScreenLeft").click(function(){
				goFullScreenLeft();
			});
			// goFullScreenRight
			$("#goFullScreenRight").click(function(){
				goFullScreenRight();
			});

			// closeFullScreenLeft
			$("#closeFullScreenLeft").click(function(){
				closeFullScreenLeft();
			});
			
			// closeFullScreenRight
			$("#closeFullScreenRight").click(function(){
				closeFullScreenRight();
			});
			
			$('.font-size-controller').click(function(){
		        var action = $(this).attr('data-action');
		        $(this).parents("div[id*='_frame']").find('.can-change-font-size').each(function(){
		            var currentFontSize, currentFontSizeNum, newFontSize;
		            currentFontSize = $(this).css('font-size');
		            currentFontSizeNum = parseFloat(currentFontSize, 10);
		            if ( action == 'increase' ) {
		                newFontSize = currentFontSizeNum * 1.1; 
		            } else {
		                newFontSize = currentFontSizeNum * 0.9;
		            }   
		            $(this).css({
		                'font-size': newFontSize,
		                'line-height': (newFontSize+10)+'px'
		            });
		            $(this).attr('data-font-size', newFontSize);
		        });
		    });

		    $('#decrease_font_size').click(function(){
		        var currentFontSize, currentFontSizeNum, newFontSize;
		        currentFontSize = $('#text_frame').css('font-size');
		        currentFontSizeNum = parseFloat(currentFontSize, 10);
		        
		        $('#text_frame').css({
		            'font-size': newFontSize,
		            'line-height': (newFontSize+10)+'px'
		        });
		    });
		/* //= GENERAL */
		/* =========== */
		
		/* ============ */
		/* FRONT MATTER */
			// APRI/CHIUDI BIBLIOGRAFIA GENERALE
			$('#biblio_link').click(function(){
		    	$(this).toggleClass('active');
		    	// console.log(' # biblio_link click #');
		        if($('#generalBiblio_cont').is(':visible')){
		        	$('#generalBiblio_content').scrollTop(0);
		            $('#generalBiblio_cont').hide('fade', 'slow', function(){
		            });
		        } else {
		        	$('#generalBiblio_content').scrollTop(0);
		            $('#generalBiblio_cont').show('fade', 'slow', function(){
		            	if ( $('.bibl.highlight').length > 0 ) {
		            		$('#generalBiblio_content').scrollTop($('.bibl.highlight:first').position().top-100);
			            	var hideHilights = setTimeout(function(){
								            		hideHilights();
								            	}, 1500);
			            	function hideHilights(){
			            		$('.bibl.highlight').removeClass('highlight');
			            		clearTimeout(hideHilights);
			            	}
		            	}
		            });
		        }
		        $('#settings_link.active').trigger('click');
		    });

		    $('#generalBiblio_cont').click(function(event){
		    	// console.log(' # generalBiblio_cont click #');
		    	if ( $(event.target).parents('#close_generalBiblio_cont').length > 0 ) {
	    			$('#biblio_link').trigger('click');
	    		} else {
	    			if ( !$(event.target).is('#generalBiblio') ) {
			    		if ( $(event.target).parents('#generalBiblio').length <= 0 ) {
			    			$('#biblio_link').trigger('click');
			    		}
					}
	    		}
		    });
			// APRI/CHIUDI REGESTO 
		    $('.toggleReg').click(function(event) {
		    	// console.log(' # toggleReg click #');
		        var regesto_cont;
		        $(this)
		            .toggleClass('active')
		            .find('.fa')
		                .toggleClass('fa-toggle-on')
		                .toggleClass('fa-toggle-off');
		        if ( $(this).attr('id') == "switchReg-add" ) {
		            regesto_cont = "#regesto_cont-add";
		        } else {
		            regesto_cont = "#regesto_cont";
		        }
		        toggleReg(regesto_cont);

		    });

		    // APRI/CHIUDI FRONT
		    $('.toggleFront').click(function(event) {
		    	// console.log(' # toggleFront click #');
		        var front_cont;
		        $(this)
		            .toggleClass('active');
		        if ( $(this).attr('id') == "switchFront-add" ) {
		            front_cont = "#front_cont-add";
		        } else {
		            front_cont = "#front_cont";
		        }
		        toggleFront(front_cont);
		    });
		/* //= FRONT MATTER */
		/* ================ */

		/* ====== */
		/* SEARCH */
		
			// Open Keyboard
			if ( $('.searchKeyboardButton').length > 0 ) {
				$('.searchKeyboardButton').click(function(){
					if ( !$(this).hasClass('inactive') && $('.keyboardSearch').length > 0) {
						var numKeys, newKeyboardHeight, newKeyboardWidth;
						var search_cont, keyboard;
						var keyHeight, keyWidth;

						search_cont = $(this).parents('.searchContainer:first');
						keyboard = search_cont.find('.keyboardSearch');
						numKeys = $(keyboard).find('.key').length;
						keyHeight = $(keyboard).find('.key').outerHeight();
						keyWidth = $(keyboard).find('.key').outerWidth();
						if ( numKeys % 9 == 0 ) {
							newKeyboardHeight = (numKeys/9)*keyHeight+1;
						} else {
							newKeyboardHeight = (Math.floor(numKeys/9)*keyHeight)+1+keyHeight;
						}
						
						newKeyboardWidth = 9*keyWidth+1;
						
						if ( !search_cont.hasClass('collapsed') ) {
							keyboard.addClass('openDown');
							var offsetTop = $(this).parents('.bottomBoxHeader').outerHeight()+2;
							keyboard.css({
								'top': offsetTop,
								'height': newKeyboardHeight,
								'width': newKeyboardWidth
							});
						} else {
							keyboard.removeClass('openDown');
							if ( numKeys % 9 == 0 ) {
								offsetTop = ((numKeys/9)*keyHeight)+2;
							} else {
								offsetTop = (Math.floor(numKeys/9)*keyHeight)+2+keyHeight;
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
			/* APRI/CHIUDI RICERCA */
		    $('.searchButton').click(function(event) {
		    	// console.log(' # searchButton click #');
		        var boxSuffix = $(this).attr('data-boxsuffix') || '',
		        	searchCont = $('#search_cont'+boxSuffix),
		        	listSelect = $('#span_list_select'+boxSuffix),
		        	switchRegBtn = $('#switchReg'+boxSuffix);
		        var speed;
		        if(searchCont.hasClass('collapsed')){
		           speed = 'fast';
		        } else {
		           speed = 'slow';
		        }

		        // BOX RICERCA APERTO
		        if (searchCont.is(":visible")) {
		            closeSearchBox(speed, boxSuffix);
		            updateTextContHeight();

		            if ( listSelect.length > 0 ) {
		                // Se ho il regesto...
		                if ( (switchRegBtn.length > 0 ) && 
		                     (!switchRegBtn.hasClass('disabled')) ) {
		                    // ...e il regesto non è aperto
		                    if ( !switchRegBtn.hasClass('active') ) {
		                        // attivo il selettore dei filtri
		                        listSelect.removeClass('not_active').css('opacity', '1'); 
		                    }
		                } else {
		                    listSelect.removeClass('not_active').css('opacity', '1');
		                }
		            }
		        } 
		        // BOX RICERCA CHIUSO
		        else {
		        	var listsBtn = $('#list_link'+boxSuffix),
		        		switchFrontBtn = $('#switchFront'+boxSuffix);
		            if ( listsBtn.length > 0 && listsBtn.hasClass('active') ) {
		                closeListsBox('fast');
		            }
		            // Se ho il regesto, questo non è disabilitato e c'è un solo livello di edizione...
		            if ( (switchRegBtn.length > 0) && 
		                 (!switchRegBtn.hasClass('disabled')) &&
		                 ($('#span_ee_select .option').length == 1) ) {
		                // ...e questo è attivo e siamo nella modalità testo immagine
		                if ( switchRegBtn.hasClass('active') && $('#txtimg_link').hasClass('current_mode') ) {
		                    // chiudo il regesto
		                    $('#regesto_cont'+boxSuffix).hide();
		                    switchRegBtn.removeClass('active');
		                }
		            }

		            // Se ho il front
		            if ( (switchFrontBtn.length > 0) && 
		                 (!switchFrontBtn.hasClass('disabled')) ) {
		                // chiudo il front
		                $('#front_cont'+boxSuffix).hide();
		                switchFrontBtn.removeClass('active');
		            }
		            openSearchBox(speed, boxSuffix);

		            if ( !searchCont.hasClass('collapsed') ) {
		                if ( listSelect.length > 0 ) {
		                    listSelect.addClass('not_active').css('opacity', '0.5');
		                }
		            }
		        }
		    });

	    	$('.toggleSearchButton').click(function() {
	    		// console.log(' # toggleSearchButton click #');
		        // var boxSuffix = $(this).attr('data-boxsuffix');
		        toggleSearchCont(this);
		    });

		    $('.searchInput').keyup(function(event) {
		    	// console.log(' # search_input keyup #');
		        if ( $(this).val() != '' ) {
		            $(this).addClass('clearable');
		        } else {
		            $(this).removeClass('clearable');
		        }
		    });

		    $('.clear_input').click(function(event) {
		    	// console.log(' # clear_input click #');
		        $(this).prev().val('').removeClass('clearable');
		        var searchCont = $(this).parents('.searchContainer');
		        searchCont
		        	.find('.tipue_search_results_count, .searchResultsContent, .bottomBoxFooter div').empty(); 
		        searchCont
		        	.find('.searchQuery')
		        		.empty()
		        		.append('<span lang="'+window.lang.currentLang+'">'+window.lang.convert('ENTER_YOUR_QUERY_INTO_THE_SEARCH_BOX_ABOVE', window.lang.currentLang)+'</span>');
				$(this).parents("div[id*='frame']").find('.highlight').removeClass('highlight');
		    });

		    $('.searchInput').keyup(function (e) {
		    	// console.log(' # tipue_search_input keyup #');
		        var boxSuffix = $(this).attr('data-boxsuffix');
		        if ( $("#search_cont"+boxSuffix).hasClass('bottomBoxOpened') ) {
			        $('#text_elem'+boxSuffix).unhighlight();
			        var input_text_value = $(this).val();
			        var word_array = input_text_value.split(' ');
			        for (var i = 0; i<word_array.length; i++){
			            $('#text_elem'+boxSuffix).highlight(word_array[i]);
			        }
			        //$('ul.AnnSubmenu').highlight($(this).val());
			        // $("span.highlight").css({ backgroundColor: "#FFFF88" });	
		        }
		    });

		    if ( $('#search_cont').length > 0 ) {
		    	setSearchClosedPosition();
		    }
		/* //= SEARCH */
		/* ========== */

		/* ========== */
		/* NAVIGATION */

			// Go to previous page;
			$(".main_left_arrow").click(function(){
				// console.log(' # main_left_arrow click #');
		        arrow("left");
		    });
		    // Go to next page;
		    $(".main_right_arrow").click(function(){
		    	// console.log(' # main_right_arrow click #');
		        arrow("right");
		    });

		    // Go to text
		    if ( $('#inside_right_arrow').length > 0 || $('#inside_right_arrow').length > 0 ) {
		        $("#inside_left_arrow, #inside_left_arrow-add").click(function(){
		            navDoc("left");
		        });
		        $("#inside_right_arrow, #inside_right_arrow-add").click(function(){
		            navDoc("right");
		        });
		    }


			// APRI/CHIUDI THUMBNAILS
		    $(".thumb_link").click(function(){
		    	// console.log(' # thumb_link click #');
		        if ( $('#switch_msDesc').length > 0 && $('#switch_msDesc').hasClass('active') ) {
		            $('#switch_msDesc').trigger('click');
		        }
		        if (magnifierON == false){  //modalità zoom attivo JK
		            if($("#image_loading").css('display')!=="none"){$("#image_loading").hide()}
		            if($("#image_elem").css('display') === "none"){
		                $("#image_elem").show();
		                $("#image_fade").show();
		                if(!$('#left_header').hasClass('menuClosed')){
		                    $("#image_tool").show();
		                }
		                $("#thumb_cont").hide();
		                // $(this).removeClass('active');
		            } else{
		                $("#image_elem").hide();
		                $("#image_fade").hide();
		                $("#image_tool").hide();
		                $("#thumb_cont").show();
		                // $(this).addClass('active');
		            }
		        } else {                  //modalità magnifier attivo JK
		            if($("#mag_image_elem").css('display') === "none"){
		                $("#mag_image_elem").show();
		                $("#image_tool").show();
		                $("#thumb_cont").hide();
		                // $(this).removeClass('active');
		            } else{
		                $("#mag_image_elem").hide();
		                $("#image_tool").hide();
		                $("#thumb_cont").show();
		                // $(this).addClass('active');
		            }
		        }
		        $(this).toggleClass('active');
		    });

		/* //= NAVIGATION */
		/* ============== */

		/* ===== */
		/* LISTS */
			/* APRI/CHIUDI LISTE */
		    $('#list_link').click(function(event) {
		    	// console.log(' # list_link click #');
		        // if ( $('#search_cont').is(':visible') ) {
		        //  $('#search_link').trigger('click');
		        // }

		        var speed;
		        if($('#lists_cont').hasClass('collapsed')){
		            speed = 'fast';
		        } else {
		            speed = 'slow';
		        }
		        if ($('#lists_cont').is(":visible")) {
		            closeListsBox(speed);
		            updateTextContHeight();

		            if ( $('#span_list_select').length > 0 ) {
		                if ( $('#switchReg').length > 0 ) {
		                    if ( !$('#switchReg').hasClass('active') ) {
		                        $('#span_list_select').removeClass('not_active').css('opacity', '1');   
		                    }
		                } else {
		                    $('#span_list_select').removeClass('not_active').css('opacity', '1');
		                }
		            }

		        } else {
		            // chiudi il div della ricerca
		            if ( $('#search_link').length > 0 && $('#search_link').hasClass('active') ) {
		                var boxSuffix = $('#search_link.active').attr('data-boxsuffix') || '';
		                closeSearchBox('fast', boxSuffix);
		            }
		            openListsBox(speed);

		            if ( !$('#lists_cont').hasClass('collapsed') ) {
		                if ( $('#span_list_select').length > 0 ) {
		                    $('#span_list_select').addClass('not_active').css('opacity', '0.5');
		                }
		            }
		        }

		    });
		/* //= LISTS */
		/* ========= */

		/* ========== */
		/* VIEW MODES */
			
			// TOGGLE TXT IMG MODE VIEW
		    $("#txtimg_link").click(function(){
		    	// console.log(' # txtimg_link click #');
		        if(!$(this).hasClass("current_mode")){
		            openTxtImgMode();
		        }
		    });

		    // TOGGLE TXT TXT MODE VIEW
		    $("#txttxt_link").click(function(){
		    	// console.log(' # txttxt_link click #');
		        if(!$(this).hasClass("current_mode")){
		        	openTxtTxtMode();
		        }
		    });
		    
		    // TOGGLE BOOKREADER MODE VIEW
		    $("#imgd_link").click(function(){
		    	// console.log(' # imgd_link click #');
		        if(!$(this).hasClass("current_mode")){
		            openBookreaderMode();
		        }
		    });
		    
		    // TOGGLE TXT SINGLE MODE VIEW
		    $("#txt_single").click(function(){
		    	// console.log(' # txt_single click #');
		        if(!$(this).hasClass("current_mode")){
		           openTxtSingleMode();
		        }
		    });
		/* //= VIEW MODES */
		/* ============== */

		/* ****************** */
		/* Integrazione by LS */
		/* ****************** */
		$('#settings_link').click(function(){
			// console.log(' # settings_link click #');
	        $(this).toggleClass('active');
	        if($('#settings_cont').is(':visible')){
	            $('#settings_cont').animate({
					height:"toggle"
				}, 400); 
	        } else {
	            $('#settings_cont').animate({
					height:"toggle"
				}, 400); 
	        }
	    });
	    $('.flag').click(function(){
	    	// console.log(' # flag click #');
			if ( !$(this).hasClass('active') ) {
				var lang = $(this).attr('data-value');
				$('.flag.active').removeClass('active');
				window.lang.change(lang);
				$(this).addClass('active');
				$('#settings_link').trigger('click');
			}
		});
		window.lang.run();
		if ( window.lang.currentLang === 'undefined' ) {
			window.lang.change('en');
		} else {
			$('.flag.active').removeClass('active');
			$(".flag[data-value='"+window.lang.currentLang+"']").addClass('active');
		}
		resizeButtonsAndSelects();

	    /* *********************** */
		/* /END Integrazione by LS */
		/* *********************** */

		/* ***************************** */
		/* / END Gestione click e eventi */
		/* ***************************** */
	});

	/* ******** */
	/* Funzioni */
	/* ******** */
	//---
	
	/* HANDLING SEARCH ELEMENTS */
	function InitializeSearch(){
		// console.log(' # InitializeSearch #');
		if ( $('#search_cont').is(':visible') ) {
	        if ( $('#search_cont').hasClass('collapsed') ) {
	            $('#tipue_search_input').trigger('keyup');
	        }
	    }
	    if ( $('#search_cont-add').is(':visible') ) {
	        $('#tipue_search_input-add').trigger('keyup');

	    }
	}

	function toggleSearchCont(toggler){
		// console.log(' # toggleSearchCont #');
		var search_cont = $(toggler).parents('.searchContainer'),
	    	search_input = search_cont.find('.searchInput'),
	    	search_query = search_cont.find('.searchQuery'),
	    	search_startButton = search_cont.find('.searchStart'),
	    	search_keyboardButton = search_cont.find('.searchKeyboardButton');
	    	search_cont_results = search_cont.find('.searchResultsContent');
	    var boxSuffix = $(toggler).attr('data-boxsuffix'),
	    	listSelector = $('#span_list_select'+boxSuffix);

	    if ( search_cont.hasClass('collapsed') ) {
	        search_cont.removeClass('collapsed')
	        if ( search_input.val() != '' && 
	             search_query.attr('data-value') != search_input.val() &&
	             $.trim(search_cont_results.text()) == '') {
	                search_startButton.trigger('click');
	        } 
	        // else {
	            var top, mainContainerHeight;
	            top = 0;
	            mainContainerHeight =  search_cont.parents("div[id*='main_']").outerHeight();
	            if(search_cont.parents("div[id*='main_']").find('.top-menu').hasClass('menuClosed')){
	                top = -search_cont.parents("div[id*='main_']").find('.top-menu').outerHeight();
	                search_cont.css('height', mainContainerHeight+'px');

	            }
	            search_cont.animate({
	                   top: top+'px'
	            }, 400);
	            $(toggler).find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');
	            
	            if ( listSelector.length > 0 && !listSelector.hasClass('not_active')) {
	                listSelector.addClass('not_active').css('opacity', '0.5');
	            }
	        // }
	    } else {
	        scrollDownSearchContainer(400, search_cont);
	        $(toggler).find('.fa').removeClass('fa-angle-double-down').addClass('fa-angle-double-up');

	        if ( listSelector.length > 0 && listSelector.hasClass('not_active')) {
	            var switchRegBtn = $('#switchReg');
	            if ( switchRegBtn.length > 0 && !switchRegBtn.hasClass('disabled') ) {
	                if ( !switchRegBtn.hasClass('active') ) {
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

	function scrollDownSearchContainer(speed, searchCont){
	    // console.log(' # scrollDownSearchContainer #');
	    var newTop;
	    var mainContainerHeight, bottomBoxHeaderHeight;

	    mainContainerHeight = searchCont.parents("div[id*='main_']").outerHeight();
	    bottomBoxHeaderHeight = searchCont.find('.bottomBoxHeader').outerHeight();  

	    if($('#right_header').hasClass('menuClosed')){
	        newTop = mainContainerHeight - (bottomBoxHeaderHeight*2) - 16;
	    } else {
	        var bottomMenuHeight;
	        bottomMenuHeight = $('#text_tool').outerHeight();
	        newTop = mainContainerHeight - (bottomMenuHeight*2) - bottomBoxHeaderHeight - 6;
	    }
	    searchCont
	        .addClass('collapsed')
	        .animate({
	           top: newTop+'px'
	    }, speed);
	}

	function setSearchClosedPosition(boxSuffix){
		// console.log(' # setSearchClosedPosition #');
	    var newTop;
	    var mainContainerHeight, bottomBoxHeaderHeight;
	    if (boxSuffix == undefined) {boxSuffix = '';}
	    mainContainerHeight = $('#main_right_frame').height();
	    if ( $('#main_right_frame').hasClass('full') ){
	        bottomBoxHeaderHeight = $('#search_header').height() + 4;   
	    } else {
	        bottomBoxHeaderHeight = $('#search_header').height() + 4;   
	    }
	    
	    if($('#right_header').hasClass('menuClosed')){
	        newTop = mainContainerHeight - (bottomBoxHeaderHeight*2) - 8;
	    } else {
	        var bottomMenuHeight;
	        bottomMenuHeight = $('#text_tool').height();
	        newTop = mainContainerHeight - (bottomMenuHeight*2) - bottomBoxHeaderHeight;
	    }
	    
	    $('#search_cont'+boxSuffix)
	        .addClass('collapsed')
	        .css({
	           top: newTop+'px'
	        });

	    $('#toggle_search_cont'+boxSuffix+' .fa')
	        .removeClass('fa-angle-double-down')
	        .addClass('fa-angle-double-up');
	}
	function closeSearchBox(speed, boxSuffix) {
		// console.log(' # closeSearchBox #');
	    $('#search_cont'+boxSuffix).removeClass('bottomBoxOpened');
	    $('#search_link'+boxSuffix).removeClass('active');
	    var closeDiv = function(){
	        return $('#search_cont'+boxSuffix).hide('slide',  {direction: 'down'}, 'linear', speed);
	    };
	    
	    $.when( closeDiv() ).done(function() {
	        setSearchClosedPosition(boxSuffix); 
	    });
	    updateTextContHeight();
	    
	    if ( $('#keyboard'+boxSuffix).is(':visible') ) {
	        $('#keyboard_link'+boxSuffix).trigger('click');
	    }

	    $('#text_cont'+boxSuffix+' .highlight').removeClass('highlight');
	}

	function openSearchBox(speed, boxSuffix) {
		// console.log(' # openSearchBox #');
		var searchCont = $('#search_cont'+boxSuffix);
	    searchCont.addClass('bottomBoxOpened');
	    $('#search_link'+boxSuffix).addClass('active');

	    var openDivSearch = function() {
	        var newSearchContTop = searchCont.parents("div[id*='main_']").outerHeight() - ($('#text_tool'+boxSuffix).outerHeight()*2) - $('#search_header'+boxSuffix).outerHeight() - 6;
	        searchCont.css({
	            'top': newSearchContTop+'px'
	        });
	        
	        return searchCont.show();
	    };
	    
	    $.when( openDivSearch() ).done(function() {
	        updateTextContHeight();
	    });
	    if ( searchCont.hasClass('collapsed') ) {
	        var switchRegBtn = $('#switchReg'+boxSuffix);
	        if ( switchRegBtn.length > 0 && !switchRegBtn.hasClass('disabled') ) {
	            if ( switchRegBtn.hasClass('active') && $('#txtimg_link').hasClass('current_mode') ) {
	                switchRegBtn.trigger('click');
	            }
	        }
	    }
    	var searchInput = $('#tipue_search_input'+boxSuffix);
	    if ( searchInput.val() != '' ) {
	        searchInput.trigger('keyup');
	    }
	    searchInput.focus();
	}
	/* ==/ HANDLING SEARCH ELEMENTS END */

	/* HANDLING LISTS */
	function updateEntitiesFiltered(frame) {
		frame
        	.find('.like_select.filter')
        		.find('.option.selected')
        			.removeClass('selected')
        			.trigger('click');
	}

	function toggleListCont(toggler){
		// console.log(' # toggleListCont #');
	    var boxSuffix = $(toggler).attr('data-boxsuffix'),
	    	listsCont = $('#lists_cont'),
	    	listsSelector = $('#span_list_select');

	    if ( listsCont.hasClass('collapsed') ) {
	        var top, mainContainerHeight;
	        top = 0;
	        listsContParent = listsCont.parents("div[id*='main_']");
	        mainContainerHeight = listsContParent.outerHeight();
	        if(listsContParent.find('.top-menu').hasClass('menuClosed')){
	            top = -listsContParent.find('.top-menu').outerHeight();
	            listsCont.css('height', mainContainerHeight+'px');
	        }
	        listsCont.animate({
	               top: top+'px'
	        }, 400);
	        $(toggler).find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');
	        listsCont.removeClass('collapsed');

	        var listsElementsOpened = $('.list:visible').find('.list_element_opened');
	        if ( listsElementsOpened.length > 0 ) {
	            listsElementsOpened.find('.occurences').show();
	        }
	        if ( listsSelector.length > 0 && !listsSelector.hasClass('not_active')) {
	            listsSelector.addClass('not_active').css('opacity', '0.5');
	        }
	    } else {
	        scrollDownListContainer(400);
	        $(toggler).find('.fa').removeClass('fa-angle-double-down').addClass('fa-angle-double-up');

	        if ( listsSelector.length > 0 && listsSelector.hasClass('not_active')) {
	            var switchRegBtn = $('#switchReg'+boxSuffix);
	            if ( switchRegBtn.length > 0 && !switchRegBtn.hasClass('disabled') ) {
	                if ( !switchRegBtn.hasClass('active') ) {
	                    listsSelector.removeClass('not_active').css('opacity', '1');   
	                }
	            } else {
	                listsSelector.removeClass('not_active').css('opacity', '1');
	            }
	        }
	    }
	}

	function closeListsBox(speed){
		// console.log(' # closeListsBox #');
	    $('#lists_cont')
	    	.removeClass('bottomBoxOpened')
	    	.hide('slide',  {direction: 'down'}, 'linear', speed);
	    $('#list_link').removeClass('active');
	    
	    updateTextContHeight();

	    $('#text_cont')
	        .find('.selected_from_list')
	            .removeClass('selected_from_list');
	}

	function openListsBox(speed){
		// console.log(' # openListsBox #');
	    var listsCont = $('#lists_cont');
	    listsCont.addClass('bottomBoxOpened');
	    $('#list_link').addClass('active');
	    var openDivLists = function() {
	        // var newSearchContTop = listsCont.parents("div[id*='main_']").outerHeight() - ($('#text_tool').outerHeight()*2) - $('#search_header').outerHeight() - 6;
	        // listsCont.css({
	        //  'top': newSearchContTop+'px'
	        // });

	        if(listsCont.hasClass('collapsed')){
	            return listsCont.show();
	        } else {
	            return listsCont.show('slide',  {direction: 'down'}, 'linear', speed);
	        }
	        
	    };
	    $.when( openDivLists() ).done(function() {
	        updateTextContHeight();
	    });
	}

	function filterListElements(filter){
		// console.log(' # filterListElements #');
	    var filterType, filterValue;
	    filterType = $(filter).attr('data-filter-type');
	    filterValue = $(filter).attr('data-value');
	    $('.filter_active').removeClass('filter_active');
	    $(filter).addClass('filter_active');

	    $('.occurences:visible').hide();
	    $('.list_element_opened').removeClass('list_element_opened');

	    $('.list_element').hide();
	    var listsElementsFiltered = $(".list_element[data-order-list='"+filterValue.toLowerCase()+"'], .list_element[data-order-list='"+filterValue.toUpperCase()+"']");
	    listsElementsFiltered.show();
	    if (filterValue.toLowerCase() == 'c') {
	    	$(".list_element[data-order-list='Ç']").show();
	    }
	    
	    if ( $('.ul_list:visible').find(listsElementsFiltered).length == 0) {
	        if ( $( '.no_elements' ).length > 0) {
	            $( '.no_elements' ).detach().appendTo('.ul_list:visible').show();
	        } else {
	            $('<li />')
	                .addClass('list_element')
	                .addClass('no_elements')
	                .append("<span lang='"+window.lang.currentLang+"'>"+window.lang.convert('NO_ELEMENTS', window.lang.currentLang)+"</span>")
	                .appendTo('.ul_list:visible');
	        }
	    }

	    $("div[id*='list_']").scrollTop(0);

	    window.lang.run();
	}

	function openList(elem, listName){
		// console.log(' # openList #');
	    if ( $('#lists_cont').hasClass('collapsed') ) {
	        $('#toggle_list_cont').trigger('click');
	    }
	    $('.labelList.active').removeClass('active');
	    $(elem).addClass('active');
	    $('.list.list_opened').hide();
	    $('#list_'+listName).addClass('list_opened').show();
	}

	function showListElementOccurrences(elem, listName){
		// console.log(' # showListElementOccurrences #');
	    if($(elem).hasClass('list_element_opened')){
	        // $(elem).find('.small-note, .occurences').toggle();
			$(elem).find('.fa').removeClass('fa-angle-down').addClass('fa-angle-right');
			$(elem).removeClass('list_element_opened');
	    } 
	    else {
	        if($(elem).find('.occurences').length<=0){
	            prepareOccurrencesList(elem, listName);
	        }
	        // $(elem).parents('.list').find('.occurences:visible').hide();
	        $(elem).parents('.list').find('.small-note:visible').hide();
	        $(elem).parents('.list')
	        	.find('.list_element_opened')
	        		.removeClass('list_element_opened')
	        		.find('.fa-angle-down')
	        			.removeClass('fa-angle-down')
	        			.addClass('fa-angle-right');
	        $(elem)
	            .addClass('list_element_opened')
	            .find('.fa')
	        		.removeClass('fa-angle-right')
	        		.addClass('fa-angle-down');
	    }
	}

	function prepareOccurrencesList(elem, listName){
		// console.log(' # prepareOccurrencesList #');
	    var occ_ref;
	    var list_ref, list_occ;
	    list_ref = $(elem).attr('id');
	    list_occ = $("<div/>").addClass('occurences');
	    occ_ref = $('#'+listName)
	                    .find('#occorrenze')
	                        .find("span[data-ref='"+list_ref+"']");
	    if(occ_ref.length > 0){
	        occ_ref.each(function(){
	            var pb, doc, pb_n;
	            var doc_lab;
	            pb = $(this).attr('data-pb');
	            pb_n = $(this).attr('data-pb-n');
	            doc = $(this).attr('data-doc');
	            doc_lab = $("#span_tt_select .option_container .option[data-value='"+doc+"']").attr('title');
	            var occElem = $(list_occ).find("span[data-pb='"+pb+"'][data-doc='"+doc+"']");
	            if ( occElem.length > 0 ) {
	                var occ;
	                occ = occElem.attr('data-occ')*1;
	                occ++;
	                occElem
	                    .attr('data-occ', occ)
	                    .attr('title', occ+" "+window.lang.convert('OCCURRENCES', window.lang.currentLang));
	                $(this).remove();
	            } else {
	            	$(this)
	                    .attr('data-occ', '1')
	                    .attr('title', "1 "+window.lang.convert('OCCURRENCE', window.lang.currentLang))
	                    .text(window.lang.convert('FOL', window.lang.currentLang)+" "+pb_n+" - "+window.lang.convert('DOC', window.lang.currentLang)+" "+doc_lab)
	                    .click(function(){
	                        goToOccurrencePage(this, pb, doc);
	                    })
	                    .detach()
	                    .appendTo(list_occ);
	            }
	        });
	    } else {
	        $(list_occ).append("<span class='no_occ' lang='"+window.lang.currentLang+"'>"+window.lang.convert('NO_MATCHES_FOUND', window.lang.currentLang)+"</span>");
	    }
	    $(elem).append(list_occ);
	    window.lang.run();
	}

	function goToOccurrencePage(elem, pb, doc){
		// console.log(' # goToOccurrencePage #');
	    var current_pp, current_tt;
	    if ( $('.current_mode').attr('id') === 'txtimg_link' && $('#regesto_cont').is(':visible') ) {
	        hide_regesto('#regesto_cont', '#regesto');
	    }
	    current_pp = $('#span_pp_select .label_selected').attr('data-value');
	    current_tt = $('#span_tt_select .label_selected').attr('data-value');
	    // Se il riferimento punta ad una pagina diversa, aggiorno l'hash e carico la pagina di interesse
	    if (pb != current_pp) {
	        $('#text_cont').addClass('reachingOccurence');
	        updateHash(doc, pb, "");
	    } 
	    // Altrimenti...
	    else {
	        // Se il riferimento punta ad un documento presente sulla pagina corrente, ma diverso da quello attivo
	        // aggiorno il documento attivo
	        if (doc != current_tt) {
	            $("#text .doc[data-doc='"+doc+"']").trigger('click');
	        }
	        // Attiva occorrenza in lista
	        if ( $('.list').length > 0 && $('.list_element.list_element_opened').length > 0 ) {
	            $('.selected_from_list').removeClass('selected_from_list');
	            var ref;
	            ref = $('.list_element_opened').attr('id');
	            $("#text span[data-ref='"+ref+"']").addClass('selected_from_list');
	        }
	        // $('#text_cont').animate({
	        //     scrollTop: ($('.selected_from_list').position().top)
	        // }, 200);
			$('#text_cont').scrollTop($('.selected_from_list').position().top);
	    }
	    $('#toggle_list_cont').trigger('click');
	}

	function scrollDownListContainer(speed){
		// console.log(' # scrollDownListContainer #');
	    var newTop;
	    var mainContainerHeight, bottomBoxHeaderHeight;

	    mainContainerHeight = $('#lists_cont').parents("div[id*='main_']").outerHeight();
	    bottomBoxHeaderHeight = $('#search_header').outerHeight();  

	    if($('#right_header').hasClass('menuClosed')){
	        newTop = mainContainerHeight - (bottomBoxHeaderHeight*2) - 16;
	    } else {
	        var bottomMenuHeight;
	        bottomMenuHeight = $('#text_tool').outerHeight();
	        newTop = mainContainerHeight - (bottomMenuHeight*2) - bottomBoxHeaderHeight - 6;
	    }
	    $('#lists_cont')
	        .addClass('collapsed')
	        .animate({
	           top: newTop+'px'
	    }, speed);
	}

	function showItemInList(id_ref){
		// console.log(' # showItemInList #');
	    var speed;
	    var top, mainContainerHeight;
	    var list_filter_type, list_filter_pos;
	    var list, list_id;
	    
	    // Open the list where the element is
	    if ( $('#'+id_ref).length > 0 ) {
	    	var listsCont = $('#lists_cont');
	        list = $('#'+id_ref).parent().parent();
	        list_id = list.attr('id');
	        if ( !  list.hasClass('list_opened') ) {
	            $('.occurences:visible').hide();
	            $('.list_element_opened').removeClass('list_element_opened');
	            
	            $('.list_opened').hide();
	            $('.labelList.active').removeClass('active');
	            $("#header_"+list_id).addClass('active');
	            $('#list_'+list_id).addClass('list_opened').show();
	        }
	        // Open the letter of the element
	        list_filter_pos = $('#'+id_ref).attr('data-order-list');
	        $(".list_filter[data-value='"+list_filter_pos.toUpperCase()+"']").trigger('click');

	        if(listsCont.hasClass('collapsed')){
	            speed = 'fast';
	        } else {
	            speed = 'slow';
	        }
	        scrollDownListContainer(0);
	        listsCont.show(0);
	        
	        top = 0;
	        mainContainerHeight = $('#central_wrapper').height();
	        if($('#right_header').hasClass('menuClosed')){
	            top = -$('#right_header').height();
	            listsCont.css('height', mainContainerHeight+'px');
	        }       
	        listsCont.animate({
	               top: top+'px'
	        }, 200, function(){
	            $('#list_'+list_id).animate({
	                scrollTop: 0
	            }, function(){
	                $('#'+id_ref).find('.toggle_list_element').trigger('click');
	                $('#list_'+list_id).scrollTop($('#'+id_ref).position().top);   
	            });
	        });
	        $('#toggle_list_cont').find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');

	        $('#list_link').addClass('active');
	        //updateTextContHeight();
	        listsCont.removeClass('collapsed');
	    }
	}
	
	function InitializeLinkTextList(){
		// console.log(' # InitializeLinkTextList #');
	    $('span.tooltip span.entity_name.link_active').unbind('click').click(function() {
	        var id_ref, order_list;

	        $(this).parent('.tooltip').siblings('.trigger').trigger('click');
	        id_ref = $(this).attr('data-ref');

	        if ( $('#'+id_ref).length == 0 ) {
	            alert('There was an error in opening the entity reference. Please try later.');
	        } else {
	            showItemInList(id_ref); 
	        }
	    });
	}

	/* ==/ HANDLING LISTS END */

	/* HANDLING REGESTO */
	function show_regesto(regesto_container, regesto){
		// console.log(' # show_regesto #');
	    var height;
	    height = $('#central_wrapper').height();
	    
	    if ( ! $('#main_right_frame').hasClass('menuClosed') && !$('#main_left_frame').hasClass('menuClosed') ) {
	        height = height - ($('#main_right_frame').height() * 2);
	    }

	    if ( $('#lists_cont') && $('#list_header').is(':visible') ) {
	        height = height - $('#list_header').height() + 4;
	    }
	    
	    $(regesto_container)
	        .removeClass('hidden')
	        .animate({
	            'top': '0px',
	            'min-height': '436.1px',
	            'height': height+"px"
	        }, 400, function(){
	            $(regesto_container).removeAttr('style');
	            if ( $(regesto_cont).parents("div[id*='frame']").attr('id') == 'main_left_frame' && 
	                 $('#span_ee_select').find('.option') == 0 ) {
	                $(regesto_container).find('.showHide_regesto').hide();  
	            } else {
	                $(regesto_container).find('.showHide_regesto').removeAttr('style');
	            }
	        });
	    $(regesto).show();
	    $(regesto_container).scrollTop(0);
	    $(regesto_container).parents("div[id*='frame']")
	        .find('.like_select.filter').css('opacity', '.5').addClass('not_active');
	}
	
	function hide_regesto(regesto_cont, regesto){
		// console.log(' # hide_regesto #');
	    if ( $(this).attr('id') == "hide_regesto-add" ) {
	        if ( !$("#switchReg-add").hasClass('disabled') ) {
	            $("#switchReg-add")
	                .toggleClass('active')
	                .find('.fa')
	                    .toggleClass('fa-toggle-on')
	                    .toggleClass('fa-toggle-off');
	            toggleReg(regesto_cont);
	        }
	    } else {
	        if ( !$("#switchReg").hasClass('disabled') ) {
	            $("#switchReg")
	                .toggleClass('active')
	                .find('.fa')
	                    .toggleClass('fa-toggle-on')
	                    .toggleClass('fa-toggle-off');
	            toggleReg(regesto_cont);
	        }
	    }
	}

	function updateRegestoContent(current_doc){
		// console.log(' # updateRegestoContent #');
	    var id_regesto_cont, id_regesto;
	    id_regesto_cont = "#regesto_cont";
	    id_regesto = "#regesto";

	    if ($('#regesto_cont-add').length > 0 ) {
	        id_regesto_cont = "#regesto_cont-add";
	        id_regesto = "#regesto-add";
	    }

	    $(id_regesto_cont).load("data/output_data/prefatory_matter/regesto/regesto_doc_"+current_doc+".html #regesto", function(response, status, xhr){
	        if (status == "success") {
	            if ( $('#regesto').children().length>0 && $.trim($("#regesto").text())!=='' ) {
	                // $('<div />')
	                //  .attr('id', "hide_regesto")
	                //  .addClass('hide_regesto')
	                //  .append("<i class='fa fa-chevron-up'></i></div>")   
	                //  .click(function(){ hide_regesto(id_regesto_cont, id_regesto); })
	                //  .appendTo(id_regesto_cont); // solo nel box di destra

	                if ( ($('#span_ee_select .label_selected').attr('data-value') != 'diplomatic') &&
	                     (!$('#switchReg').hasClass('active')) ) {
	                    $("#main_right_frame").find('.like_select.filter')
	                        .css('opacity', "1")
	                        .removeClass('not_active');         
	                } else {
	                    $("#main_right_frame").find('.like_select.filter')
	                        .css('opacity', "0.5")
	                        .addClass('not_active'); 
	                }
	                if ( $("#span_ee_select").find('.option').length == 0 ) {
	                    // Se ho un solo livello di edizione, in modalità txt txt nel frame di sx avrò sicuramente il regesto,
	                    // quindi non ho bisogno del selettore con i filtri nel menu in basso a sx
	                    $("#main_left_frame").find('.like_select.filter')
	                        .css('opacity', "0")
	                        .addClass('not_active'); 
	                } else if ($("#span_ee_select").find('.option').length > 0) {
	                    // ...altrimenti
	                    if ( $('#span_ee_select-add .label_selected').attr('data-value') != 'regesto' ) {
	                        // Se nel frame ho il regesto visibile, il selettore dei filtri rimane opacizzato...
	                        $("#main_left_frame").find('.like_select.filter')
	                            .css('opacity', "0.5")
	                            .addClass('not_active');            
	                    } else {
	                        // altrimenti è funzionante e pienamente visibile
	                        $("#main_left_frame").find('.like_select.filter')
	                            .css('opacity', "1")
	                            .removeClass('not_active');             
	                    }
	                }
	                if ( $('#switchReg').hasClass('disabled') ) {
	                    $('#switchReg').removeClass('disabled').show();
	                    resizeButtonsAndSelects();
	                }
	            } else {
	                hide_regesto(id_regesto_cont, id_regesto);
	                $('#switchReg').addClass('disabled').hide();
	                resizeButtonsAndSelects();
	            }
	        } else { 
	            hide_regesto(id_regesto_cont, id_regesto);
	            $('#switchReg').addClass('disabled').hide();
	            resizeButtonsAndSelects();
	        } 
	    });
	}

    /* Apertura/chiusura regesto */
    function toggleReg(cont){
    	// console.log(' # toggleReg #');
	    if ($(cont).is(":visible")) {
	        $(cont).hide('drop',  {direction: 'up'}, 'linear', function(){
	            $(cont).removeClass('open');
	            var ee_val;
	            ee_val = $(cont).parents("div[id*='frame']").find('.main_ee_select .label_selected').attr('data-value');
	            if ( ee_val.toLowerCase() != 'diplomatic' ) {
	                $(cont)
	                    .parents("div[id*='frame']")
	                        .find('.like_select.filter')
	                            .css('opacity', "1")
	                            .removeClass('not_active'); 
	            }
	        });
	        
	    } else {
	        $(cont).show('drop',  {direction: 'up'}, 'linear', function(){
	            // Disattivare filtri liste nell'edizione diplomatica
	            $(cont)
	                .addClass('open')
	                .parents("div[id*='frame']")
	                    .find('.like_select.filter')
	                        .css('opacity', "0.5")
	                        .addClass('not_active');
	            
	        });
	    }
	}

	/* ==/ HANDLING REGESTO END */

	/* HANDLING FRONT */
	function show_front(front_container, front){
		// console.log(' # show_front #');
	    var height;
	    height = $('#central_wrapper').height();
	    
	    if ( ! $('#main_right_frame').hasClass('menuClosed') && !$('#main_left_frame').hasClass('menuClosed') ) {
	        height = height - ($('#main_right_frame').height() * 2);
	    }

	    if ( $('#lists_cont') && $('#list_header').is(':visible') ) {
	        height = height - $('#list_header').height() + 4;
	    }
	    
	    $(front_container)
	        .removeClass('hidden')
	        .animate({
	            'top': '0px',
	            'min-height': '436.1px',
	            'height': height+"px"
	        }, 400, function(){
	            $(front_container).addClass('open').removeAttr('style');
	            if ( $(front_cont).parents("div[id*='frame']").attr('id') == 'main_left_frame' && 
	                 $('#span_ee_select').find('.option') == 0 ) {
	                $(front_container).find('.showHide_front').hide();  
	            } else {
	                $(front_container).find('.showHide_front').removeAttr('style');
	            }
	        });
	    $(front).show();
	    $(front_container).scrollTop(0);
	    $(front_container).parents("div[id*='frame']")
	        .find('.like_select.filter').css('opacity', '.5').addClass('not_active');
	}
	
	function hide_front(front_cont, front){
		// console.log(' # hide_front #');
	    if ( front_cont == "#hide_front-add" ) {
	        if ( !$("#switchFront-add").hasClass('disabled') ) {
	            $("#switchFront-add")
	                .toggleClass('active');
	            toggleReg(front_cont);
	        }
	    } else {
	        if ( !$("#switchFront").hasClass('disabled') ) {
	            $("#switchFront")
	                .toggleClass('active');
	            toggleReg(front_cont);
	        }
	    }
	}

	function updateFrontContent(current_doc){
		// console.log(' # updateFrontContent #');
	    var id_front_cont, id_front;
	    id_front_cont = "#front_cont";
	    id_front = "#front";

	    if ($('#front_cont-add').length > 0 ) {
	        id_front_cont = "#front_cont-add";
	        id_front = "#front-add";
	    }

	    $(id_front_cont).load("data/output_data/prefatory_matter/front/front_doc_"+current_doc+".html #front", function(response, status, xhr){
	        if (status == "success") {
	            if ( $('#front_cont .front').children().length>0 && $.trim($("#front_cont .front").text())!=='' ){
	                // $('<div />')
	                //  .attr('id', "hide_front")
	                //  .addClass('hide_front')
	                //  .append("<i class='fa fa-chevron-up'></i></div>")   
	                //  .click(function(){ hide_front(id_front_cont, id_front); })
	                //  .appendTo(id_front_cont); // solo nel box di destra

	                if ( ($('#span_ee_select .label_selected').attr('data-value') != 'diplomatic') &&
	                     (!$('#switchFront').hasClass('active')) ) {
	                    $("#main_right_frame").find('.like_select.filter')
	                        .css('opacity', "1")
	                        .removeClass('not_active');         
	                } else {
	                    $("#main_right_frame").find('.like_select.filter')
	                        .css('opacity', "0.5")
	                        .addClass('not_active'); 
	                }
	                if ( $("#span_ee_select").find('.option').length == 0 ) {
	                    // Se ho un solo livello di edizione, in modalità txt txt nel frame di sx avrò sicuramente il front,
	                    // quindi non ho bisogno del selettore con i filtri nel menu in basso a sx
	                    $("#main_left_frame").find('.like_select.filter')
	                        .css('opacity', "0")
	                        .addClass('not_active'); 
	                } else if ($("#span_ee_select").find('.option').length > 0) {
	                    // ...altrimenti
	                    if ( $('#span_ee_select-add .label_selected').attr('data-value') != 'front' ) {
	                        // Se nel frame ho il front visibile, il selettore dei filtri rimane opacizzato...
	                        $("#main_left_frame").find('.like_select.filter')
	                            .css('opacity', "0.5")
	                            .addClass('not_active');            
	                    } else {
	                        // altrimenti è funzionante e pienamente visibile
	                        $("#main_left_frame").find('.like_select.filter')
	                            .css('opacity', "1")
	                            .removeClass('not_active');             
	                    }
	                }
	                if ( $('#switchFront').hasClass('disabled') ) {
	                    $('#switchFront').removeClass('disabled').show();
	                    $('#front_cont').show();
	                    resizeButtonsAndSelects();
	                }
	            } else { 
	                hide_front(id_front_cont, id_front);
	                $('#switchFront').addClass('disabled').hide();
	                $('#front_cont').hide();
	                resizeButtonsAndSelects();
	            }
	        } else { 
	            hide_front(id_front_cont, id_front);
	            $('#switchFront').addClass('disabled').hide();
	            $('#front_cont').hide();
	            resizeButtonsAndSelects();
	        } 
	        
	    });
	}

    /* Apertura/chiusura front */
    function toggleFront(front_cont){
    	// console.log(' # toggleFront #');
	    if ($(front_cont).is(":visible")) {
	        $(front_cont).hide('drop',  {direction: 'up'}, 'linear', function(){
	            var ee_val;
	            ee_val = $(front_cont).parents("div[id*='frame']").find('.main_ee_select .label_selected').attr('data-value');
	            if ( ee_val.toLowerCase() != 'diplomatic' ) {
	                $(front_cont)
	                    .parents("div[id*='frame']")
	                        .find('.like_select.filter')
	                            .css('opacity', "1")
	                            .removeClass('not_active'); 
	            }
	        });
	        
	    } else {
	        $(front_cont).show('drop',  {direction: 'up'}, 'linear', function(){
	            // Disattivare filtri liste nell'edizione diplomatica
	            $(front_cont)
	                .parents("div[id*='frame']")
	                    .find('.like_select.filter')
	                        .css('opacity', "0.5")
	                        .addClass('not_active');
	            
	        });
	    }
	}
	/* ==/ HANDLING FRONT END */
	
	/* HANDLING INTERFACE NAVIGATION */

	/* Inizializzazione collegamenti ref */
	function InitializeRefs(){
		// console.log(' # InitializeRefs #');
		$('.ref[data-target]').unbind('click').click(function(){
			// console.log(' # ref click #');
			var type = $(this).attr('data-type'),
				target = $(this).attr('data-target').replace('#', '');
			if ( type == 'doc' ) {
				var targetTToption = $('#span_tt_select').find(".option[data-value='"+target+"']");
				if (targetTToption.length == 0){
					alert(window.lang.convert('TEXT_NOT_AVAILABLE', window.lang.currentLang));
				} else {
					if ( $('#span_tt_select').find(".label_selected").attr("data-value") != target ) {
						targetTToption.trigger('click');
					}
				}
				$(this).parents('.bottomBoxOpened').find("[id*='toggle']").trigger('click');
			} else {
				var targetElem = $('#'+target);
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

	/* Inizializzazione Popup (note inline, dettagli elementi liste, ...) */
	function InitializePopup(){
		// console.log(' # InitializePopup #');
	    $('.popup').unbind('hover').hover(function(e){
	        if ( $('.doc').length<0 || $(this).parents('.doc').hasClass('current') ) {
	            e.stopPropagation();
	            $(this).addClass('over');
	            if($(this).parents('.popup').length > 0){
	              $(this).parents('.popup').removeClass('over');
	            }
	        }
	    }, function(){
	        if ( $('.doc').length<0 || $(this).parents('.doc').hasClass('current') ) {
	            if($(this).parents('.popup').length > 0){
	                $(this).parents('.popup').addClass('over');
	            }
	            $(this).removeClass('over');
	         }
	    });
	    
	    $('.tooltip').unbind('click').click(function(e){
	        if($(this).hasClass('opened')) {
	            e.stopPropagation();
	        }
	    });
	    $('.trigger').unbind( "click" ).click(function(e){
	        if ( $('.doc').length<0 || $(this).parents('.doc').hasClass('current') || $(this).parents("div[id*='regesto_cont']").length>0 ) {
	            e.stopPropagation();
	            var popup, trigger, tooltip, before;
	            popup = $(this).parent('.popup');
	            trigger = popup.find('.trigger');
	            tooltip = popup.find('> .tooltip');
	            before = tooltip.find('> .before');
	            
	            if ( tooltip.hasClass('opened') ) {
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
	                
	                if($(this).parent('.popup').find('> .tooltip')){
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
	                triggerHeight = trigger.css('font-size').substr(0,2)*1+1;
	                
	                triggerTop = trigger.offset().top;
	                triggerLeft = trigger.position().left;
	                triggerWidth = trigger.width();
	                
	                var tooltipTop = tooltip.offset().top;
	                
	                var x = e.clientX;
	                var y = e.clientY;
	                
	                var tooltipRealWidth, tooltipRealHeight;
	                tooltip.css('position', 'relative');    
	                tooltipRealWidth = tooltip.width();

	                if( tooltipRealWidth > 200 ){
	                    tooltip.css({
	                        'width': '200px',
	                        'max-width': '200px'
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
	                left = x - (tooltipRealWidth/2);
	                tooltip.offset({
	                        top: y+20,
	                        left: left
	                    });
	                
	                var containerWidth, tooltipLeft, marginRightText;
	                if ( popup.parents("div[id*='frame']").hasClass('full') ){
	                    containerWidth = $('#text_cont').width();
	                    marginRightText = 50;
	                } else {
	                    containerWidth = $('#text').width();    
	                    marginRightText = $('#text').position().left;
	                }
	                tooltipLeft = tooltip.position().left;
	                
	                if (tooltipLeft + tooltipRealWidth > containerWidth){
	                    tooltip.css({
	                        'right': marginRightText+"px"
	                    });
	                }
	                tooltipRealWidth = tooltip.width(); 
	                
	                
	                
	                // Se supera a destra il margine destro del contenitore....
	                tooltipNewLeft = tooltip.position().left;
	                if ( tooltipNewLeft + tooltipRealWidth > containerWidth ) {
	                    var diff = (tooltipNewLeft + tooltipRealWidth) - containerWidth;
	                    //var newLeft = $(this).find('> .tooltip').offset().left - diff + marginRightText;
	                    tooltipNewLeft = left - diff + marginRightText;
	                    tooltip.offset({
	                            left: tooltipNewLeft
	                        });
	                }

	                // Se supera a sinistra il margine sinistro del contenitore...
	                var offsetLeftText;
	                if ( popup.parents("div[id*='frame']").hasClass('full') ){
	                    offsetLeftText = $('#text_cont').offset().left;
	                } else {
	                    offsetLeftText = $('#text').offset().left;
	                }

	                if ( left < offsetLeftText ) {
	                    tooltip.offset({
	                            left: offsetLeftText
	                        });
	                }

	                // Riposiziono l'elemento .before
	                var beforeWidth, beforeNewLeft;
	                var beforeMarginRight, tooltipMarginRight;
	                beforeNewLeft = x;
	                beforeWidth = before.width();
	                beforeMarginRight = x+beforeWidth;
	                tooltipMarginRight = tooltip.offset().left + tooltip.width();
	                if ( beforeMarginRight > tooltipMarginRight){
	                    var diff = (beforeMarginRight - tooltipMarginRight );
	                    beforeNewLeft = x - diff;
	                }
	                before.offset({ left: beforeNewLeft-5});

	                // Riposizionamento se supera il margine inferiore del contenitore
	                var tooltipOffsetBottom, containerHeight;
	                tooltipOffsetBottom = tooltip.offset().top + tooltip.height();
	                containerHeight = $('#text_cont').offset().top + $('#text_cont').height() - 42;

	                if ( tooltipOffsetBottom > containerHeight ){
	                    var tooltipMoveToTop = triggerHeight + tooltip.height() + before.height() + 8;
	                    var tooltipNewTop = before.offset().top - tooltipMoveToTop;
	                    tooltip.offset({
	                            top: tooltipNewTop
	                        });
	                    
	                    var beforeNewTop = tooltip.height() + 8;
	                    before
	                        .offset({
	                            left: beforeNewLeft-10
	                        })
	                        .css({
	                            "top": beforeNewTop+"px",
	                            "transform": "rotate(180deg)"
	                        });
	                }
	                tooltipRealWidth = tooltip.width();
	                if( tooltipRealWidth > 200 ){
	                    tooltip.css({
	                        'width': '200px',
	                        'max-width': '200px'
	                    });
	                } 
	                
	                $(this).focus();    

	                return false;
	            }
	        }
	    });
	    
	    
	    $(document).click(function(){
	        $('.over').removeClass('over');
	        $('.opened').removeClass('opened');
	        $('.popup').find('> .tooltip').hide();
	        $(this).hide();
	    });
	   

	    InitializeLinkTextList();
	}

	function updateHash(tt_val, pp_val, ee_val){
		// console.log(' # updateHash #');
	    window.location.hash = "doc="+tt_val+"&page="+pp_val;
	}

	/* Selezione pagina:
	   – aggiornamento della label del selettore delle pagine singole e selezione della option corrispondente
	   - aggiornamento della label del selettore delle pagine doppie e selezione della option corrispondente
	   - aggiunta della classe "inPage" alle option dei documenti contenuti nella pagina selezionata
	 */
	function selectPP(current_page, pp_lab, tt_val){
		// console.log(' # selectPP #');
		var dd_opt, dd_val, dd_lab, dd_first_doc;
	    
	    // SELETTORE PAGINE E SELETTORE PAGINE DUPLICATO NEL FRAME SINISTRO
	    $('#span_pp_select .label_selected, #span_pp_select-add .label_selected')
	        .attr('data-value', current_page)
	        .attr('data-first-doc', tt_val)
	        .text(pp_lab);

	    $("#span_pp_select .option[data-value!='"+current_page+"'], #span_pp_select-add .option[data-value!='"+current_page+"']")
	        .removeClass('selected');

	    $("#span_pp_select .option[data-value='"+current_page+"'], #span_pp_select-add .option[data-value='"+current_page+"']")
	        .addClass('selected');

	    // SELETTORE PAGINE BOOK READER
	    $('#span_dd_select .option')
	        .removeClass('selected');
	    
	    dd_opt = $('#span_dd_select .option_container .option:contains("'+pp_lab+'")');
	    dd_opt.addClass('selected');
	                
	    dd_val = dd_opt.attr('data-value');
	    dd_lab = dd_opt.text();
	    dd_first_doc = tt_val;

	    $('#span_dd_select .label_selected')
	        .attr('data-value', dd_val)
	        .attr('data-first-doc', dd_first_doc)
	        .text(dd_lab);
	    $('.inPage').removeClass('inPage');
	    
	   	
	   	// GESTIONE DOCUMENTI MULTIPLI SU STESSA PAGINA
	    $("#span_tt_select .option[data-value='"+tt_val+"']").addClass('inPage');
	    $("#span_tt_select-add .option[data-value='"+tt_val+"']").addClass('inPage');

	    // #CDP. Add scroll to elemento
	    
	    $("#span_tt_select .option[data-first-page='"+current_page+"'], #span_tt_select-add .option[data-first-page='"+current_page+"']")
	    	.addClass('inPage');
	    
	    if ($("#span_tt_select").find('.inPage').length > 1) {
	        var actual_label = $('#span_tt_select .label_selected').text();
	        $('#span_tt_select .label_selected, #span_tt_select-add .label_selected').text(actual_label);
	    } 
	}

	/* Selezione documento: 
	   - aggiornamento della label del selettore dei documenti
	*/
	function selectTT(current_doc){
		// console.log(' # selectTT #');
		var current_doc_lab = $("#span_tt_select .option_container .option[data-value='"+current_doc+"']").text();
	    // SELETTORE TESTI E SELETTORE TESTI DUPLICATO NEL FRAME SINISTRO
	    $('#span_tt_select .label_selected, #span_tt_select-add .label_selected')
	        .attr('data-value', current_doc)
	        .text(current_doc_lab);
	    
	    // GESTIONE DOCUMENTI MULTIPLI SU STESSA PAGINA
	    var pp_first_doc_val = $("#span_pp_select .option_container .option.selected").attr('data-first-doc');  
	    $("#span_tt_select .option[data-value='"+pp_first_doc_val+"'], #span_tt_select-add .option[data-value='"+pp_first_doc_val+"']")
	    	.addClass('inPage');

	    $("#span_tt_select .option_container .option[data-value='"+current_doc+"'], #span_tt_select-add .option_container .option[data-value='"+current_doc+"']")
	        .addClass('selected')
	        .addClass('inPage')
	            .siblings('.selected')
	                .removeClass('selected');

	    if ( $("#span_tt_select").find('.inPage').length > 1 ) {
	        var actual_label = $('#span_tt_select .label_selected').text();
	        $('#span_tt_select .label_selected').text(actual_label);
	        $('#span_tt_select-add .label_selected').text(actual_label);
	    }

	    $('.doc.current').removeClass('current').addClass('not_current');
	    $(".doc[data-doc='"+current_doc+"']").removeClass('not_current').addClass('current');
	    if ( $('.doc.current').length > 0 && $('.doc.current').position() != undefined ){
	        $('#text_cont, #text_cont-add').scrollTop($('.doc.current').position().top);
	    }
	}

	// IT: Seleziono un documento nella pagina
	// (pensato per casi in cui possono esserci più documenti in una stessa pagina)
	function selectDocumentInPage(elem) {
		// console.log(' # selectDocumentInPage #');
	    var tt_val, tt_lab, doc_title, current_doc_title, pp_val;
	    if ( $(elem).parents("div[id*='frame']").find('.doc').length > 1 && 
	         $(elem).hasClass('not_current') ) {
	        
	        doc_title = $(elem).attr('title');
	        current_doc_title = $(".doc.current").attr('tempTitle');

	        $(".doc.current")
	            .attr('title', current_doc_title)
	            .removeAttr('tempTitle')
	            .removeClass('current')
	            .addClass('not_current');
	        
	        $(elem)
	            .attr('tempTitle', doc_title)
	            .removeAttr('title')
	            .removeClass('not_current')
	            .addClass('current');

	        tt_val = $(elem).attr('data-doc');
	        tt_lab = $("#span_tt_select .option[data-value='"+tt_val+"']").text();
	        pp_val = $("#span_pp_select .label_selected").attr('data-value');
	        
	        // updateRegestoContent(tt_val);
	        // updateFrontContent(tt_val);
	        updateHash(tt_val, pp_val, "");

	        if ( $('.doc.current').length > 0 && $('.doc.current').position() != undefined ){
	            $('#text_cont, #text_cont-add').scrollTop($('.doc.current').position().top);
	        }
	    }
	}

	// IT: Gestisce il cambio pagina e gli eventi correlati
	function gotopage(pp_val, pp_lab, state){
		// console.log(' # gotopage #');
	    var edition, edition_add; 
	    var current_font_size;
	    //N.B. i caricamenti delle immagini si attivano grazie agli eventi change dei label_selected in iviewer_config
	    edition = $("#span_ee_select .main_ee_select .label_selected").text().toLowerCase();
	    // $('#span_pp_select .label_selected').trigger('change');
	    
	    if ( $('#text_cont').attr('data-font-size') != '') {
	        current_font_size = parseFloat($('#text_cont').attr('data-font-size')); 
	    } else {
	        current_font_size = parseFloat($('#text_cont').css('font-size'));
	    }
	    
	    $('#text_elem')
	    	.attr('data-page', pp_val)
	    	.empty()
	    	.load("data/output_data/"+edition+"/page_"+pp_val+"_"+edition+".html #text_frame", function( response, status, xhr ){
		        $('#text_cont')
		            .css({
		                'font-size': current_font_size+'px',
		                'line-height': (current_font_size+10)+'px'
		            });
		        //IT: Attiva occorrenza in lista 
		        var right_frame = $('#main_right_frame');
		        if ( right_frame.find('.list').length > 0 && 
		        	 right_frame.find('.list_element.list_element_opened').length > 0 ) {
		            right_frame.find('.selected_from_list').removeClass('selected_from_list');
		            right_frame.find('.list_element_opened').each(function() {
		                var ref;
		                ref = $(this).attr('id');
		                $("#text span[data-ref='"+ref+"']").addClass('selected_from_list');
		            });
		        }
		        //IT: Riattiva filtri attivi
		        updateEntitiesFiltered(right_frame);

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

		        // Aggiorna eventi sul click negli elementi del text
		        var current_tt, current_doc_title;
		        current_tt = $('#span_tt_select .option_container .option.selected').attr('data-value');
		        $("#text_cont .doc[data-doc!='"+current_tt+"']").addClass('not_current');
		        current_doc_title = $("#text_cont .doc[data-doc='"+current_tt+"']").attr('title');
		        
		        $("#text_cont .doc[data-doc='"+current_tt+"']")
		            .attr('tempTitle', current_doc_title)
		            .removeAttr('title')
		            .addClass('current');

		        if ($('#text_cont .doc').length > 0) {
		            $('#text_cont').scrollTop($('#text_cont .doc.current').position().top);

		            $("#text_cont .doc").unbind('click').click(function(){
		                selectDocumentInPage(this);
		            });
		        }

		        $("img").error(function () {
		            $(this)
		                .unbind("error")
		                .attr("src", "images/no-image.png")
		                .css('opacity', '0.3');
		            if ( $(this).parent('.tooltip') ){
		                $(this).css({
		                    'width': '100px'
		                });
		            }
		        });

		        InitializePopup();
		        InitializeRefs();
		        InitializeSearch();

		        
		        if ($('.selected_from_list').length > 0) {
		        	$('#text_cont.reachingOccurence')
		        		.scrollTop($('.selected_from_list').position().top)
				        .removeClass('reachingOccurence');
		        }
	    	});
	    
	    // IT: Aggiorna l'indirizzo del frame secondario per il testo
	    if ($("#text_cont-add").length > 0){ //SISTEMARE
	    	edition_add = $("#span_ee_select-add .option_container .option.selected").text().toLowerCase();

	        $('#text_elem-add').load("data/output_data/"+edition_add+"/page_"+pp_val+"_"+edition_add+".html #text_frame", function(){
	        	$('#text_cont-add')
		            .css({
		                'font-size': current_font_size+'px',
		                'line-height': (current_font_size+10)+'px'
		            });
		        //IT: Attiva occorrenza in lista 
		        var left_frame = $('#main_left_frame');
		        if ( left_frame.find('.list').length > 0 &&
		        	 left_frame.find('.list_element.list_element_opened').length > 0 ) {
		            
		            left_frame.find('.selected_from_list').removeClass('selected_from_list')
		            left_frame.find('.list_element_opened').each(function() {
		                var ref;
		                ref = $(this).attr('id');
		                $("#text span[data-ref='"+ref+"']").addClass('selected_from_list');
		            });
		        }
		        //IT: Riattiva filtri attivi
		        left_frame
		        	.find('.like_select.filter')
		        		.find('.option.selected')
			        		.removeClass('selected')
			        		.trigger('click');

		        // Aggiorna eventi sul click negli elementi del text
		        var current_tt, current_doc_title;
		        current_tt = $('#span_tt_select-add .option_container .option.selected').attr('data-value');
		        $("#text_cont-add .doc[data-doc!='"+current_tt+"']").addClass('not_current');
		        current_doc_title = $("#text_cont-add .doc[data-doc='"+current_tt+"']").attr('title');
		        
		        $("#text_cont-add .doc[data-doc='"+current_tt+"']")
		            .attr('tempTitle', current_doc_title)
		            .removeAttr('title')
		            .addClass('current');

		        if ($('#text_cont-add:visible .doc').length > 0) {
		        	// console.log('scroll-add');
		            $('#text_cont-add').scrollTop($('#text_cont-add .doc.current').position().top);

		            $("#text_cont-add .doc").unbind('click').click(function(){
		                selectDocumentInPage(this);
		            });
		        }

		        InitializePopup();
		        InitializeRefs();
		        InitializeSearch();
	        	/* Integration by LS */
		        window.lang.run();  
		        /* /end Integration by LS */
	        });
	            
	        // IT: Aggiorna le informazioni all'interno dell'etichetta destra   
	        $('#zvalopz')
	            .text($("input[name=edition_r-add]:checked").val())
	            .hide()
	            .fadeIn(200);
	    }
	    
	    // IT: Se ci si trova nella modalit Thumb, chiude la schermata e visualizza l'immagine
	    if($("#thumb_cont").css('display') === "block"){
	        $(".thumb_link").trigger('click');
	    }
	}

	// IT: Gestisce il cambio edizione nel frame testuale
	function gotoedition(pp_val, ee_val, pp_el, frame_id){
		// console.log(' # gotoedition #');
	    var tt_val;
	    tt_val = $('#span_tt_select .label_selected').attr('data-value');
	    if (ITLon === true){
	        UnInitialize(true);
	    } //Add by JK for ITL
	    if (HSon === true){
	        UnInitializeHS(true);
	    } //Add by JK for HS
	    $('#'+pp_el)
	    	.empty()
	    	.load("data/output_data/"+ee_val+"/page_"+pp_val+"_"+ee_val+".html #text_frame",
		        function(status) {
		            $('#'+frame_id+" .doc[data-doc!='"+tt_val+"']").addClass('not_current');

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
		            
		            var current_doc = $('#span_tt_select .label_selected').attr('data-value');
		            if ( $(".doc[data-doc='"+current_doc+"']").length > 0 ) {
		                $(".doc[data-doc='"+current_doc+"']").addClass('current');
		            }
		            
		            InitializePopup();
		            InitializeRefs();
		            InitializeSearch();
		            
		            $("#text_cont .doc, #text_cont-add .doc").unbind('click').click(function(){
		                selectDocumentInPage(this);
		            });
		            if($("#"+pp_el).parents("div[id*='frame']").find('.like_select.filter')){
	                    $("#"+pp_el)
	                        .parents("div[id*='frame']")
	                            .find('.like_select.filter')
	                                .find('.option_container .option.selected')
	                                    .removeClass('selected')
	                                    .trigger('click');
	                                    
	                }
		            /* Integration by LS */
			        window.lang.run();  
			        /* /end Integration by LS */
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
		// console.log(' # preload #');
	    $(arrayOfImages).each(function(){
	        $('<img/>')[0].src = this;
	    });
	}
    
    /* Navigazione per documento */
    function navDoc(toward){
    	// console.log(' # navDoc #');
	    var current_tt, new_tt, current_pp, new_pp, new_tt_val;
	    current_tt = $('#span_tt_select').find('.option.selected');
	    current_pp = $('#span_pp_select').find('.option.selected').attr('data-value');

	    if (toward === "left") {
	        new_tt = current_tt.prev();
	    } else if (toward === "right"){
	        new_tt = current_tt.next();
	    }

	    new_pp = new_tt.attr('data-first-page');
	    new_tt_val = new_tt.attr('data-value');
	    if ( $(".doc[data-doc='"+new_tt_val+"']").length > 0 ) {
	        $(".doc[data-doc='"+new_tt_val+"']").trigger('click');
	        //selectTT(new_tt_val);
	        $('#text_cont').scrollTop($('.doc.current').position().top);
	        updateHash(new_tt_val, current_pp, "");
	    } else {
	        new_tt.trigger('click');
	    }
	    var insideLeftArrow = $('#inside_left_arrow'),
	    	insideLeftArrowAdd = $('#inside_left_arrow-add'),
	    	insideRightArrow = $('#inside_right_arrow'),
	    	insideRightArrowAdd = $('#inside_right_arrow-add');
	    if ( insideLeftArrow.length > 0 || insideRightArrow.length > 0 ) {
	        if (new_tt.prev().length <= 0) {
	        	insideLeftArrow.addClass('disabled');
	        	insideLeftArrowAdd.addClass('disabled');
	        } else {
	        	insideLeftArrow.removeClass('disabled');
	        	insideLeftArrowAdd.removeClass('disabled');
	        }

	        if (new_tt.next().length <= 0) {
	        	insideRightArrow.addClass('disabled');
	        	insideRightArrowAdd.addClass('disabled');
	        } else {
	        	insideRightArrow.removeClass('disabled');
	        	insideRightArrowAdd.removeClass('disabled');
	        }
	    }
	}

    /* Navigazione per pagine */
	function arrow(toward){ //duplicata temporaneamente in jquery.rafmas-keydown
		// console.log(' # arrow #');
	    var d_page, l_page;
	    var current_pp, current_opt;
	    var new_pp_opt;
	    var new_pp_val, new_pp_lab, new_tt_val;
	    var current_tt_val, current_tt_first_page;

	    if ( !$("#imgd_link").hasClass("current_mode")){
	        if ( groupingPagesByDoc ) {
	            if (toward === "left"){
	                current_opt = $('.main_pp_select .option_container .option.selected:first');
	                current_pp = current_opt.attr("data-value");
	                
	                if (current_opt.prev().hasClass('option')) {
	                    new_pp_opt = current_opt.prev();
	                } 
	                // se la pagina corrente e' la prima di un gruppo
	                else if (current_opt.prev().is('span')) {
	                    // se il gruppo della pagina corrente non e' il primo gruppo
	                    if (current_opt.parent().prev().length > 0 ) {
	                        // seleziono l'ultima pagina del gruppo precedente
	                        new_pp_opt = current_opt.parent().prev().find('.option:last')
	                    }
	                }
	            }
	            if (toward === "right"){
	                current_opt = $('.main_pp_select .option_container .option.selected:last');
	                current_pp = current_opt.attr("data-value");
	                // se la pagina corrente non e' l'ultima di un gruppo
	                if ( current_opt.next().length > 0 && current_opt.next().hasClass('option')) {
	                    new_pp_opt = current_opt.next();
	                } else {
	                    // se il gruppo della pagina corrente non e' l'ultimo
	                    if (current_opt.parent().next().length > 0 ) {
	                        // seleziono l'ultima pagina del gruppo precedente
	                        new_pp_opt = current_opt.parent().next().find('.option:first')
	                    }   
	                }
	            }
	        } else {
	            current_opt = $('.main_pp_select .option_container .option.selected');
	            current_pp = current_opt.attr("data-value");
	            if (toward === "left" && ! $(current_opt).is(":first-child")){
	                new_pp_opt = current_opt.prev();
	            }
	            if (toward === "right" && ! $(current_opt).is(":last-child")){
	                new_pp_opt = current_opt.next();
	            }
	        }
	        if ( new_pp_opt != null ) {
	            new_tt_val = new_pp_opt.attr('data-first-doc'); // primo documento contenuto.
	        }
	    } else {
	        $('#span_dd_select .label_selected').attr('data-last-hash-txtimg', '');
	        current_opt = $('.main_dd_select .option_container .option.selected');
	        current_pp = current_opt.attr('data-value');
	        if (toward === "left" && ! $(current_opt).is(":first-child")){
	            new_pp_opt = current_opt.prev();
	        }
	        if (toward === "right" && ! $(current_opt).is(":last-child")){
	            new_pp_opt = current_opt.next();
	        }
	        if ( new_pp_opt != null ) {
	            new_tt_val = new_pp_opt.attr('data-first-page-first-doc'); // primo documento contenuto.    
	        }
	    }
	    if ( new_pp_opt != null ) {
	        new_pp_val = new_pp_opt.attr('data-value'); // id pagina cliccata
	        new_pp_lab = new_pp_opt.text(); 
	        
	        current_tt_val = $(".main_tt_select .label_selected").attr("data-value"); 
	        current_tt_first_page = $(".main_tt_select .option_container .option.selected").attr('data-first-page');
	        if(current_tt_first_page === new_pp_val){
	            updateHash(current_tt_val, new_pp_val, "");
	        } else {
	            updateHash(new_tt_val, new_pp_val, "");
	        }
	    }
	}

	// Simulazione trigger di un evento "click" su option per gestire gli scambi dei livelli di edizione
	function selectOther(other_to_select, other_ee_select, page, doc, other_frame){
		// console.log(' # selectOther #');
	    gotoedition(page, doc, other_to_select.attr('data-value').toLowerCase(), other_frame);
	    other_to_select.addClass('selected')
	                        .siblings('.option').removeClass('selected');
	    other_ee_select.find('.label_selected')
	                        .attr('data-value', other_to_select.attr('data-value').toLowerCase())
	                        .text(other_to_select.text())
	                        .trigger('change');
	}

	/* ==/ HANDLING INTERFACE NAVIGATION END*/

	/* HANDLING RESIZINGS */

	// Gestione altezza contenitore testuale
	function updateTextContHeight(){
		// console.log(' # updateTextContHeight #');
	    var mainContainer, centralWrapper;
	    var mainContainerHeight, bottomBoxHeaderHeight;
	    var new_container_height, old_container_height;
	    
	    centralWrapper = $('#central_wrapper');
	    new_container_height = centralWrapper.height();
	    new_container_height -= (centralWrapper.find('header').height()*2);
	    // $('.menu-box:visible').each(function(){
	    //  new_container_height -= $(this).height();
	    // });
	    
	    centralWrapper.find("div[id*='main_']").each(function(){
	        // Se nel frame i box in basso sono tutti chiusi
	        if( $(this).find('.bottomBoxOpened').length == 0 ) {
	            // Ricalcolo l'altezza del frame in modo che riempia tutto lo spazio
	            new_container_height = $(this).height();
	            if ( !$(this).find('header').hasClass('menuClosed') ) {
	                new_container_height -= $(this).find('header').height();
	                if ( $(this).find('.bottom-menu').length > 0 ) {
	                    new_container_height -= $(this).find('.bottom-menu').height();
	                }
	            }
	            $(this).find('.text-box.height-changed')
	                .removeClass('height-changed')
	                .css({'height': new_container_height+'px'});
	        } 
	        // Invece se il box in basso del frame è aperto
	        // ricalcolo l'altezza sulla base dell'header di tale box
	        else {
	            mainContainerHeight = $(this).height();
	            bottomBoxHeaderHeight = $(this).find('.bottomBoxOpened .bottomBoxHeader:visible').height() + 2;
	            
	            if($(this).find('header').hasClass('menuClosed')){
	                new_container_height = mainContainerHeight - bottomBoxHeaderHeight;
	                $(this).find('.bottomBox:visible')
	                    .animate({height: mainContainerHeight+'px'}, 'fast');
	            } else {
	                //old_container_height = $('#main_left_frame').height()-$('#left_header').height()-$('#image_tool').height();
	                new_container_height = mainContainerHeight - bottomBoxHeaderHeight - ($(this).find('header').height()*2);
	            }

	            // $('.text-box')
	            //  .removeClass('height-changed')
	            //  .css({'height': (new_container_height+bottomBoxHeaderHeight+2)+'px'});
	            $(this)
	                .find('.text-box')
	                    .each(function(){
	                        if ( !$(this).hasClass('height-changed') ) {
	                            $(this)
	                                .addClass('height-changed')
	                                .animate({'height': new_container_height}, 'fast');
	                        }
	                    });
	        }
	    });
	}
	// Gestione lunghezza delle select sulla base della option più lunga
	function updateSelectLength(elem){
		// console.log(' # updateSelectLength #');
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
	    
	    if ( $(elem).find('.option_container').hasClass('up') ) {
	        var height;
	        height = $(elem).find('.option_container').height()+6;
	        $(elem).find('.option_container').attr('data-toggle-top', height);
	    }

	    if($(elem).attr('id') === 'span_ee_select'){
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
	    if($(elem).attr('id') === 'span_dd_select'){
	        var widthPP, optPP;
	        widthPP = $('#span_pp_select').find('div').width() * 1.5 - 5;
	        optPP = $('#span_pp_select').find('.option_container').width() * 1.5;
	        
	        // $('#span_dd_select')
	        //  .css('width', widthPP)
	        //  .attr('data-first-load-width', widthPP);
	        $('#span_dd_select')
	        	.addClass('widthChanged')
	        	.find('.option_container')
	        		.removeAttr('style')
	                .css('width', optPP)
	                .attr('data-first-load-width', optPP);

	        if ( optionTooltipInPages ) {
	            if ( $(elem).find('.option_tooltip_dd').length > 0 ){
	                $(elem).find('.option_tooltip_dd').css({
	                    'left': widthPP+1,
	                    'min-width': widthPP-50
	                    // 'min-width': 'auto'
	                });
	            }
	        }
	    }
	    if( $(elem).attr('id') === 'span_tt_select' ) {
	        if ( optionTooltipInPages ) {
	            if ( $('#span_pp_select').find('.option_tooltip').length > 0 ){
	                $('#span_pp_select').find('.option_tooltip').css({
	                    'min-width': widthSel-50
	                });
	            }
	        }
	    }
	    if( $(elem).attr('id') === 'span_pp_select' ) {
	        if ( optionTooltipInPages ) {
	            if ( $(elem).find('.option_tooltip').length > 0 ){
	                $(elem).find('.option_tooltip').css({
	                    'left': widthSel+1
	                });
	            }
	        }
	    }
	    if( $(elem).attr('id') === 'span_list_select-add' ) {
	        widthSel = $('#span_list_select').find('.option_container').width()+10;
	    }

	    $(elem).find('.option_container').css({
	        "width": widthSel-10,
	        "position": "absolute",
	        "visibility": "visible",
	        "display": "none"
	    });
	}

	// Ridimensionamento barra in alto in base ai pulsanti presenti
	function resizeGlobalTopBar() {
		// console.log(' # resizeGlobalTopBar #');
	    var interface_tools_width = $('#cont_interface_tools').width(),
	        botleftconcave_width = $('.botleftconcave').width(),
	        concave_width = $('.concave').width(),
	        extTop = $('.extTop').width();
	    var diff = interface_tools_width - botleftconcave_width + 10;
	    $('.botleftconcave').width(botleftconcave_width+diff);
	    $('.concave').width(concave_width+diff);
	    $('.extTop').width(extTop+diff);
	}

	// Ridimensionamento pulsanti e selettori in base allo spazio disponibile
	function resizeButtonsAndSelects() {
		// console.log(' # resizeButtonsAndSelects #');
	    /* ========= */
	    /* TOP MENUS */
	    /* ========= */

	    /* ========== */
	    /* LEFT FRAME */
	    /* ========== */
	    var leftMenu = $('#left_menu')
	    	leftHeader = $('#left_header'),
	    	leftHeaderBtns = leftHeader.find('.mainButtons'),
	    	leftHeaderSelects = leftHeader.find('.like_select');
	    leftMenu.css('width', 'auto');
	    leftMenu
	    	.css('width', 'auto')
	        .clone()
	        .attr('id', 'left_menu_copy')
	        .css('display', 'none')
	        .appendTo(leftHeader);
	    var leftMenuCopy = $('#left_menu_copy');
	    leftMenuCopy.find('.small').removeClass('small').find('span').show();
	    
	    if ( leftMenuCopy.outerWidth() >= leftHeader.innerWidth()) {
	        leftHeaderBtns
	            .addClass('small')
	            .find('span').hide();

	        if ( leftMenu.outerWidth() > leftHeader.innerWidth()) {
	            var diff =  leftMenu.outerWidth() - leftHeader.innerWidth();
	            var remove_width = diff/leftHeaderSelects.length;
	            leftHeaderSelects.each(function(){
	                var new_width = $(this).outerWidth() - remove_width; 
	                $(this).css({
	                    'width': new_width
	                });
	            });
	        } else {
	            leftHeaderSelects.each(function(){
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

	        leftHeaderSelects.each(function(){
	            var reset_width = $(this).attr('data-first-load-width'); 
	            $(this).css({
	                'width': reset_width
	            });
	        });
	    }
	    leftMenuCopy.remove();
	    leftMenu.css('width', '100%');

	    
	    /* =========== */
	    /* RIGHT FRAME */
	    /* =========== */
	    var rightMenu = $('#right_menu'),
	    	rightHeader = $('#right_header')
	    	rightHeaderBtns = rightHeader.find('.mainButtons'),
	    	rightHeaderSelects = rightHeader.find('.like_select');
	    rightMenu.css('width', 'auto');
	    if ( rightMenu.outerWidth() >= rightHeader.innerWidth() - 30 ) {
	        rightHeaderBtns
	            .addClass('small')
	            .find('span').hide();
	    } else {
	        rightHeaderBtns
	            .removeClass('small')
	            .find('span').show();
	    }
	    if ( rightMenu.outerWidth() >= rightHeader.innerWidth() - 30 ) {
	        var diff =  rightMenu.outerWidth() - (rightHeader.innerWidth() - 30);
	        var remove_width = diff/rightHeaderSelects.length;
	        if (remove_width > 0) {
	            rightHeaderSelects.each(function(){
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
	        rightHeaderSelects.each(function(){
	            $(this).css({
	                'width': 'auto'
	            });
	        });
	    }
	    rightMenu.css('width', '100%');

	    /* ============ */
	    /* BOTTOM MENUS */
	    /* ============ */

	    /* ========== */
	    /* LEFT FRAME */
	    /* ========== */
	    var leftTextTool = $('#text_tool-add'),
	    	leftTextToolBtns = leftTextTool.find('.mainButtons'),
	    	leftTextToolSelect = leftTextTool.find('.like_select');
	    leftTextTool.css('width', 'auto');
	    if ( leftTextTool.outerWidth() >= rightHeader.innerWidth() - 30 ) {
	        leftTextToolBtns
	            .addClass('small')
	            .find('span').hide();
	    } else {
	        leftTextToolBtns
	            .removeClass('small')
	            .find('span').show();
	    }
	    if ( leftTextTool.outerWidth() >= rightHeader.innerWidth() - 30 ) {
	        var diff =  leftTextTool.outerWidth() - (rightHeader.innerWidth() - 30);
	        var remove_width = diff/leftTextToolSelect.length;
	        if (remove_width > 0) {
	            leftTextToolSelect.each(function(){
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
	        leftTextToolSelect.each(function(){
	            $(this).css({
	                'width': 'auto'
	            });
	        });
	    }
	    leftTextTool.css('width', '100%');

	    /* =========== */
	    /* RIGHT FRAME */
	    /* =========== */
	    var rightTextTool = $('#text_tool'),
	    	rightTextToolBtns = rightTextTool.find('.mainButtons'),
	    	rightTextToolSelect = rightTextTool.find('.like_select');
	    rightTextTool.css('width', 'auto');
	    if ( rightTextTool.outerWidth() >= rightHeader.innerWidth() - 30 ) {
	        rightTextToolBtns
	            .addClass('small')
	            .find('span').hide();
	    } else {
	        rightTextToolBtns
	            .removeClass('small')
	            .find('span').show();
	    }
	    if ( rightTextTool.outerWidth() >= rightHeader.innerWidth() - 30 ) {
	        var diff =  rightTextTool.outerWidth() - (rightHeader.innerWidth() - 30);
	        var remove_width = diff/rightTextToolSelect.length;
	        if (remove_width > 0) {
	            rightTextToolSelect.each(function(){
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
	        rightTextToolSelect.each(function(){
	            $(this).css({
	                'width': 'auto'
	            });
	        });
	    }
	    rightTextTool.css('width', '100%');
	}

	function fitBottomBoxHeightAndPosition(boxSuffix, height_full){
		// console.log(' # fitBottomBoxHeightAndPosition #');
	    var mainFrame = $("div[id*='main_"+boxSuffix+"_frame']");
	    if ( mainFrame.find('.bottomBoxOpened').length > 0 ) {
	        mainFrame.find('.bottomBoxOpened').each(function() {
	            if ( $(this).hasClass('collapsed') ) {
	                $(this).animate({'top': height_full-119, 'height': height_full-85}, 700); 
	                // 118 = altezza menu in alto e menu in basso + altezza header liste + 1px
	            } else {
	                $(this).animate({'height': height_full-85}, 700);   
	            }
	        });
	        
	        mainFrame.find("div[id*='text_cont'], div[id*='regesto_cont'], div[id*='front_cont']").animate({'height': height_full-118}, 700);
	    } else {
	        mainFrame.find('.bottomBox:visible').animate({'height': height_full-85}, 700);
	        mainFrame.find("div[id*='text_cont'], div[id*='regesto_cont'], div[id*='front_cont']").animate({'height': height_full-85}, 700);
	    }
	}

	function fitFrame() {
		// console.log(' # fitFrame #');
	    var noMenu_height;
	    var noMenu_height_left, noMenu_height_right;
	    if ( $('.full').length > 0 ) {
	        noMenu_height = $('.full').height();
	    } else {
	        noMenu_height = $('#central_wrapper').outerHeight();    
	    }
	    noMenu_height_left = noMenu_height;
	    noMenu_height_right = noMenu_height;
	    var mainLeftFrame = $('#main_left_frame'),
	    	mainRightFrame = $('#main_right_frame');
	    // Se menu chiuso
	    if ( $('#left_header').hasClass('menuClosed') ) {
	        $('#lists_cont, #search_cont')
	            .css('height', noMenu_height);

	        if ( mainLeftFrame.find('.bottomBox:visible').length > 0 ) {	            
	            noMenu_height_left -= mainLeftFrame.find('.bottomBox:visible').first().find('.bottomBoxHeader').first().outerHeight();
	        }
	        if ( mainRightFrame.find('.bottomBox:visible').length > 0 ) {
	            noMenu_height_right -= mainRightFrame.find('.bottomBox:visible').first().find('.bottomBoxHeader').first().outerHeight();
	        }

	        if ( mainRightFrame.find('#regesto_cont').length > 0 || 
	             mainRightFrame.find('#front_cont').length > 0 ) {
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
	                	.css('height', noMenu_height_left+33);

	            // RIGHT FRAME
	            mainRightFrame
	            	.find('#regesto_cont, #front_cont')
	                	.css('height', noMenu_height+33);
	            
	            mainRightFrame
	            	.find('#text_cont')
	                .css('height', noMenu_height);

	        }
	        if ( $('.bottomBox:visible').hasClass('collapsed') ) {
	            
	        }
	        $('.bottomBox.collapsed:visible').each(function(){
	            var bottomBox_newTop = noMenu_height - (mainRightFrame.find('.bottomBox:visible').find('.bottomBoxHeader').outerHeight()*2) - 11;
	            $(this).css('top', bottomBox_newTop+'px');
	        });
	    } 
	    // Se menu aperto
	    else {
	        if( $('.bottom-menu').length > 0 ){
	            noMenu_height = noMenu_height - $('.top-menu').first().outerHeight() - $('.bottom-menu').first().outerHeight(); 
	        } else {
	            noMenu_height = noMenu_height - $('.top-menu').first().outerHeight();
	        }
	        if ( $('.bottomBox').length > 0 && $('.bottomBox:visible').length > 0 ) {
	            $('.bottomBox').css('height', noMenu_height );
	        }
	        noMenu_height_left = noMenu_height;
	        if ( mainLeftFrame.find('.bottomBox').length > 0 && 
	             mainLeftFrame.find('.bottomBox:visible').length > 0 ) {
	            noMenu_height_left = noMenu_height_left - mainLeftFrame.find('.bottomBox:visible').find('.bottomBoxHeader').outerHeight() - 1;
	        }
	        
	        noMenu_height_right = noMenu_height;
	        if ( mainRightFrame.find('.bottomBox').length > 0 && 
	             mainRightFrame.find('.bottomBox:visible').length > 0 ) {
	            noMenu_height_right = noMenu_height_right - mainRightFrame.find('.bottomBox:visible').find('.bottomBoxHeader').outerHeight() - 1;
	        }
	        
	        $('.bottomBox.collapsed:visible').each(function(){
	            $(this).css('top', noMenu_height-$('.bottomBox:visible').find('.bottomBoxHeader').outerHeight() - 2);
	        });
	        
	        // LEFT FRAME
	        mainLeftFrame.find('#text_cont-add, #regesto_cont, #regesto_cont-add, #front_cont-add')
	            .css('height', noMenu_height_left);
	        
	        // RIGHT FRAME
	        mainRightFrame.find('#text_cont, #regesto_cont, #front_cont')
	                .css('height', noMenu_height_right);
	    }
	}

	function cropLongTextLabel(text_label, min_char_num) {
		// console.log(' # cropLongTextLabel #');
	    if (text_label.length > min_char_num ) {
	        text_label = text_label.substr(0, min_char_num - 3) + "...";
	    }
	    return text_label;
	}
 	/* ==/ HANDLING RESIZINGS END*/

	/* HANDLING FULLSCREENS */
	function goFullScreenLeft(){
		// console.log(' # goFullScreenLeft #');
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
		
		$('#header_collapse').toggle();
		var mainLeftFrame = $("#main_left_frame"),
			globalWrapper = $("#global_wrapper"),
			globalWrapper_height = globalWrapper.height(),
			globalWrapper_width = globalWrapper.width();
		mainLeftFrame.toggleClass("full");
		height_full = ($(window).height() > globalWrapper_height) ? $(window).height()-4 : globalWrapper_height-4;
		width_full = ($(window).width()>globalWrapper_height) ? $(window).width()-4 : globalWrapper_height-4;
		// 4 è l'altezza totale dei bordi di sinistra e destra
		margin_left = -(mainLeftFrame.offset().left);
		margin_top = -(mainLeftFrame.offset().top);
		
		//cambia dimensione elementi per Mag //Add for Mag
		left_headerHeight = $('#left_header').height();
        $('#mag_image_elem').css({'margin-top': left_headerHeight+'px', 'height': height_full-left_headerHeight+'px'});
        $('.zoomWindow').css({left: (width_full - $(".zoomWindow").width())/2+'px'});
        $('.zoomPup').css({left: (width_full - $(".zoomPup").width())/2+'px'});
        
        if ( mainLeftFrame.find('#regesto_cont').length > 0 ) {
        	$('#regesto_cont').animate({'height': height_full-84}, 700);
        } else {
        	fitFrame();
        }
        if (mainLeftFrame.attr('data-menu-state') == 'collapsed' ) {
        	expandMenu(mainLeftFrame, height_full);
        }
        var textWidth;
        var isTxtTxtCurrentMode = $('#txttxt_link').hasClass('current_mode');
		mainLeftFrame.animate({
			width: width_full,
			height: height_full,
			top: margin_top,
			left: margin_left,
			minWidth: "1021px"
		}, 700, function(){
			$('#left_header .closeFullScreen').toggle();
			$('.zoomWindow').show(0); //Add for mag
			//$('#header_collapse').animate({opacity: 1});
			if ( isTxtTxtCurrentMode ) {
				textWidth = $('#text_cont-add').find('#text').css('display', 'inline-block').outerWidth();
				$('#text_cont-add').find('#text').css({
					'margin-left': -(textWidth/2)+'px',
					'display': 'block'
				});
			}
		});
		if ( isTxtTxtCurrentMode ) {
			textWidth = $('#text_cont-add').find('#text').css('display', 'inline-block').outerWidth();
			$('#text_cont-add').find('#text').css({
				'left': '50%',
				'position': 'relative',
				'margin-left': -(textWidth/2)+'px'
			});
		}
		fitBottomBoxHeightAndPosition('left', height_full);
		$('.go-full-left').toggle();
		//$('#switchITL:visible').hide();
		$('#switchITL').addClass('inactive');

		$('#text_cont-add').removeAttr('style');
		
		if(($('#span_ee_select-add').is(':visible'))&&!$('#span_ee_select-add').hasClass('widthChanged')){
			$('#span_ee_select-add')
				.addClass('widthChanged')
				.find('.option_container')
					.removeAttr('style');

			$('#span_ee_select-add')
				.each(function(){
					widthSel = $(this).width();
					widthOpt = $(this).find('.option_container').width()+10;
					if(widthSel > (widthOpt+24)){
						$(this).find('.option_container').css('width', widthSel-10);
					} else {
						$(this).css('width', widthOpt+24);
						$(this).find('.option_container').css('width', widthOpt+14);
					}
				});
		}

		// Gestione selettori
		if( ! $('#imgd_link').hasClass("current_mode") ){
			if ($('#left_menu').find('.main_pp_select').length == 0){
				$('#span_pp_select').detach().prependTo('#left_menu').css('display', 'inline-block');
			}
			if ($('#left_menu').find('.main_tt_select').length == 0){
				$('#span_tt_select').detach().prependTo('#left_menu').css('display', 'inline-block');
			}
		}
	}

	function closeFullScreenLeft(){
		// console.log(' # closeFullScreenLeft #');
		var mainLeftFrame = $('#main_left_frame');
		//$('#header_collapse').animate({opacity: 0});
		$('.zoomWindow').hide();
		$('.zoomPup').hide();
		//caso in cui si passa a fullscreen dalla visualizzazione a doppia pagina
		if (mainLeftFrame.attr('data-menu-state') == 'collapsed' ) {
        	collapseMenu(mainLeftFrame, $('#central_wrapper').innerHeight());
        }
		if($('#main_right_frame').css("display") === "none"){
			mainLeftFrame.animate({
				width: "99.5%",
				height: "100%",
				top: "0px",
				left: "0px",
				minWidth: "0px"
			}, 700, function(){
				fitFrame();
				mainLeftFrame.removeClass("full");
				$('#left_header .closeFullScreen, #header_collapse').toggle();
				$('.go-full-left').toggle();
				//Add for Mag
				setMagHeight();
				$('.zoomWindow').show();
				checkAnnPosHS(); //Add for HS
			});
		} else {
			mainLeftFrame.animate({
				width: "49.8%",
				height: "100%",
				top: "0px",
				left: "0px",
				minWidth: "0px"
			}, 700, function(){
				fitFrame();
				mainLeftFrame
					.removeClass("full")
					.removeAttr("style");
				$('#left_header .closeFullScreen, #header_collapse').toggle();
				$('.go-full-left').toggle();
				//Add for Mag
				setMagHeight();
				$('.zoomWindow').show();
				checkAnnPosHS(); //Add for HS
			});
			$('#switchITL').show();
			//Se ITL è impostato su attivo, attiva il collegamento. Abilita il pulsante.
			if ($('#switchITL i ').hasClass('fa fa-chain')){ //Add by JK for ITL
				Initialize();
			}
			enableITLbutton();
			if ( $('#txttxt_link').hasClass('current_mode') ) {
				$('#text_cont-add').find('#text').removeAttr('style');
			}
		}

		//$('#span_dd_select').hide();
		// Gestione selettori
		if( $('#txtimg_link').hasClass("current_mode") ) {
			if ($('#span_pp_select').hasClass('right_menu') && $('#right_menu').find('#span_pp_select').length == 0) {
				$('#span_pp_select').detach().prependTo('#right_menu');
			} else if ($('#span_pp_select').hasClass('left_menu') && $('#left_menu').find('#span_pp_select').length == 0) {
				$('#span_pp_select').detach().prependTo('#left_menu');
			}
			if ($('#right_menu').find('#span_tt_select').length == 0) {
				$('#span_tt_select').detach().prependTo('#right_menu');
			}
		}
	}

	function goFullScreenRight(){
		// console.log(' # goFullScreenRight #');
		var height_full, width_full, margin_right, margin_left, margin_top;

		if (ITLon){ //Add by JK for ITL
			UnInitialize();
		}
		if (HSon){ //Add by JK for HS
			UnInitialize();
		}
		// Aggiunta di suffisso nel caso di testo a unico frame
		var suffix = '';
		if ( $('#main_right_frame-single').length > 0 ) { suffix='-single'; }
		
		var mainRightFrame = $('#main_right_frame'+suffix);
		mainRightFrame.addClass("full");

		if (mainRightFrame.attr('data-menu-state') == 'collapsed' ) {
        	expandMenu(mainRightFrame, $('#central_wrapper').innerHeight());
        }
		$('#header_collapse').toggle();
		var left_frame_width, offset_left;
		if ( $('#txt_single').length > 0 && $('#txt_single').hasClass('current_mode') ) {
			margin_left = -($('#central_wrapper').offset().left);
			left_frame_width = $('#central_wrapper').outerWidth();
			offset_left = 0;
		} else {
			margin_left = -($('#main_left_frame').offset().left);	
			left_frame_width = $('#main_left_frame').outerWidth();
			offset_left = left_frame_width;
			mainRightFrame.css({
				'position': 'absolute',
				'left': offset_left+'px',
				'width': left_frame_width+'px'
			});
		}
		var globalWrapper = $("#global_wrapper"),
			globalWrapper_height = globalWrapper.height(),
			globalWrapper_width = globalWrapper.width();
		height_full = ($(window).height() > globalWrapper_height) ? $(window).height()-4 : globalWrapper_height-4;
		width_full = ($(window).width()>globalWrapper_width) ? $(window).width()-4 : globalWrapper_width-4;
		// 4 è l'altezza totale dei bordi di sinistra e destra
		margin_right = -($(window).width()-(mainRightFrame.offset().left+mainRightFrame.width())-4);
		margin_top = -(mainRightFrame.offset().top);
		var textWidth;
		mainRightFrame.animate({
			width: width_full,
			height: height_full,
			marginTop: margin_top,
			left: margin_left,
			right:0,
			minWidth: "1021px",
		}, 700, function(){
			$('#right_header .closeFullScreen').toggle();
			textWidth = $('#text_cont').find('#text').css('display', 'inline-block').outerWidth();
			$('#text_cont').find('#text').css({
				'margin-left': -(textWidth/2)+'px',
				'display': 'block'
			});
		});
		textWidth = $('#text_cont').find('#text').css('display', 'inline-block').outerWidth();
		$('#text_cont')
			.css('overflow-x', 'hidden')
			.find('#text')
				.css({
					'left': '50%',
					'position': 'relative',
					'margin-left': -(textWidth/2)+'px'
				});
		
		$('.go-full-right').toggle();
		
		fitBottomBoxHeightAndPosition('right', height_full);
		// fitFrame();
		// Gestione selettori
		if ($('#right_menu').find('.main_pp_select').length == 0){
			$('#span_pp_select').detach().prependTo('#right_menu');
		}
		if ($('#right_menu').find('.main_tt_select').length == 0){
			$('#span_tt_select').detach().prependTo('#right_menu');
		}
	}

	function closeFullScreenRight(){
		// console.log(' # closeFullScreenRight #');
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
		
		var mainRightFrame = $('#main_right_frame'+suffix);
		if (mainRightFrame.attr('data-menu-state') == 'collapsed' ) {
        	collapseMenu(mainRightFrame, $('#central_wrapper').innerHeight());
        }
		var left_frame_width, offset_left;
		if ( $('#txt_single').length > 0 && $('#txt_single').hasClass('current_mode') ) {
			left_frame_width = $('#central_wrapper').outerWidth();
			offset_left = 0;
		} else {
			left_frame_width = $('#main_left_frame').outerWidth();
			offset_left = left_frame_width;
		} 
		$('#text_cont').find('#text').removeAttr('style');
		mainRightFrame.animate({
			left: offset_left+'px',
			width: left_frame_width+'px',
			height: "100%",
			marginTop: "0px",
			minWidth: "0px"
		}, 700, function(){
				fitFrame();
				mainRightFrame
					.removeClass("full")
					.removeAttr("style");
				$('#right_header .closeFullScreen, #header_collapse').toggle();
				$('.go-full-right').toggle();
			});
		// Gestione selettori
		if ( ! $('#txttxt_link').hasClass("current_mode") ){
			if ($('#span_pp_select').hasClass('right_menu') && $('#right_menu').find('#span_pp_select').length == 0) {
				$('#span_pp_select').detach().prependTo('#right_menu');
			} else if ($('#span_pp_select').hasClass('left_menu') && $('#left_menu').find('#span_pp_select').length == 0) {
				$('#span_pp_select').detach().prependTo('#left_menu');
			}
			if ( $('#regesto_cont').length > 0 && $('#span_ee_select .option').length <= 1) {
				if ($('#left_menu').find('#span_tt_select').length == 0){
					$('#span_tt_select').detach().prependTo('#left_menu');
				}
			}
		} else {
			if ($('#span_pp_select').hasClass('right_menu') && $('#right_menu').find('#span_pp_select').length == 0) {
				$('#span_pp_select').detach().prependTo('#right_menu');
			} else if ($('#span_pp_select').hasClass('left_menu') && $('#left_menu').find('#span_pp_select').length == 0) {
				$('#span_pp_select').detach().prependTo('#left_menu');
			}
		}
	}
	/* ==/ HANDLING SINGLE BOX FULL SCREEN */

	/* TOGGLE MENU */
	function collapseMenu(frame, height) {
		// console.log(' # collapseMenu #');
		$('.top-menu:not(.menuClosed)').hide('blind').addClass('menuClosed');
		$('.bottom-menu:not(.menuClosed)').slideUp().addClass('menuClosed');
		
		var bottomBoxHeader_height = 0;
		var topMenu_height;
		var bottomBoxOpened_visible = frame.find('.bottomBoxOpened:visible');
		if ( !frame.is(':visible') ) {
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
		
		frame.find('.inner_frame').animate({
			height: height - bottomBoxHeader_height,
			top: -topMenu_height
		});
		frame.find('.bottomBoxOpened:not(.collapsed)').animate({
			height: height,
			top: -topMenu_height
		});
		frame.find('.bottomBoxOpened.collapsed').each(function(){
			var bottomBox_newTop = height - ($(this).find('.bottomBoxHeader').outerHeight()*2) - 11;
			$(this).animate({
				top: bottomBox_newTop+'px'
			});
		});

		if ( magnifierON === true ) {
			magnifierReady();
		}
	}
	function expandMenu(frame, height) {
		// console.log(' # expandMenu #');
		$('.top-menu.menuClosed:not(.hidden)').show('blind');
		$('.bottom-menu.menuClosed:not(.hidden)').slideToggle("slow");
		$('.top-menu.menuClosed, .bottom-menu.menuClosed').removeClass('menuClosed');
		
		var bottomBoxHeader_height = 0;
		var topMenu_height;
		var bottomBoxOpened_visible = frame.find('.bottomBoxOpened:visible');
		if ( !frame.is(':visible') ) {
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
		
		var withMenu_height = height - (topMenu_height*2);
		frame.find('.inner_frame:not(#image_cont):not(#msDesc_cont)').animate({
			height: withMenu_height - bottomBoxHeader_height,
			top: 0
		});
		frame.find('#image_cont, #msDesc_cont').animate({
			height: (withMenu_height+topMenu_height),
			top: 0
		});
		frame.find('.bottomBoxOpened:not(.collapsed)').animate({
			height: withMenu_height,
			top: 0
		});
		frame.find('.bottomBoxOpened.collapsed').each(function(){
			var bottomBox_newTop = withMenu_height - $(this).find('.bottomBoxHeader').outerHeight() - 2;
			$(this).animate({
				top: bottomBox_newTop+'px'
			});
		});

		if ( magnifierON === true ) {
			magnifierReady();
		}
	}
	/* ==/ TOGGLE MENU */

	/* HANDLING MODE VIEW CHANGES */
	function openTxtImgMode(){
		// console.log(' # openTxtImgMode #');
		var ppSelector = $('#span_pp_select'),
			ttSelector = $('#span_tt_select');
		updateHash(ttSelector.find('.label_selected').attr('data-value'), 
                   ppSelector.find('.label_selected').attr('data-value'), "");

        $("#txtimg_link")
            .addClass("current_mode")
            .siblings()
                .removeClass("current_mode");
        if ( $('#span_ee_select .label_selected').attr('data-value')!='diplomatic' ) {
            $('.like_select.filter').removeClass('not_active');
        }
        
        // Nascondo pulsanti visibili solo nelle altre modalità
        $("#text_cont-add").remove();
        $("#span_ee_select-add").hide();

        // Se il regesto è nel box di sinistra, lo sposto a destra
        if ( $('#main_left_frame').find('#regesto_cont') ){
            var current_font_size;
            if ( $('#text_cont').attr('data-font-size') && $('#text_cont').attr('data-font-size') != '') {
                current_font_size = parseFloat($('#text_cont').attr('data-font-size')); 
            } else {
                current_font_size = parseFloat($('#text_cont').css('font-size'));
            }

            $('#regesto_cont')
                .css({
                    'font-size': current_font_size+'px',
                    'line-height': (current_font_size+10)+'px'
                })
                .attr('data-font-size', current_font_size)
                .detach()
                .insertAfter("#right_header")
            ;   
        }
        
        if ( $('#switch_msDesc').hasClass('active') ) {
            $("#msDesc_cont").show();
        }

        $('#switchReg').show();
        var regestoCont = $('#regesto_cont');
        if(regestoCont) {
        	var listsCont = $('#lists_cont');
            if (listsCont && listsCont.is(':visible')) {
                var testo_cont_height;
                testo_cont_height = $('#text_cont').height();

                regestoCont.css('height', testo_cont_height+'px');
            }

            if ( $('#switchReg').hasClass('active') ){
                if ( !regestoCont.is(':visible') ) {
                    //regestoCont.show('drop',  {direction: 'up'}, 'linear');
                    regestoCont.show();
                }
            } else {
                regestoCont.hide();
            }
        }
        
        $("#span_dd_select").hide();
        
        // Risistemo gli eventuali selettori spostati precedentemente
        var rightMenu = $("#right_menu");
        if ( $("#left_menu").find("#span_pp_select").length == 0 && ppSelector.hasClass('left_menu')) {
            ppSelector.detach().prependTo('#left_menu');
            if ( optionTooltipInPages ) {
                ppSelector.find('.option_tooltip').css({'opacity': '0.8'});
            }
        } else if ( rightMenu.find("#span_pp_select").length == 0 && ppSelector.hasClass('right_menu')) {
            ppSelector.detach().prependTo(rightMenu);
            if ( optionTooltipInPages ) {
                ppSelector.find('.option_tooltip').css({'opacity': '0.8'});
            }
        }

        if ( rightMenu.find("#span_tt_select").length == 0 ) {
            ttSelector.detach().prependTo('#right_menu');
        }
        if ( rightMenu.find("#span_ee_select").length == 0 && $("#span_ee_select").find('.option').length > 0) {
            $('#span_ee_select').detach().insertAfter(ttSelector);
        }

        if ( !ttSelector.is(':visible') ){
            ttSelector.show();    
        }
        if ( !ppSelector.is(':visible') ) {
            ppSelector.show();
        }

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

        $('#text_tool-add').hide().addClass('hidden');
        
        $('#search_cont-add').hide();
        
        var insideRightArrow = $('#inside_right_arrow'),
        	insideLeftArrow = $('#inside_left_arrow');
        if ( insideLeftArrow.length > 0 || insideRightArrow.length > 0 ) {
            insideLeftArrow
                .unbind('click')
                .click(function(){
                    if( !$(this).hasClass('disabled') ){
                        navDoc("left");
                    }
                });
            
            insideRightArrow
                .unbind('click')
                .click(function(){
                    if( !$(this).hasClass('disabled') ){
                        navDoc("right");
                    }
            	});
            /*if( !$("#inside_left_arrow").is(':visible') && 
                ! $('#disabled').hasClass('selected') ) {
                if($('#inside_left_arrow')){
                    $('#inside_left_arrow').show();
                }
            }*/
        }

        
        $('#right_header.menuClosed').hide();
        
        $('#thumb_elem').show();
        $('#zvalint').show();
        //$('#zvalopz').text("");

        fitFrame();
        
        $('#header_collapse').animate({
            left: "50%",
            marginLeft: "-10px"
        });
 
        $('.go-full-right:not(:visible)').show();

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
         
        $('.go-full-left.onWhite').removeClass('onWhite');

        $('#span_pp_select-add, #span_tt_select-add').remove();
	}

	function openTxtTxtMode() {
		// console.log(' # openTxtTxtMode #');
    	var ppSelector = $('#span_pp_select'),
			ttSelector = $('#span_tt_select');
		updateHash(ttSelector.find('.label_selected').attr('data-value'), 
                   ppSelector.find('.label_selected').attr('data-value'), "");

    	var main_text_edition, first_new_edition, second_new_edition, noMenu_height;
        UnInitialize();//Add by JK for ITL
        UnInitializeHS();//Add by JK for HS
        
        $("#txttxt_link")
            .addClass("current_mode")
            .siblings()
                .removeClass("current_mode");
        
        // Nascondo menu, pulsanti e selettori relativi alle immagini /bookreader
        $("#image_menu, #mag, #image_cont, #msDesc_cont, #span_dd_select").hide();

        // GESTIONE NAVIGAZIONE DOCUMENTO
        var insideLeftArrow = $('#inside_left_arrow'),
        	insideRightArrow = $('#inside_right_arrow');
        if ( insideLeftArrow.length > 0 || insideRightArrow.length > 0 ){
            insideLeftArrow.show();
            insideRightArrow.show();
        }
        
        // GESTIONE SELETTORI PAGINE E DOCUMENTO
        
        $('#span_pp_select:not(:visible)').show();
        
        $('#span_tt_select:not(:visible)').show();

        // GESTIONE MENU STRUMENTI TESTO BOX SINISTRO
        $('#text_tool-add:not(.menuClosed)').show();
        $('#text_tool-add').removeClass('hidden');

        // GESTIONE PASSAGGIO BOOKREADER --> TXT-TXT
        // Se il box di destra non e' aperto, lo apro
        $("#main_right_frame:not(:visible)").show();

        // Se i menu erano stati chiusi in modalità bookreader, 
        // chiudo quello di destra...che magari era rimasto aperto.
        $('#right_header.menuClosed').hide();
        
        // Mostro il box di sinistra,
        $("#main_left_frame").animate({
            width: '49.8%',
            borderLeftWidth: '2px',
            borderRightWidth: '2px'
        }, function(){
            $("#right_menu").show();
            $("#text_cont").show();
        });
        // - fine gestione passaggio bookreader --> txttxt
        
        // Clono il contenuto testuale del box di destra, nel box di sinistra
        // aggiungendo "-add" agli identificativi degli elementi principali
        $('#text_cont')
            .clone()
            .attr("id", "text_cont-add")
            .insertAfter("#left_header")
        ;
        $('#text_cont-add>#text_elem')
            .attr("id", "text_elem-add")
        ;
        $('#text_elem-add')
                .find('#text_frame')
                    .attr('id', 'text_frame-add')
                    .find('#text')
                        .attr('id', 'text-add');
        if ($('#text_cont-add .doc').length > 0) {
            $('#text_cont-add').scrollTop($('#text_cont-add .doc.current').position().top);
        }

        // Aggiorno (eventualmente) le dimensioni del selettore delle edizioni nel menu di sinistra
        if (!$('#left_header').hasClass('menuClosed')) {
            var eeSelectorAdd = $('#span_ee_select-add');
            if(!eeSelectorAdd.hasClass('widthChanged')){
                eeSelectorAdd.addClass('widthChanged');
                eeSelectorAdd.find('.option_container').removeAttr('style');
    
                updateSelectLength(eeSelectorAdd);
            }
        }
        // Aggiorno (eventualmente) le dimensioni del selettore delle liste nel menu di sinistra
        if (!$('#text_tool-add').hasClass('menuClosed')) {
            var listSelectAdd = $('#span_list_select-add');
            if(!listSelectAdd.hasClass('widthChanged')){
                listSelectAdd.addClass('widthChanged');
                listSelectAdd.find('.option_container').removeAttr('style');
    
                updateSelectLength(listSelectAdd);
            }
        }


        // Se ho il REGESTO e un solo livello di edizione
        if ( $('#regesto_cont').length > 0 && $("#span_ee_select").find('.option').length == 1 ) {
            $('#regesto_cont:not(:visible)').show();

            // Se il contanitore del regesto non è nel box di sinistra lo sposto da destra a sinistra
            if ( $('#main_left_frame').find('#regesto_cont').length <= 0 ) {
                $('#regesto_cont')
                    .detach()
                    .insertAfter("#left_header")
                ;
                var listsCont = $('#lists_cont'),
                	searchCont = $('#search_cont');
                if ( (listsCont && listsCont.is(':visible')) ||
                     (searchCont && searchCont.is(':visible'))) {
                    var new_regesto_height, list_header_height;
                    list_header_height = $('#list_header').height() || $('#search_header').height();
                    new_regesto_height = $('#regesto_cont').height()+list_header_height+4;
                    $('#regesto_cont').css({'height': new_regesto_height});
                }
            }

            // ...nascondo il pulsante del Regesto dal menu di destra
            $('#switchReg').hide();
            // ... e il regesto a sinistra
            // if ( $("#switchReg").hasClass('active') ) {
            //     $('#switchReg').trigger('click').addClass('active');
            // }
            //$('#regesto_cont').hide('drop',  {direction: 'up'}, 'linear');
            
            // ...nascondo il pulsante del Regesto dal menu di sinistra e il toggle in fondo al regesto di sinistra
            $('#switchReg-add').hide();

            // ...aggiorno l'etichetta nel menu di sinistra col testo "Regesto"
            $('#span_ee_select-add')
                .css({display: "none"})
                .find('.label_selected')
                    .attr('data-value', 'regesto')
                    .text('Regesto')
                    .trigger('change');
            
            // Sposto il selettore dei testi a sinistra
            // if ( $('#left_menu').find('#span_tt_select').length == 0 ){
            //  $('#span_tt_select').detach().prependTo('#left_menu').css({'display':'inline-block'});
            // } else {
            //  if ( !$('#span_tt_select').is(':visible') ){
            //      $('#span_tt_select').show();
            //  }
            // }

            //$('#inside_left_arrow, #inside_right_arrow').hide();
            //$('#inside_left_arrow-add, #inside_right_arrow-add').show();
        } 
        else {
            //$('#zvalint').hide(); //SISTEMARE
            //$('#zvalopz').text($("input[name=edition_r]:checked").val());
            $('#span_ee_select-add')
            	.css({display: "inline-block"})
            	.find('.selected').removeClass('selected');
            //$('#switchReg-add').css({display: "inline-block"});
            var current_right_edition = $('#span_ee_select').find('.label_selected').attr('data-value');
            $("#span_ee_select-add .option_container .option[data-value!='"+current_right_edition+"']:first").trigger('click');

            // DUPLICO PULSANTI DI NAVIGAZIONE PRESENTI NEL FRAME DI DESTRA
            if ( $('#span_pp_select').hasClass('right_menu') ) {
            	$('#span_pp_select')
	            	.clone(true)
	            		.attr('id', 'span_pp_select-add')
	            		.prependTo('#left_menu')
	            		.css('display', 'inline-block');
            } else {
            	$('#span_pp_select')
	            	.clone(true)
	            		.attr('id', 'span_pp_select-add')
	            		.insertAfter('#span_tt_select')
	            		.css('display', 'inline-block');
            }

            $('#span_tt_select')
            	.clone(true)
            		.attr('id', 'span_tt_select-add')
            		.prependTo('#left_menu')
            		.css('display', 'inline-block');
        }

        //fitFrame();
        InitializePopup();
        InitializeRefs();
        InitializeSearch();

        $('#header_collapse').animate({
            left: "50%",
            marginLeft: "-10px"
        });
        
        $('.go-full-right:not(:visible)').show();
        
        if($('#left_header').hasClass('menuClosed')){
            noMenu_height = $('#image_cont').height();
            $('#text_cont-add').css({
                "top": "-42px",
                "height": noMenu_height
            });
            $('#text_cont').css({
                "height": noMenu_height
            });
            $('.go-full-left').addClass('onWhite');
        }
        fitFrame();
        // updateTextContHeight();
    }

    function openBookreaderMode(){
    	// console.log(' # openBookreaderMode #');
    	UnInitialize(); //Add by JK for ITL
        UnInitializeHS(); //Add by JK for HS
        
        if ( $('#search_link-add').hasClass('active') ) {
            $('#search_link-add').trigger('click');
        }

        $("#imgd_link").addClass("current_mode").siblings().removeClass("current_mode");
        //$("#txtimg_link").removeClass("current_mode");
        //$("#imgimg_link").removeClass("current_mode");
        //$("#txttxt_link").removeClass("current_mode");

        $(".main_dd_select").trigger("imgd_mode");
        $('#span_pp_select, #span_tt_select').hide();

        if ( $('#main_left_frame').find('#regesto_cont') ){
            $('#regesto_cont').hide();  
        }
        $("#switchReg-add").hide();
        $('#text_tool-add').hide().addClass('hidden');
        
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
        $('#switchITL').hide();
        $('#switchHS').hide();
        //$('#thumb_elem').hide();
        var ddSelector = $('#span_dd_select');
        ddSelector.css({display: "inline-block"});
        fitFrame();
        
        if(!$('#left_header').hasClass('menuClosed')){
            if(!ddSelector.hasClass('widthChanged')){
                ddSelector.addClass('widthChanged');
                ddSelector.find('.option_container').removeAttr('style');
                updateSelectLength(ddSelector); 
            }
        }
        
        $('#header_collapse').animate({
            left: "100%",
            marginLeft: "-30px"
        });
        $('.go-full-right').hide();
        $('.go-full-left.onWhite').removeClass('onWhite');

        $('#span_pp_select-add, #span_tt_select-add').remove();
    }
    
    function openTxtSingleMode(){
    	// console.log(' # openTxtSingleMode #');
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
    /* ==/ HANDLING MODE VIEW CHANGES */

	/* ************** */
	/* / END Funzioni */
	/* ************** */
	
	/* WINDOW RESIZE EVENTS */
	$(window).bind('resize', function(e){
		var height_full, width_full, leftCss, newLeft, rightR, leftR;
		// window.resizeEvt;
		if ($('.full') != null) {
			height_full = ($(window).height() > $("body").height()) ? $(window).height()-4 : $("body").height();
			width_full = $(window).width()-4;
			$('.full').css({
				"height": height_full,
				"width": width_full
			});
			setMagHeight();
			resizeButtonsAndSelects();
			fitFrame();
			// clearTimeout(window.resizeEvt);
			// window.resizeEvt = setTimeout(function()
			// {
			if ($('.full').length > 0) {
				leftCss = $('.full').css("left").replace(/[^-\d\.]/g, '');
				newLeft = leftCss - ($('.full').offset().left);
				$('.full').css("left", newLeft);
			}
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
			// }, 300);
		}
		//updateTextContHeight();
		//scrollDownListContainer(0);
	});
});
