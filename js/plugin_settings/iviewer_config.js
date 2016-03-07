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
    var current_pp;
    var hash_parts = new Array();
    hash_parts = location.hash.substr(1).split('&');
    if ( hash_parts != "" ) {
        for (var i = 0; i < hash_parts.length; i++) {
            if(hash_parts[i].indexOf("page") === 0) { //begins with "page"
                current_pp = hash_parts[i].substr(5);
                if (current_pp.indexOf('+') > 0) {
                    current_pp = current_pp.substr(0, current_pp.indexOf('+'));
                }
            }
        }
    } else {
        if ($('.current_mode').attr('id') == 'imgd_link'){
            current_pp = $('.main_dd_select .option_container .option:first').attr('data-value');
        } else {
            current_pp = $('.main_pp_select .option_container .option:first').attr('data-value');
        }
    }
    var cpns;
    if (current_pp !== undefined) {
       cpns="data/input_data/images/single/"+current_pp+".jpg";
    }
    var iv1 = $("#image_elem").iviewer({
            src: cpns, 
            update_on_resize: true,
            zoom_animation: false,
            mousewheel: true,
            onMouseMove: function(ev, coords) {clickTrue(); },
            onFinishLoad: function(ev, src) {
                                            $('#image_loading').hide();
                                            $("#iviewerImage").show(function(){
                                                $('#zoom_fit').trigger('click');
                                            }); 
                                            if (($('.current_mode').attr('id')=='txtimg_link') & (!$('#switchITL').hasClass('inactive')) & ($('#switchITL i').hasClass('fa fa-chain')) ){
                                                  Initialize();} //Add by JK for ITL
                                            if (($('.current_mode').attr('id')=='txtimg_link') & (!$('#switchHS').hasClass('inactive')) & ($("#switchHS i").hasClass('fa fa-dot-circle-o')) ) {
                                                  InitializeHS();} //Add by JK for HS

                                            var current_url = '';
                                            
                                            if ($('.current_mode').attr('id')=='imgd_link') {
                                                current_url = 'data/input_data/images/double/'+current_pp.replace("+", "-")+'_big.jpg';      
                                            } else {
                                                if (current_pp.indexOf('+') > 0) {
                                                    current_pp = current_pp.substr(0, current_pp.indexOf('+'));
                                                }
                                                current_url = 'data/input_data/images/single/'+current_pp+'_big.jpg';
                                            }
                                            if (magnifierON) {
                                                magnifierReady();
                                                chooseZoomMag();
                                            }
                                              
                                            //$("#mag_image_elem").empty();
                                            if(!magnifierON) $('#image_fade').fadeIn(400);

                                            loadThumbs();
                                            var getBigImage = setTimeout(function (){
                                                magnifierReady();
                                                chooseZoomMag();
                                                //iv1.iviewer('fit');
                                                clearTimeout(getBigImage);
                                            }, 5000);
                                        }, 
          // onStartDrag: function(ev, coords) { return false; }, //this image will not be dragged
           onAfterZoom: function(ev, zoom) {if ($('#switchITL i').hasClass('fa-chain')){ReInitialize();}; //Add by JK for ITL
                                            if ($("#switchHS i").hasClass('fa-dot-circle-o')){ReInitializeHS();}; //Add by JK for HS
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
        
        function checkIfBigImage(current_url){
            $.ajax({
                url: current_url,
                success: function(data){
                    magnifierReady();
                    chooseZoomMag();
                    if ($("#switchMag").attr("title")){
                        //$("#switchMag").removeAttr("title");
                        if($("#switchMag").hasClass('inactive')) $("#switchMag").removeClass('inactive');
                        if($("#switchMag").hasClass('likeInactive')) $("#switchMag").removeClass('likeInactive');
                            $("#switchMag").attr("onclick", "magOn()");
                        }
                    //bigImage=true; 
                },
                error: function(data){
                    $("#switchMag").attr("title", "No big image");
                    $("#switchMag").removeClass('active');
                    if($("#switchMag i").hasClass('fa-search-plus')){$("#switchMag").addClass('likeInactive');}
                    else{$("#switchMag").removeAttr("onclick").addClass('inactive');}
                    //bigImage=false;
                    if (magnifierON) {magnifierON=false;}
                    //if ($('#switchITL').hasClass('inactive')){$('#switchITL i ').removeClass('fa-chain').addClass('fa-chain-broken');}//Add by JK for ITL
                    //if ($("#switchHS").hasClass('inactive')){$("#switchHS i").removeClass('fa-chain').addClass('fa-chain-broken');}//Add by JK for HS
                    chooseZoomMag();
                }
                }); //Add by JK for Mag
        }

        function loadThumbs(){
            var countThumbs = 0;
            var thumbsElems = document.getElementsByClassName('thumb_single_img');
            
            var getThumbsSrc = setInterval(function (){
                for (var i = 0; i < 10 && countThumbs < thumbsElems.length; i++) {
                    var thumbEl = thumbsElems[countThumbs];
                    if (thumbEl.getAttribute('src') == undefined || thumbEl.getAttribute('src') == '') {
                        if (thumbEl.getAttribute('data-src') !== undefined){
                            thumbEl.setAttribute('src', thumbEl.getAttribute('data-src'));
                        }
                    }
                    countThumbs++;
                }
                if (countThumbs == thumbsElems.length) {
                    clearInterval(getThumbsSrc);
                }
            }, 2500);
        }
        
        $("#zoom_in").click(function(){ iv1.iviewer('zoom_by', 1); }); 
        $("#zoom_out").click(function(){ iv1.iviewer('zoom_by', -1); }); 
        $("#zoom_fit").click(function(){ iv1.iviewer('fit'); ReInitialize(); ReInitializeHS(); }); 
        $("#zoom_orig").click(function(){ iv1.iviewer('set_zoom', 100); ReInitialize(); ReInitializeHS();}); 
        $("#zoom_update").click(function(){ iv1.iviewer('update_container_info'); });
      
        $(window).hashchange( function(){
            var curr_src;

            hash_parts = location.hash.substr(1).split('&');
            if ( hash_parts != "" ) {
                for (var i = 0; i < hash_parts.length; i++) {
                    if(hash_parts[i].indexOf("page") === 0) { //begins with "page"
                        current_pp = hash_parts[i].substr(5);
                    }
                }
            } else {
                if ($('.current_mode').attr('id') == 'imgd_link'){
                    current_pp = $('.main_dd_select .option_container .option:first').attr('data-value');
                } else {
                    current_pp = $('.main_pp_select .option_container .option:first').attr('data-value');
                }
            }

            if ($('.current_mode').attr('id') == 'imgd_link'){
                curr_src = "data/input_data/images/double/"+current_pp.replace("+", "-")+".jpg";
            } else {
                if (current_pp.indexOf('+') > 0) {
                    current_pp = current_pp.substr(0, current_pp.indexOf('+'));
                }
                curr_src = "data/input_data/images/single/"+current_pp+".jpg";
            }
            //alert(curr_src);
            if (firstload){
                iv1.iviewer('loadImage', "data/input_data/images/single/"+current_pp+".jpg");
                firstload = false;
            }
            else if ( $('#text_elem').attr('data-page') != current_pp || $('#iviewerImage').attr('src') != curr_src ||
                      (($('#iviewerImage').attr('src') == curr_src) && ($('#image_loading').is(':visible')) ) 
                    ){
                $('#image_fade').fadeOut(600, function(){
                //$('#iviewerImage').fadeOut(600);      
                    $('#image_loading').show();     
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
            try {
                $("#val").html(curr_val.toFixed(0));
                iv1.iviewer('set_zoom', ui.value);
            } catch(e){ }
        }
});