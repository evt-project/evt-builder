/**
 * 
 * Interface Control jQuery
 * Functions Handling Generic Elements Bindings
 * Version 0.3 (201601)
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * 
 * @author RafMas 
 * @since 2012 @to 2015
 * 
 * @author Julia Kenny - JK
 * @from 2012 @to 2014  
 *
 * @author ChiaraDipi - CDP
 * @since 2013  
 *
 **/

/*= BIND GENERIC OPTION HOVER EVENT =*/
function bindOptionHover() {
    $('.like_select .option_container .option').hover(function(){
        $('.hovered').removeClass('hovered');
        var parent_title = $(this).parents('.like_select').attr('title');
            $(this).parents('.like_select').attr('data-title', parent_title);
            $(this).parents('.like_select').attr('title', '');
    }, function(){
        var old_parent_title = $(this).parents('.like_select').attr('data-title');
        $(this).parents('.like_select')
                        .attr('title', old_parent_title)
                        .removeAttr('data-title');
    });
}

/*= BIND EVENT TO OPEN OPTION CONTAINER OF SELECTS =*/
function bindOpenSelectClick() {
    /* Apertura option container dei selettori a tendina */
    $(".open_select").click(function(){
        $('.hovered').removeClass('hovered');
        if ( !$(this).parents('.like_select').hasClass('not_active') ){
            if (!($(".option_container").is(':animated'))){
                if($('.option_container:visible').parents('.like_select').attr('id') !== $(this).parents('.like_select').attr('id')){
                    $('.option_container.up:visible').animate({
                        top: '-5px',
                        height:"toggle"
                    }, 0); 
                    $('.option_container.down:visible').animate({height:"toggle"}, 0);   
                }
                if($(this).hasClass('open_up')){
                    if ($(this).siblings('.option_container').is(':visible')) {
                        $(this).siblings('.option_container').animate({
                            top: '-5px',
                            height:"toggle"
                        }, 0);
                    } else {
                        var top = "-" + $(this).siblings('.option_container').attr('data-toggle-top') + "px";
                        $(this).siblings('.option_container').animate({
                            top: top,
                            height:"toggle"
                        }, 0);
                    }
                } else {
                    var option_container = $(this).siblings('.option_container');
                    option_container.animate({
                        scrollTop: 0,
                        height:"toggle"
                    }, 0, function(){
                        var scroll = $(this).find('.option.selected').position().top;
                        option_container.animate({
                            scrollTop: scroll
                        }, 0);
                    });
                }
            }
        }
    });
}

/*= BIND GENERIC OPTION CLICK EVENT ============================================== =*/
/*= General event on click on ".option":                                           =*/
/*= - it select the element clicked and unselect the others.                       =*/
/*= - it closes the ".like_select".                                                =*/
/*= - If it is a filter, it is possible to select more than one ".option" element. =*/
function bindOptionClick() {
    $(".like_select .option_container .option").click(function(){
        if( (!$(this).hasClass('selected')) && (! $(this).parents('.like_select').hasClass('filter'))){
            var option_sel_value, option_sel_label;

            option_sel_value = $(this).attr('data-value');
            option_sel_label = $(this).text();
            $(this).parents('.like_select')
                        .find('.label_selected')
                            .attr('data-value', option_sel_value)
                            .text(option_sel_label)
                            .trigger('change');
            
            /*if ($(this).parents('.option_container').parent().attr("class") === "main_tt_select"){
                newText = $(this).attr('title');
                $(this).parents('.option_container').prev().prev().text(cropLongTextLabel(newText, 12)).attr("data-value", newText).trigger('change'); // .label_selected
            }
            else{
                newText = $(this).text();
                if ($(this).parents('.option_container').parent().attr("class") !== "main_pp_select"){
                    $(this).parents('.option_container').prev().prev().text(newText).attr("data-value", newPage).trigger('change'); // .label_selected
                }
            }*/

            var thisSelect          = $(this).parents('.like_select'),
                thisOptionContainer = $(this).parents('.option_container');
            thisSelect
                .find(".option[data-value!='"+option_sel_value+"']")
                    .removeClass('selected');
            $(this)
                .addClass('selected');
            
            if (thisOptionContainer.is(':visible')) {
                if(thisOptionContainer.hasClass('up')){
                   thisOptionContainer.animate({
                       top: '-5px',
                       height:"toggle"
                   }, 0, function(){
                        // updateSelectLength(thisSelect);
                        thisOptionContainer.css('min-width', thisSelect.width()-10);
                   });
                } else {
                    thisOptionContainer.animate({
                        height:"toggle"
                    }, 0, function(){
                        // updateSelectLength(thisSelect);
                        thisOptionContainer.css('min-width', thisSelect.width()-10);
                    });
                }
            }
        }
    });
}

