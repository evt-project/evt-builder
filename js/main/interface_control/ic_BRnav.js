$(function () {
// Pulsante per ridurre la barra di navigazione
	$('.BRnavCntl').click(
        function(){
            if ($('#BRnavCntlBtm').hasClass('BRdn')) {
                $('#BRnav').animate({bottom:-65});
				$('#central_wrapper').animate({height:"87.5%"}, 1000);  // Aumento l'altezza del central_wrapper
                $('#BRnavCntlBtm').addClass('BRup').removeClass('BRdn');
				$('#BRnavCntlBtm i').removeClass('fa fa-caret-down fa-lg').addClass('fa fa-caret-up fa-lg');  // Rimuove la classe per mettere quella con la freccia verso il basso
                $('#BRnavCntlTop').addClass('BRdn').removeClass('BRup');
				$('#BRnavCntlTop i').addClass('fa fa-caret-down fa-lg').removeClass('fa fa-caret-up fa-lg');
                $('#BRnavCntlBtm.BRnavCntl').animate({height:'45px'});
                $('.BRnavCntl').delay(1000).animate({opacity:.25},1000);
            } else {
                $('#BRnav').delay(200).animate({bottom:0});  // .delay() ritarda l'animazione degli elementi seguenti
				$('#central_wrapper').animate({height:"77.5%"}, 1000);  // Riduco l'altezza del central_wrapper
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

});