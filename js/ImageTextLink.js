

/* This is the JavaScript code used to display the Web view of the image markup project. */

/*
     Version 1.3.
     
     Started work on this December 5 2005.
     
     Image Markup Tool Web View JavaScript  file.to support Web View functionality.
     December 2005 - April 2008.
     
     LICENSE
     
     The contents of this file are subject to the Mozilla Public License Version
     1.1 (the "License"); you may not use this file except in compliance with
     the License. You may obtain a copy of the License at
     "http://www.mozilla.org/MPL/"
     
     Software distributed under the License is distributed on an "AS IS" basis,
     WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
     the specific language governing rights and limitations under the License.
     
     The Original Code is "[web_view.js]". 
     
     The Initial Developer of the Original Code is Martin Holmes (Victoria,
     BC, Canada, "http://www.mholmes.com/"). Copyright (C) 2005-2008 Martin Holmes
     and the University of Victoria Computing and Media Centre. The code was
     co-developed for university and personal projects, and rights are shared
     by Martin Holmes and the University of Victoria. All Rights Reserved.
     
*/

/*Modified by JK*/

//We need to know if this is the dreadful IE6 or below -- it can't handle key CSS features.

var isOldIE = ((navigator.userAgent.indexOf('MSIE 6') > -1) || (navigator.userAgent.indexOf('MSIE 5') > -1));
var isIE = (navigator.userAgent.indexOf('MSIE') > -1);

/*These three arrays are for convenience; they allow us to unhighlight things quickly. */

var Areas = new Array();
var Anns = new Array();
var AnnMenuItems = new Array();

var HeightOffset;
var selectedAreaHeightOffset;
var ImgLeft;
var selectedAreaImgLeft;
var ImgWidth;
var ImgRight;
var ImgBottom;
var paddingTop;
var marginTop;
var imgTop;
var ImgHeight;
var ViewWidth;
var WindowHeight;
var Ratio;
var click;
var Initializing = true;


function Initialize(){
    if (Initializing == true){
    
/* Populate three handy lists with pointers to the menu items, areas and Anns. */
    HeightOffset = parseInt(document.getElementById('iviewerImage').offsetTop);
    ImgLeft = parseInt(document.getElementById('iviewerImage').offsetLeft);
    ImgWidth = parseInt(document.getElementById('iviewerImage').offsetWidth);
    ImgRight = ImgLeft + ImgWidth;
    ImgHeight = parseInt(document.getElementById('iviewerImage').offsetHeight);
    ImgBottom = HeightOffset + ImgHeight;
    paddingTop = parseInt($("#iviewerImage").css('padding-top'));
    marginTop = parseInt($("#iviewerImage").css('margin-top'));
    imgTop = HeightOffset + paddingTop + marginTop;
    document.getElementById("switchITL").setAttribute('src','images/ITLon.png');
    
    //var L = document.getElementById('AnnMenuContainer');
    //ViewWidth = parseInt(L.parentNode.offsetWidth);
    
    var ratio = ((document.getElementById("iviewerImage").width)/1200);
    Ratio = ratio;
    var NList = document.getElementsByTagName('div');
    for (var i=0; i<NList.length; i++){
        if (NList[i].className == 'Area'){
            NList[i].style.left = (parseFloat(NList[i].style.left)*ratio) + ImgLeft + 'px';
            NList[i].style.top = (parseFloat(NList[i].style.top)*ratio) + imgTop + 'px';
            NList[i].style.width = (parseFloat(NList[i].style.width)*ratio) + 'px';
            NList[i].style.height = (parseFloat(NList[i].style.height)*ratio) + 'px';
			NList[i].style.display = 'block';
//Remove non-breaking spaces which were only added for the accursed IE.
            if (isIE == false){
                NList[i].innerHTML = '';
            }
            Areas.push(NList[i]);
            document.getElementById("image_elem").appendChild(NList[i]);
        }
        else{
            if (NList[i].className == 'Annotation'){
                Anns.push(NList[i]);
            }
        }
    }
    NList = document.getElementsByTagName('li');
    for (i=0; i<NList.length; i++){
         if (NList[i].className == 'AnnMenuItem'){
             AnnMenuItems.push(NList[i]);
         }
    }
//Position the Annotation Menu container
    /*
    L.style.top = HeightOffset + 'px';  
    SetAnnMenuHeight();
   
    if (parseInt(L.offsetWidth) > (ViewWidth / 3)){
        L.style.width = '30%'; //Hack for IE, which doesn't support CSS max-width 
    }
    var LLeft = Math.min(ImgRight,  (ViewWidth - parseInt(L.offsetWidth)));
    L.style.left = LLeft + 'px';
    
    if (isOldIE == false){
        L.style.position = 'fixed';
    }*/
    
//Now hide all the submenus
    /*NList = document.getElementsByTagName('ul');
    for (i=0; i<NList.length; i++){
        if (NList[i].className == 'AnnSubmenu'){
            NList[i].style.display = 'none';
        }
    }*/
    /* #3 da commentare avere il subMenu semmpre aperto*/
    
//Now check to see if there's a hash in the url, and select that area if there is.
    /*var DocHash = document.location.hash;
    var Item = null;
    var ItemId = '';
    if (DocHash.length > 1){*/
//Find the item id by stripping off the initial #Area_ or # if not Area_
        /*if (DocHash.substring(0, 6) == '#Area_'){
            ItemId = DocHash.substring(6, DocHash.length);
            Item = document.getElementById(ItemId);*/
//If it's an annotation, show it:
            /*if (Item.className == 'Annotation'){
                ShowAnn(ItemId);
            }
        }
        else{
            ItemId = DocHash.substring(1, DocHash.length);
            Item = document.getElementById(ItemId);
            if (Item != null){*/
//Try to find a container which is an annotation div
                /*while ((Item.className != 'Annotation') && (Item.nodeName.toLowerCase() != 'body')){
                    Item = Item.parentNode;
                }
                if (Item.className == 'Annotation'){*/
//we have an annotation; we need to find the corresponding area and show it.
//Strip off the first four characters (Ann_).
                    /*var TheId = Item.getAttribute('id');
                    ShowAnn(TheId.substring(4, TheId.length));      
                }
            }
        }
    }*/
    
//Attach the onresize event (if the IE version is not 6, where it causes endless loops).
    if (isOldIE == false){
        //window.onresize = SetAnnMenuHeight;
    }    
    
    Initializing = false;
    }
}