/*= BIND GLOBAL WRAPPER MOUSE DOWN EVENT =*/
function bindGlobarWrapperMouseDown() {
    $("#global_wrapper").on('mousedown', function (e) {
        if ( ($(e.target).closest(".like_select").length === 0) && !($(".option_container").is(':animated')) ) {
            if($('.option_container:visible').hasClass('up')){
               $('.option_container:visible').animate({
                   top: '-5px',
                   height:"toggle"
               }, 0);
            } else {
                $('.option_container:visible').animate({height:"toggle"}, 0);
            }
        }

        if ( $(e.target).parents("#settings_cont").length === 0 && 
             ! $("#settings_cont").is(':animated') &&
             $(e.target).parents("#settings_link").length === 0 &&
             $(e.target).attr('id') !== 'settings_link' ) {
            if ( $('#settings_cont').is(':visible') ) {
                $('#settings_link').trigger('click');
            }
        }
    });
}

/*= BIND BUTTONS CLICK EVENT =*/
function bindBtnClick() {
    // GENERIC BUTTONS
    $('#left_menu .mainButtons').click(function(){
        if ( ! $(this).hasClass('inactive') ) {
            $(this).siblings().removeClass('active');
        }
    });

    // MAGNIFIER, HOTSPOT, ITL BUTTONS
    $('#switchMag, #switchHS, #switchITL').click(function(){
        if ( !$(this).hasClass('likeInactive') ) {
            var msDescSwitcher = $('#switch_msDesc');
            if ( msDescSwitcher.length > 0 && msDescSwitcher.hasClass('active') ) {
                msDescSwitcher.trigger('click');
            }
            var thumbsSwitcher = $('#thumb_elem');
            if ( thumbsSwitcher.length > 0 && thumbsSwitcher.hasClass('active') ) {
                thumbsSwitcher.removeClass('active');
            }
        }
    });

    // THUMBNAILS BUTTON
    $(".thumb_link").click(function(){
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
        
        if ( $('#msDesc_cont').length > 0 && $('#msDesc_cont').is(':visible') ) {
            $('#switch_msDesc').removeClass('active');
            $('#msDesc_cont').hide();
        }
        if (magnifierON == false) { 
            if($("#image_loading").css('display')!=="none"){$("#image_loading").hide()}
            if($("#image_elem").css('display') === "none"){
                $("#image_elem").show();
                $("#image_fade").show();
                if(!$('#left_header').hasClass('menuClosed') ){
                    $("#image_tool").show();
                }
                $("#thumb_cont").hide();
            } else{
                $("#image_elem").hide();
                $("#image_fade").hide();
                $("#image_tool").hide();
                $("#thumb_cont").show();
            }
        } else {                  //modalità magnifier attivo JK
            if($("#mag_image_elem").css('display') === "none"){
                $("#mag_image_elem").show();
                $("#image_tool").show();
                $("#thumb_cont").hide();
                $('#switchMag').addClass('active');
            } else{
                $("#mag_image_elem").hide();
                $("#image_tool").hide();
                $("#thumb_cont").show();
            }
        }
        $(this).toggleClass('active');
    });
}

