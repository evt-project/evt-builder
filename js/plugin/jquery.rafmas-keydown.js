/**
 * 
 * KeyDown jQuery
 * Version 0.1 (201210)
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * 
 * @author RafMas 
 * @since 2012
 *
 * @author ChiaraDipi 
 * @since 2014
 **/

//Pressione tasti
$(document).keydown(function(e){
	if (e.altKey) {
		//MODE VIEW
		if (e.keyCode == 49) { //alt+1
			$('#mode_switch .mode_view:nth-child(1)').trigger('click');
		} else if (e.keyCode == 50) { //alt+2
			$('#mode_switch .mode_view:nth-child(2)').trigger('click');
		} else if (e.keyCode == 51) { //alt+3
			$('#mode_switch .mode_view:nth-child(3)').trigger('click');
		} else if (e.keyCode == 52) { //alt+1
			$('#mode_switch .mode_view:nth-child(4)').trigger('click');
		} 
		//NAVIGATION
		else if (e.keyCode == 80) { //alt+p => open PAGE SELECTOR
			if ($('#span_pp_select').is(':visible'))
				$('#span_pp_select').find('.open_select').trigger('click');
			if ($('#span_dd_select').is(':visible'))
				$('#span_dd_select').find('.open_select').trigger('click');
			return false;
		} else if (e.keyCode == 84) { //alt+t => open TEXT SELECTOR
			if ($('#span_tt_select').is(':visible'))
				$('#span_tt_select').find('.open_select').trigger('click');
			return false;
		} else if (e.keyCode == 69) { //alt+e => open EDITION SELECTOR
			if ($('#span_ee_select').is(':visible'))
				$('#span_ee_select').find('.open_select').trigger('click');
			return false;
		}
		// other useful
		else if (e.keyCode == 73) { //alt+i => open PROJECT INFO
			$('#info_link').trigger('click');
			return false;
		}
	}

	if ((e.keyCode == 102 || e.keyCode == 70) && (e.ctrlKey||e.metaKey) && e.altKey && e.shiftKey) { 
		e.preventDefault();
		//CTRL+ALT+SHIF+f - CMD+ALT+SHIF+f => go fullscreen
		document.getElementById("main_fullscreen").click();
	}
	if ((e.keyCode == 102 || e.keyCode == 70) && (e.ctrlKey||e.metaKey) && e.altKey) { //CTRL+f - CMD+f
        e.preventDefault();
        if (e.shiftKey) {
        	if($('#search_link-add').is(':visible')){
		        if ( !$('#search_link-add').hasClass('active') ) {
		        	$('#search_link-add').trigger('click');
		        } else {
		        	$('#tipue_search_input-add').focus();
		        }
		    }	
        } else {
	        if($('#search_link').is(':visible')){
		        if ( !$('#search_link').hasClass('active') ) {
		        	$('#search_link').trigger('click');
		        } else {
		        	$('#tipue_search_input').focus();
		        }
		    }
		}
        return false;
    }
	if (e.keyCode == 37) { //left
		if ((!$("#tipue_search_input") || !$("#tipue_search_input").is(":focus")) && 
			 (!$("#tipue_search_input-add") || !$("#tipue_search_input-add").is(":focus"))) {
			if (!$(".main_left_arrow").hasClass('arrow_left_disable'))
				$(".main_left_arrow").trigger('click');
			return false;
		}
	}				
	if (e.keyCode == 39) { //right
		if ((!$("#tipue_search_input") || !$("#tipue_search_input").is(":focus")) &&
			(!$("#tipue_search_input-add") || !$("#tipue_search_input-add").is(":focus"))) {
			if (! $(".main_right_arrow").hasClass('arrow_right_disable'))
				$(".main_right_arrow").trigger('click');
			return false;
		}
	}	
	if (e.keyCode == 38) { //up
		if ( !$('#headerInfo_cont').is(':visible')) {
			if ($('.option_container:visible').length == 0) {
				if ( !$('#imgd_link').hasClass('current_mode') ) {
					if (!$("#tipue_search_input") || !$("#tipue_search_input").is(":focus")) {
						if ( $('#inside_left_arrow').length > 0 || $('#inside_right_arrow').length > 0) {
							if (!$('#inside_left_arrow').hasClass('disabled')){
								$('#inside_left_arrow').trigger('click');
								$('#inside_left_arrow').animate({
									opacity: 1
								},
									100, function() {
										$('#inside_left_arrow').animate({
											opacity: 0.2
										}, 100);
								});
							} 
							return false;
						}
					}
				}
			} else {
				if ($('.hovered').length > 0) {
					$('.option_container:visible .option.hovered')
						.removeClass('hovered')
						.prev()
							.addClass('hovered');	
				} else {
					$('.hovered').removeClass('hovered');
					$('.option_container:visible .option.selected:first').prev().addClass('hovered');
				}
				var height = $('.option_container:visible').find('.option').height();
				var selected = $('.option_container:visible').find('.option.hovered').index();    
				var scroll = (height*1.5)*selected;
				$('.option_container:visible').animate({
					scrollTop: scroll
				}, 400);
				return false;
			}
		}
	}				
	if (e.keyCode == 40) { //down
		if ( !$('#headerInfo_cont').is(':visible')) {
			if ($('.option_container:visible').length == 0) {
				if ( !$('#imgd_link').hasClass('current_mode') ) {
					if (!$("#tipue_search_input") || !$("#tipue_search_input").is(":focus")) {
						if ( $('#inside_left_arrow').length > 0 || $('#inside_right_arrow').length > 0) {
							if (!$('#inside_right_arrow').hasClass('disabled')){
								$('#inside_right_arrow').trigger('click');
								$('#inside_right_arrow').animate({
									opacity: 1
								},
									100, function() {
										$('#inside_right_arrow').animate({
											opacity: 0.2
										}, 100);
								});
							}
						}
						return false;
					}
				}
			} else {
				if ($('.hovered').length > 0) {
					$('.option_container:visible .option.hovered')
						.removeClass('hovered')
						.next()
							.addClass('hovered');	
				} else {
					$('.hovered').removeClass('hovered');
					$('.option_container:visible .option.selected').next().addClass('hovered');
				}
				var height = $('.option_container:visible').find('.option').height();
				var selected = $('.option_container:visible').find('.option.hovered').index();    
				var scroll = (height*1.5)*selected;
				$('.option_container:visible').animate({
					scrollTop: scroll
				}, 400);
				return false;
			}
		}
	}	
	if (e.keyCode == 27) { //escape
		$("#header_collapse.fa-caret-down").trigger('click');
		$('.full .closeFullScreen').trigger('click');
		$('.option_container:visible').prev().trigger('click');
		$('#info_link.active').trigger('click');
		if ( $('#search_cont').hasClass('collapsed') && 
			$('#tipue_search_input').is(':focus') ) {
			$("#search_link.active").trigger('click');
			$('#main_right_frame .highlight').removeClass('highlight');
		}
		if ( $('#search_cont-add').hasClass('collapsed') && 
			 $('#tipue_search_input-add').is(':focus') ) {
			$("#search_link-add.active").trigger('click');
			$('#main_left_frame .highlight').removeClass('highlight');
		}

		if ( $('#keyboard_shortcuts_cont').is(':visible') ) {
			$('#keyboard_shortcuts_link').trigger('click');
		}
		return false;
	}	
	if ( e.keyCode == 13 ) { //input
		$('.option_container:visible .hovered').trigger('click').removeClass('hovered');
	}
});