/**
 * 
 * Interface Control jQuery
 * Functions Handling Lists Elements and Events
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

/*= UPDATE HIGHLIGHTED ENTITIES IN TEXT =*/
function updateEntitiesFiltered(frame) {
    frame
        .find('.like_select.filter')
            .find('.option.selected')
                .removeClass('selected')
                .trigger('click');
}

/*= TOGGLE LISTS CONTAINER =*/
function toggleListCont(toggler){
    var boxSuffix = $(toggler).attr('data-boxsuffix'),
        listsCont = $('#lists_cont'),
        listsSelector = $('#span_list_select');

    if ( listsCont.hasClass('collapsed') ) {
        var top, mainContainerHeight;
        top = 0;
        listsContParent = listsCont.parents("div[id*='main_']");
        mainContainerHeight = listsContParent.outerHeight();
        if(listsContParent.find('.top-menu').hasClass('menuClosed')){
            top = -listsContParent.find('.top-menu').outerHeight();
            listsCont.css('height', mainContainerHeight+'px');
        }
        listsCont.animate({
               top: top+'px'
        }, 400);
        $(toggler).find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');
        listsCont.removeClass('collapsed');

        var listsElementsOpened = $('.list:visible').find('.list_element_opened');
        if ( listsElementsOpened.length > 0 ) {
            listsElementsOpened.find('.occurences').show();
        }
        if ( listsSelector.length > 0 && !listsSelector.hasClass('not_active')) {
            listsSelector.addClass('not_active').css('opacity', '0.5');
        }
    } else {
        scrollDownListContainer(400);
        $(toggler).find('.fa').removeClass('fa-angle-double-down').addClass('fa-angle-double-up');

        if ( listsSelector.length > 0 && listsSelector.hasClass('not_active')) {
            var switchRegBtn = $('#switchReg'+boxSuffix);
            if ( switchRegBtn.length > 0 && !switchRegBtn.hasClass('disabled') ) {
                if ( !switchRegBtn.hasClass('active') ) {
                    listsSelector.removeClass('not_active').css('opacity', '1');   
                }
            } else {
                listsSelector.removeClass('not_active').css('opacity', '1');
            }
        }
    }
}

/*= CLOSE LISTS CONTAINER =*/
function closeListsBox(speed){
    $('#lists_cont')
        .removeClass('bottomBoxOpened')
        .hide('slide',  {direction: 'down'}, 'linear', speed);
    $('#list_link').removeClass('active');
    
    updateTextContHeight();

    $('#text_cont')
        .find('.selected_from_list')
            .removeClass('selected_from_list');
}

/*= OPEN LISTS CONTAINER =*/
function openListsBox(speed){
    var listsCont = $('#lists_cont');
    listsCont.addClass('bottomBoxOpened');
    $('#list_link').addClass('active');
    var openDivLists = function() {
        // var newSearchContTop = listsCont.parents("div[id*='main_']").outerHeight() - ($('#text_tool').outerHeight()*2) - $('#search_header').outerHeight() - 6;
        // listsCont.css({
        //  'top': newSearchContTop+'px'
        // });

        if(listsCont.hasClass('collapsed')){
            return listsCont.show();
        } else {
            return listsCont.show('slide',  {direction: 'down'}, 'linear', speed);
        }
        
    };
    $.when( openDivLists() ).done(function() {
        updateTextContHeight();
    });
}

/*= HANDLE NAVIGATION LIST ELEMENTS PER LETTER =*/
function filterListElements(filter){
    var filterType, filterValue;
    filterType = $(filter).attr('data-filter-type');
    filterValue = $(filter).attr('data-value');
    $('.filter_active').removeClass('filter_active');
    $(filter).addClass('filter_active');

    $('.occurences:visible').hide();
    $('.list_element_opened').removeClass('list_element_opened');

    $('.list_element').hide();
    var listsElementsFiltered = $(".list_element[data-order-list='"+filterValue.toLowerCase()+"'], .list_element[data-order-list='"+filterValue.toUpperCase()+"']");
    listsElementsFiltered.show();
    if (filterValue.toLowerCase() == 'c') {
        $(".list_element[data-order-list='Ç']").show();
    }
    
    if ( $('.ul_list:visible').find(listsElementsFiltered).length == 0) {
        if ( $( '.no_elements' ).length > 0) {
            $( '.no_elements' ).detach().appendTo('.ul_list:visible').show();
        } else {
            $('<li />')
                .addClass('list_element')
                .addClass('no_elements')
                .append("<span lang='"+window.lang.currentLang+"'>"+window.lang.convert('NO_ELEMENTS', window.lang.currentLang)+"</span>")
                .appendTo('.ul_list:visible');
        }
    }

    $("div[id*='list_']").scrollTop(0);

    window.lang.run();
}