/*= BIND FONT SIZE CONTROLLER BUTTONS CLICK EVENT =*/
function bindFontSizeControllerBtnClick() {
    $('.font-size-controller').click(function(){
        var action = $(this).attr('data-action');
        var sizeCtrl = $(this);
        if (!$(this).hasClass('inactive')) {
            $(this).parents("div[id*='_frame']").find('.can-change-font-size').each(function(){
                var currentFontSize, currentFontSizeNum, newFontSize;
                currentFontSize = $(this).css('font-size');
                currentFontSizeNum = parseFloat(currentFontSize, 10);
                if ( action == 'increase' ) {
                    newFontSize = currentFontSizeNum * 1.1; 
                } else {
                    newFontSize = currentFontSizeNum * 0.9;
                }
                if (newFontSize < 40 && newFontSize > 12) {
                    $(this).css({
                        'font-size': newFontSize,
                        'line-height': (newFontSize+12)+'px'
                    });
                }

                if ( (parseFloat(newFontSize, 10) * 1.1) >= 40 ) {
                    $(this).parents("div[id*='_frame']").find("[data-action='increase']").addClass('inactive');
                } else {
                    $(this).parents("div[id*='_frame']").find("[data-action='increase']").removeClass('inactive');
                }
                if ( (parseFloat(newFontSize, 10) * 0.9) <= 12 ) {
                    $(this).parents("div[id*='_frame']").find("[data-action='decrease']").addClass('inactive');
                } else {
                    $(this).parents("div[id*='_frame']").find("[data-action='decrease']").removeClass('inactive');
                }

                $(this).attr('data-font-size', newFontSize);

                var lineNwidth = $('.dipl-lineN:last').outerWidth();
                var textInnerWidt = $(this).parents("div[id*='_frame']").find("div[id*='text_cont']").innerWidth()*85/100;
                $(this).find('.dipl-left, .interp-left').each(function(){
                    $(this).css({
                        'max-width': (textInnerWidt-lineNwidth-43)+'px'
                    });
                });
            });
            
            var frameWidth;
            if ($(this).parent().attr('id') == 'text_tool-add') {
                frameWidth = $('#text_cont-add').find('#text').outerWidth();
                $('.full').find('#text_cont-add #text').css({
                    'position': 'absolute',
                    'left': '50%',
                    'margin-left': -(frameWidth/2)+'px'
                });
            } else {
                frameWidth = $('#text').outerWidth();
                $('.full').find('#text').css({
                    'position': 'absolute',
                    'left': '50%',
                    'margin-left': -(frameWidth/2)+'px'
                });
            }
        }
    });

    $('#decrease_font_size').click(function(){
        var currentFontSize, currentFontSizeNum, newFontSize;
        currentFontSize = $('#text_frame').css('font-size');
        currentFontSizeNum = parseFloat(currentFontSize, 10);
        
        $('#text_frame').css({
            'font-size': newFontSize,
            'line-height': (newFontSize+10)+'px'
        });
    });
}

/*= BIND COLLAPSE MENU BUTTONS CLICK EVENT =*/
function bindCollapseMenuBtnClick() {
    $('#header_collapse').click(function(){
        var noMenu_height, withMenu_height;
        var topMenu_height, bottomMenu_height;
        var bottom_box_frame, bottom_box_visible;
        var action;
        action = $(this).attr('data-action');
        /* COLLAPSE MENUS*/
        if (action == 'collapse') {
            $('.main_frame').each(function(){
                noMenu_height = $(this).innerHeight();
                $(this).attr('data-menu-state', 'collapsed');
                collapseMenu($(this), noMenu_height);
            }); 
            // Modifico colore dell'icona .go-full-right che altrimenti non si vedrebbe
            $('.go-full-right').addClass('onWhite');
            // Se è aperto il text di sinistra modifico colore dell'icona go-full-left che altrimenti non si vedrebbe
            if ( $('#text_cont-add').is(':visible') || $('#msDesc_cont').is(':visible') ) {
                $('.go-full-left').toggleClass('onWhite');
            }
            setMagHeight(); //Add for Mag
            $(this).attr('data-action', 'expand');
        } 
        /* EXPAND MENUS*/
        else if ( action == 'expand') {
            $('.main_frame').each(function(){
                noMenu_height = $(this).innerHeight();
                $(this).attr('data-menu-state', 'expanded');
                expandMenu($(this), noMenu_height);
            }); 
            $('.go-full-right').removeClass('onWhite');
            if ( $('#text_cont-add').is(':visible') || $('#msDesc_cont').is(':visible') ){
                $('.go-full-left').removeClass('onWhite');
            }
            setMagHeight(); //Add for Mag
            $(this).attr('data-action', 'collapse');
        }

        // Modifico lo stile e la posizione dell'icona
        if($(this).hasClass('fa-caret-up')){
            if($(".closeFullScreen:visible").length>0){
                $(this).animate({
                    top: "-75px"
                });
            } else {
                $(this).animate({
                    top: "-8px"
                });
            }
            $(this).removeClass('fa-caret-up').addClass('fa-caret-down');
        } else {
            if($(".closeFullScreen:visible").length>0){
                $(this).animate({
                    top: "-39px"
                });
            } else {
                $(this).animate({
                    top: "23px"
                });
            }
            $(this).removeClass('fa-caret-down').addClass('fa-caret-up');
        }
        
        $('.like_select:visible').each(function(){
                if (!$(this).hasClass('widthChanged')) {
                    $(this).addClass('widthChanged');
                    $(this).find('.option_container').removeAttr('style');
                    updateSelectLength($(this));
                }
        });
    });
}

