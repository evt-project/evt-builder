/**
 * Magnifier Functions
 * Version 0.3 (201312)
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
 * @author Julia Kenny – JK
 * @since 2012 @to 2015
 *
 * @author Chiara Di Pietro – CDP
 * @since 2014
 *
 **/

var magnifierON = false;
//var bigImage;

function magnifierReady() {
	$("#mag_image_elem").empty();
	setMagHeight();

	var hash_parts = new Array();
	var current_pp;
	hash_parts = location.hash.substr(1).split('&');
	if ( hash_parts != "" ) {
		//alert('fromHash');
		for (var i = 0; i < hash_parts.length; i++) {
		    if(hash_parts[i].indexOf("page") === 0) { //begins with "page"
		        current_pp = hash_parts[i].substr(5);
		    }
		}
	} else {
		if ($('.current_mode').attr('id') == 'imgd_link'){
			//alert('fromDD');
			current_pp = $('.main_dd_select .option_container .option:first').data('value');
		} else {
			//alert('fromPP');
			current_pp = $('.main_pp_select .option_container .option:first').data('value');
		}
	}

	var img = document.getElementById("iviewerImage").cloneNode(false);
	img.removeAttribute("style");
	/*IT: calcolo nuova altezza: */
	if ($('.current_mode').attr('id') == 'imgd_link') {
		if (current_pp.indexOf('+') < 0) { 
    		zoomImagWidth = 445;
		} else {
			zoomImagWidth = 900;
		}
	} else {
		zoomImagWidth = 445; /*richiamata anche in jqzoom*/
	}
	var imgWidth = parseFloat($("#iviewerImage").css('width'));
	// var imgHeight = parseFloat($("#iviewerImage").css('height'));
	var imgHeight = parseFloat($('#mag_image_elem').innerHeight());
	var left_headerHeight = $("#left_header").outerHeight();
	
	zoomImagHeight = (zoomImagWidth * imgHeight) / imgWidth; /*richiamata anche in jqzoom*/
	
	/*IT: modifico gli attibuti della nuova immagine*/
	img.setAttribute('id', 'magImage');
	/*IT: inserisco nuova immagine in #mag_image_elem */

	//alert(current_pp);
	var imageExt = $('#global_wrapper').attr('data-image-extension') || 'jpg';
	if ($('.current_mode').attr('id') == 'imgd_link') {
		imgB = "data/input_data/images/double/" + current_pp.replace("+", "-") + "_big."+imageExt;
	} else {
		if (current_pp.indexOf('+') > 0) {
    		current_pp = current_pp.substr(0, current_pp.indexOf('+'));
		}
		imgB = "data/input_data/images/single/" + current_pp + "_big."+imageExt;
	}
	$("#mag_image_elem").append('<a href="' + imgB + '" class="magnifier" ></a>');
	$("#mag_image_elem > a").append(img);
	/*IT: imposto il css della nuova immagine*/
	$("#magImage").css({
		// 'width': zoomImagWidth + 'px',
		// 'height': zoomImagHeight + 'px',
		'width': zoomImagWidth +'px',
		'height': imgHeight + 'px',
		'margin-left': 'auto',
		'margin-right': 'auto'
	});
	if ($('.current_mode').attr('id') == 'imgd_link') {
		if (current_pp.indexOf('+') < 0) { 
			setTimeout(function() {
				magON();
			}, 1000);
		} else {
			setTimeout(function() {
				magONbig();
			}, 1000);
		}
	} else {
		setTimeout(function() {
			magON();
		}, 1000);
	}
}

function setMagHeight() {;
	left_headerHeight = $("#left_header").outerHeight();
	if ($('#left_header').hasClass('menuClosed')) {
		$("#mag_image_elem").css({
			'height': ($("#image_cont").height() + left_headerHeight) + 'px'
		});
	} else {
		$("#mag_image_elem").css({
			'height': ($("#image_cont").height()) + 'px',
			'margin-top': left_headerHeight+'px'
		});
	}
	$('.zoomWindow').css({
		left: ($("#image_cont").width() - $(".zoomWindow").width()) / 2 + 'px'
	});
	$('.zoomPup').css({
		left: ($("#image_cont").width() - $(".zoomPup").width()) / 2 + 'px'
	});
}

