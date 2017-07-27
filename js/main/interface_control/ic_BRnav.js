// Funzione al click su ImgTxt
function createSliderTxtImg() {
	var arrayPages = [];  // Array che conterrà il numero delle pagine
	if($('.main_pp_select')) {
		$('.main_pp_select .option_container .optionGroup div').each(function() {
			var val_page = $(this).attr('data-value');
			//alert(val_page);
			//var val_page = $(this).text();
			arrayPages.push(val_page); // Lo mette nell'array
		});
	createBrnav(arrayPages);  // Restituisce l'array contenente le pagine
	}
}

// Funzione al click su Bookreader
function createSliderBookreader() {
	var val_pages;
	var arrayPagePairs = [];
	if($('.main_dd_select')) { 
		$('.main_dd_select .option_container .option').each(function() {
			val_pages = $(this).attr('data-value');
			//val_pages = $(this).text();
			//alert(val_pages);
			arrayPagePairs.push(val_pages);
		});
	createBrnav(arrayPagePairs);
	}
}

// Funzione per creare lo slider (gli viene passato l'array a seconda che è stata cliccata un tipo di modalità)
function createBrnav(array) {
	//alert(array);
	$("#pagenum").text(array[0] + "/" + array[array.length-1]); // Mostra il numero della pagina sul totale della pagine
	$('#BRpager').slider({
        min: 0,
        max: array.length-1,
		/*slide: function(event, ui) {  // E' lanciato durante il trascinamento del cursore
			$("#pagenum").text(array[ui.value] + "/" + array[array.length-1]);
		},*/
		change: function(event, ui) {
			//alert(ui.value);
			if ( !$("#imgd_link").hasClass("current_mode")) {
				if (groupingPagesByDoc) {
					var current_opt = $('.main_pp_select .option_container .option.selected:first');
					var current_pp = current_opt.attr("data-value"); // Pagina corrente					
					var newPage = array[ui.value]; // Elemento dell'array di indice ui.value (sarà quello su cui si sposta lo slider)
					//alert(newPage);
					
					if(current_opt.siblings().hasClass('option')) {
						var new_pp_opt = $("div[data-value='"+newPage+"'"+"]");  // La variabile prende il div con attributo fol_+newPage (cioè la nuova pagina)
					}
				}
					
				if(new_pp_opt != null) {
					var new_tt_val = new_pp_opt.attr('data-first-doc');
				}
				
			}else{
				$('#span_dd_select .label_selected').attr('data-last-hash-txtimg', '');
				current_opt = $('.main_dd_select .option_container .option.selected');
				current_pp = current_opt.attr('data-value');				
				var newPage = array[ui.value];
				//alert(newPage);				
				
				//newPage = newPage.replace(" - ", "+fol_"); // Sostituisco (ad esempio 214v - 215r con 241v+fol_215r)
				if(current_opt.siblings().hasClass('option')) {
					var new_pp_opt = $("div[data-value='"+newPage+"'"+"]");  // La variabile prende il div con attributo fol_+newPage (cioè la nuova pagina)
				}
				
				if(new_pp_opt != null) {
					new_tt_val = new_pp_opt.attr('data-first-page-first-doc');
				}				
			}
			
			if (new_pp_opt != null) {
				new_pp_val = new_pp_opt.attr('data-value'); // Pagina risultante dallo slider
				//alert(new_pp_val);
        
				var current_tt_val = $(".main_tt_select .label_selected").attr("data-value"); 
				var current_tt_first_page = $(".main_tt_select .option_container .option.selected").attr('data-first-page');
				if(current_tt_first_page === new_pp_val) {
					updateHash(current_tt_val, new_pp_val, "");  // Aggiorno la hash
				}else{
					updateHash(new_tt_val, new_pp_val, "");
				}
			}
			$("#pagenum").text(array[ui.value] + "/" + array[array.length-1]); 
		}
	});
}

function bindArrowsBRnavClick() {
	// Pulsante per ridurre la barra di navigazione
	$('.BRnavCntl').click(
        function(){
            if ($('#BRnavCntlBtm').hasClass('BRdn')) {
                $('#BRnav').delay(150).animate({bottom:-55});
				$('#central_wrapper').animate({height:"87.5%"}, 1000);  // Aumento l'altezza del central_wrapper
                $('#BRnavCntlBtm').addClass('BRup').removeClass('BRdn');
				$('#BRnavCntlBtm i').removeClass('fa fa-caret-down fa-lg').addClass('fa fa-caret-up fa-lg');  // Rimuove la classe per mettere quella con la freccia verso il basso
                $('#BRnavCntlTop').addClass('BRdn').removeClass('BRup');
				$('#BRnavCntlTop i').addClass('fa fa-caret-down fa-lg').removeClass('fa fa-caret-up fa-lg');
                $('#BRnavCntlBtm.BRnavCntl').animate({height:'45px'});
                $('.BRnavCntl').delay(1000).animate({opacity:.25},1000);
            } else {
                $('#BRnav').delay(350).animate({bottom:0});  // .delay() ritarda l'animazione degli elementi seguenti
				$('#central_wrapper').animate({height:"82.5%"}, 1000);  // Riduco l'altezza del central_wrapper
                $('#BRnavCntlBtm').addClass('BRdn').removeClass('BRup');
				$('#BRnavCntlBtm i').removeClass('fa fa-caret-up fa-lg').addClass('fa fa-caret-down fa-lg');
                $('#BRnavCntlTop').addClass('BRup').removeClass('BRdn');
				$('#BRnavCntlTop i').addClass('fa fa-caret-up fa-lg').removeClass('fa fa-caret-down fa-lg');
                $('#BRnavCntlBtm.BRnavCntl').animate({height:'30px'});
                $('.BRvavCntl').animate({opacity:1})
            };
        }
    );
    $('#BRnavCntlBtm').mouseover(function(){
        if ($(this).hasClass('BRup')) {
            $('.BRnavCntl').animate({opacity:1},250);
        };
    });
    $('#BRnavCntlBtm').mouseleave(function(){
        if ($(this).hasClass('BRup')) {
            $('.BRnavCntl').animate({opacity:.25},250);
        };
    });
    $('#BRnavCntlTop').mouseover(function(){
        if ($(this).hasClass('BRdn')) {
            $('.BRnavCntl').animate({opacity:1},250);
        };
    });
    $('#BRnavCntlTop').mouseleave(function(){
        if ($(this).hasClass('BRdn')) {
            $('.BRnavCntl').animate({opacity:.25},250);
        };
    });
}