/*ADD BY JK: */

function ReInitialize(){
    //alert("ReInitialize()");
    if (Initializing == false){
        newImgTop = parseInt(document.getElementById('iviewerImage').offsetTop) +parseInt($('#iviewerImage').css('padding-top')) + parseInt($('#iviewerImage').css('margin-top'));
        newImgLeft = parseInt(document.getElementById('iviewerImage').offsetLeft);    
        var newRatio = ((document.getElementById("iviewerImage").width)/1200);
        
        var NList = document.getElementsByTagName('div');
        for (var i=0; i<NList.length; i++){
            if ((NList[i].className == 'Area')||(NList[i].className == 'SelectedArea')||(NList[i].className == 'HighlightedArea')){
                NList[i].style.left = (((parseFloat(NList[i].style.left)) - ImgLeft)/Ratio) * newRatio + newImgLeft + 'px';
		        NList[i].style.top = (((parseFloat(NList[i].style.top)) - imgTop)/Ratio) * newRatio + newImgTop + 'px';
                NList[i].style.width = ((parseFloat(NList[i].style.width))/Ratio) * newRatio + 'px';
                NList[i].style.height = ((parseFloat(NList[i].style.height))/Ratio)* newRatio + 'px';
            }
	    }
	    ImgLeft = newImgLeft;
	    imgTop = newImgTop;
	    Ratio = newRatio;
    }
}

function UnInitialize(){ 
	if (Initializing == false){
	//alert("UnInitialize");
	UnHighlight();
	Deselect();
	var ratio = ((document.getElementById("iviewerImage").width)/1200);	
	
	for (var i=0; i<Areas.length; i++){
	    Areas[i].style.left = ((parseFloat(Areas[i].style.left)) - ImgLeft)/ratio + 'px';
		Areas[i].style.top = ((parseFloat(Areas[i].style.top)) - imgTop)/ratio + 'px';
        Areas[i].style.width = (parseFloat(Areas[i].style.width)/ratio) + 'px';
        Areas[i].style.height = (parseFloat(Areas[i].style.height)/ratio) + 'px';
		Areas[i].style.display = 'none';
		document.getElementById("areaAnnotations").appendChild(Areas[i]);
	}
	Areas = [];
	
	Anns = [];
	AnnMenuItems = [];
	
	HeightOffset=0;
	ImgLeft=0;
	ImgWidth =0;
	ImgRight=0;
	ImgBottom=0;
	ImgHeight=0;
	paddingTop = 0;
	marginTop = 0;
    imgTop = 0;
	ViewWidth=0;
	WindowHeight=0;
	Initializing = true;
    }
}

