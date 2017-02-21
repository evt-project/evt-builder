/**
 * 
 * Utils jQuery
 * Version 0.1 (201210)
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
 * @author RafMas 
 * @since 2012 @to 2015
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