/*= OPEN SINGLE LIST =*/
function openList(elem, listName){
    if ( $('#lists_cont').hasClass('collapsed') ) {
        $('#toggle_list_cont').trigger('click');
    }
    $('.labelList.active').removeClass('active');
    $(elem).addClass('active');
    $('.list.list_opened').hide();
    $('#list_'+listName).addClass('list_opened').show();
}

/*= SHOW LIST ELEMENT OCCURRENCES =*/
function showListElementOccurrences(elem, listName){
    if($(elem).hasClass('list_element_opened')){
        // $(elem).find('.small-note, .occurences').toggle();
        $(elem).find('.fa').removeClass('fa-angle-down').addClass('fa-angle-right');
        $(elem).removeClass('list_element_opened');
    } 
    else {
        if($(elem).find('.occurences').length<=0){
            prepareOccurrencesList(elem, listName);
        }
        // $(elem).parents('.list').find('.occurences:visible').hide();
        $(elem).parents('.list').find('.small-note:visible').hide();
        $(elem).parents('.list')
            .find('.list_element_opened')
                .removeClass('list_element_opened')
                .find('.fa-angle-down')
                    .removeClass('fa-angle-down')
                    .addClass('fa-angle-right');
        $(elem)
            .addClass('list_element_opened')
            .find('.fa')
                .removeClass('fa-angle-right')
                .addClass('fa-angle-down');
    }
}

/*= PREPARE LIST ELEMENT OCCURRENCES =*/
function prepareOccurrencesList(elem, listName){
    var occ_ref;
    var list_ref, list_occ;
    list_ref = $(elem).attr('id');
    list_occ = $("<div/>").addClass('occurences');
    occ_ref = $('#'+listName)
                    .find('#occorrenze')
                        .find("span[data-ref='"+list_ref+"']");
    if(occ_ref.length > 0){
        occ_ref.each(function(){
            var pb, doc, pb_n;
            var doc_lab;
            pb = $(this).attr('data-pb');
            pb_n = $(this).attr('data-pb-n');
            doc = $(this).attr('data-doc');
            doc_lab = $("#span_tt_select .option_container .option[data-value='"+doc+"']").attr('title');
            var occElem = $(list_occ).find("span[data-pb='"+pb+"'][data-doc='"+doc+"']");
            if ( occElem.length > 0 ) {
                var occ;
                occ = occElem.attr('data-occ')*1;
                occ++;
                occElem
                    .attr('data-occ', occ)
                    .attr('title', occ+" "+window.lang.convert('OCCURRENCES', window.lang.currentLang));
                $(this).remove();
            } else {
                $(this)
                    .attr('data-occ', '1')
                    .attr('title', "1 "+window.lang.convert('OCCURRENCE', window.lang.currentLang))
                    .text(window.lang.convert('FOL', window.lang.currentLang)+" "+pb_n+" - "+window.lang.convert('DOC', window.lang.currentLang)+" "+doc_lab)
                    .click(function(){
                        goToOccurrencePage(this, pb, doc);
                    })
                    .detach()
                    .appendTo(list_occ);
            }
        });
    } else {
        $(list_occ).append("<span class='no_occ' lang='"+window.lang.currentLang+"'>"+window.lang.convert('NO_MATCHES_FOUND', window.lang.currentLang)+"</span>");
    }
    $(elem).append(list_occ);
    window.lang.run();
}

/*= GO TO OCCURRECE PAGE =*/
function goToOccurrencePage(elem, pb, doc){
    var current_pp, current_tt;
    if ( $('.current_mode').attr('id') === 'txtimg_link' && $('#regesto_cont').is(':visible') ) {
        hide_regesto('#regesto_cont', '#regesto');
    }
    current_pp = $('#span_pp_select .label_selected').attr('data-value');
    current_tt = $('#span_tt_select .label_selected').attr('data-value');
    // Se il riferimento punta ad una pagina diversa, aggiorno l'hash e carico la pagina di interesse
    if (pb != current_pp) {
        $('#text_cont').addClass('reachingOccurence');
        updateHash(doc, pb, "");
    } 
    // Altrimenti...
    else {
        // Se il riferimento punta ad un documento presente sulla pagina corrente, ma diverso da quello attivo
        // aggiorno il documento attivo
        if (doc != current_tt) {
            $("#text .doc[data-doc='"+doc+"']").trigger('click');
        }
        // Attiva occorrenza in lista
        if ( $('.list').length > 0 && $('.list_element.list_element_opened').length > 0 ) {
            $('.selected_from_list').removeClass('selected_from_list');
            var ref;
            ref = $('.list_element_opened').attr('id');
            $("#text span[data-ref='"+ref+"']").addClass('selected_from_list');
        }
        // $('#text_cont').animate({
        //     scrollTop: ($('.selected_from_list').position().top)
        // }, 200);
        $('#text_cont').scrollTop($('.selected_from_list').position().top);
    }
    $('#toggle_list_cont').trigger('click');
}