function switchIMT(){
  if (magnifierON==true){}
	else if (Initializing == true){
	   Initialize();
	   //document.getElementById("switchITL").setAttribute('src','images/ITLon.png');//Add by JK for ITL
     $('#switchITL i').removeClass('fa-chain-broken').addClass('fa-chain');//Add by CDP for FA
     $('#switchITL span').text("ITL ON");//Add by CDP for FA
    }
	else {
	   UnInitialize();
	   //document.getElementById("switchITL").setAttribute('src','images/ITLoff.png');
     $('#switchITL i ').removeClass('fa-chain').addClass('fa-chain-broken');//Add by CDP for FA
     $('#switchITL span').text("ITL OFF");//Add by CDP for FA
	}
}

    function moveAreas(){
    	if (Initializing == false){
    	    newImgTop = parseInt(document.getElementById('iviewerImage').offsetTop) +parseInt($('#iviewerImage').css('padding-top')) + parseInt($('#iviewerImage').css('margin-top'));
            newImgLeft = parseInt(document.getElementById('iviewerImage').offsetLeft);
            var NList = document.getElementsByTagName('div')
            for (var i=0; i<NList.length; i++){
                if ((NList[i].className == 'Area')||(NList[i].className == 'SelectedArea')||(NList[i].className == 'HighlightedArea')){
                    NList[i].style.left = (parseFloat(NList[i].style.left))- ImgLeft + newImgLeft + 'px';
                    NList[i].style.top = (parseFloat(NList[i].style.top))- imgTop + newImgTop + 'px';
                }
	       }
	       ImgLeft = newImgLeft;
	       imgTop = newImgTop;
	   }
    }
    
/* END ADD BY JK*/

/*function SetAnnMenuHeight(){*/
/* Set the maximum height of the menu, based on the available window height, so that 
    it can scroll appropriately when required. */
    /*
    if (window.innerHeight){
        WindowHeight = parseInt(window.innerHeight);
    }
    else{
        if (document.documentElement.clientHeight){
            WindowHeight = parseInt(document.documentElement.clientHeight);
        }
        else{
            WindowHeight = 400; //have to fix it at something.
        }
    }
    var AnnMenuTitleHeight = parseInt(document.getElementById('AnnMenuTitle').offsetHeight);
    var M = document.getElementById('AnnMenu');
    M.style.maxHeight = (WindowHeight - (HeightOffset + AnnMenuTitleHeight)) + 'px';
}*/
/*#1*/

function UnHighlight(){
/* Hide all area borders on the image, and unhighlight area list items, assuming they aren't the currently selected item.  */
     for (var i=0; i<Areas.length; i++){
         if (Areas[i] != null){
             if (Areas[i].className != 'SelectedArea'){
                 Areas[i].className = 'Area';
            }
         }
      }
      for (var i=0; i<AnnMenuItems.length; i++){
         if (AnnMenuItems[i] != null) {
             if (AnnMenuItems[i].className != 'SelectedAnnMenuItem'){
                 AnnMenuItems[i].className = 'AnnMenuItem';
            }
         }
     }
}

function Deselect(){
    if (Initializing == true){return;}
/* Deselect the currently-selected elements  */
     var c;
     for (var i=0; i<Areas.length; i++){
         if (Areas[i] != null){
             Areas[i].className = 'Area';
         }
     }
     for (i=0; i<AnnMenuItems.length; i++){
         if (AnnMenuItems[i] != null){
             AnnMenuItems[i].className = 'AnnMenuItem';
         }
     }
     for (i=0; i<Anns.length; i++){
         if (Anns[i] != null){
             Anns[i].style.display = 'none';
         }
     }
}

function Highlight(ItemId){
    if (Initializing == true){return;}
    UnHighlight();
    
    var El = document.getElementById('Area_' + ItemId);
    if (El != null){
        if (El.className != 'SelectedArea'){
            El.className = 'HighlightedArea';
        }
    }
    
    El = document.getElementById('MenuItem_' + ItemId);
    if (El != null){
        if (El.className != 'SelectedAnnMenuItem'){
            El.className = 'HighlightedAnnMenuItem';
/* The following lines can be uncommented if you want to make the 
menu expand itself automatically to reveal hidden items when their 
counterpart areas in the image are moused-over. */
//            if (El.parentNode.style.display != 'block'){
//                El.parentNode.style.display = 'block';
//            }
        }
    }
}

