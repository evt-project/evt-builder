/**
 * Interface Control jQuery
 * Functions Handling Prefatory Matter Elements and Events
 * Version 0.3 (201601)
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
 * @author Julia Kenny - JK
 * @from 2012 @to 2014
 *
 * @author ChiaraDipi - CDP
 * @since 2013
 *
 * @short-term Alessandro Barsi – AB
 * (added functions for manuscript, text and project info)
 * @in 2015
 *
 * @short-term Federica Spinelli - FS
 * (added support for translation as third edition level)
 * @in 2017
 **/

/* ===== */
/* FRONT */
/* ===== */

/*= OPEN FRONT INFO CONTAINER =*/
function show_front(front_container, front){
    var height;
    height = $('#central_wrapper').height();

    if ( ! $('#main_right_frame').hasClass('menuClosed') && !$('#main_left_frame').hasClass('menuClosed') ) {
        height = height - ($('#main_right_frame').height() * 2);
    }

    if ( $('#lists_cont') && $('#list_header').is(':visible') ) {
        height = height - $('#list_header').height() + 4;
    }

    $(front_container)
        .removeClass('hidden')
        .animate({
            'top': '0px',
            'min-height': '436.1px',
            'height': height+"px"
        }, 400, function(){
            $(front_container).addClass('open').removeAttr('style');
            if ( $(front_cont).parents("div[id*='frame']").attr('id') == 'main_left_frame' &&
                 $('#span_ee_select').find('.option') == 0 ) {
                $(front_container).find('.showHide_front').hide();
            } else {
                $(front_container).find('.showHide_front').removeAttr('style');
            }
        });
    $(front).show();
    $(front_container).scrollTop(0);
    $(front_container).parents("div[id*='frame']")
        .find('.like_select.filter').css('opacity', '.5').addClass('not_active');
}

/*= CLOSE FRONT INFO CONTAINER =*/
function hide_front(front_cont, front){
    if ( front_cont == "#hide_front-add" ) {
        if ( !$("#switchFront-add").hasClass('disabled') ) {
            $("#switchFront-add")
                .removeClass('active');
            toggleReg(front_cont);
        }
    } else {
        if ( !$("#switchFront").hasClass('disabled') ) {
            $("#switchFront")
                .removeClass('active');
            toggleReg(front_cont);
        }
    }
}

/*= UPDATE FRONT INFO CONTENT DEPENDING ON DOCUMENT =*/
function updateFrontContent(current_doc){
    var id_front_cont, id_front;
    id_front_cont = "#front_cont";
    id_front = "#front";

    if ($('#front_cont-add').length > 0 ) {
        id_front_cont = "#front_cont-add";
        id_front = "#front-add";
    }

    $(id_front_cont).load("data/output_data/prefatory_matter/front/front_doc_"+current_doc+".html #front", function(response, status, xhr){
        if (status == "success") {
            if ($.trim($("#front_cont .front").text())!=='' ){
                // $('<div />')
                //  .attr('id', "hide_front")
                //  .addClass('hide_front')
                //  .append("<i class='fa fa-chevron-up'></i></div>")
                //  .click(function(){ hide_front(id_front_cont, id_front); })
                //  .appendTo(id_front_cont); // solo nel box di destra

                if ( ($('#span_ee_select .label_selected').attr('data-value') == 'diplomatic') || ($('#span_ee_select .label_selected').attr('data-value') == 'critical') &&
                     (!$('#switchFront').hasClass('active')) ) {
                    $("#main_right_frame").find('.like_select.filter')
                        .css('opacity', "1")
                        .removeClass('not_active');
                } else {
                    $("#main_right_frame").find('.like_select.filter')
                        .css('opacity', "0.5")
                        .addClass('not_active');
                }
                if ( $("#span_ee_select").find('.option').length == 0 ) {
                    // Se ho un solo livello di edizione, in modalità txt txt nel frame di sx avrò sicuramente il front,
                    // quindi non ho bisogno del selettore con i filtri nel menu in basso a sx
                    $("#main_left_frame").find('.like_select.filter')
                        .css('opacity', "0")
                        .addClass('not_active');
                } else if ($("#span_ee_select").find('.option').length > 0) {
                    // ...altrimenti
                    if ( $('#span_ee_select-add .label_selected').attr('data-value') == 'front' ) {
                        // Se nel frame ho il front visibile, il selettore dei filtri rimane opacizzato...
                        $("#main_left_frame").find('.like_select.filter')
                            .css('opacity', "0.5")
                            .addClass('not_active');
                    } else {
                        // altrimenti è funzionante e pienamente visibile
                        $("#main_left_frame").find('.like_select.filter')
                            .css('opacity', "1")
                            .removeClass('not_active');
                    }
                }
                if ( $('#switchFront').hasClass('disabled') ) {
                    $('#switchFront').removeClass('disabled').show();
                    if ($('#switchFront').hasClass('active')) {
                        $('#front_cont').show();
                    }
                    resizeButtonsAndSelects();
                }
            } else {
                hide_front(id_front_cont, id_front);
                $('#switchFront')
                    .addClass('disabled')
                    // .hide()
                ;
                $('#front_cont').hide();
                resizeButtonsAndSelects();
            }
        } else {
            hide_front(id_front_cont, id_front);
            $('#switchFront')
                .addClass('disabled')
                // .hide()
            ;
            $('#front_cont').hide();
            resizeButtonsAndSelects();
        }
        resizeGlobalTopBar();
    });
}

