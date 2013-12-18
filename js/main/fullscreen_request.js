/**
 * 
 * Full screen request
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

(function () {
    var viewFullScreen = document.getElementById("main_fullscreen");
    if (viewFullScreen) {
        viewFullScreen.addEventListener("click", function () {
			//alert(viewFullScreen.title);
			if(viewFullScreen.title=="fullscreen"){
				var docElm = document.documentElement;
				if (docElm.requestFullscreen) {
					docElm.requestFullscreen();
				}
				else if (docElm.mozRequestFullScreen) {
					docElm.mozRequestFullScreen();
				}
				else if (docElm.webkitRequestFullScreen) {
					docElm.webkitRequestFullScreen();
				}
				//viewFullScreen.title="close";
			}
			else{
				if (document.exitFullscreen) {
					document.exitFullscreen();
				}
				else if (document.mozCancelFullScreen) {
					document.mozCancelFullScreen();
				}
				else if (document.webkitCancelFullScreen) {
					document.webkitCancelFullScreen();
				}
				//viewFullScreen.title="fullscreen";
			}
        }, false);
    }
	
	var viewFullScreenII = document.getElementById("view-fullscreenII");
    if (viewFullScreenII) {
        viewFullScreenII.addEventListener("click", function () {
			if(viewFullScreenII.title=="fullscreen"){
				var docElm = document.documentElement;
				if (docElm.requestFullscreen) {
					docElm.requestFullscreen();
				}
				else if (docElm.mozRequestFullScreen) {
					docElm.mozRequestFullScreen();
				}
				else if (docElm.webkitRequestFullScreen) {
					docElm.webkitRequestFullScreen();
				}
				//viewFullScreenII.title="close";
			}
			else{
				if (document.exitFullscreen) {
					document.exitFullscreen();
				}
				else if (document.mozCancelFullScreen) {
					document.mozCancelFullScreen();
				}
				else if (document.webkitCancelFullScreen) {
					document.webkitCancelFullScreen();
				}
				//viewFullScreenII.title="fullscreen";
			}
        }, false);
    }
	
	//Doesn't quite work - rafmas
	document.addEventListener("mozfullscreenchange", function(e) {
		if(viewFullScreen.title=="fullscreen"){
			viewFullScreen.title="close";
			viewFullScreenII.title="close";
			return false;
		}
		if(viewFullScreen.title=="close")
			viewFullScreen.title="fullscreen";	
			viewFullScreenII.title="fullscreen";	
	},false);
	document.addEventListener("webkitfullscreenchange", function(e) {
		if(viewFullScreen.title=="fullscreen"){
			viewFullScreen.title="close";
			viewFullScreenII.title="close";
			return false;
		}
		if(viewFullScreen.title=="close")
			viewFullScreen.title="fullscreen";	
			viewFullScreenII.title="fullscreen";	},false);

})();

function goFullScreenLeft(){
		if (ITLon){UnInitialize();}
		if($('#header_collapse').hasClass('fa-caret-down')) 
			$("#header_collapse").trigger('click');
		$('#header_collapse').toggle();
		$("#main_left_frame").toggleClass("full");
		var height_full = ($(window).height() > $("body").height()) ? $(window).height()-4 : $("body").height();
		var width_full = ($(window).width()>$("#global_wrapper").width()) ? $(window).width()-4 : $("#global_wrapper").width()-4;
		// 4 è l'altezza totale dei bordi di sinistra e destra
		var margin_left = -($('#main_left_frame').offset().left);
		var margin_top = -($('#main_left_frame').offset().top);
		
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
			//$('#header_collapse').animate({opacity: 1});
		});
		$('.go-full-left').toggle();
		$('#switchITL:visible').hide();
		
		if(($('#span_ee_select-add').is('visible'))&&!$('#span_ee_select-add').hasClass('widthChanged')){
			$('#span_ee_select-add').addClass('widthChanged')
			$('#span_ee_select-add .option_container').removeAttr('style');

			$('#span_ee_select-add').each(function(){
				var widthSel = $(this).width();
				var widthOpt = $(this).find('.option_container').width()+10;
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
		//caso in cui si passa a fullscreen dalla visualizzazione a doppia pagina
		if($('#main_right_frame').css("display")=="none"){
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
				$('.zoomWindow').css({left: ($("#image_cont").width() - $(".zoomWindow").width())/2+'px'});
	            $('.zoomPup').css({left: ($("#image_cont").width() - $(".zoomPup").width())/2+'px'});
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
				$('.zoomWindow').css({left: ($("#image_cont").width() - $(".zoomWindow").width())/2+'px'});
	            $('.zoomPup').css({left: ($("#image_cont").width() - $(".zoomPup").width())/2+'px'});
			});
			$('#switchITL').show();
		}
	    
		$('#span_dd_select').hide();
	}

	function goFullScreenRight(){
	    if (ITLon){UnInitialize();} //Add by JK for ITL
	    if (HSon){UnInitialize();} //Add by JK for HS
		if($('#header_collapse').hasClass('fa-caret-down')) 
			$("#header_collapse").trigger('click');
		$('#header_collapse').toggle();
		// Gestione del full screen per browser webkit
		if ($.browser.webkit) {
			var height_full = ($(window).height() > $("body").height()) ? $(window).height()-4 : $("body").height();
			var width_full = ($(window).width()>$("#global_wrapper").width()) ? $(window).width()-4 : $("#global_wrapper").width()-4;
			// 4 è l'altezza totale dei bordi di sinistra e destra
			var margin_right = -($(window).width()-($('#main_right_frame').offset().left+$('#main_right_frame').width())-4);
			var margin_top = -($('#main_right_frame').offset().top);
			$("#main_right_frame").toggleClass("full");
			$('#main_right_frame').animate({
				width: width_full,
				height: height_full,
				marginTop: margin_top,
				right:margin_right,
				minWidth: "1021px"
			}, 700, function(){
				$('#right_header .closeFullScreen').toggle();
			});
			$("#main_right_frame").css('position', 'absolute');
			$('.go-full-right').toggle();
			
		} else {
			var height_full = ($(window).height() > $("body").height()) ? $(window).height()-4 : $("body").height();
			var width_full = ($(window).width()>$("#global_wrapper").width()) ? $(window).width()-4 : $("#global_wrapper").width()-4;
			// 4 è l'altezza totale dei bordi di sinistra e destra
			var margin_right = -($(window).width()-($('#main_right_frame').offset().left+$('#main_right_frame').width())-4);
			var margin_top = -($('#main_right_frame').offset().top);
			var margin_left = -($('#main_right_frame').offset().left);
			$("#main_right_frame").toggleClass("full");

			$('#main_right_frame').animate({
				width: width_full,
				height: height_full,
				marginTop: margin_top,
				left: margin_left,
				right:margin_right,
				minWidth: "1021px"
			}, 700, function(){
				$('#right_header .closeFullScreen').toggle();
			});
			
			$('.go-full-right').toggle();
		}
	} 

	function closeFullScreenRight(){
	    if ($('#switchITL i ').hasClass('fa-chain')){Initialize();} //Add by JK for ITL
	    if ($('#switchHS i ').hasClass('fa fa-dot-circle-o')){InitializeHS();} //Add by JK for HS
	    // Gestione del full screen per browser webkit
		if ($.browser.webkit) {
			var widthLeft = $('#main_left_frame').width()-4;
			$('#main_right_frame').animate({
				width: widthLeft,
				height: "100%", 
				marginTop: "0px", 
				right: "0px", 
				minWidth: "0px",
			}, 700, function(){
				$('#main_right_frame').removeAttr("style");
				$('#right_header .closeFullScreen, #header_collapse').toggle();
				$('#main_right_frame').toggleClass("full");
				$('.go-full-right').toggle();
			});
		} else {
			var widthLeft = $('#main_left_frame').width()-3;
			$('#main_right_frame').animate({
				width: widthLeft,
				height: "100%", 
				marginTop: "0px", 
				left: "0px", 
				minWidth: "0px",
			}, 700, function(){
				$('#main_right_frame').removeAttr("style");
				$('#right_header .closeFullScreen,  #header_collapse').toggle();
				$('#main_right_frame').toggleClass("full");
				$('.go-full-right').toggle();
			});
		}
	}