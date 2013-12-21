/**
 * 
 * Utils jQuery
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
	//$( document ).tooltip(); Attiva tooltip jQuery
	
	// IT: Nasconde le funzioni non compatibili con IE
	if ($.browser.msie) {
		$("#cont_fullscreen").hide();
	}
	
	// IT: Disabilita il tasto destro del mouse nel riquadro immagine
	$("#image_elem, #mag_image_elem").bind("contextmenu",function(e){
	  e.preventDefault()
	});
});