/*= TOGGLE FRONT INFO CONTAINER =*/
function toggleFront(front_cont){
    if ($(front_cont).is(":visible")) {
        $(front_cont).hide('drop',  {direction: 'up'}, 'linear', function(){
            var ee_val;
            ee_val = $(front_cont).parents("div[id*='frame']").find('.main_ee_select .label_selected').attr('data-value');
            if ( (ee_val.toLowerCase() == 'diplomatic')|| (ee_val.toLowerCase() == 'critical') || (ee_val.toLowerCase() == 'translation')) {
                $(front_cont)
                    .parents("div[id*='frame']")
                        .find('.like_select.filter')
                            .css('opacity', "1")
                            .removeClass('not_active');
            }
        });

     /*} else {
        $(front_cont).show('drop',  {direction: 'up'}, 'linear', function(){
            Disattivare filtri liste nell'edizione diplomatica
            $(front_cont)
                .parents("div[id*='frame']")
                    .find('.like_select.filter')
                        .css('opacity', "0.5")
                        .addClass('not_active');

        });*/
    }
}
/* ==/ FRONT END */

/* ======================= */
/* REGESTO                 */
/* (Functions added for CP */
/* ======================= */

/*= OPEN REGESTO CONTAINER =*/
function show_regesto(regesto_container, regesto){
    var height;
    height = $('#central_wrapper').height();

    if ( ! $('#main_right_frame').hasClass('menuClosed') && !$('#main_left_frame').hasClass('menuClosed') ) {
        height = height - ($('#main_right_frame').height() * 2);
    }

    if ( $('#lists_cont') && $('#list_header').is(':visible') ) {
        height = height - $('#list_header').height() + 4;
    }

    $(regesto_container)
        .removeClass('hidden')
        .animate({
            'top': '0px',
            'min-height': '436.1px',
            'height': height+"px"
        }, 400, function(){
            $(regesto_container).removeAttr('style');
            if ( $(regesto_cont).parents("div[id*='frame']").attr('id') == 'main_left_frame' &&
                 $('#span_ee_select').find('.option') == 0 ) {
                $(regesto_container).find('.showHide_regesto').hide();
            } else {
                $(regesto_container).find('.showHide_regesto').removeAttr('style');
            }
        });
    $(regesto).show();
    $(regesto_container).scrollTop(0);
    $(regesto_container).parents("div[id*='frame']")
        .find('.like_select.filter').css('opacity', '.5').addClass('not_active');
}