/*function ShowCategory(El){
    if (Initializing == true){return;}
    var AnnList = El.parentNode.getElementsByTagName('ul');
    if (AnnList.length > 0){
        if (AnnList[0].style.display != 'block'){
            AnnList[0].style.display = 'block';
        }
        else{
            AnnList[0].style.display = 'none';
        }
    }  
}*/
// #3 Serve per aprire e chiudere la cetegoria quando clicco sul titolo della cat

function JumpTo(ItemId){
	if (Initializing == true){return;}
	Deselect();
    
    var TheArea = document.getElementById('Area_' + ItemId);
    if (TheArea != null){
        TheArea.className = 'SelectedArea';
        //document.getElementById('image_elem').scrollTop = TheArea.offsetTop; //Add by JK for EVT-builder
    }

    var TheMenuItem = document.getElementById('MenuItem_' + ItemId);
    if (TheMenuItem != null){
        if (TheMenuItem.parentNode.style.display != 'block'){
            TheMenuItem.parentNode.style.display = 'block';
        }    
       TheMenuItem.className = 'SelectedAnnMenuItem';
    }
    
//ShowAnn(ItemId);
//The following line commented out to stop unnecessary jumping around. It removes the option 
//of bookmarking a specific annotation, though :-(
//    document.location.hash='Area_' + ItemId;

//Now we need to scroll the annotation into view:

/* For dismally crappy old IE6 which doesn't support position: fixed,
move the menu so it doesn't scroll out of view. */
   /* if (isOldIE == true){
        document.getElementById('AnnMenuContainer').style.top = (HeightOffset + GetScrollTop()) + 'px';
    }*/
}

function ShowAnn(ItemId){
    if (click==false){return;}
    Deselect();
    
    var TheArea = document.getElementById('Area_' + ItemId);
        if (TheArea != null){
        TheArea.className = 'SelectedArea';
        //document.getElementById('image_elem').scrollTop = TheArea.offsetTop; //Add by JK for EVT-builder
        //TheArea.scrollIntoView();
        /*if (parseInt(TheArea.style.top) < GetScrollTop()){
            window.scrollBy(0, (parseInt(TheArea.style.top) - GetScrollTop()));
        } 
        var AreaBottom = parseInt(TheArea.style.top) + parseInt(TheArea.style.height);
        if ((GetScrollTop() + GetViewportHeight()) < AreaBottom){
            window.scrollTo(0, parseInt(TheArea.style.top));
        }*/
    }
    
    var TheMenuItem = document.getElementById('MenuItem_' + ItemId);
    if (TheMenuItem != null){
        if (TheMenuItem.parentNode.style.display != 'block'){
            TheMenuItem.parentNode.style.display = 'block';
        }    
       TheMenuItem.className = 'SelectedAnnMenuItem';
       //scroll it
       document.getElementById('text_elem').scrollTop = TheMenuItem.offsetTop; //Add by JK for EVT-builder
        
//Now try to scroll it into view
        //TheMenuItem.scrollIntoView();
    }
    
    /*var TheAnnotation = document.getElementById('Ann_' + ItemId);
//Position the Ann div (try to keep it on the image itself)
    if (TheAnnotation != null){

//if the user has previously dragged a div, use the same position
        if ((DroppedX > -1)&&(DroppedY > -1)){
            if (isOldIE == false){
                TheAnnotation.style.position = 'fixed';
            }
            TheAnnotation.style.left = DroppedX + 'px';
            TheAnnotation.style.top = DroppedY + 'px';
            TheAnnotation.style.display = 'block';
            return;
        }
	
//Otherwise, figure out the best place to show it:
//First, set it to absolute positioning
        TheAnnotation.style.position = 'absolute';
	
//Horizontal position
        var ALeft = parseInt(TheArea.style.left);

//Show the Ann so we can position it afterwards
        TheAnnotation.style.left = ALeft + 'px';
        TheAnnotation.style.display = 'block';
        if (ALeft + parseInt(TheAnnotation.offsetWidth) > ImgRight){
            ALeft = ImgRight - parseInt(TheAnnotation.offsetWidth);
        }
        TheAnnotation.style.left = ALeft + 'px';
//Vertical position
        var ATop = parseInt(TheArea.style.top) + parseInt(TheArea.offsetHeight);
        if (ATop + parseInt(TheAnnotation.offsetHeight) > ImgBottom){
            ATop = parseInt(TheArea.style.top) - parseInt(TheAnnotation.offsetHeight);
        }
        TheAnnotation.style.top = ATop  + 'px';
//Handle the problem of disappearing off the top
        if (parseInt(TheAnnotation.offsetTop) < HeightOffset){
            TheAnnotation.style.top = HeightOffset + 'px';
            TheAnnotation.style.left = '0px';
        }
    }
*/
}