/*= COLLAPSE LISTS CONTAINER =*/
function scrollDownListContainer(speed){
    var newTop;
    var mainContainerHeight, bottomBoxHeaderHeight;

    mainContainerHeight = $('#lists_cont').parents("div[id*='main_']").outerHeight();
    bottomBoxHeaderHeight = $('#search_header').outerHeight();  

    if($('#right_header').hasClass('menuClosed')){
        newTop = mainContainerHeight - (bottomBoxHeaderHeight*2) - 16;
    } else {
        var bottomMenuHeight;
        bottomMenuHeight = $('#text_tool').outerHeight();
        newTop = mainContainerHeight - (bottomMenuHeight*2) - bottomBoxHeaderHeight - 6;
    }
    $('#lists_cont')
        .addClass('collapsed')
        .animate({
           top: newTop+'px'
    }, speed);
}

/*= SHOW ITEM FROM TEXT INTO LIST =*/
function showItemInList(id_ref){
    var speed;
    var top, mainContainerHeight;
    var list_filter_type, list_filter_pos;
    var list, list_id;
    
    // Open the list where the element is
    if ( $('#'+id_ref).length > 0 ) {
        var listsCont = $('#lists_cont');
        list = $('#'+id_ref).parent().parent();
        list_id = list.attr('id');
        if ( !  list.hasClass('list_opened') ) {
            $('.occurences:visible').hide();
            $('.list_element_opened').removeClass('list_element_opened');
            
            $('.list_opened').hide();
            $('.labelList.active').removeClass('active');
            $("#header_"+list_id).addClass('active');
            $('#list_'+list_id).addClass('list_opened').show();
        }
        // Open the letter of the element
        list_filter_pos = $('#'+id_ref).attr('data-order-list');
        $(".list_filter[data-value='"+list_filter_pos.toUpperCase()+"']").trigger('click');

        if(listsCont.hasClass('collapsed')){
            speed = 'fast';
        } else {
            speed = 'slow';
        }
        scrollDownListContainer(0);
        listsCont.show(0);
        
        top = 0;
        mainContainerHeight = $('#central_wrapper').height();
        if($('#right_header').hasClass('menuClosed')){
            top = -$('#right_header').height();
            listsCont.css('height', mainContainerHeight+'px');
        }       
        listsCont.animate({
               top: top+'px'
        }, 200, function(){
            $('#list_'+list_id).animate({
                scrollTop: 0
            }, function(){
                $('#'+id_ref).find('.toggle_list_element').trigger('click');
                $('#list_'+list_id).scrollTop($('#'+id_ref).position().top);   
            });
        });
        $('#toggle_list_cont').find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');

        $('#list_link').addClass('active');
        //updateTextContHeight();
        listsCont.removeClass('collapsed');
    }
}

/*= INITIALIZE LINK BETWEEN TEXT TRIGGER AND LIST ELEMENT =*/
function InitializeLinkTextList(){
    $('span.tooltip span.entity_name.link_active').unbind('click').click(function() {
        var id_ref, order_list;

        $(this).parent('.tooltip').siblings('.trigger').trigger('click');
        id_ref = $(this).attr('data-ref');

        if ( $('#'+id_ref).length == 0 ) {
            alert('There was an error in opening the entity reference. Please try later.');
        } else {
            showItemInList(id_ref); 
        }
    });
}

/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND TOGGLE LISTS BUTTON CLICK EVENT =*/
function bindListsBtnClick() {
    $('#list_link').click(function(event) {
        var speed;
        if($('#lists_cont').hasClass('collapsed')){
            speed = 'fast';
        } else {
            speed = 'slow';
        }
        if ($('#lists_cont').is(":visible")) {
            closeListsBox(speed);
            updateTextContHeight();

            if ( $('#span_list_select').length > 0 ) {
                if ( $('#switchReg').length > 0 ) {
                    if ( !$('#switchReg').hasClass('active') ) {
                        $('#span_list_select').removeClass('not_active').css('opacity', '1');   
                    }
                } else {
                    $('#span_list_select').removeClass('not_active').css('opacity', '1');
                }
            }

        } else {
            // chiudi il div della ricerca
            if ( $('#search_link').length > 0 && $('#search_link').hasClass('active') ) {
                var boxSuffix = $('#search_link.active').attr('data-boxsuffix') || '';
                closeSearchBox('fast', boxSuffix);
            }
            openListsBox(speed);

            if ( !$('#lists_cont').hasClass('collapsed') ) {
                if ( $('#span_list_select').length > 0 ) {
                    $('#span_list_select').addClass('not_active').css('opacity', '0.5');
                }
            }
        }
    });
}