/*= CLOSE REGESTO CONTAINER =*/
function hide_regesto(regesto_cont, regesto){
    if ( $(this).attr('id') == "hide_regesto-add" ) {
        if ( !$("#switchReg-add").hasClass('disabled') ) {
            $("#switchReg-add")
                .toggleClass('active')
                .find('.fa')
                    .toggleClass('fa-toggle-on')
                    .toggleClass('fa-toggle-off');
            toggleReg(regesto_cont);
        }
    } else {
        if ( !$("#switchReg").hasClass('disabled') ) {
            $("#switchReg")
                .toggleClass('active')
                .find('.fa')
                    .toggleClass('fa-toggle-on')
                    .toggleClass('fa-toggle-off');
            toggleReg(regesto_cont);
        }
    }
}

/*= UPDATE REGESTO CONTENT DEPENDING ON DOCUMENT =*/
function updateRegestoContent(current_doc){
    var id_regesto_cont, id_regesto;
    id_regesto_cont = "#regesto_cont";
    id_regesto = "#regesto";

    if ($('#regesto_cont-add').length > 0 ) {
        id_regesto_cont = "#regesto_cont-add";
        id_regesto = "#regesto-add";
    }

    $(id_regesto_cont).load("data/output_data/prefatory_matter/regesto/regesto_doc_"+current_doc+".html #regesto", function(response, status, xhr){
        if (status == "success") {
            if ( $('#regesto').children().length>0 && $.trim($("#regesto").text())!=='' ) {
                // $('<div />')
                //  .attr('id', "hide_regesto")
                //  .addClass('hide_regesto')
                //  .append("<i class='fa fa-chevron-up'></i></div>")
                //  .click(function(){ hide_regesto(id_regesto_cont, id_regesto); })
                //  .appendTo(id_regesto_cont); // solo nel box di destra

                if ( ($('#span_ee_select .label_selected').attr('data-value') == 'diplomatic') || ($('#span_ee_select .label_selected').attr('data-value') == 'critical') ||
                    ($('#span_ee_select .label_selected').attr('data-value') == 'translation') &&
                     (!$('#switchReg').hasClass('active')) ) {
                    $("#main_right_frame").find('.like_select.filter')
                        .css('opacity', "1")
                        .removeClass('not_active');
                } else {
                    $("#main_right_frame").find('.like_select.filter')
                        .css('opacity', "0.5")
                        .addClass('not_active');
                }
                if ( $("#span_ee_select").find('.option').length == 0 ) {
                    // Se ho un solo livello di edizione, in modalità txt txt nel frame di sx avrò sicuramente il regesto,
                    // quindi non ho bisogno del selettore con i filtri nel menu in basso a sx
                    $("#main_left_frame").find('.like_select.filter')
                        .css('opacity', "0")
                        .addClass('not_active');
                } else if ($("#span_ee_select").find('.option').length > 0) {
                    // ...altrimenti
                    if ( $('#span_ee_select-add .label_selected').attr('data-value') == 'regesto' ) {
                        // Se nel frame ho il regesto visibile, il selettore dei filtri rimane opacizzato...
                        $("#main_left_frame").find('.like_select.filter')
                            .css('opacity', "0.5")
                            .addClass('not_active');
                    } else {
                        // altrimenti è funzionante e pienamente visibile
                        $("#main_left_frame").find('.like_select.filter')
                            .css('opacity', "1")
                            .removeClass('not_active');
                    }
                }
                if ( $('#switchReg').hasClass('disabled') ) {
                    $('#switchReg').removeClass('disabled').show();
                    resizeButtonsAndSelects();
                }
            } else {
                hide_regesto(id_regesto_cont, id_regesto);
                $('#switchReg').addClass('disabled').hide();
                resizeButtonsAndSelects();
            }
        } else {
            hide_regesto(id_regesto_cont, id_regesto);
            $('#switchReg').addClass('disabled').hide();
            resizeButtonsAndSelects();
        }
        resizeGlobalTopBar();
    });
}

