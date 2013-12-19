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
			if(viewFullScreen.title=="Fullscreen"){
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
			if(viewFullScreenII.title=="Fullscreen"){
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
		if(viewFullScreen.title=="Fullscreen"){
			viewFullScreen.title="close";
			viewFullScreenII.title="close";
			return false;
		}
		if(viewFullScreen.title=="close")
			viewFullScreen.title="Fullscreen";	
			viewFullScreenII.title="Fullscreen";	
	},false);
	document.addEventListener("webkitfullscreenchange", function(e) {
		if(viewFullScreen.title=="Fullscreen"){
			viewFullScreen.title="close";
			viewFullScreenII.title="close";
			return false;
		}
		if(viewFullScreen.title=="close")
			viewFullScreen.title="Fullscreen";	
			viewFullScreenII.title="Fullscreen";	},false);

})();