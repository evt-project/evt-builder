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
		   onFinishLoad: function(ev, src) {var prova = document.getElementById("switchITL").getAttribute('src'); if (prova=='images/ITLon.png'){Initialize();} //Add by JK for ITL
		                                      magnifierReady(); //Add by JK for Mag
		                                      
		                 ;}, 
		  // onStartDrag: function(ev, coords) { return false; }, //this image will not be dragged
		   onAfterZoom: function(ev, zoom) { var prova = document.getElementById("switchITL").getAttribute('src');
		                                     if (prova=='images/ITLon.png'){ReInitialize();};
		                                     $( "#slider" ).slider( "option", "value", iv1.iviewer('info', 'zoom') );
		                                   },
		   //onAfterZoom: function(ev, new_zoom) {var prova = document.getElementById("switchITL").getAttribute('value'); if (prova=='turn ITL off'){alert("aa");ReInitialize();}}, //Add by JK for ITL
		   onStartDrag: function() {click="true";},
		   onDrag: function (ev, point) {moveAreas();}, //Add by JK for ITL
		   onStopDrag: function(ev, point) {moveAreas(); onmouseup=clickFalse();} //Add by JK for ITL
		   
	  });
	  
        function clickFalse(){
         //Add by JK for ITL
            click = false;
        }
        function clickTrue(){
        //Add by JK for ITL
            if((Initializing == false)&&(click == false)){
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
			iv1.iviewer('loadImage', "data/input_data/images/"+$(this).text()+".jpg");	//SISTEMARE: rimuovere central_page_number		
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