/*= TOGGLE REGESTO CONTAINER =*/
function toggleReg(cont){
    if ($(cont).is(":visible")) {
        $(cont).hide('drop',  {direction: 'up'}, 'linear', function(){
            $(cont).removeClass('open');
            var ee_val;
            ee_val = $(cont).parents("div[id*='frame']").find('.main_ee_select .label_selected').attr('data-value');
            //if (( ee_val.toLowerCase() == 'diplomatic' )||( ee_val.toLowerCase() == 'critical')||( ee_val.toLowerCase() == 'translation') ){
                $(cont)
                    .parents("div[id*='frame']")
                        .find('.like_select.filter')
                            .css('opacity', "1")
                            .removeClass('not_active');
            //}
        });

    } else {
        $(cont).show('drop',  {direction: 'up'}, 'linear', function(){
            // Disattivare filtri liste nell'edizione diplomatica
            $(cont)
                .addClass('open')
                .parents("div[id*='frame']")
                    .find('.like_select.filter')
                        .css('opacity', "0.5")
                        .addClass('not_active');

        });
    }
}

/* ==/ REGESTO END */


/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND MS DESC BUTTON CLICK EVENT =*/
function bindMsDescBtnClick() {
    $('#switch_msDesc').click(function(){
        var thumbContOpen = $('#thumb_cont').css('display') !== 'none';
        if ( $('#msDesc_cont').is(':visible') ) { // HIDE
            $('#msDesc_cont').hide('drop', {direction:'up'}, 'linear', function(){
                $('#msDesc_cont').removeClass('open');

                if(!$('#left_header').hasClass('menuClosed') &&
                    !magnifierON &&
                    !thumbContOpen){
                    $('#msDesc_cont').addClass('alignedBottom');
                    // $("#image_tool").show();
                } else {
                    $('#msDesc_cont').removeClass('alignedBottom');
                    // $("#image_tool").hide();
                }
                $('#switch_msDesc').removeClass('active');
                $('#image_tool > *').removeClass('hidden');
                $('#image_tool').removeClass('no-opacity');
                if (thumbContOpen){
                    $("#thumb_elem").addClass('active');
                }

                if (magnifierON && !thumbContOpen) {
                    $("#switchMag").addClass('active');
                }

                if (ITLon && !thumbContOpen) {
                    $("#switchITL").addClass('active');
                }
            });
        } else { // SHOW
            $('#msDesc_cont').show('drop', {direction:'up'}, 'linear', function(){
                $('#msDesc_cont').addClass('open');
                // $("#image_tool > *").show();
            });
            if($('#left_header').hasClass('menuClosed') || magnifierON || thumbContOpen) {
                $('#msDesc_cont').addClass('alignedBottom');
                // $("#image_tool").show();
            } else {
                $('#msDesc_cont').removeClass('alignedBottom');
                // $("#image_tool").hide();
            }
            $('#switch_msDesc').addClass('active');
            $('#image_tool').addClass('no-opacity');
            /*$('#image_tool').addClass('hidden');*/
             // $('#image_tool > *').addClass('hidden');
        }
    });
}

/*= BIND TEXT INFO BUTTON CLICK EVENT =*/
function bindTextInfoBtnClick() {
    $('#info_link').click(function(){
        $(this).toggleClass('active');
        if($('#headerInfo_cont').is(':visible')){
            $('#headerInfo_cont').hide('fade', 0);
        } else {
            $('#headerInfo_cont').show('fade', 0);
        }
        $('#settings_link.active').trigger('click');
    });
}