/*function HideAnn(AnnId){
    var El = document.getElementById(AnnId);
    if (El != null){
	El.style.display = 'none';
	El.style.position = 'absolute';
    }
    DroppedX = -1;
    DroppedY = -1;
}*/ 
/*#1 PopUp con annotazione sull'immagine*/

var DeltaX;
var DeltaY;
var DraggedEl = null;
var DroppedX = -1;
var DroppedY = -1;

/*function BeginDrag(El, e){
    if (!e){e = window.event;}
    var x = parseInt(El.style.left);
    var y = parseInt(El.style.top);
    DeltaX = e.clientX - x;
    DeltaY = e.clientY - y;
    DraggedEl = El;
    if (document.addEventListener){
        document.addEventListener('mousemove', MouseMoveHandler, true);
        document.addEventListener('mouseup', MouseUpHandler, true);
    }
    else{
        document.attachEvent('onmousemove', MouseMoveHandler);
        document.attachEvent('onmouseup', MouseUpHandler);
    }
    if (e.stopPropagation){e.stopPropagation();}else{e.cancelBubble = true;}
    if (e.preventDefault){e.preventDefault();}else{e.returnValue = false;}
}*/

/*function MouseMoveHandler(e){
    if (!e){e = window.event;}
    DraggedEl.style.left = (e.clientX - DeltaX) + 'px';
    DraggedEl.style.top = (e.clientY - DeltaY) + 'px';
    if (e.stopPropagation){e.stopPropagation();}else{e.cancelBubble = true;}
}

function MouseUpHandler(e){
    if (document.removeEventListener){
        document.removeEventListener('mouseup', MouseUpHandler, true);
        document.removeEventListener('mousemove', MouseMoveHandler, true);
    }
    else{
        document.detachEvent('onmouseup', MouseUpHandler);
        document.detachEvent('onmousemove', MouseMoveHandler);
    }
    if (!e){e = window.event;}
    if (e.stopPropagation){e.stopPropagation();}else{e.cancelBubble = true;}
    if (DraggedEl != document.getElementById('AnnMenuContainer')){
        DroppedX = parseInt(DraggedEl.style.left);
        DroppedY = parseInt(DraggedEl.style.top);
        if (isOldIE == false){
            DroppedX = DroppedX - GetScrollLeft();
            DroppedY = DroppedY - GetScrollTop();*/
/*If the user moved the annotation, we should conclude that he/she wants it to be 
in a fixed location, perhaps off to the side of the graphic. If that's the case, then 
we need to set it to position: fixed, then convert its location relative to the scroll 
offset. */
//        DraggedEl.style.position = 'absolute';
/*            DraggedEl.style.left = DroppedX + 'px';
            DraggedEl.style.top = DroppedY + 'px';
            DraggedEl.style.position = 'fixed';
        }
    }
    DraggedEl = null;
}*/

//Utility function for getting the vertical scroll offset for a scrolling document
/*function GetScrollTop(){
	if (document.documentElement && document.documentElement.scrollTop){
		return document.documentElement.scrollTop;
	}
	else{
		if (document.body){
 			return document.body.scrollTop;
		}
		else{
			return window.pageYOffset;
		}
	}
}*/

//Utility function for getting the horizontal scroll offset for a scrolling document
/*function GetScrollLeft(){
	if (document.documentElement && document.documentElement.scrollLeft){
		return document.documentElement.scrollLeft;
	}
	else{
		if (document.body){
 			return document.body.scrollLeft;
		}
		else{
			return window.pageXOffset;
		}
	}
}*/

//Utility function for finding the height of the browser viewport
/*function GetViewportHeight(){
    var Result = 400; //default just in case
    if (window.innerHeight){
        Result = window.innerHeight;
    }
    else{
        Result = document.getElementsByTagName('body')[0].clientHeight;
    }
    return Result;
}*/

//Zooming (showing a large portion of the original image)
/*function ShowZoom(X, Y, W, H){
    var Z = document.getElementById('Zoom');
    if (Z != null){
        Z.style.width = (W + 6) + 'px';
        Z.style.height = (H + 6) + 'px';
        if (Z.getElementsByTagName('img').length > 0){
            var Img = Z.getElementsByTagName('img')[0];
            Img.style.left = (X * -1) + 'px';
            Img.style.top = (Y * -1) + 'px';
        }
        Z.style.top = (GetScrollTop() + 10) + 'px';
        Z.style.display = 'block';
    }
}*/

