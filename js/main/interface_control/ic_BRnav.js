// Funzione al click su ImgTxt
function createSliderTxtImg() {
	var arrayPages = []; // Array che conterrà il numero delle pagine
	if ($('.main_pp_select')) {
		$('.main_pp_select .option_container .optionGroup div').each(function() {
			var pageId = $(this).attr('data-value');
			var pageLabel = $(this).text();
			var docId = $(this).attr('data-first-doc');
			arrayPages.push({
				id: pageId,
				label: pageLabel,
				firstDoc: docId
			}); // Lo mette nell'array
		});
		createBrnav(arrayPages); // Restituisce l'array contenente le pagine
	}
}

// TODO: create function fo click on TxtTxt
function createSliderTxtTxt() {

} 

// Funzione al click su Bookreader
function createSliderBookreader() {
	var arrayPagePairs = [];
	if ($('.main_dd_select')) {
		$('.main_dd_select .option_container .option').each(function() {
			var pageId = $(this).attr('data-value');
			var pageLabel = $(this).text()
			var docId = $(this).attr('data-first-page-first-doc');
			arrayPagePairs.push({
				id: pageId,
				label: pageLabel,
				firstDoc: docId
			});
		});
		createBrnav(arrayPagePairs);
	}
}

// Funzione per creare lo slider (gli viene passato l'array a seconda che è stata cliccata un tipo di modalità)
function createBrnav(array) {
	//alert(array);
	var pageNum = array && array.length > 0 ? array[0].label + "/" + array[array.length - 1].label : '';
	$("#pagenum").text(pageNum); // Mostra il numero della pagina sul totale della pagine
	$('#BRpager').slider({
		min: 0,
		max: array.length - 1,
		/*slide: function(event, ui) {  // E' lanciato durante il trascinamento del cursore
			$("#pagenum").text(array[ui.value] + "/" + array[array.length-1]);
		},*/
		change: function(event, ui) {
			var newPage = array[ui.value]; // Elemento dell'array di indice ui.value (sarà quello su cui si sposta lo slider)
			var newPageId = newPage ? newPage.id : '';
			var newPageLabel = newPage ? newPage.label : '';
			var newDocId = newPage ? newPage.firstDoc : '';
			if (newPage) { // Check just to be sure
				updateHash(newDocId, newPageId, '');
				
				var pageNum = array && array.length > 0 ? newPageLabel + "/" + array[array.length - 1].label : '';
				$("#pagenum").text(pageNum);
			}
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