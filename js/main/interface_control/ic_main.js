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
 **/

/*jslint browser: true*/
/*global $, jQuery, alert */

/* Variabili generiche*/
var fulltogg;
var first_pp, last_pp;
var first_dd, last_dd;
var groupingPagesByDoc, optionTooltipInPages;
var image_ext;

$(function() {
	image_ext = $('#global_wrapper').attr('data-image-extension') || 'jpg';
	window.lang = new jquery_lang_js();
	window.lang.run();
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
						.attr("lang", 'def')
						.addClass('option')
						.text(current_id.toUpperCase())
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

			var firstEE = $('.main_ee_select .option_container div:first').text();
			$('.main_ee_select .label_selected')
				.text(window.lang.convert(firstEE.toUpperCase(), window.lang.currentLang))
				.attr("data-value", $('.main_ee_select .option_container div:first').attr('data-value'))
				.trigger('change');

			// ADD BY FS 	
			//Se ho più di un'edizione e non è attiva la modalità txttxt non visualizzare l'opzione per la selezione dell'edizione di traduzione 
        	if( (!$('#txttxt_link').hasClass('current_mode')) && $(xml).find('editions edition').length > 0 ) {
				$("#span_ee_select .option_container .option[data-value='translation']").hide();
        	}


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
			// 						.attr("data-doc-group", text_ref)
			// 						.addClass('optionGroup')
			// 						.append($('<span>').text(text_ref));
			// 		$('.main_dd_select .option_container').append(group_elem);
			// 	});
			// }

			$(xml).find('pages pair').each(function() {
				var current_id, first_page_d, second_page_d;
				var current_label, first_label_d, second_label_d;
				var first_text_ref, second_text_ref;
				var first_page_in_front, second_page_in_front;

				first_page_d = $(this).children('pb').eq(0).text();
				first_label_d = $(this).children('pb').eq(0).attr("n") != "" ? $(this).children('pb').eq(0).attr("n") : first_page_d;
				
				if (first_page_d.indexOf('-front') < 0){
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
						// 		$(".main_dd_select [data-doc-group='"+second_text_ref+"']").append(
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
							current_label = first_label_d+"<span lang='def'>PAGE_MISSING_RIGHT</span>";
						} else {
							current_label = "<span lang='def'>PAGE_MISSING_LEFT</span>"+ first_label_d;
						}
					}

					// if (groupingPagesByDoc) {
					// 	$(".main_dd_select [data-doc-group='"+first_text_ref+"']").append(
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
				}
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
	    						.attr("data-doc-group", current_id)
	    						.addClass('optionGroup')
	    						.append($('<span>').text(current_label))
					);
				}

				$(this).find('pb').each(function(){
					var page_current_id = $(this).text();
					var pageInFront = page_current_id.indexOf('-front') >= 0
					page_current_id = page_current_id.replace('-front', '')
					
    				var page_current_label = $(this).attr("n");
    				if( ( groupingPagesByDoc && $(".main_pp_select [data-doc-group='"+current_id+"'] .option[data-value='"+page_current_id+"']").length <= 0)|| 
    					(!groupingPagesByDoc && $(".main_pp_select .option_container .option[data-value='"+page_current_id+"']").length <= 0)) {
    					var newOption = $('<div/>')
				    						.attr("data-value", page_current_id)
				    						.attr("data-first-doc", current_id)
				    						.attr("data-has-front", pageInFront)
				    						.addClass('option')
				    						.text(page_current_label);
    					if (groupingPagesByDoc) {
    						$(".main_pp_select [data-doc-group='"+current_id+"']").append(newOption);
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
		    				.addClass('thumb_single_img')
		    				.attr("src", "images/empty-image.jpg")
		    				.attr("data-state", "to-load")
		    				.attr('data-src', 'data/input_data/images/single/'+page_current_id+'_small.'+image_ext)
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
						toggleListCont(this);
					});

				$('.list_filter').click(function() {
					filterListElements(this);
				});

				var listContainer = $('#lists_cont');				
				$(xml).find('liste').children().each(function(){
					if ($(this).attr('active') == '1'){
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
								openList(this, listName);
							})
							.appendTo('#list_header_elements_contents');
						listContainer.find('.list').first().addClass('list_opened').show();
						listContainer.find('.labelList').first().addClass('active');
						$('.list_filter').first().trigger('click');

						var listElement = $('#list_'+listName);
						listElement.load("data/output_data/liste/"+listName+".html div", function(){ 

							if ( listElement.find('li').length == 0 ) {
								listElement.remove();
								$('#header_'+listName).remove();

								if ( $('#list_header_elements_contents').find('.labelList').length == 0 ) {
									$('#lists_cont').remove();
									$('#list_link').remove();
								}
							} else {
								$('[id]').each(function(){ 
				                  $('[id="' + this.id + '"]:gt(0)').remove(); 
				              	});
								listElement
									.find('.list_element').find('.toggle_list_element, .entity_name').click(function(){
										showListElementOccurrences($(this).parent(), listName);
									});
							}
							/* Integration by LS */
					        if ( $("[lang!='"+window.lang.currentLang+"']").length > 0 ) {
					        	window.lang.update(window.lang.currentLang);
					        }
					        /* /end Integration by LS */
					        InitializeRefs();
					        // If chronological index there are no letters
					        if (listName !== 'listDoc') {
					        	$('.list_filter:first').trigger('click');
					        }
						});
					}
				});
				listContainer.find('.list').first().addClass('list_opened').show();
				listContainer.find('.labelList').first().addClass('active');

				if ($.browser.safari) {
					$('#list_header .labelList').css('top', '1px');
				} else if ($.browser.webkit) {
					$('#list_header .labelList').css('top', '-8.5px');
				}
			} else {
				listContainer.remove();
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
					second_page_lab = window.lang.convert('PAGE_MISSING_RIGHT', window.lang.currentLang);
				} else {
					newhash = first_page+"+"+second_page;
				}
				newlab = first_page_lab+second_page_lab;
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
				
				if (typeof(second_page_lab) != 'undefined'){
					newhash = first_page+"+"+second_page;
				} else {
					newhash = first_page;
				}
				var newLab = $(".main_dd_select .option_container .option[data-value='"+newhash+"']").text();
				$(".main_dd_select .label_selected")
					.text(newlab)
					.attr("data-value", newhash)
					.attr("data-first-doc", temp_tt)
				;
				
				updateHash(temp_tt, newhash);
				$(window).hashchange();
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
								temp_tt_val = $(this).parents('.optionGroup').attr('data-doc-group');
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
									temp_tt_val = $(this).parents('.optionGroup').attr('data-doc-group');
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

			/* PAGE SELECT CLICK  */
			bindPPselectClick();

			/* DOCUMENT SELECT CLICK  */
			bindTTselectClick();

			/* EDITION LEVEL SELECT  CLICK / SWITCH ON/OFF REGESTO */
			bindEEselectClick();
			
			/* DOUBLE PAGE SELECT CLICK */
			bindDDselectClick();

			/* FILTER SELECT CLICK */
			bindFilterOptionClick();
			
			/* BIND LIST TOOL SELECT CLICK */
			bindDocListSortSelectClick();

			/* GENERIC SELECT CLICK */
			bindOptionClick();
			
			/* GENERIC SELECT HOVER */
			bindOptionHover();

			$('.like_select').each(function(){
				updateSelectLength(this);
			});
			
			/* BIND GLOBAL WRAPPER MOUSE DOWN EVENT */
			bindGlobarWrapperMouseDown();

			/* CLICK SU SINGOLA THUMBNAIL */
			bindThumbClick();
			
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
				    	bindMsDescBtnClick();
				    }
				    /* Integration by LS */
			        if ($("[lang!='"+window.lang.currentLang+"']").length > 0) {
			        	window.lang.run();
			        }
			        /* /end Integration by LS */
			        resizeGlobalTopBar();
			    });
			}
			
			/* ====================== */
			/* TRANSLATE */
			if (($(xml).find('trad').attr('active')==1)){
			    $('#trad_cont').load("data/output_data/translate/page__translate.html #trad", function(){
			    	if ( $('#trad_cont').is(':empty') ) {
				    	$('#switch_trad, #trad_cont').remove();
				    	resizeButtonsAndSelects();
				    } else {
				    	bindMsDescBtnClick();
				    }
			        resizeGlobalTopBar();
			    });
			}

			/* ============ */
			/* FRONT MATTER */
			if (($(xml).find('headerInfo').length > 0) && ($(xml).find('headerInfo').attr('active')==1)){
			    $('#headerInfo_cont').load("data/output_data/prefatory_matter/header_info.html #headerInfo", function(response, status, xhr){
			    	if(response != undefined) {
				    	/* Integration by LS */
				        if ($("[lang!='"+window.lang.currentLang+"']").length > 0) {
				        	window.lang.run();  
				        }
				        /* /end Integration by LS */
				        
				         /* Integration by IT */
					    $(document).ready(function() {
	                    	$("#headerInfo_nav_tabs").detach().insertBefore('#headerInfo_content');
	                        // $(".box_tab").hide(); 
	                        // $("#headerInfo_nav_tabs li:first").addClass("active").show(); 
	                        // $(".box_tab:first").show(); 

	                        $("#headerInfo_nav_tabs li").click(function() {
	                     		var activeTabTrigger = $("#headerInfo_nav_tabs li.active");
	                     		var activeTab = $(activeTabTrigger.attr('data-tab'));
	                     		activeTab.hide();
	                            // $("#headerInfo_nav_tabs li").removeClass("active"); 
	                            activeTabTrigger.removeClass('active');
	                            $(this).addClass("active"); 
	                            // $(".box_tab").hide(); 
	                     
	                            var activeTab = $(this).find("a").attr("href");
	                            $($(this).attr('data-tab')).show(); 
	                            // return false;
	                        });
	                       	$("#headerInfo_nav_tabs li:first").trigger('click');
	                    });
	                    /* /end Integration by IT */
	                } else {
	                	$('#info_link').remove();
	                }
			    });
			    
			    bindTextInfoBtnClick();

			    bindHeaderInfoBtnClick();

			    resizeGlobalTopBar();
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
						gotopage(current_page, pp_lab, "none");
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
				    resizeButtonsAndSelects();
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
			resizeGlobalTopBar();
		}
	});

	$(document).ready(function(){
		var editionIdentifier = document.getElementById("home_title").textContent.replace(/\s/g, "");
		var welcomeCookie = getCookie('welcome_'+editionIdentifier);
		if (welcomeCookie === undefined || welcomeCookie === '') {
			$('#welcomeInfo_cont').show('fade', 0);
		}

		if ($('#generalBiblio_cont').length == 0) {
			$('#biblio_link').remove();
		}

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
			if ( $(this).find('.option_container .option').length <= 2 ) { 
				// ci sono solo gli elementi "Seleziona tutto" e "Pulisci selezione"
				$(this).remove();
			}
		});

		/* *********************** */
		/* Gestione click e eventi */
		/* *********************** */
		$("#home_title").click(function(){
			window.location="index.html";
		});

		$('#poweredBy').click(function(){
			$('#EVTinfo_cont').show('fade', 0);
		});
		/*= TOGGLE SHORTCUTS =*/
		bindShortcutsBtnClick();
		
		/*= SELECTORS =*/
		bindOpenSelectClick();

		/*= BUTTONS =*/
		bindBtnClick();

		/*= Collapse menus =*/
		bindCollapseMenuBtnClick();
			
		/*= Internal boxes fullscreen =*/
		bindInternalFullscreenBtnClick();
			
		/*= Font size controllers =*/
		bindFontSizeControllerBtnClick();
		
		/*= BIBLIOGRAPHY =*/
		bindBiblioRefClick();
		bindBiblioBtnClick();
		
		/*= FRONT MATTER =*/
		bindToggleFrontBtnClick();

		/*= SEARCH =*/
		bindSearchBtnsClick();
		
		/*= ARROWS NAVIGATION =*/
		bindArrowsBtnsClick();

		/*= LISTS =*/
		bindListsBtnClick();
		bindListsSortingOrderBtnClick(); 
		bindChronologicalIndex();
		showOrHideRegesto();
		bindDocumentLinkChronologicalIndex();

		/*= VIEW MODES =*/
		bindViewModesBtnsClick();	

		/* ****************** */
		/* Integrazione by LS */
		/* ****************** */
		/*= SETTINGS =*/
		bindSettingsBtnClick();

		/*= LANG =*/
		initializeLang();

	    /* *********************** */
		/* /END Integrazione by LS */
		/* *********************** */

		/*= RESIZE =*/
		resizeButtonsAndSelects();
		
		/* ***************************** */
		/* / END Gestione click e eventi */
		/* ***************************** */

		window.onerror = function myErrorHandler(errorMsg, url, lineNumber) {
		    if (errorMsg == 'BigImageError') {
		    	try {
		    		var errorMsg = window.lang.convert('ERROR_LOADING_HI_IMAGE', window.lang.currentLang);
		    		var lens = document.getElementsByClassName('zoomPreload')[0];
            		lens.textContent = errorMsg;
            		if ($('.current_mode').attr('id') === 'txtimg_link' || $('.current_mode').attr('id') === 'imgd_link'){
            			alert(errorMsg);
            		}
            		$('.zoomWrapperImage')
            			.addClass('bigImageError')
            			.attr('data-error-msg', errorMsg);
            		if (magnifierON){
            			document.getElementById('switchMag').click();
            		}
            	} catch(e){}
			} else {
				console.log('Error occurred: '+errorMsg, url, lineNumber);
			}
		    return true;
		}
	});	
});

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
} 

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return '';
}