function magOn() {
	var thumb_cont  = $('#thumb_cont'),
		msDesc_cont = $('#msDesc_cont');
	if (magnifierON == false || 
		(thumb_cont.length > 0 && thumb_cont.css('display') !== 'none') ||
		(msDesc_cont.length > 0 && $('#msDesc_cont').css('display') !== 'none')) {
		
		if ($('.zoomWrapperImage').hasClass('bigImageError')) {
			var errorMsg = $('.zoomWrapperImage').attr('data-error-msg');
			alert(errorMsg);
		} else {
			// magnifierReady();
			// chooseZoomMag();   	
		   	if($('#switchMag').hasClass('likeInactive')) {
		       $('#switchMag').removeAttr('onclick').removeClass('likeInactive').addClass('inactive');
		       $('#switchMag i').removeClass('fa fa-search-plus').addClass('fa fa-search');
		  	}
		    else{
	      		/*IT: Se il collegamento testo immagine è attivo, lo disattivo*/
	      		UnInitialize(); //Add by JK for ITL
	      		$('#switchITL i').removeClass('fa fa-chain').addClass('fa fa-chain-broken');
	      		$('#switchITL').removeClass('active'); //Add by CDP
	      		if($('#switchITL').hasClass('likeInactive')) disableITLbutton();
	      
	      		/*IT: Se gli HotSpot sono attivi, li disattivo*/
	      		UnInitializeHS(); //Add by JK for HS
	      		$('#switchHS i').removeClass('fa fa-dot-circle-o').addClass('fa fa-circle-o');
	      		$('#switchHS').removeClass('active');
	      		if($('#switchHS').hasClass('likeInactive')) disableHSbutton();
	      
	      		/*IT: rendo visibile il div del magnifier e invisibile quello dello zoom*/
	      		$("#mag_image_elem").fadeIn();
	      		$("#image_elem, #image_tool, #image_fade").css({
	      			'display': 'none'
	      		});
	      		//$('#image_tool').addClass('menuClosed'); //Add by CDP per gestire la scomparsa del menu
	      		$('#switchMag').addClass('active'); //Add by CDP for FA
	      		$('#switchMag i').removeClass('fa fa-search').addClass('fa fa-search-plus');
	      		//$('#switchITL').removeClass('inactive');//Add by CDP for FA
	      		$('#image_tool').addClass('hidden');
	      		magnifierON = true;
	      	}
	    }
	} else {
		/*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
		$("#image_elem, #image_fade").css({
			"overflow": "hidden"
		});
		$("#image_elem, #image_fade").fadeIn();
		if (!$('#image_tool').hasClass('menuClosed')) {
			$("#image_tool").css({
				"display": "block",
				"overflow": "hidden"
			}); //Add by CDP per gestire la scomparsa del menu
		}
		$("#mag_image_elem").fadeOut();
		$('#switchMag').removeClass('active'); //Add by CDP for FA
		$('#switchMag i').removeClass('fa fa-search-plus').addClass('fa fa-search');
		$('#image_tool').removeClass('hidden');
		magnifierON = false;
	}
	$('#thumb_cont, #msDesc_cont').css('display', 'none');
}

function disableITLbutton() {
	if($('#switchITL').hasClass('likeInactive')) $('#switchITL').removeClass('likeInactive');
	$('#switchITL').addClass('inactive'); //Add by CDP for FA
	$('#switchITL').removeAttr("onclick");
	$('#switchITL').attr('title', 'Image-Text link non disponibile');
	//$('#switchITL i').removeClass('fa-chain').addClass('fa-chain-broken'); //Add by CDP for FA
}

function enableITLbutton() {
	if($('#switchITL').hasClass('inactive')) $('#switchITL').removeClass('inactive');
	if($('#switchITL').hasClass('likeInactive')) $('#switchITL').removeClass('likeInactive');
	$('#switchITL').attr('onclick', 'switchITL()');
	$('#switchITL').removeAttr('title').attr('title', 'Image-Text link');
}

function disableHSbutton() {
	if($('#switchHS').hasClass('likeInactive')) $('#switchHS').removeClass('likeInactive');
	$('#switchHS').addClass('inactive'); //Add by CDP for FA
	$('#switchHS').removeAttr('onclick');
	$('#switchHS').attr('title', 'Hot spot non disponibili');
	//$('#switchHS i').removeClass('fa fa-dot-circle-o').addClass('fa fa-dot-circle-o'); //Add by CDP for FA
}

function enableHSbutton() {
	if($('#switchHS').hasClass('inactive')) $('#switchHS').removeClass('inactive');
	if($('#switchHS').hasClass('likeInactive')) $('#switchHS').removeClass('likeInactive');
	$('#switchHS').attr('onclick', 'switchHS()');
	$('#switchHS').removeAttr('title').attr('title', 'Hot spot');
}

function chooseZoomMag() {
	//if ((magnifierON == true) && (bigImage == true)) 
	if (magnifierON) {
		/*IT: rendo visibile il div del magnifier e invisibile quello dello zoom*/
		$("#image_elem, #image_tool, #image_fade, #thumb_cont").css('display', 'none');
		$("#mag_image_elem").css('display', 'none').fadeIn(1000);
		$('#switchMag').removeClass('inactive').addClass('active'); //Add by CDP for FA
		//document.getElementById("#image_tool").setAttribute('style', 'display:none;');
	}
	//else if ((magnifierON == false) || ((magnifierON == true) && (bigImage == false))) {
	else{
		/*IT: rendo visibile il div dello dello zoom e invisibile quello del magnifier*/
		magnifierON == false;
		$("#mag_image_elem, #thumb_cont").css({
			"display": "none"
		});
		$("#image_elem").css({
			"display": "block",
			"overflow": "hidden"
		});
		if (!$('#image_tool').hasClass('menuClosed')) $("#image_tool").css({
			"display": "block",
			"overflow": "hidden"
		}); //Add by CDP per gestire la scomparsa del menu
	}
}

function magON() {
	var options = {
		zoomType: 'drag',
		position: 'inside',
		title: false,
		lens: false,
		preloadImages: false,
		alwaysOn: false,
		lensWidth: 30,
		lensHeight: 15,
		zoomRatio: 1
	};
	$('.magnifier').jqzoom(options);
}

function magONbig() {
	var options = {
		zoomType: 'drag',
		position: 'inside',
		title: false,
		lens: false,
		preloadImages: false,
		alwaysOn: false,
		lensWidth: 40,
		lensHeight: 20,
		zoomRatio: 1
	};
	$('.magnifier').jqzoom(options);
}