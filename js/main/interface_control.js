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

$( function() {

	$.ajax({
		type: "GET",
		url: "data/output_data/structure.xml",
		dataType: "xml",
		success: function(xml) {
			
			//Edition
			$(xml).find('editions edition').each(function(){
				var current_id = $(this).attr("n");
				var current_label = $(this).text();
				$('.main_ee_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_label)
				);
			});
			$(".main_ee_select .option_container div:first-child").addClass( "selected" );

			$('.main_ee_select .label_selected')
				.text($('.main_ee_select .option_container div:first').text());

			//Page
			$(xml).find('pages pair pb').each(function(){
				var current_id = $(this).text();
				$('.main_pp_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_id)
				);
			});
			$('.main_pp_select .option_container div:first-child').addClass('selected');
			$('.main_pp_select .label_selected')
				.text($('.main_pp_select .option_container div:first').text());

			//Page_dd
			$(xml).find('pages pair').each(function(){
				var first_page_d = $(this).children('pb').eq(0).text();
				var second_page_d = $(this).children('pb').eq(1).text();
				var current_id = "";
				if (second_page_d != "")
					current_id = first_page_d+"-"+second_page_d;
				else
					current_id = first_page_d;
				$('.main_dd_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_id)
				);
			});
			$('.main_dd_select .option_container div:first-child').addClass('selected');
			$('.main_dd_select .label_selected')
			 	.text($('.main_dd_select .option_container div:first').text());

			//Text
			$(xml).find('textpage text').each(function(){
				var current_id = $(this).attr("n");
				$('.main_tt_select .option_container').append(
					$('<div/>')
						.attr("id", "value_"+current_id)
						.addClass('option')
						.text(current_id)
				);
			});
			$('.main_tt_select .option_container div:first-child').addClass('selected');
			$('.main_tt_select .label_selected')
				.text($('.main_tt_select .option_container div:first').text());	

			/* Gestione eventi */

			$(".label_selected").on('change',function(){
				var current_lab = $(this).text();
				$(this).siblings(".option_container")
					.find("#value_"+current_lab)
					.addClass("selected")
					.siblings().removeClass('selected');
			});

			$(".main_ee_select .label_selected").on('change',function(){
			     var temp_frame = "";
			     var temp_parent = "";
			     if($(this).parent().parent().attr("id") == "span_ee_select-add"){
			     	temp_frame = "text_elem-add";
			     	temp_parent = "text_cont-add";
			     } else{
			     	temp_frame = "text_elem";
			     	temp_parent = "text_cont";
			     }
			     gotoedition(location.hash.replace( /^#/, '' ),$(this).text().toLowerCase(),temp_frame,temp_parent);
			});		
			$(".main_pp_select .label_selected").on('change',function(){
			     var tt_val_temp = $(".main_tt_select .label_selected").text();
			     var pp_val_temp = $('.main_pp_select .label_selected').text();
			     var parent_temp = $(xml)
			     	.find('text pb:contains('+pp_val_temp+')')
			     	.parent()
			     	.attr("n");
			     if(!parent_temp)
			     	$(".main_tt_select .label_selected").text("(Text)");
			     else
				     if(parent_temp!=tt_val_temp){
				     	$(".main_tt_select .label_selected").text(parent_temp).trigger("change");
			     	}

			     var newhash = $(this).text()
			     window.location.hash = newhash;

			});

			$(".main_tt_select .label_selected").on('change',function(){
				var tt_val_temp = $(this).text();
			    var first_page = $(xml)
	     			.find('text[n='+tt_val_temp+']')
			     	.find(":first-child")
			     	.text();
			    $(".main_pp_select .label_selected").text(first_page).trigger("change");
			});

			$(".open_select").click(function(){
				if (!($(".option_container").is(':animated'))){
					if($('.option_container:visible').parents('.like_select').attr('id')!=$(this).parents('.like_select').attr('id'))
						$('.option_container:visible').animate({height:"toggle"}, 400);
					$(this).siblings('.option_container').animate({height:"toggle"}, 400);
				}
			});
			$(".option").click(function(){
				if(! $(this).hasClass('selected')){
					var newPage = $(this).attr('id').substr(6); 
					$(this).parent().prev().prev().text(newPage).trigger('change'); // .label_selected
					$(this).parent().animate({height:"toggle"}, 400);
					//$("#value_" + newPage).addClass("selected").siblings().removeClass('selected');
				}
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

		function gotopaged(pp_val){
			

			$("#iviewerImage").attr("src", "images/null.jpg"); // Loading...
			//$("#value_" + pp_val).addClass("selected").siblings().removeClass('selected');

			$('#folio_page_number').val(pp_val).change(); // IT: Questo attiva l'evento nel file js/plugin/jquery.iviewer config

			// IT: Se ci si trova nella modalit Thumb, chiude la schermata e visualizza l'immagine
			if($("#image_elem").css('display')=="none"){
				$("#image_elem").show();
				$("#image_tool").show();
				$("#thumb_cont").hide();
			}			

		}

		// IT: Gestiosce il cambio pagina e gli eventi correlati
		function gotopage(pp_val, state){	
		
			var edition=$("#span_ee_select .main_ee_select .label_selected").text().toLowerCase();	

			$(".main_pp_select .label_selected").text(pp_val).trigger("change");
			
			$('#text_elem').load("data/output_data/"+edition+"/page_"+pp_val+"_"+edition+".html #text_frame");
			
			/*$('#text_elem').load('pagina.html', function() {
			  alert('Load was performed.');
			});*/
			
			// IT: Aggiorna l'indirizzo del frame secondario per il testo
			if ($("#text_cont-add").length > 0){ //SISTEMARE
				var edition_add=$("#span_ee_select-add .option_container .option.selected").text().toLowerCase();			
	
				$('#text_elem-add').load("data/output_data/"+edition_add+"/page_"+pp_val+"_"+edition_add+".html #text_frame");
					
				// IT: Aggiorna le informazioni all'interno dell'etichetta destra	
				$('#zvalopz')
					.text($("input[name=edition_r-add]:checked").val())
					.hide()
					.fadeIn(200);	
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
				$("#imgd_link").removeClass("current_mode");
				$("#imgimg_link").removeClass("current_mode");
				$("#txttxt_link").removeClass("current_mode");

				//$("#image_cont-add").remove();
				$("#text_cont-add").remove();
				$("#span_ee_select-add").hide();

				$("#main_right_frame").show();
				$("#main_left_frame").animate({
		            'width': '49.8%', 
		        }, function(){
		        	$("#text_menu").show();
					$("#text_cont").show();
		        });				
				
				
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
				$("#imgd_link").removeClass("current_mode");
				$("#txtimg_link").removeClass("current_mode");
				$("#imgimg_link").removeClass("current_mode");

				$("#image_menu").hide();
				$("#mag").hide();
				$("#image_cont").hide(); 
				

				$("#main_right_frame").show();
				$("#main_left_frame").animate({
		            'width': '49.8%', 
		        }, function(){
		        	$("#text_menu").show();
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

				$('#zvalint').hide(); //SISTEMARE
				//$('#zvalopz').text($("input[name=edition_r]:checked").val());			

				$("#span_ee_select-add").show();

				var main_text_edition = $('#span_ee_select .main_ee_select .label_selected').text();
				var first_new_edition = $('.main_ee_select .option_container').children('.option').eq(0).text();
				var second_new_edition = $('.main_ee_select .option_container').children('.option').eq(1).text();
				if (main_text_edition == first_new_edition){
					$("#span_ee_select-add .main_ee_select .label_selected").text(second_new_edition).trigger("change"); 
				} else{
					$("#span_ee_select-add .main_ee_select .label_selected").text(first_new_edition).trigger("change");
				}
			}
		});

		$("#imgd_link").click(function(){	
			if($(this).attr("class")!="current_mode"){
				$("#imgd_link").addClass("current_mode");
				$("#txtimg_link").removeClass("current_mode");
				$("#imgimg_link").removeClass("current_mode");
				$("#txttxt_link").removeClass("current_mode");


				$("#text_menu").hide();
				$("#main_left_frame").animate({
		            'width': '99.5%', 
		        }, function(){
		             $("#main_right_frame").hide();	
		        });				
		

				//$("#image_cont-add").remove();
				$("#text_cont-add").remove();
				$("#span_ee_select-add").hide();

				//$("#text_cont").hide();

				$("#mag").show();				
				$("#image_menu").show();
				$("#image_cont").show();
				$("#span_dd_select").show();
				
				
			}
		});	
		// /MODE -
		
		/*$("#text_copy").live("click", function(){
			..codice qui..
		});*/	
	
	/* / Gestione key press */
	$(document).keydown(function(e){	
			// Toggle Full screen img * PRESS F *
			if ((e.keyCode == 70)&&(!$("#main_right_frame").hasClass('full'))){
				$("#main_left_frame").toggleClass("full");
				if($('#main_left_frame').hasClass('full')){
					var height_full = ($(window).height()>$("body").height()) ? $(window).height()-4 : $("body").height();
					var width_full = $(window).width()-4; /* "-4" perché il box ha bordo 2px */
					var margin_left = -($('#main_left_frame').offset().left);
					var margin_top = -($('#main_left_frame').offset().top);
					$('#main_left_frame').animate({
						width: width_full,
						height: height_full,
						top: margin_top,
						left: margin_left,
						minWidth: "1021px"
					}, 700);
				} else {
					if($('#main_right_frame').css("display")=="none"){
						$('#main_left_frame').animate({
							width: "99.5%", 
							height: "100%", 
							top: "0px", 
							left: "0px", 
							minWidth: "0px"
						}, 700);
					} else {
						$('#main_left_frame').animate({
							width: "49.8%",
							height: "100%",
							top: "0px",
							left: "0px",
							minWidth: "0px"
						}, 700);
					}
				}
				$(".top_image_tools").toggle("bind");
			}

			// Toggle Full screen textRight * PRESS G *
			if ((e.keyCode == 71)&&(!$("#main_left_frame").hasClass('full'))){
				$("#main_right_frame").toggleClass("full");
				if($('#main_right_frame').hasClass('full')){
					var height_full = ($(window).height()>$("body").height()) ? $(window).height()-4 : $("body").height();
					var width_full = $(window).width()-4; /* "-4" perché il box ha bordo 2px */
					var margin_left = -($('#main_right_frame').offset().left);
					var margin_top = -($('#main_right_frame').offset().top);
					$('#main_right_frame').animate({
						width: width_full,
						height: height_full,
						marginTop: margin_top,
						left: margin_left,
						minWidth: "1021px"
					}, 700);
				} else {
					$('#main_right_frame').animate({
						width:  "49.7%",
						height: "100%", 
						marginTop: "0px", 
						left: "0px", 
						minWidth: "0px"
					}, 700, function(){
						$('#main_right_frame').removeAttr("style");
					});
				}
			}

			// Hide/show left-header * PRESS L *
			if (e.keyCode == 76){
				$('#left_header').toggle('blind').toggleClass('menuClosed');
				if($('#left_header').hasClass('menuClosed')){
					noMenu_height = $('#image_cont').height()+50;
					$('#image_cont').animate({
						top: "-50px",
						height: noMenu_height
					});
				} else {
					noMenu_height = $('#image_cont').height()+50;
					$('#image_cont').animate({
						top: "0px",
						height: "100%"
					});
				}
			}

			// Hide/show right-header * PRESS R * 
			if (e.keyCode == 82){
				$('#right_header').toggle('blind').toggleClass('menuClosed');
				if($('#right_header').hasClass('menuClosed')){
					$('#text_cont').animate({
						height: "100%"
					});
				} else {
					noMenu_height = $('#image_cont').height()+50;
					$('#text_cont').animate({
						height: "92.8%"
					});
				}
			}
		});

});