/*= INITIALIZE REF HYPERLINKS =*/
function InitializeRefs(){
    $('.ref[data-target]').unbind('click').click(function(){
        var type = $(this).attr('data-type'),
            target = $(this).attr('data-target').replace('#', '');
        if ( type == 'doc' ) {
            var targetTToption = $('#span_tt_select').find(".option[data-value='"+target+"']");
            if (targetTToption.length == 0){
                alert(window.lang.convert('TEXT_NOT_AVAILABLE', window.lang.currentLang));
            } else {
                if ( $('#span_tt_select').find(".label_selected").attr("data-value") != target ) {
                    targetTToption.trigger('click');
                }
            }
            $(this).parents('.bottomBoxOpened').find("[id*='toggle']").trigger('click');
        } else {
            var targetElem = $('#'+target);
            if (targetElem.length > 0) {
                targetElem.addClass('highlight');
                $('#generalBiblio_content').scrollTop(0);
                $('#biblio_link').trigger('click');
            } else {
                alert(window.lang.convert('NO_REF', window.lang.currentLang));
            }
        }
    });
}

/*= INITIALIZE POPUPs (INLINE NOTEs, NAMED ENTITIES DETAILS, ...) =*/
function InitializePopup(){
    $('.popup').unbind('hover').hover(function(e){
        if ( $('.doc').length<0 || $(this).parents('.doc').hasClass('current') ) {
            e.stopPropagation();
            $(this).addClass('over');
            if($(this).parents('.popup').length > 0){
              $(this).parents('.popup').removeClass('over');
            }
        }
    }, function(){
        if ( $('.doc').length<0 || $(this).parents('.doc').hasClass('current') ) {
            if($(this).parents('.popup').length > 0){
                $(this).parents('.popup').addClass('over');
            }
            $(this).removeClass('over');
         }
    });
    
    $('.tooltip').unbind('click').click(function(e){
        if($(this).hasClass('opened')) {
            e.stopPropagation();
        }
    });
    $('.trigger').unbind( "click" ).click(function(e){
        if ( $('.doc').length<=0 
            || $(this).parents('.doc').hasClass('current') || 
               $(this).parents("div[id*='regesto_cont']").length > 0 || 
               $(this).parents("div[id*='front_cont']").length > 0 ) {
            e.stopPropagation();
            var popup, trigger, tooltip, before;
            popup = $(this).parent('.popup');
            trigger = popup.find('.trigger');
            tooltip = popup.find('> .tooltip');
            before = tooltip.find('> .before');
            
            if ( tooltip.hasClass('opened') ) {
                popup.removeClass('opened');
                tooltip
                    .removeAttr('style')
                    .removeClass('opened')
                    .hide()
                    .find('> .before')
                        .removeAttr('style');
            } else {
                $('.tooltip.opened')
                    .removeClass('opened')
                    .toggle()
                    .find('> .before')
                        .removeAttr('style');
                $('.popup.opened')
                    .removeClass('opened');
                
                if($(this).parent('.popup').find('> .tooltip')){
                    $(this)
                        .parent('.popup')
                            .find('> .tooltip')
                                .removeClass('opened')
                                .toggle()
                                .find('> .before')
                                    .removeAttr('style');
                }
             
                popup.addClass('opened');
                tooltip
                    .addClass('opened')
                    .show();
                
                var triggerHeight, triggerTop, triggerLeft, triggerWidth;
                triggerHeight = trigger.css('font-size').substr(0,2)*1+1;
                
                triggerTop = trigger.offset().top;
                triggerLeft = trigger.position().left;
                triggerWidth = trigger.width();
                
                var tooltipTop = tooltip.offset().top;
                
                var x = e.clientX;
                var y = e.clientY;
                
                var tooltipRealWidth, tooltipRealHeight;
                tooltip.css('position', 'relative');    
                tooltipRealWidth = tooltip.width();

                if( tooltipRealWidth > 300 ){
                    tooltip.css({
                        'width': '300px',
                        'max-width': '300px'
                    });
                } 
                tooltip.css({
                    'position': 'absolute'
                });
                tooltipRealWidth = tooltip.width();
                tooltipRealHeight = tooltip.height();


                // Sposto il tooltip, prima allineando la metà al punto in cui ho cliccato
                // poi spostandolo a sinistra se supera il margine destro del contenitore
                // o a destra se supera il margine sinistro.
                var left, tooltipNewLeft;
                left = x - (tooltipRealWidth/2);
                tooltip.offset({
                        top: y+20,
                        left: left
                    });
                
                var containerWidth, tooltipLeft, marginRightText;
                if ( popup.parents("div[id*='frame']").hasClass('full') ){
                    containerWidth = $('#text_cont').width();
                    marginRightText = 50;
                } else {
                    containerWidth = $('#text').width();    
                    marginRightText = $('#text').position().left;
                }
                tooltipLeft = tooltip.position().left;
                
                if (tooltipLeft + tooltipRealWidth > containerWidth){
                    tooltip.css({
                        'right': marginRightText+"px"
                    });
                }
                tooltipRealWidth = tooltip.width(); 
                
                
                
                // Se supera a destra il margine destro del contenitore....
                tooltipNewLeft = tooltip.position().left;
                if ( tooltipNewLeft + tooltipRealWidth > containerWidth ) {
                    var diff = (tooltipNewLeft + tooltipRealWidth) - containerWidth;
                    //var newLeft = $(this).find('> .tooltip').offset().left - diff + marginRightText;
                    tooltipNewLeft = left - diff + marginRightText;
                    tooltip.offset({
                            left: tooltipNewLeft
                        });
                }

                // Se supera a sinistra il margine sinistro del contenitore...
                var offsetLeftText;
                if ( popup.parents("div[id*='frame']").hasClass('full') ){
                    offsetLeftText = $('#text_cont').offset().left;
                } else {
                    offsetLeftText = $('#text').offset().left;
                }

                if ( left < offsetLeftText ) {
                    tooltip.offset({
                            left: offsetLeftText
                        });
                }

                // Riposiziono l'elemento .before
                var beforeWidth, beforeNewLeft;
                var beforeMarginRight, tooltipMarginRight;
                beforeNewLeft = x;
                beforeWidth = before.width();
                beforeMarginRight = x+beforeWidth;
                tooltipMarginRight = tooltip.offset().left + tooltip.width();
                if ( beforeMarginRight > tooltipMarginRight){
                    var diff = (beforeMarginRight - tooltipMarginRight );
                    beforeNewLeft = x - diff;
                }
                before.offset({ left: beforeNewLeft-5});

                // Riposizionamento se supera il margine inferiore del contenitore
                var tooltipOffsetBottom, containerHeight;
                tooltipOffsetBottom = tooltip.offset().top + tooltip.height();
                containerHeight = $('#text_cont').offset().top + $('#text_cont').height() - 42;

                if ( tooltipOffsetBottom > containerHeight ){
                    var tooltipMoveToTop = triggerHeight + tooltip.height() + before.height() + 8;
                    var tooltipNewTop = before.offset().top - tooltipMoveToTop;
                    tooltip.offset({
                            top: tooltipNewTop
                        });
                    
                    var beforeNewTop = tooltip.height() + 8;
                    before
                        .offset({
                            left: beforeNewLeft-10
                        })
                        .css({
                            "top": beforeNewTop+"px",
                            "transform": "rotate(180deg)"
                        });
                }
                tooltipRealWidth = tooltip.width();
                if( tooltipRealWidth > 300 ){
                    tooltip.css({
                        'width': '300px',
                        'max-width': '300px'
                    });
                } 
                
                $(this).focus();    

                return false;
            }
        }
    });
    
    
    $(document).click(function(){
        $('.over').removeClass('over');
        $('.opened').removeClass('opened');
        $('.popup').find('> .tooltip').hide();
        $(this).hide();
    });
   

    InitializeLinkTextList();
}
