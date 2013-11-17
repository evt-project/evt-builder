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

	// IT: Setting variabili generiche
	var keycount=0;
	var fulltogg=false;
	var pp_temp_val=$(".main_pp_select").val();
	
	// IT: Imposta l'etichetta dell'edizione, al primo caricamento della index
	$('#edval span').text($("input[name=edition_r]:checked").val());	
	
	
	/* Funzioni */
		// IT: Cicla e setta i valori di tutti i select di classe .main_pp_select
		function setallselect(pp_num){
			$(".main_pp_select").each(function(){
				$(this).val( pp_num );
			});
		}	
		// IT: Gestiosce il cambio pagina e gli eventi correlati
		function gotopage(pp_val, state){
			var edition=$("input[name=edition_r]:checked").val().toLowerCase();						
				
			// IT: Aggiorna l'indirizzo dell'iFrame per il testo
			
			//Gestione iFrame - rimosso
			/*$('#text_elem').remove();
			$('<iframe id="text_elem" class="scroll-ios">').appendTo('#text_cont');
			$("#text_elem")
				.attr("src", "data/"+edition+"/page_"+pp_val+"_"+edition+".html")
				.hide()
				.fadeIn(400);
			*/
			
			$('#text_elem').load("data/output_data/"+edition+"/page_"+pp_val+"_"+edition+".html #text_frame");
			/*$('#text_elem').load('pagina.html', function() {
			  alert('Load was performed.');
			});*/
			
			// IT: Aggiorna l'indirizzo del frame secondario per il testo
			if ($("#text_cont-add").length > 0){
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
			$('#central_page_number span').text(pp_val).hide()
				.fadeIn(200);
			$('#edval span')
				.hide()
				.fadeIn(200);

			$("#iviewerImage").attr("src", "images/null.jpg"); // Loading...
			$('#folio_page_number').val(pp_val).change(); // IT: Questo attiva l'evento nel file js/plugin/jquery.iviewer
			
			preload([
				'images/'+$('.main_pp_select option:selected').prev('option').val()+'.jpg',
				'images/'+$('.main_pp_select option:selected').next('option').val()+'.jpg'
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
		$('.main_pp_select').change(function(){
			//gotopage($(this).val(), "none");
			window.location.hash = $(this).val();
			//setallselect($(this).val());		
		});

		// IT: Switch edizioni
		$('input[name=edition_r]').change(function(){
			gotoedition(location.hash.replace( /^#/, '' ),$(this).val().toLowerCase(),"text_elem", "text_cont");
		});	

		// IT: Viene utilizzata la modalit live per rilevare il cambiamento di elementi aggiunti dinamicamente alla pagina			
		$("input[name=edition_r-add]").live("change", function(){
			gotoedition(location.hash.replace( /^#/, '' ),$(this).val().toLowerCase(),"text_elem-add", "text_cont-add");
		});			

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
			if($('.main_pp_select option:selected').prev('option').val()){
				window.location.hash = $('.main_pp_select option:selected').prev('option').val();
				//$("#main_left_arrow").trigger('click');
			}		
		});		
		$("#main_right_arrow").click(function(){
				if($('.main_pp_select option:selected').next('option').val()){
					window.location.hash = $('.main_pp_select option:selected').next('option').val();
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
				$("#radio_edition-add").remove();
				
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
					.insertAfter("#right_header")
				;
				$('#text_cont-add>#text_elem')
					.attr("id", "text_elem-add")
				;

				$('#zvalint').hide();
				$('#zvalopz').text($("input[name=edition_r]:checked").val());				
							
				$('#radio_edition')
					.clone()
					.attr("id", "radio_edition-add")
					.appendTo("#right_header")
				;		
				
				$('#radio_edition-add>input[name="edition_r"]').each(function(index) {
					this.name = this.name + "-add";
				});
			}
		});	
		// /MODE -
		
		/*$("#text_copy").live("click", function(){
			..codice qui..
		});*/	
	/* / Gestione click */

	/* HASH CHANGE - ba.bbq plugin */
		// IT: Associa un evento a windows.onhashchange; quando l'hash cambia, ottiene il suo valore per usarlo in diverse funzioni
		$(window).hashchange( function(){
			var hash = location.hash;

			if(hash){
			    UnInitialize(); //Add by JK for ITL
				gotopage(hash.replace( /^#/, '' ), "none");
				setallselect(hash.replace( /^#/, '' ));
				chooseZoomMag(); //Add by JK for Mag
				
			}else{
				window.location.hash=$(".main_pp_select option:first").val();
			}
			// IT: Cambia il titolo della pagina in base all'hash
			//document.title = 'The hash is ' + ( hash.replace( /^#/, '' ) || 'blank' ) + '.';
		})
		// IT: L'evento viene attivato quando cambia l'hash della pagina
		$(window).hashchange();
	/* / HASH CHANGE - ba.bbq plugin */
});
