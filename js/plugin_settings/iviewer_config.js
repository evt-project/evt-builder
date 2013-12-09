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
	 var cpns="data/input_data/images/"+location.hash.replace( /^#/, '' )+".jpg";
	 var iv1 = $("#image_elem").iviewer({
		   src: cpns, 
		   update_on_resize: true,
		   zoom_animation: false,
		   mousewheel: true,
		   onMouseMove: function(ev, coords) {clickTrue(); },
		   onFinishLoad: function(ev, src) {
		   									$("#iviewerImage").fadeIn(200);
		   									if ($('#switchITL i').hasClass('fa-chain')){Initialize();} //Add by JK for ITL
		                                    if ($("#switchHS i").hasClass('fa fa-dot-circle-o')){InitializeHS();} //Add by JK for HS
		                                    
		                                    $.ajax({
                                                    url: 'data/input_data/images/'+location.hash.replace( /^#/, '' )+'_big.jpg',
                                                    success: function(data){
                                                        if ($("#switchMag").attr("title")){$("#switchMag").removeAttr("title").removeClass('inactive'); $("#switchMag").attr("onclick", "magOn()");}
                                                        bigImage=true; 
                                                        magnifierReady();
                                                        chooseZoomMag();
                                                    },
                                                    error: function(data){
                                                        $("#switchMag").attr("title", "no big image");
                                                        $("#switchMag").removeAttr("onclick").removeClass('active').addClass('inactive');
                                                        bigImage=false;
                                                        //if ($('#switchITL').hasClass('inactive')){$('#switchITL i ').removeClass('fa-chain').addClass('fa-chain-broken');}//Add by JK for ITL
                                                        //if ($("#switchHS").hasClass('inactive')){$("#switchHS i").removeClass('fa-chain').addClass('fa-chain-broken');}//Add by JK for HS
                                                        chooseZoomMag();
                                                    }
                                                }); //Add by JK for Mag
											$("#mag_image_elem").empty();
											$('#image_fade').fadeIn(400);
											setTimeout(function (){
									            //iv1.iviewer('fit');
									         }, 320);
		                                    ;}, 
		  // onStartDrag: function(ev, coords) { return false; }, //this image will not be dragged
		   onAfterZoom: function(ev, zoom) {if ($('#switchITL i').hasClass('fa-chain')){ReInitialize();}; //Add by JK for ITL
		                                    if ($("#switchHS i").hasClass('fa fa-dot-circle-o')){ReInitializeHS();}; //Add by JK for HS
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
	
		$(".main_pp_select .label_selected").on('change',function(){
			//iv1.iviewer('fit');
			//iv1.iviewer('loadImage', "data/input_data/images/"+$(this).text()+".jpg");
			
			if (firstload){
				iv1.iviewer('loadImage', "data/input_data/images/"+$(this).text()+".jpg");
				firstload = false;
			}
			else {
				var curr_src = "data/input_data/images/"+$(this).text()+".jpg";
				$('#image_fade').fadeOut(600, function(){
				//$('#iviewerImage').fadeOut(600);				
					iv1.iviewer('loadImage', curr_src);
				});
			}
		});

		$(".main_dd_select .label_selected").on('change',function(){
		    //iv1.iviewer('fit');
			//iv1.iviewer('loadImage', "data/input_data/images/double/"+$(this).text()+".jpg");

			if (firstload){
				iv1.iviewer('loadImage', "data/input_data/images/double/"+$(this).text()+".jpg");
				firstload = false;
			}
			else {
				var curr_src = "data/input_data/images/double/"+$(this).text()+".jpg";
				$('#image_fade').fadeOut(600, function(){
				//$('#iviewerImage').fadeOut(600);				
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
		  $("#val").html(curr_val.toFixed());
		  //console.log(iv1.iviewer('info', 'zoom'));
		  iv1.iviewer('set_zoom', ui.value);
		  
		  //alert(iv1.iviewer('info', 'zoom'));
		}
});