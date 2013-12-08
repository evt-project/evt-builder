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
	 var cpns="data/input_data/images/"+location.hash.replace( /^#/, '' )+".jpg";
	 var iv1 = $("#image_elem").iviewer({
		   src: cpns, 
		   update_on_resize: true,
		   zoom_animation: false,
		   mousewheel: true,
		   onMouseMove: function(ev, coords) {clickTrue(); },
		   onFinishLoad: function(ev, src) {if ($('#switchITL i ').hasClass('fa-chain')){Initialize();} //Add by JK for ITL
		                                    //if ($("#switchHS").attr('src')=='images/HSon.png'){InitializeHS();} //Add by JK for HS
		                                    $.ajax({
                                                    url: 'data/input_data/images/'+location.hash.replace( /^#/, '' )+'_big.jpg',
                                                    success: function(data){
                                                        if ($("#switchMag").attr("title")){$("#switchMag").removeAttr("title"); $("#switchMag").attr("onclick", "magOn()");}
                                                        bigImage=true; 
                                                        magnifierReady();
                                                        chooseZoomMag();
                                                    },
                                                    error: function(data){
                                                        $("#switchMag").attr("title", "no big image");
                                                        $("#switchMag").removeAttr("onclick");
                                                        bigImage=false;
                                                        if ($('#switchITL').hasClass('inactive')){$('#switchITL i ').removeClass('fa-chain').addClass('fa-chain-broken');}//Add by JK for ITL
                                                        //if ($("#switchHS").attr('src')=='images/HSdis.png'){$("#switchHS").attr('src','images/HSoff.png');}//Add by JK for HS
                                                        chooseZoomMag();
                                                    }
                                                }); //Add by JK for Mag
		                                    ;}, 
		  // onStartDrag: function(ev, coords) { return false; }, //this image will not be dragged
		   onAfterZoom: function(ev, zoom) {if ($('#switchITL i ').hasClass('fa-chain')){ReInitialize();}; //Add by JK for ITL
		                                    //if ($("#switchHS").attr('src')=='images/HSon.png'){ReInitializeHS();}; //Add by JK for HS
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
            if(((Initializing == false)&&(click == false))||((InitializingHS == false)&&(click == false))){
                click = true;
            }
        }
        
	   $("#zoom_in").click(function(){ iv1.iviewer('zoom_by', 1); }); 
	   $("#zoom_out").click(function(){ iv1.iviewer('zoom_by', -1); }); 
	   $("#zoom_fit").click(function(){ iv1.iviewer('fit'); ReInitialize(); }); 
	   $("#zoom_orig").click(function(){ iv1.iviewer('set_zoom', 100); ReInitialize(); }); 
	   $("#zoom_update").click(function(){ iv1.iviewer('update_container_info'); });
	  
	  /*$('select[name=" "]').change( function() {
			iv1.iviewer('loadImage', document.getElementById('slideshow-image').getAttribute('src'));
		});*/
		
		//$('#folio_page_number').change(function(){	
		$(".main_pp_select .label_selected").on('change',function(){
			iv1.iviewer('fit');
			$("#image_elem").css({opacity:0});
			iv1.iviewer('loadImage', "data/input_data/images/"+$(this).text()+".jpg");	//SISTEMARE: rimuovere central_page_number		
			$("#image_elem").animate({opacity:1});
		});

		$(".main_dd_select .label_selected").on('change',function(){
		    iv1.iviewer('fit');
			iv1.iviewer('loadImage', "data/input_data/images/double/"+$(this).text()+".jpg");
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
		  $("#val").html(iv1.iviewer('info', 'zoom'));
		  iv1.iviewer('set_zoom', ui.value);
		  
		  //alert(iv1.iviewer('info', 'zoom'));
		}
});