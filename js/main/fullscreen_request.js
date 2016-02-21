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
 * @author RafMas 
 * @since 2013
 **/

(function () {
    var viewFullScreen = document.getElementById("main_fullscreen");
    if (viewFullScreen) {
        viewFullScreen.addEventListener("click", function () {
        	if(viewFullScreen.getAttribute('data-action')=="go_fullscreen"){
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
			}
			else {
				if (document.exitFullscreen) {
					document.exitFullscreen();
				}
				else if (document.mozCancelFullScreen) {
					document.mozCancelFullScreen();
				}
				else if (document.webkitCancelFullScreen) {
					document.webkitCancelFullScreen();
				}
			}
        }, false);
    }
	
	var viewFullScreenII = document.getElementById("view-fullscreenII");
    if (viewFullScreenII != null) {
        viewFullScreenII.addEventListener("click", function () {
			if(viewFullScreenII.getAttribute('data-action')=="go_fullscreen"){
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
	
	if (document.addEventListener) {
	    document.addEventListener('webkitfullscreenchange', onFullScreenChange, false);
	    document.addEventListener('mozfullscreenchange', onFullScreenChange, false);
	    document.addEventListener('fullscreenchange', onFullScreenChange, false);
	    document.addEventListener('MSFullscreenChange', onFullScreenChange, false);
	}

	function onFullScreenChange(){
		var viewFullScreen = document.getElementById("main_fullscreen");
	    if(viewFullScreen.getAttribute('data-action')=="go_fullscreen"){
			viewFullScreen.title = window.lang.convert('EXIT_FULLSCREEN', window.lang.currentLang);
			viewFullScreen.setAttribute('data-action', 'exit_fullscreen');
			var goFullScreenIcon = viewFullScreen.getElementsByClassName('fa')[0]
			goFullScreenIcon.className = "fa fa-compress";
		}
		else {
			viewFullScreen.title = window.lang.convert('GO_FULLSCREEN', window.lang.currentLang);
			viewFullScreen.setAttribute('data-action', 'go_fullscreen');
			var goFullScreenIcon = viewFullScreen.getElementsByClassName('fa')[0]
			goFullScreenIcon.className = "fa fa-expand";
		}
	}

})();