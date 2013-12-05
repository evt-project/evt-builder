/**
 * 
 * Interface Control jQuery
 * Version 0.1 (201210)
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * 
 * @author RafMas 
 * @since 2012
 *
 **/

$( function() {

	$.ajax({
		type: "GET",
		url: "data/output_data/structure.xml",
		dataType: "xml",
		success: function(xml) {
			
			//Edition
			$(xml).find('editions edition').each(function(){
				//alert($(this).text());
				var current_id = $(this).attr("n");
				var current_label = $(this).text();
				$('.main_ee_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_label)
				);
			});
			$('.main_ee_select .option_container div:first').addClass('selected');
			$('.main_ee_select .label_selected')
				.text($('.main_ee_select .option_container div:first').text());

			//Page
			$(xml).find('textpage text pb').each(function(){
				var current_id = $(this).attr("n");
				var current_label = $(this).text();
				$('.main_pp_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_label)
				);
			});
			$('.main_pp_select .option_container div:first').addClass('selected');
			$('.main_pp_select .label_selected')
				.text($('.main_pp_select .option_container div:first').text());


			//Text
			$(xml).find('textpage text').each(function(){
				var current_id = $(this).attr("n");
				//var current_label = $(this).text();
				$('.main_tt_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_id)
				);
			});
			$('.main_tt_select .option_container div:first').addClass('selected');
			$('.main_tt_select .label_selected')
				.text($('.main_tt_select .option_container div:first').text());	

			/* Gestione eventi */

			// riferimento a .trigger('change')
			$(".main_ee_select .label_selected").on('change',function(){
			     //alert($('.main_ee_select .label_selected').text()); 
			     gotoedition(location.hash.replace( /^#/, '' ),$(this).text().toLowerCase(),"text_elem", "text_cont");
			});
			$(".main_ee_select-add .label_selected").on('change',function(){
			    gotoedition(location.hash.replace( /^#/, '' ),$(this).text().toLowerCase(),"text_elem-add", "text_cont-add");
			});
			$(".main_pp_select .label_selected").on('change',function(){
			     //alert($('.main_pp_select .label_selected').text()); 
			     var tt_val_temp = $(".main_tt_select .label_selected").text();
			     var pp_val_temp = $('.main_pp_select .label_selected').text();
			     var parent_temp = $(xml)
			     	.find('text pb:contains('+pp_val_temp+')')
			     	.parent()
			     	.attr("n");
			     if(parent_temp!=tt_val_temp){
			     	$(".main_tt_select .label_selected").text(parent_temp).trigger('change');
			     }
			     
			     var newhash = $(this).text()
			     window.location.hash = newhash;
			     $("#value_" + newhash).addClass("selected").siblings().removeClass('selected');

			});
			$(".main_tt_select .option_container .option").click(function(){
			    // alert($('.main_tt_select .label_selected').text()); 
				var tt_val_temp = $(this).text();
			    var first_page = $(xml)
	     			.find('text[n='+tt_val_temp+']')
			     	.find(":first-child")
			     	.text();
			    gotopage(first_page, "none");
			});

			$(".open_select").click(function(){
				if($('.option_container:visible').parents('.like_select').attr('id')!=$(this).parents('.like_select').attr('id'))
					$('.option_container:visible').animate({height:"toggle"}, 400);
				$(this).siblings('.option_container').animate({height:"toggle"}, 400);
			});
			$(".option").click(function(){
				var newPage = $(this).attr('id').substr(6); 
				$(this).parent().prev().prev().text(newPage).trigger('change'); // .label_selected
				$(this).parent().animate({height:"toggle"}, 400);
			});

			$(document).on('mousedown', function (e) {
			    if ($(e.target).closest(".like_select").length === 0) {
			        $('.option_container:visible').animate({height:"toggle"}, 400);
			    }
			});

			/* / Gestione eventi */


			/* HASH CHANGE - ba.bbq plugin */
				// IT: Associa un evento a windows.onhashchange; quando l'hash cambia, ottiene il suo valore per usarlo in diverse funzioni
				$(window).hashchange( function(){
					var hash = location.hash;
					var current_page = hash.replace( /^#/, '' );
					var checkpp = $(xml).find('text pb:contains('+current_page+')').text();

					if(hash && (checkpp != "")){
					    UnInitialize(); //Add by JK for ITL
						gotopage(current_page, "none");
						chooseZoomMag(); //Add by JK for Mag
						
					}else{
						window.location.hash=$(".main_pp_select .label_selected").text();
					}
					// IT: Cambia il titolo della pagina in base all'hash
					//document.title = 'The hash is ' + ( hash.replace( /^#/, '' ) || 'blank' ) + '.';
				})
				// IT: L'evento viene attivato quando cambia l'hash della pagina
				$(window).hashchange();
			/* / HASH CHANGE - ba.bbq plugin */
		}
	});


	//---

	// IT: Setting variabili generiche
	var keycount=0;
	var fulltogg=false;
	//var pp_temp_val=$(".main_pp_select").val();
	
	// IT: Imposta l'etichetta dell'edizione, al primo caricamento della index
	//$('#edval span').text($("input[name=edition_r]:checked").val());	
	
	
	/* Funzioni */

		// IT: Gestiosce il cambio pagina e gli eventi correlati
		function gotopage(pp_val, state){
			//var edition=$("input[name=edition_r]:checked").val().toLowerCase();						
			var edition=$(".main_ee_select .label_selected").text().toLowerCase();	

			$(".main_pp_select .label_selected").text(pp_val).trigger('change');
			$("#value_" + pp_val).addClass("selected").siblings().removeClass('selected');				

			
			$('#text_elem').load("data/output_data/"+edition+"/page_"+pp_val+"_"+edition+".html #text_frame");
			
			/*$('#text_elem').load('pagina.html', function() {
			  alert('Load was performed.');
			});*/
			
			// IT: Aggiorna l'indirizzo del frame secondario per il testo
			if ($("#text_cont-add").length > 0){ //SISTEMARE
				var edition_add=$("input[name=edition_r-add]:checked").val().toLowerCase();			
				
				/* Gestione iframe secondario - rimosso
				$('#text_elem-add').remove();
				$('<iframe id="text_elem-add" class="scroll-ios">').appendTo('#text_cont-add');
				$("#text_elem-add")
					.attr("src", "data/"+edition_add+"/page_"+pp_val+"_"+edition_add+".html")
					.hide()
					.fadeIn(400);
				*/	
				$('#text_elem-add').load("data/output_data/"+edition_add+"/page_"+pp_val+"_"+edition_add+".html #text_frame");
					
				// IT: Aggiorna le informazioni all'interno dell'etichetta destra	
				$('#zvalopz')
					.text($("input[name=edition_r-add]:checked").val())
					.hide()
					.fadeIn(200);	
				//$('input[name=edition_r-add]').prop('checked', false);
			} else {
				// IT: Aggiorna le informazioni all'interno dell'etichetta destra	
				$('#zval>span')
					.hide()
					.fadeIn(200);			
			}
			
			// IT: Aggiorna le informazioni all'interno delle etichette			
			$('#central_page_number span').text(pp_val);
			/*$('#edval span')
				.hide()
				.fadeIn(200);*/

			$("#iviewerImage").attr("src", "images/null.jpg"); // Loading...
			$('#folio_page_number').val(pp_val).change(); // IT: Questo attiva l'evento nel file js/plugin/jquery.iviewer config
			
			preload([
				'images/'+$('.main_pp_select .option_container .option.selected').prev().text()+'.jpg',
				'images/'+$('.main_pp_select .option_container .option.selected').next().text()+'.jpg'
			]);

			// IT: Se ci si trova nella modalit Thumb, chiude la schermata e visualizza l'immagine
			if($("#image_elem").css('display')=="none"){
				$("#image_elem").show();
				$("#image_tool").show();
				$("#thumb_cont").hide();
			}			
		}
		// IT: Gestisce il cambio edizione nel frame testuale
		function gotoedition(pp_val, pp_el, frame_id, parent_id){
			//$('#'+frame_id).remove();
			//$('<iframe id="'+frame_id+'">').appendTo('#'+parent_id);
			//$('#'+frame_id)
			//	.attr("src", "data/"+pp_el+"/page_"+pp_val+"_"+pp_el+".html");/*
			//	.hide()
			//	.fadeIn(800);*/
			UnInitialize(); //Add by JK for ITL
			$('#'+frame_id).load("data/output_data/"+pp_el+"/page_"+pp_val+"_"+pp_el+".html #text_frame");
			var pp_el_upp = pp_el;
			pp_el_upp = pp_el_upp.toLowerCase().replace(/\b[a-z]/g, function(letter) {
				return letter.toUpperCase();	
			});
		    setTimeout(function(){ var prova = document.getElementById("switchITL").getAttribute('src'); //Add by JK for ITL
		       if (prova=='images/ITLon.png'){Initialize();};},100); //Add by JK for ITL

			// IT: Gestisce la scrittura nell'etichetta destra o sinistra a seconda del frame caricato
			if (frame_id.indexOf("-add")>-1) {
				$('#zvalopz').text(pp_el_upp);
			} else{
				$('#edval span').text(pp_el_upp);
			}
		}
		// IT: Un preload basilare per la navigazione delle immagini
		function preload(arrayOfImages) {
			$(arrayOfImages).each(function(){
				$('<img/>')[0].src = this;
			});
		}	
	/* / Funzioni */
	
	/* Gestione eventi */
		// IT: Principale per il cambio pagina: attiva l'evento al cambio hash
		/*$('.main_pp_select').change(function(){
			//gotopage($(this).val(), "none");
			window.location.hash = $(this).val();
			//setallselect($(this).val());		
		});*/		

		// IT: Ingresso e uscita dal riquadro immagine
		/*
		$("#image_cont").mouseenter(function(){
			if($("#image_elem").css('display')!="none"){
				$("#image_tool").show("slow");
				keycount=1;		
			}
		});		
		$("#image_cont").mouseleave(function(){  
			$("#image_tool").hide("slow");
			keycount=0;
		});
		*/
	/* / Gestione eventi */
	
	
	/* Gestione click */
		$("#home_title").click(function(){
			window.location="index.html";
		});		
		
		$("#main_left_arrow").click(function(){
			if($('.main_pp_select .option_container .option.selected').prev().text()){
				window.location.hash = $('.main_pp_select .option_container .option.selected').prev().text();
				//$("#main_left_arrow").trigger('click');
			}		
		});		
		$("#main_right_arrow").click(function(){
			if($('.main_pp_select .option_container .option.selected').next().text()){
				window.location.hash = $('.main_pp_select .option_container .option.selected').next().text();
				//$("#main_right_arrow").trigger('click');
			}
		});
		
		$("#main_left_menu").click(function(){
			if($("#main_left_menu-openlink").css('display')!="none"){					
				$("#main_left_frame header").show('slide', {direction: 'left'}, 1000);
				$("#main_left_frame-single header").show('slide', {direction: 'left'}, 1000);
				$("#main_left_menu-openlink").toggle();
				$("#main_left_menu-closelink").toggle();	
				keycount=1;
			} else{
				$("#main_left_frame header").hide('slide', {direction: 'left'}, 1000);
				$("#main_left_frame-single header").hide('slide', {direction: 'left'}, 1000);
				$("#main_left_menu-openlink").toggle();
				$("#main_left_menu-closelink").toggle();	
				keycount=0;
			}
		});
				
		$("#main_right_menu").click(function(){
			if($("#main_right_menu-openlink").css('display')!="none"){
				$("#main_right_frame header").show('slide', {direction: 'right'}, 1000);
				$("#main_right_menu-openlink").toggle();
				$("#main_right_menu-closelink").toggle();
				keycount=0;
			} else{
				$("#main_right_frame header").hide('slide', {direction: 'right'}, 1000);
				$("#main_right_menu-openlink").toggle();
				$("#main_right_menu-closelink").toggle();	
				keycount=1;
			}
		});							

		$("#thumb_link").click(function(){				
			if (magnifierON==false){  //modalità zoom attivo JK
                if($("#image_elem").css('display')=="none"){
				    $("#image_elem").show();
				    $("#image_tool").show();
				    $("#thumb_cont").hide();
			    } else{
				    $("#image_elem").hide();
				    $("#image_tool").hide();
				    $("#thumb_cont").show();
				}
			}else {                  //modalità magnifier attivo JK
			    if($("#mag_image_elem").css('display')=="none"){
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
			window.location.hash = $(this).attr('id').replace( '_small', '' );
			$("#thumb_link").trigger('click');
			if($("#main_right_frame header").css('display')!="none"){
				$("#main_right_menu").trigger('click');
			}
			
		});	
		
		// MODE -
		$("#txtimg_link").click(function(){
			if($(this).attr("class")!="current_mode"){
				$("#txtimg_link").addClass("current_mode");
				$("#imgimg_link").removeClass("current_mode");
				$("#txttxt_link").removeClass("current_mode");

				//$("#image_cont-add").remove();
				$("#text_cont-add").remove();
				$("#span_ee_select-add").remove();
				
				$("#text_menu").show();
				$("#text_cont").show();
				$("#mag").show();				
				$("#image_menu").show();
				$("#image_cont").show();
				
				$('#zvalint').show();
				$('#zvalopz').text("");
				
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
			if($(this).attr("class")!="current_mode"){
			    UnInitialize();//Add by JK for ITL
			    document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');//Add by JK for ITL
				$("#txttxt_link").addClass("current_mode");
				$("#txtimg_link").removeClass("current_mode");
				$("#imgimg_link").removeClass("current_mode");

				$("#image_menu").hide();
				$("#mag").hide();
				$("#image_cont").hide(); 

				$('#text_cont')
					.clone()
					.attr("id", "text_cont-add")
					.insertAfter("#left_header")
				;
				$('#text_cont-add>#text_elem')
					.attr("id", "text_elem-add")
				;

				$('#zvalint').hide();
				$('#zvalopz').text($("input[name=edition_r]:checked").val());				
							
				$('#span_ee_select')
					.clone()
					.attr("id", "span_ee_select-add")
					.appendTo("#left_header")
				;		
				$('#span_ee_select-add .main_ee_select')
					.attr("class", ".main_ee_select-add");
				
				$('#span_ee_select-add').find(".open_select").click(function(){
					if($('.option_container:visible').parents('.like_select').attr('id')!=$(this).parents('.like_select').attr('id'))
						$('.option_container:visible').animate({height:"toggle"}, 400);
					$('#span_ee_select-add').find('.option_container').animate({height:"toggle"}, 400);
				});
				$('#span_ee_select-add').find(".option").click(function(){
					var newPage = $(this).attr('id').substr(6); 
					$(this).parent().prev().prev().text(newPage).trigger('change'); // .label_selected
					$(this).parent().animate({height:"toggle"}, 400);
				});
				//$('#radio_edition-add>input[name="edition_r"]').each(function(index) {
				/*$('#span_ee_select-add .main_ee_select .option_container .option').each(function(index) {
					this.name = this.name + "-add";
					//SISTEMARE
				});*/
			}
		});	
		// /MODE -
		
		/*$("#text_copy").live("click", function(){
			..codice qui..
		});*/	
	/* / Gestione click */

});
