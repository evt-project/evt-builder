/**
 * 
 * iViewer Config - jQuery
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
	var firstload = true;
	var current_pp;
    var hash_parts = new Array();
	hash_parts = location.hash.substr(1).split('&');
	if ( hash_parts != "" ) {
		for (var i = 0; i < hash_parts.length; i++) {
		    if(hash_parts[i].indexOf("page") === 0) { //begins with "page"
		        current_pp = hash_parts[i].substr(5);
		    	if (current_pp.indexOf('+') > 0) {
		    		current_pp = current_pp.substr(0, current_pp.indexOf('+'));
				}
		    }
		}
	} else {
		if ($('.current_mode').attr('id') == 'imgd_link'){
			current_pp = $('.main_dd_select .option_container .option:first-child').attr('data-value');
		} else {
			current_pp = $('.main_pp_select .option_container .option:first-child').attr('data-value');
		}
	}
	
	var cpns="data/input_data/images/single/"+current_pp+".jpg";
	
	var iv1 = $("#image_elem").iviewer({
		   src: cpns, 
		   update_on_resize: true,
		   zoom_animation: false,
		   mousewheel: true,
		   onMouseMove: function(ev, coords) {clickTrue(); },
		   onFinishLoad: function(ev, src) {
		   									
		   									$('#image_loading').hide();
		   									$("#iviewerImage").fadeIn(200);
		   									if (($('.current_mode').attr('id')=='txtimg_link') & (!$('#switchITL').hasClass('inactive')) & ($('#switchITL i').hasClass('fa fa-chain')) ){
		   									      Initialize();} //Add by JK for ITL
		                                    if (($('.current_mode').attr('id')=='txtimg_link') & (!$('#switchHS').hasClass('inactive')) & ($("#switchHS i").hasClass('fa fa-dot-circle-o')) ) {
		                                          InitializeHS();} //Add by JK for HS

		                                    var current_url = '';
		                                    
		                                    if ($('.current_mode').attr('id')=='imgd_link')
		                                    	current_url = 'data/input_data/images/double/'+current_pp.replace("+", "-")+'_big.jpg';      
		                                    else
		                                    	current_url = 'data/input_data/images/single/'+current_pp+'_big.jpg';      
		                                    
		                                    $.ajax({
                                                    url: current_url,
                                                    success: function(data){
                                                        magnifierReady();
                                                        chooseZoomMag();
                                                        if ($("#switchMag").attr("title")){
                                                            //$("#switchMag").removeAttr("title");
                                                            if($("#switchMag").hasClass('inactive')) $("#switchMag").removeClass('inactive');
                                                            if($("#switchMag").hasClass('likeInactive')) $("#switchMag").removeClass('likeInactive');
                                                            $("#switchMag").attr("onclick", "magOn()");
                                                        }
                                                        //bigImage=true; 
                                                        
                                                    },
                                                    error: function(data){
                                                        $("#switchMag").attr("title", "No big image");
                                                        $("#switchMag").removeClass('active');
                                                        if($("#switchMag i").hasClass('fa-search-plus')){$("#switchMag").addClass('likeInactive');}
                                                        else{$("#switchMag").removeAttr("onclick").addClass('inactive');}
                                                        //bigImage=false;
                                                        if (magnifierON) {magnifierON=false;}
                                                        //if ($('#switchITL').hasClass('inactive')){$('#switchITL i ').removeClass('fa-chain').addClass('fa-chain-broken');}//Add by JK for ITL
                                                        //if ($("#switchHS").hasClass('inactive')){$("#switchHS i").removeClass('fa-chain').addClass('fa-chain-broken');}//Add by JK for HS
                                                        chooseZoomMag();
                                                    }
                                                }); //Add by JK for Mag
											//$("#mag_image_elem").empty();
											if(!magnifierON) $('#image_fade').fadeIn(400);
											setTimeout(function (){
									            //iv1.iviewer('fit');
									         }, 320);
		                                    ;}, 
		  // onStartDrag: function(ev, coords) { return false; }, //this image will not be dragged
		   onAfterZoom: function(ev, zoom) {if ($('#switchITL i').hasClass('fa-chain')){ReInitialize();}; //Add by JK for ITL
		                                    if ($("#switchHS i").hasClass('fa-dot-circle-o')){ReInitializeHS();}; //Add by JK for HS
		                                    $( "#slider" ).slider( "option", "value", iv1.iviewer('info', 'zoom') );
		                                   },
		   onStartDrag: function() {click="true";},
		   onDrag: function (ev, point) {moveAreas(); moveAreasHS()}, //Add by JK for ITL
		   onStopDrag: function(ev, point) {moveAreas(); moveAreasHS(); onmouseup=clickFalse();} //Add by JK for ITL
	  });
	  
        function clickFalse(){
         //Add by JK for ITL
            click = false;
        }
        function clickTrue(){
        //Add by JK for ITL
            if(((ITLon == true)&&(click == false))||((HSon == true)&&(click == false))){
                click = true;
            }
        }
        
	   $("#zoom_in").click(function(){ iv1.iviewer('zoom_by', 1); }); 
	   $("#zoom_out").click(function(){ iv1.iviewer('zoom_by', -1); }); 
	   $("#zoom_fit").click(function(){ iv1.iviewer('fit'); ReInitialize(); ReInitializeHS(); }); 
	   $("#zoom_orig").click(function(){ iv1.iviewer('set_zoom', 100); ReInitialize(); ReInitializeHS();}); 
	   $("#zoom_update").click(function(){ iv1.iviewer('update_container_info'); });
	  
	  	/*$('select[name=" "]').change( function() {
			iv1.iviewer('loadImage', document.getElementById('slideshow-image').getAttribute('src'));
		});*/
	
		/*$(".main_pp_select .label_selected").on('change',function(){
			//iv1.iviewer('fit');
			//iv1.iviewer('loadImage', "data/input_data/images/"+$(this).text()+".jpg");
			
			if (firstload){
				iv1.iviewer('loadImage', "data/input_data/images/single/"+$(this).attr("data-value")+".jpg");
				firstload = false;
			}
			else {
				alert($(this).attr("data-value"));
				var curr_src = "data/input_data/images/single/"+$(this).attr("data-value")+".jpg";
				$('#image_fade').fadeOut(600, function(){
				//$('#iviewerImage').fadeOut(600);		
					$('#image_loading').show();		
					iv1.iviewer('loadImage', curr_src);
				});
			}
		});
		$(".main_dd_select .label_selected").on('change',function(){
		    //iv1.iviewer('fit');
			//iv1.iviewer('loadImage', "data/input_data/images/double/"+$(this).text()+".jpg");

			if (firstload){
				iv1.iviewer('loadImage', "data/input_data/images/double/"+$(this).attr("data-value")+".jpg");
				firstload = false;
			}
			else {
				var curr_src = "data/input_data/images/double/"+$(this).attr("data-value")+".jpg";
				$('#image_fade').fadeOut(600, function(){
				//$('#iviewerImage').fadeOut(600);
					$('#image_loading').show();
					iv1.iviewer('loadImage', curr_src);
				});
			}
		});	
		*/
		$(window).hashchange( function(){
			var curr_src;

			hash_parts = location.hash.substr(1).split('&');
			if ( hash_parts != "" ) {
				for (var i = 0; i < hash_parts.length; i++) {
				    if(hash_parts[i].indexOf("page") === 0) { //begins with "page"
				        current_pp = hash_parts[i].substr(5);
				    }
				}
			} else {
				if ($('.current_mode').attr('id') == 'imgd_link'){
					current_pp = $('.main_dd_select .option_container .option:first-child').attr('data-value');
				} else {
					current_pp = $('.main_pp_select .option_container .option:first-child').attr('data-value');
				}
			}

			if ($('.current_mode').attr('id') == 'imgd_link'){
				curr_src = "data/input_data/images/double/"+current_pp.replace("+", "-")+".jpg";
			} else {
				curr_src = "data/input_data/images/single/"+current_pp+".jpg";
			}
			//alert(curr_src);
			if (firstload){
				iv1.iviewer('loadImage', "data/input_data/images/single/"+current_pp+".jpg");
				firstload = false;
			}
			else if ( $('#text_elem').attr('data-page') != current_pp || $('#iviewerImage').attr('src') != curr_src ||
					  (($('#iviewerImage').attr('src') == curr_src) && ($('#image_loading').is(':visible')) ) 
					){
				$('#image_fade').fadeOut(600, function(){
				//$('#iviewerImage').fadeOut(600);		
					$('#image_loading').show();		
					iv1.iviewer('loadImage', curr_src);
				});
			}

		});

		$("#slider").slider(
		{
		  orientation: "orizontal",
		  min: 20,
		  max: 140,
		  step: 1,
		  slide: showValue,
		  change: showValue

		});
		$("#update").click(function () {
		  $("#slider").slider("option", "value", iv1.iviewer('info', 'zoom'));
		});
		function showValue(event, ui) {
		  var curr_val = iv1.iviewer('info', 'zoom');
		  //if (curr_val>25 && curr_val<140)
		  $("#val").html(curr_val.toFixed(0));
		  //console.log(iv1.iviewer('info', 'zoom'));
		  iv1.iviewer('set_zoom', ui.value);
		  
		  //alert(iv1.iviewer('info', 'zoom'));
		}
});