/*= BIND HEADER TEXT INFO BUTTON CLICK EVENT =*/
function bindHeaderInfoBtnClick() {
    $('#headerInfo_cont').click(function(event){
        if ( $(event.target).parents('#close_header_info_cont').length > 0 ) {
            $('#info_link').trigger('click');
        } else {
            if ( !$(event.target).is('#headerInfo') ) {
                if ( $(event.target).parents('#headerInfo').length <= 0 ) {
                    $('#info_link').trigger('click');
                }
            }
        }
    });

    $('.closeDialog, .dialog_close').click(function(event){
        var target = $(this).attr('data-dialog');
        if (target !== undefined && target !== '') {
            if ($('#'+target).find('.neverShowAgain').is(':checked')) {
                var editionIdentifier = document.getElementById("home_title").textContent.replace(/\s/g, "");
                setCookie('welcome_'+editionIdentifier, 'neverShowAgain', 365);
            }
            $('#'+target).hide('fade', 0);
        }
    });

    $('.dialog').click(function(event){
        var targetContent = $(this).attr('data-content');
        if (targetContent !== undefined && targetContent !== '') {
            if ( !$(event.target).is('#'+targetContent) ) {
                if ( $(event.target).parents('#'+targetContent).length <= 0 ) {
                    $(this).hide('fade', 0);
                    if ($(this).find('.neverShowAgain').is(':checked')) {
                        setCookie('welcome', 'neverShowAgain', 1);
                    }
                }
            }
        }
    });
}

/*= BIND BIBLIOGRAPHY REFERENCE IN TEXT CLICK EVENT =*/
function bindBiblioRefClick() {
    // APRI/CHIUDI BIBLIOGRAFIA GENERALE
    $('#biblio_link').click(function(){
        $(this).toggleClass('active');
        if($('#generalBiblio_cont').is(':visible')){
            $('#generalBiblio_content').scrollTop(0);
            $('#generalBiblio_cont').hide('fade', 0, function(){
            });
        } else {
            $('#generalBiblio_content').scrollTop(0);
            $('#generalBiblio_cont').show('fade', 0, function(){
                if ( $('.bibl.highlight').length > 0 ) {
                    $('#generalBiblio_content').scrollTop($('.bibl.highlight:first').position().top-100);
                    var hideHilights = setTimeout(function(){
                                            $('.bibl.highlight').removeClass('highlight');
                                            clearTimeout(hideHilights);
                                        }, 1500);
                }
            });
        }
        $('#settings_link.active').trigger('click');
    });
}

/*= BIND BIBLIOGRAPHY BUTTON CLICK EVENT =*/
function bindBiblioBtnClick() {
    $('#generalBiblio_cont').click(function(event){
        if ( $(event.target).parents('#close_generalBiblio_cont').length > 0 ) {
            $('#biblio_link').trigger('click');
        } else {
            if ( !$(event.target).is('#generalBiblio') ) {
                if ( $(event.target).parents('#generalBiblio').length <= 0 ) {
                    $('#biblio_link').trigger('click');
                }
            }
        }
    });
}

/*= BIND TOGGLE FRONT INFO (OR REGESTO) BUTTON CLICK EVENT =*/
function bindToggleFrontBtnClick() {
    $('.toggleReg').click(function(event) {
        if (!$(this).hasClass('disabled')) {
            var regesto_cont;
            $(this)
                .toggleClass('active')
                .find('.fa')
                    .toggleClass('fa-toggle-on')
                    .toggleClass('fa-toggle-off');
            if ( $(this).attr('id') == "switchReg-add" ) {
                regesto_cont = "#regesto_cont-add";
            } else {
                regesto_cont = "#regesto_cont";
            }
            toggleReg(regesto_cont);
        }
    });
    // APRI/CHIUDI FRONT
    $('.toggleFront').click(function(event) {
        if (!$(this).hasClass('disabled')) {
            var front_cont;
            $(this)
                .toggleClass('active');
            if ( $(this).attr('id') == "switchFront-add" ) {
                front_cont = "#front_cont-add";
            } else {
                front_cont = "#front_cont";
            }
            toggleFront(front_cont);
        }
    });
}
