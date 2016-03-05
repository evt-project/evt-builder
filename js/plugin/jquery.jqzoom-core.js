/*!
 * jQzoom Evolution Library v2.3  - Javascript Image magnifier
 * http://www.mind-projects.it
 *
 * Copyright 2011, Engineer Marco Renzi
 * Licensed under the BSD license.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the organization nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * Date: 03 May 2011 22:16:00
 */
 
 /*
  * 2012 Edited by JK
  *
  * 2016 Edited by CDP
  */
 
(function ($) {
    //GLOBAL VARIABLES
    var isIE6 = ($.browser.msie && $.browser.version < 7);
    var body = $(document.body);
    var window = $(window);
    var jqzoompluging_disabled = false; //disabilita globalmente il plugin
    
    $.fn.jqzoom = function (options) {      /*Do un nome al plugin: Tramite lutilizzo di $.fn.jqzoom creo una nuova funzione che si chiama jqzoom*/
    return this.each(function () {          /*.each cicla il plugin su tutti gli elementi a cui  associato, Return permette di accodare altre funzioni*/
        var node = this.nodeName.toLowerCase();
            if (node == 'a') {
                new jqzoom(this, options);
            }
        });
    };
    jqzoom = function (el, options) {
        var api = null;
        api = $(el).data("jqzoom");
        if (api) return api;
        var obj = this;
        var settings = $.extend({}, $.jqzoom.defaults, options || {}); /*Merge defaults and options, without modifying the defaults (by passing an empty object as the target we preserve both of the original objects)*/
        obj.el = el;
        el.rel = $(el).attr('rel');
        //ANCHOR ELEMENT
        el.zoom_active = false;
        el.zoom_disabled = false;       //to disable single zoom instance
        el.largeimageloading = false;   //tell us if large image is loading
        el.largeimageloaded = false;    //tell us if large image is loaded
        el.stageresized = false;        //tell us if large image has been resized
        el.scale = {};                  // = largeimage/smallimage
        el.scaleI = {};                 // = smallimage/largeimage
        el.timer = null;
        el.mousepos = {};
        el.mouseDown = false;
        $(el).css({
            'outline-style': 'none',
            'text-decoration': 'none'
        });
        //BASE IMAGE
        var img = $("img:eq(0)", el);
        //el.title = $(el).attr('title');
        //el.imagetitle = img.attr('title');
        //var zoomtitle = ($.trim(el.title).length > 0) ? el.title : el.imagetitle;
        var smallimage = new Smallimage(img);
        var lens = new Lens();
        var stage = new Stage();
        var largeimage = new Largeimage();
        var loader = new Loader();
        //preventing default click,allowing the onclick event [exmple: lightbox]
        $(el).bind('click', function (e) {
            e.preventDefault();
            return false;
        });
        //setting the default zoomType if not in settings
        var zoomtypes = ['standard', 'drag', 'reverse'];
        if ($.inArray($.trim(settings.zoomType), zoomtypes) < 0) {
            settings.zoomType = 'standard';
        }
        $.extend(obj, {
            create: function () { //create the main objects
                //create ZoomPad
                if ($(".zoomPad", el).length == 0) {
                    el.zoomPad = $('<div/>').addClass('zoomPad');
                    img.wrap(el.zoomPad);
                }
                //creating ZoomPup
                if ($(".zoomPup", el).length == 0) {
                    lens.append();
                }
                //creating zoomWindow
                if ($(".zoomWindow", el).length == 0) {
                    stage.append();
                }
                //creating Preload
                if ($(".zoomPreload", el).length == 0) {
                    loader.append();
                }
                //preloading images
                if (settings.preloadImages || settings.zoomType == 'drag' || settings.alwaysOn) {
                    obj.load();
                }
                obj.init();
            },
            init: function () {
                //drag option
                if (settings.zoomType == 'drag') {
                    $(".zoomPad", el).mousedown(function () {
                        el.mouseDown = true;
                    });
                    $(".zoomPad", el).mouseup(function () {
                        el.mouseDown = false;
                    });
                    document.body.ondragstart = function () {
                        return false;
                    };
                    $(".zoomPad", el).css({
                        cursor: 'default'
                    });
                    $(".zoomPup", el).css({
                        cursor: 'move'
                    });
                }
                $(".zoomPad", el).bind('mouseenter mouseover', function (event) {
                    //img.attr('title', '');
                    //$(el).attr('title', '');
                    el.zoom_active = true;
                    //if loaded then activate else load large image
                    smallimage.fetchdata();
                    if (el.largeimageloaded) {
                        obj.activate(event);
                    } else {
                        obj.load();
                    }

                });
                $(".zoomPad", el).bind('mouseleave', function (event) {
                    obj.deactivate();
                });
                $(".zoomPad", el).bind('mousemove', function (e) {

                    //prevent fast mouse mevements not to fire the mouseout event
                    /*if (e.pageX > smallimage.pos.r || e.pageX < smallimage.pos.l || e.pageY < smallimage.pos.t || e.pageY > smallimage.pos.b) {
                        lens.setcenter();
                        return false;
                    }*/
                    
                    el.zoom_active = true;
                    if (el.largeimageloaded && !$('.zoomWindow', el).is(':visible')) {
                        obj.activate(e);
                    }
                    if (el.largeimageloaded && (settings.zoomType != 'drag' || (settings.zoomType == 'drag' && el.mouseDown))) {
                        lens.setposition(e);
                        if (settings.position == 'inside'){
                            stage.moveposition(e);
                        }
                    }
                });

                var thumb_preload = new Array();
                var i = 0;
                //binding click event on thumbnails
                var thumblist = new Array();
                thumblist = $('a').filter(function () {
                    var regex = new RegExp("gallery[\\s]*:[\\s]*'" + $.trim(el.rel) + "'", "i");
                    var rel = $(this).attr('rel');
                    if (regex.test(rel)) {
                        return this;
                    }
                });
                if (thumblist.length > 0) {
                    //getting the first to the last
                    var first = thumblist.splice(0, 1);
                    thumblist.push(first);
                }
                thumblist.each(function () {
                    //preloading thumbs
                    if (settings.preloadImages) {
                        var thumb_options = $.extend({}, eval("(" + $.trim($(this).attr('rel')) + ")"));
                        thumb_preload[i] = new Image();
                        thumb_preload[i].src = thumb_options.largeimage;
                        i++;
                    }
                    $(this).click(function (e) {
                        if($(this).hasClass('zoomThumbActive')){
                          return false;
                        }
                        thumblist.each(function () {
                            $(this).removeClass('zoomThumbActive');
                        });
                        e.preventDefault();
                        obj.swapimage(this);
                        return false;
                    });
                });
            },
            load: function () {
                if (el.largeimageloaded == false && el.largeimageloading == false) {
                    var url = $(el).attr('href');
                    el.largeimageloading = true;
                    largeimage.loadimage(url);
                }
            },
            activate: function (e) {
                clearTimeout(el.timer);
                //show lens and zoomWindow
                if (settings.lens==true){lens.show();}
                stage.show();
            },
            deactivate: function (e) {
                switch (settings.zoomType) {
                case 'drag':
                    //nothing or lens.setcenter();
                    break;
                default:
                    //img.attr('title', el.imagetitle);
                    //$(el).attr('title', el.title);
                    if (settings.alwaysOn) {
                        lens.setcenter();
                    } else {
                        stage.hide();
                        lens.hide();
                    }
                    break;
                }
                el.zoom_active = false;
            },
            swapimage: function (link) {
                el.largeimageloading = false;
                el.largeimageloaded = false;
                var options = new Object();
                options = $.extend({}, eval("(" + $.trim($(link).attr('rel')) + ")"));
                if (options.smallimage && options.largeimage) {
                    var smallimage = options.smallimage;
                    var largeimage = options.largeimage;
                    $(link).addClass('zoomThumbActive');
                    $(el).attr('href', largeimage);
                    img.attr('src', smallimage);
                    lens.hide();
                    stage.hide();
                    obj.load();
                } else {
                    alert('ERROR :: Missing parameter for largeimage or smallimage.');
                    throw 'ERROR :: Missing parameter for largeimage or smallimage.';
                }
                return false;
            }
        });
        //sometimes image is already loaded and onload will not fire
        if (img[0].complete) {
            //fetching data from sallimage if was previously loaded
            if ($(".zoomPad", el).length == 0) obj.create();
            smallimage.fetchdata();
        }
/*========================================================,
|   Smallimage
|---------------------------------------------------------:
|   Base image into the anchor element
`========================================================*/

        function Smallimage(image) {
            var $obj = this;
            this.node = image[0];
            this.findborder = function () {
                var bordertop = parseFloat(image.css('border-top-width'));
                var borderleft = parseFloat(image.css('border-left-width'));
                $obj.btop = (bordertop> 0) ? eval(bordertop) : 0;
                $obj.bleft = (borderleft > 0) ? eval(borderleft) : 0;
            };
            this.fetchdata = function () {
                var scaleI = {};
                $obj.findborder();
                $obj.w = image.width();
                $obj.h = image.height();
                $obj.ow = image.outerWidth();   //width+padding+border  (NO margin)
                $obj.oh = image.outerHeight();
                $obj.pos = image.offset();
                $obj.position = image.position();
                $obj.addLeft = $obj.position.left;
                $obj.addTop = $obj.position.top;
                $obj.pos.l = $obj.pos.left + $obj.bleft;
                $obj.pos.t = $obj.pos.top + $obj.btop;
                $obj.pos.r = $obj.pos.l + $obj.w;
                $obj.pos.b = $obj.pos.t + $obj.h;
                $obj.rightlimit = $obj.pos.left + $obj.ow;
                $obj.bottomlimit = $obj.pos.top + $obj.oh;
                scaleI.x = ($obj.w / largeimage.w);
                scaleI.y = ($obj.h / largeimage.h);
                el.scaleI = scaleI;
            };
            this.node.onerror = function () {
                // alert('Problems while loading image.');
                throw new Error('SmallImageError/There was a problem while loading the image.'); //Add by CDP
            };
            this.node.onload = function () {
                if ($(".zoomPad", el).length == 0) obj.create();
                $obj.fetchdata();
            };
            return $obj;
        };
/*========================================================,
|  Loader
|---------------------------------------------------------:
|  Show that the large image is loading
`========================================================*/

        function Loader() {
            var $obj = this;
            this.append = function () {
                this.node = $('<div/>').addClass('zoomPreload').css('visibility', 'hidden').html(settings.preloadText);
                $('.zoomPad', el).append(this.node);
            };
            this.show = function () {
                smallimage.fetchdata();
                if(smallimage.addLeft==0){//If add by JK for EVT-builder
                    var add= (parseFloat($("#main_right_frame").css("width"))-smallimage.ow)/2;
                    this.node.left = (smallimage.ow - this.node.width())/ 2 + add;
                }
                else {
                   this.node.left = (smallimage.ow - this.node.width()) / 2  + smallimage.addLeft;
                }
                if(smallimage.addTop==0){//If add by JK for EVT-builder
                   //var add= (parseFloat($("#main_right_frame").css("height"))-smallimage.oh)/2;
                   this.node.top = (smallimage.oh - this.node.height())/ 2;
                }
                else {
                   this.node.top = (smallimage.oh - this.node.height()) / 2 + smallimage.addTop;
                }
                //setting position
                this.node.css({
                    top: this.node.top + "px",
                    left: this.node.left + "px",
                    position: 'absolute',
                    visibility: 'visible'
                });
            };
            this.hide = function () {
                this.node.css('visibility', 'hidden');
            };
            return this;
        }
/*========================================================,
|   Lens
|---------------------------------------------------------:
|   Lens over the image
`========================================================*/

        function Lens() {
            var $obj = this;
            this.node = $('<div/>').addClass('zoomPup');
            //this.nodeimgwrapper = $("<div/>").addClass('zoomPupImgWrapper');
            this.append = function () {                                             /*creo div.ZoomPup(cioè lente) lo metto dentro zoomPad, invisibile + prendo dimensioni*/
                $('.zoomPad', el).append($(this.node).hide());
                if (settings.zoomType == 'reverse') {
                    this.image = new Image();
                    this.image.src = smallimage.node.src; // fires off async
                    $(this.node).empty().append(this.image);
                }
                $obj.setdimensions();
            };
            this.setdimensions = function () {                                      /*info dimensioni*/
                this.node.w = (parseInt(settings.lensWidth) > smallimage.w ) ? smallimage.w : parseInt (settings.lensWidth); 
                this.node.h = (parseInt(settings.lensHeight) > smallimage.h ) ? smallimage.h : parseInt(settings.lensHeight);
                //centering lens
                /*if(smallimage.addLeft==0){//If add by JK for EVT-builder
                    var add= (parseFloat($("#main_right_frame").css("width"))-zoomImagWidth)/2;  //Var zoomImagWidth set in switchZM.js
                    this.node.top = (smallimage.oh - this.node.h - 2) / 2;
                    this.node.left = ((smallimage.ow - this.node.w - 2) / 2) + add;
                }else {
                    this.node.top = (smallimage.oh - this.node.h - 2) / 2;
                    this.node.left = ((smallimage.ow - this.node.w - 2) / 2) + smallimage.addLeft;
                }*/
                this.node.css({
                    top: 0,
                    left: 0,
                    width: this.node.w + 'px',
                    height: this.node.h + 'px',
                    position: 'absolute',
                    display: 'none',
                    borderWidth: 1 + 'px'
                });

                if (settings.zoomType == 'reverse') {
                    this.image.src = smallimage.node.src;
                    $(this.node).css({
                        'opacity': 1
                    });
                    $(this.image).css({
                        position: 'absolute',
                        display: 'block',
                        left: -(this.node.left + 1 - smallimage.bleft) + 'px',
                        top: -(this.node.top + 1 - smallimage.btop) + 'px'
                    });

                }
            };
            this.setcenter = function () {                                          /*do le coordinare top e left per posizionare la lente al centro*/
                //calculating center position
                if(smallimage.addLeft==0){//If add by JK for EVT-builder
                    var add= (parseFloat($("#main_right_frame").css("width"))-smallimage.w)/2;
                    this.node.left = ((smallimage.ow - this.node.w - 2) / 2)+ add;
                }else {
                    this.node.left = ((smallimage.ow - this.node.w - 2) / 2) + smallimage.addLeft;
                }
                if(smallimage.addTop==0){//If add by JK for EVT-builder
                    var add= (parseFloat($("#main_right_frame").css("height"))-smallimage.h)/2;
                    this.node.top = ((smallimage.oh - this.node.h - 2) / 2)+add;
                }else {
                    this.node.top = (smallimage.oh - this.node.h - 2) / 2 + smallimage.addTop;
                }
                this.node.top = (smallimage.oh - this.node.h - 2) / 2;
                //centering lens
                this.node.css({
                    top: this.node.top,
                    left: this.node.left
                });
                if (settings.zoomType == 'reverse') {
                    $(this.image).css({
                        position: 'absolute',
                        display: 'block',
                        left: -(this.node.left + 1 - smallimage.bleft) + 'px',
                        top: -(this.node.top + 1 - smallimage.btop) + 'px'
                    });
                }
                //centering large image
                largeimage.setposition();
                //stage.setposition();          //?CONTROLLARE
            };
            this.setposition = function (e) {
                el.mousepos.x = e.pageX;
                el.mousepos.y = e.pageY;
                var lensleft = 0;
                var lenstop = 0;

                function overleft(lens) {
                    return el.mousepos.x -1-(lens.w / 2) < smallimage.pos.l; 
                }

                function overright(lens) {
                    return el.mousepos.x +1+(lens.w/ 2) > smallimage.pos.r;
                }

                function overtop(lens) {
                    return el.mousepos.y -1-(lens.h) / 2 < smallimage.pos.t; 
                }

                function overbottom(lens) {
                    return el.mousepos.y +1+(lens.h) / 2 > smallimage.pos.b; 
                }
                
                if (overleft(this.node)) {
                    lensleft = smallimage.addLeft + smallimage.bleft;
                } else if (overright(this.node)) {
                    lensleft = smallimage.addLeft + smallimage.w + smallimage.bleft - this.node.w;
                } else {
                    lensleft = el.mousepos.x-smallimage.pos.l+smallimage.bleft+smallimage.addLeft - ((this.node.w + 2)/2);
                }

                if (overtop(this.node)) {
                    lenstop = smallimage.addTop + smallimage.btop;
                } else if (overbottom(this.node)) {
                    lenstop = smallimage.addTop + smallimage.h + smallimage.btop - this.node.h;
                } else {
                    lenstop = el.mousepos.y - smallimage.pos.t + smallimage.btop + smallimage.addTop - (this.node.h + 2) / 2;
                }
                
                this.node.left = lensleft;
                this.node.top = lenstop;
                this.node.css({
                    'left': lensleft + 'px',
                    'top': lenstop + 'px'
                });
                if (settings.zoomType == 'reverse') {
                    if ($.browser.msie && $.browser.version > 7) {
                        $(this.node).empty().append(this.image);
                    }

                    $(this.image).css({
                        position: 'absolute',
                        display: 'block',
                        left: -(this.node.left + 1 - smallimage.bleft) + 'px',
                        top: -(this.node.top + 1 - smallimage.btop) + 'px'
                    });
                }
               
                largeimage.setposition();
            };
            this.hide = function () {
                img.css({
                    'opacity': 1
                });
                this.node.hide();
            };
            this.show = function () {  
                
                //if (settings.zoomType != 'innerzoom' && (settings.lens || settings.zoomType == 'drag')) {    //N.B mostro lente anche con innerzoom
                    this.node.show();
                //}       
                 if (settings.zoomType == 'reverse') {
                    img.css({
                        'opacity': settings.imageOpacity
                    });
                }
            };
            this.getoffset = function () {
            //Coordinate angolo sx-top lente
                var o = {};
                if(smallimage.addLeft==0){
                    var add= (parseFloat($("#main_right_frame").css("width"))-zoomImagWidth)/2;
                    o.left = $obj.node.left - add;
                    }
                else{
                    o.left = $obj.node.left - smallimage.addLeft;
                }
                o.top = $obj.node.top;
                return o;
            };
            return this;
        };
/*========================================================,
|   Stage
|---------------------------------------------------------:
|   Window area that contains the large image
`========================================================*/

        function Stage() {
            var $obj = this;
            //this.node = $("<div class='zoomWindow'><div class='zoomWrapper'><div class='zoomWrapperTitle'></div><div class='zoomWrapperImage'></div></div></div>");
            this.node = $("<div class='zoomWindow'><div class='zoomWrapperImage'></div></div>");
            //this.ieframe = $('<iframe class="zoomIframe" src="javascript:\'\';" marginwidth="0" marginheight="0" align="bottom" scrolling="no" frameborder="0" ></iframe>');
            this.append = function () {
                $('.zoomPad', el).append(this.node);
                this.node.css({
                    position: 'absolute',
                    display: 'none',
                    zIndex: 5001
                });
                /*if (settings.position == 'inside') {
                    var thickness = (smallimage.bleft == 0) ? 1 : smallimage.bleft;
                    $('.zoomWrapper', this.node).css({
                        width: Math.round(settings.lensWidth) + 'px',
                        borderWidth: thickness + 'px'
                    });
                }*/
                
                /*$('.zoomWrapper', this.node).css({
                    width: Math.round(settings.lensWidth) + 'px' ,
                    height: Math.round(settings.lensHeight) + 'px',
                    borderWidth: thickness + 'px'
                });*/
                
                $('.zoomWrapperImage', this.node).css({
                    // width: Math.round(settings.lensWidth) + 'px',
                    // height: Math.round(settings.lensHeight) + 'px'
                    width: Math.round(settings.lensWidth/el.scaleI.x) + 'px' ,
                    height: Math.round(settings.lensHeight/el.scaleI.y) + 'px'
                });
                //zoom title
                /*$('.zoomWrapperTitle', this.node).css({
                    width: '100%',
                    position: 'absolute'
                });  
              
                $('.zoomWrapperTitle', this.node).hide();
                if (settings.title && zoomtitle.length > 0) {
                    $('.zoomWrapperTitle', this.node).html(zoomtitle).show();
                }*/
            };
            this.setdimensions = function () {
                  /*$('.zoomWrapper', this.node).css({
                      width: Math.round(settings.lensWidth/el.scaleI.x) + 'px' ,
                      height: Math.round(settings.lensHeight/el.scaleI.y) + 'px'
                  });*/
                  $('.zoomWrapperImage', this.node).css({
                      width: Math.round(settings.lensWidth/el.scaleI.x) + 'px' ,
                      height: Math.round(settings.lensHeight/el.scaleI.y) + 'px'
                  });
                  el.stageresized = true;
                  //$obj.setposition();
            };
            this.hide = function () {
                switch (settings.hideEffect) {
                case 'fadeout':
                    this.node.fadeOut(settings.fadeoutSpeed, function () {});
                    break;
                default:
                    this.node.hide();
                    break;
                }
                //this.ieframe.hide();
            };
            this.show = function () {
                switch (settings.showEffect) {
                case 'fadein':
                    this.node.fadeIn();
                    this.node.fadeIn(settings.fadeinSpeed, function () {});
                    break;
                default:
                    this.node.show();
                    break;
                }
                /*if (isIE6 && settings.zoomType != 'innerzoom') {
                    this.ieframe.width = this.node.width();
                    this.ieframe.height = this.node.height();
                    this.ieframe.left = this.node.leftpos;
                    this.ieframe.top = this.node.toppos;
                    this.ieframe.css({
                        display: 'block',
                        position: "absolute",
                        left: this.ieframe.left,
                        top: this.ieframe.top,
                        zIndex: 99,
                        width: this.ieframe.width + 'px',
                        height: this.ieframe.height + 'px'
                    });
                    $('.zoomPad', el).append(this.ieframe);
                    this.ieframe.show();
                };*/
            };
            this.setposition = function () {
                //this.node.leftpos = 0;
                //this.node.toppos = 0;
                //if (settings.position != 'inside') {
                var zoomWidth = Math.round(settings.lensWidth/el.scaleI.x);
                var zoomHeight = Math.round(settings.lensHeight/el.scaleI.y);
                //positioning
                switch (settings.position) {
                    case "left":
                        this.node.leftpos = (smallimage.pos.l - smallimage.bleft - Math.abs(settings.xOffset) - zoomWidth > 0) ? (0 - zoomWidth - Math.abs(settings.xOffset)) : (smallimage.ow + Math.abs(settings.xOffset));
                        this.node.toppos = Math.abs(settings.yOffset);
                        break;
                    case "top":
                        this.node.leftpos = Math.abs(settings.xOffset);
                        this.node.toppos = (smallimage.pos.t - smallimage.btop - Math.abs(settings.yOffset) - zoomHeight > 0) ? (0 - zoomHeight - Math.abs(settings.yOffset)) : (smallimage.oh + Math.abs(settings.yOffset));
                        break;
                    case "bottom":
                        this.node.leftpos = Math.abs(settings.xOffset);
                        this.node.toppos = (smallimage.pos.t - smallimage.btop + smallimage.oh + Math.abs(settings.yOffset) + zoomHeight < screen.height) ? (smallimage.oh + Math.abs(settings.yOffset)) : (0 - zoomHeight - Math.abs(settings.yOffset));
                        break;
                    case "inside":
                        if(smallimage.addLeft==0){//If add by JK for EVT-builder
                           var add= (parseFloat($("#main_right_frame").css("width"))-smallimage.w)/2;
                           this.node.leftpos = (smallimage.w - settings.lensWidth/el.scaleI.x -2)/ 2 + add -2;
                       }
                       else {
                          this.node.leftpos = smallimage.bleft - 2 + (smallimage.w - settings.lensWidth/el.scaleI.x)/ 2 + smallimage.addLeft;
                        }
                        if(smallimage.addTop==0){//If add by JK for EVT-builder
                           //var add= (parseFloat($("#main_right_frame").css("height"))-smallimage.h)/2;
                           this.node.toppos = (smallimage.oh - settings.lensHeight/el.scaleI.y -2)/ 2 -2;
                       }else{
                          this.node.toppos = smallimage.btop - 2 + (smallimage.h - settings.lensHeight/el.scaleI.y)/ 2 + smallimage.addTop;
                        }
                        break;
                    default:
                        this.node.leftpos = (smallimage.rightlimit + Math.abs(settings.xOffset) + zoomWidth < screen.width) ? (smallimage.ow + Math.abs(settings.xOffset)) : (0 - zoomWidth - Math.abs(settings.xOffset));
                        this.node.toppos = Math.abs(settings.yOffset);
                        break;
                }
                //}
                this.node.css({
                    'left': this.node.leftpos + 'px',
                    'top': this.node.toppos + 'px',
                    'position': 'absolute'
                });
                /*if (el.largeimageloaded && !(el.stageresized)) {
                }
                $obj.setdimensions();*/
                return this;
            };
            this.moveposition =function(e){
                //dimensioni ZoomWindow
                var wid = Math.round(settings.lensWidth/el.scaleI.x);
                var hei = Math.round(settings.lensHeight/el.scaleI.y);
                //
                var lensleft = 0;
                var lenstop = 0;
                //funzioni
                function overleft(stage) {
                    return el.mousepos.x - (wid) / 2 < smallimage.pos.l;
                }
                function overright(stage) {
                    return el.mousepos.x + (wid) / 2 > smallimage.pos.r;
                }
                function overtop(stage) {
                    return el.mousepos.y - (hei) / 2 < smallimage.pos.t; 
                }
                function overbottom(stage) {
                    return el.mousepos.y + (hei) / 2 > smallimage.pos.b; 
                }

                //el.mousepos.x = e.pageX;
                //el.mousepos.y = e.pageY;
                lensleft = el.mousepos.x + smallimage.bleft - smallimage.pos.l - (wid + 2) / 2 + smallimage.addLeft;
                lenstop = el.mousepos.y + smallimage.btop - smallimage.pos.t - (hei + 2) / 2 + smallimage.addTop;

                if (overleft(this.node)) {
                    lensleft = smallimage.addLeft + smallimage.bleft;
                } else if (overright(this.node)) {
                    lensleft =  smallimage.addLeft + smallimage.w + smallimage.bleft - wid - 2;
                }
                if (overtop(this.node)) {
                    lenstop = smallimage.btop;
                } else if (overbottom(this.node)) {
                    lenstop = smallimage.h + smallimage.btop - hei - 2;
                }

                this.node.leftpos = lensleft;
                this.node.toppos = lenstop;
                this.node.css({
                    'left': this.node.leftpos + 'px',
                    'top': this.node.toppos + 'px'
                });
                return this;
            };
        };
/*========================================================,
|   LargeImage
|---------------------------------------------------------:
|   The large detailed image
`========================================================*/

        function Largeimage() {
            var $obj = this;
            this.node = new Image();
            this.loadimage = function (url) {
                //showing preload
                loader.show();
                this.url = url;
                this.node.style.position = 'absolute';
                this.node.style.border = '0px';
                this.node.style.display = 'none';
                this.node.style.left = '-5000px';
                this.node.style.top = '0px';
                document.body.appendChild(this.node);
                this.node.src = url; // fires off async
            };
            this.fetchdata = function () {
                var image = $(this.node);
                var scale = {};
                this.node.style.display = 'block';
                $obj.w = image.width();
                $obj.h = image.height();
                $obj.pos = image.offset();
                $obj.pos.l = $obj.pos.left;
                $obj.pos.t = $obj.pos.top;
                $obj.pos.r = $obj.w + $obj.pos.l;
                $obj.pos.b = $obj.h + $obj.pos.t;
                scale.x = ($obj.w / smallimage.w);
                scale.y = ($obj.h / smallimage.h);
                el.scale = scale;
                //document.body.removeChild(this.node);
                $('.zoomWrapperImage', el).empty().append(this.node);
                $obj.setdimensions();
                
            };
            this.setdimensions = function () {                                      /*calcola dimensioni*/
                this.w *= settings.zoomRatio; 
                this.h *= settings.zoomRatio;
                //centering lens
                $(this.node).css({
                    width: this.w + 'px',
                    height: this.h + 'px'
                });
            }
            this.node.onerror = function () {
                // alert('Problems while loading the big image.');
                throw new Error('BigImageError'); //Add by CDP
            };
            this.node.onload = function () {
                //fetching data
                $obj.fetchdata();       //calls $obj.setdimensions();
                smallimage.fetchdata();
                stage.setdimensions();
                stage.setposition();
                //setting stage dimensions
               
                el.largeimageloading = false;
                el.largeimageloaded = true;
                loader.hide();
                if (settings.zoomType == 'drag' || settings.alwaysOn) {
                    lens.setcenter();
                    if (settings.lens==true){lens.show();}
                    stage.show();
                    //if (settings.position == 'inside'){
                        //stage.setposition();
                    //}
                }
            };
            this.setposition = function () {
                var left = -el.scale.x * (lens.getoffset().left - smallimage.bleft) * settings.zoomRatio;
                var top = -el.scale.y * (lens.getoffset().top - smallimage.btop)* settings.zoomRatio;
                $(this.node).css({
                    'left': left + 'px',
                    'top': top + 'px'
                });
            };
            return this;
        };
        $(el).data("jqzoom", obj);
    }
    //es. $.jqzoom.disable('#jqzoom1');
    $.jqzoom = {
        defaults: {
            zoomType: 'standard',
            //standard/reverse/drag
            zoomRatio: 1,
            //
            lensWidth: 100,
            //Lens default width
            lensHeight: 100,
            //Lens  default height
            xOffset: 0,
            //zoomWindow x offset, can be negative(more on the left) or positive(more on the right)
            yOffset: 0,
            //zoomWindow y offset, can be negative(more on the left) or positive(more on the right)
            position: "right",
            //zoomWindow default position
            preloadImages: true,
            //image preload
            preloadText: 'Loading zoom',
            title: true,
            lens: true,
            imageOpacity: 0.4,
            alwaysOn: false,
            showEffect: 'show',
            //show/fadein
            hideEffect: 'hide',
            //hide/fadeout
            fadeinSpeed: 'slow',
            //fast/slow/number
            fadeoutSpeed: '2000' //fast/slow/number
        },
        disable: function (el) {
            var api = $(el).data('jqzoom');
            api.disable();
            return false;
        },
        enable: function (el) {
            var api = $(el).data('jqzoom');
            api.enable();
            return false;
        },
        disableAll: function (el) {
            jqzoompluging_disabled = true;
        },
        enableAll: function (el) {
            jqzoompluging_disabled = false;
        }
    };
})(jQuery);