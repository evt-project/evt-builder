/**
 * Interface Control jQuery
 * Functions Handling Lists Elements and Events
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
 * @short-term Federica Spinelli - FS
 * (added support for translation as third edition level)
 * @in 2017
 *
 * @short-term Chiara De Martin - CDM
 * (added support for chronological index of documents)
 * @in 2017/18
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
        showHideListsNavBtn();
    });
}

function showHideListsNavBtn() {
    var totListHeadersWidth = 0;
    $('.labelList').each(function(el){
        totListHeadersWidth += $(this).outerWidth();
    });
    var totInnerWidth = $('#list_header_elements').innerWidth();

    if (totListHeadersWidth <  totInnerWidth) {
        $('#navListHeadersLx').hide();
        $('#navListHeadersRx').hide();
        $('#list_header_elements_contents').animate({'left': 0}, 42);
    } else {
        $('#navListHeadersLx').show();
        $('#navListHeadersRx').show();
    }
    updateTextContHeight();
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
    var listsElementsFiltered;
    if (filterValue === '*') {
        listsElementsFiltered = $(".list_element[data-order-list!='']");
    } else {
        listsElementsFiltered = $(".list_element[data-order-list='"+filterValue.toLowerCase()+"'], .list_element[data-order-list='"+filterValue.toUpperCase()+"']");
    }

    // Elements in chronological index (listDoc) should always be visible
    $('#listDoc .list_element').show();
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
                .append("<span lang='def'>NO_ELEMENTS</span>")
                .appendTo('.ul_list:visible');
            window.lang.run();
        }
    } else {
        if ( $( '.no_elements' ).length > 0) {
            $( '.no_elements' ).hide();
        }
        // $('.ul_list:visible').find(listsElementsFiltered).sort(function(a, b) {
        //     return a.getAttribute('id') > b.getAttribute('id');
        // }).appendTo($('.ul_list:visible'));
    }

    $("div[id*='list_']").scrollTop(0);

    window.lang.run();
}

/*= OPEN SINGLE LIST =*/
function openList(elem, listName){
    var listCont = $('#lists_cont');
    if ( listCont.hasClass('collapsed') ) {
        $('#toggle_list_cont').trigger('click');
    }
    $('.labelList.active').removeClass('active');
    $(elem).addClass('active');
    $('.list.list_opened').hide();
    $('#list_'+listName).addClass('list_opened').show();
    listCont.attr('data-list-active', listName);
    $('.filter_active').trigger('click');
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
    occ_ref = $('#list_'+listName)
                .find('#occorrenze_'+listName)
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
    /* TODO: move */
    var listHeaderContents = $('#list_header_elements_contents');
    $('#navListHeadersLx').click(function(event){
        // Scroll fino a left = 0;
        var currentLeft = parseInt(listHeaderContents.css('left').replace(/px/g, ""));
        if (currentLeft < -29) {
            listHeaderContents.animate({'left': currentLeft+30}, 42);
        } else {
            listHeaderContents.animate({'left': 0}, 42);
        }
    });
    $('#navListHeadersRx').click(function(event){
        var listHeadersWidth = 0;
        $('.labelList').each(function(el){
            listHeadersWidth += $(this).outerWidth();
        });
        var listHeadersInnerWidth = $('#list_header_elements').innerWidth();
        // Scroll fino a left = listHeadersInnerWidth - listHeadersWidth
        var currentLeft = parseInt(listHeaderContents.css('left').replace(/px/g, ""));
        if (currentLeft > (listHeadersInnerWidth - listHeadersWidth + 29)) {
            listHeaderContents.animate({'left': currentLeft-30}, 42);
        } else {
            listHeaderContents.animate({'left': listHeadersInnerWidth - listHeadersWidth}, 42);
        }
    });

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

/* --funzioni per la gestione dell'indice cronologico-- */

/* Ho creato una funzione esterna per l'ordinamento della data, che prende in input
 * il contenitore della lista e gli elementi.  */
function sortDate(container, items) {
    var sortingOrder = container.attr('data-sort');
    // Recupero il valore dell'attributo 'sort' del contenitore (#ul_listDocument) nel quale ho memorizzato il tipo di ordinamento (asc/desc)
    items.each(function () {
        /* per ogni items converto il valore della data in una forma più standard. Creo un attributo 'data-normalized-sort-date' e gli assegno questo valore */
        var attrDate = $(this).attr("data-sort-date");
        var date = attrDate ? attrDate.split("-") : undefined;
        var standardDate = date && date.length === 3 ? date[0] + " " + date[1] + " " + date[2] : undefined;
        standardDate = standardDate ? new Date(standardDate).getTime() : "";
        $(this).attr("data-normalized-sort-date", standardDate);
    });
    items.sort(function (a, b) {
        /* Ordino gli elementi sulla base del valore del nuovo attributo */
        a = parseFloat($(a).attr("data-normalized-sort-date"));
        b = parseFloat($(b).attr("data-normalized-sort-date"));
        /* verifico se l'ordinamento deve essere ascendente o discendente e restituisco il risultato conseguente */
        if (!isNaN(a) && !isNaN(b)) {
            if (sortingOrder === "asc") {
                return a < b ? -1: a > b ? 1 : 0;
            } else if (sortingOrder === "desc") {
                return a > b ? -1: a < b ? 1 : 0;
            }
        }
        return 0;
    });
    /* inserisco gli elementi nel contenitore dopo averlo svuotato */
    container.empty().prepend(items);
}

/* Anche per l'ordinamento dei documenti ho creato una funzione esterna, in cui recupero il valore
 * dell'attributo 'sort' del contenitore e ordino gli elementi di conseguenza, poi li inserisco nel contenitore */
function sortDocument(container, items) {
    var sortingOrder = container.attr('data-sort');
    items.sort(function (a, b) {
        a = parseFloat($(a).attr("data-sort-num"));
        b = parseFloat($(b).attr("data-sort-num"));
        if (sortingOrder === 'asc') {
            return a > b ? -1: a < b ? 1: 0;
        } else if (sortingOrder === 'desc') {
            return a < b ? -1: a > b ? 1: 0;
        }
    }).each(function () {
        container.prepend(this);
    });
}

/* Ho creato una funzione di preparazione dell'indice cronologico, che viene eseguita quando si clicca sull'etichetta corrispondente.
Quello che voglio ottenere all'apertura è un indice già ordinato per data crescente, dalla più antica alla più recente,
 * e visualizzare solo i primi caratteri (ho messo 300) del regesto, con la possibilità di espanderlo e poi ridurlo */
function bindChronologicalIndex() {
    $('#header_listDoc').click(function () {
        /* Recupero lo span del pulsante per l'ordinamento */
        var sortingButtonSpan = $('#sortingOrder span');
        /* Voglio che le date siano ordinate in modo ascendente, il pulsante all'inizio dovrà avere valore 'Ascendente'.
         * Per fare questo ho assegnato allo span un attributo 'data-button-sort' con valore 'asc' e un testo 'ASCENDING_ORDER'
         * (visualizzato poi 'Ascending). */
        sortingButtonSpan
            .attr('data-button-sort', 'asc')
            .attr('data-lang', 'ASCENDING_ORDER')
            .text(window.lang.convert('ASCENDING_ORDER', window.lang.currentLang));
        /* Gesisco l'icona in modo che venga visualizzato il simbolo di ascendente */
        $('#sortingOrder i').attr('class', 'fa fa-sort-amount-asc');
        /* Recupero il contenitore della lista e gli assegno un attributo 'sort' che sarà inizialmente 'asc' */
        var container = $("#ul_listDocument");
        container.attr('data-sort', 'asc');
        var items = $("#ul_listDocument .list_element");
        /* Invoco la funzione per l'ordinamento delle date */
        sortDate(container, items);

        /* Gestisco la riduzione del regesto */
        var minimized_text = $('#ul_listDocument .list_element .document_list_regesto');
        var minimized_character_count = 300;
        minimized_text.each(function () {
            var text = $(this).text();
            if (text.length < minimized_character_count) return;

            $(this).html (
            text.slice(0, minimized_character_count) + '<span class="regestoEllipsis">... </span>' +
            '<span class="regestoExpansion">' + text.slice(minimized_character_count, text.length) +'</span>');
        });
        showOrHideRegesto();
        bindDocumentLinkChronologicalIndex();
    });
}

/* Ho gestito questa parte del codice per la gestione del regesto in una funzione esterna per non
 * doverla ripetere più volte. */
function showOrHideRegesto() {
    $('#ul_listDocument .list_element .toggleRegestoInList').click(function (event) {
        var action = $(this).attr('data-action');
        $(this).siblings('.toggleRegestoInList').addClass('active');
        $(this).removeClass('active');
        if (action === 'expand') {
            // Sto gestendo il pulsante MORE
            $(this).parent().find('.document_list_regesto .regestoExpansion').show();
            $(this).parent().find('.document_list_regesto .regestoEllipsis').hide();
        } else {
            // Sto gestendo il pulsante LESS
            $(this).parent().find('.document_list_regesto .regestoExpansion').hide();
            $(this).parent().find('.document_list_regesto .regestoEllipsis').show();
        }
    });
}

/* La funzione per la gestione della selezione del parametro di ordinamento è ridotta rispetto alla versione
 * precedente. */
function bindDocListSortSelectClick() {
    $(".docList_sort_attribute_select .option_container .option").click(function () {
        if (! $(this).hasClass('selected')) {
            /* se l'opzione non è già selezionata, recupero il contenitori, gli elementi della lista e il valore su cui effettuare l'ordinamento */
            var container = $("#ul_listDocument");
            var items = $("#ul_listDocument .list_element");
            var value = $(this).attr('data-value');
            /* In base a cosa devo ordinare, invoco la funzione per l'ordinamento delle date o dei documenti */
            if (value === "sort_date") {
                sortDate(container, items)
                /* Devo invocare questa funzione sia qui che nell'else. Se non lo faccio,
                 * dopo aver effettuato un cambio nell'ordinamento nel testo si visualizza
                 * show more/show less che però non espandono né riducono il regesto. */
                showOrHideRegesto();
                bindDocumentLinkChronologicalIndex();
            } else if (value === "sort_document") {
                sortDocument(container, items);
                showOrHideRegesto();
                bindDocumentLinkChronologicalIndex();
            }
            $(this).removeClass('selected');
        } else {
            //Is currently selected
            return;
        }
    })
}

/* Questa funzione gestisce il cambio ascendente/discendente */
function bindListsSortingOrderBtnClick() {
    $('#sortingOrder').click(function () {
        // Update sorting order
        /* Recupero lo span del pulsante di ordinamento e il valore del suo attributo 'data-button-sort'. La prima
         * volta che viene eseguito questo codice, questo sarà 'asc', perché così impostato all'apertura della lista */
        var sortingOrderButton = $('#sortingOrder span');
        var sortingOrderButtonValue = sortingOrderButton.attr('data-button-sort');
        var sortinOrderBtnIcon = $('#sortingOrder i');
        /* Recupero l'opzione della select correntemente selezionata*/
        var selectedLabelValue = $('#span_listDoc_select .docList_sort_attribute_select .label_selected').attr('data-value');
        /*Recupero il contenitore della lista e gli elementi  */
        var container = $("#ul_listDocument");
        var items = $("#ul_listDocument .list_element");
        /* Se il pulsante per l'ordinamento è correntemente settato su 'Ascending' */
        if (sortingOrderButtonValue === 'asc') {
            /* Cambio il valore del suo attributo 'data-button-sort' in 'desc' e assegno questo valore anche all'attributo 'sort' di #ul_listDocument */
            /* Poi Cambio la scritta sul pulsante */
            sortingOrderButton
                .attr('data-button-sort', 'desc')
                .attr('data-lang', 'DESCENDING_ORDER')
                .text(window.lang.convert('DESCENDING_ORDER', window.lang.currentLang));
            container.attr('data-sort', 'desc');
            /* Cambio il simbolo nel pulsante */
            sortinOrderBtnIcon
                .removeClass('fa-sort-amount-asc')
                .addClass('fa-sort-amount-desc');
            /* A seconda di qual è l'opzione selezionata correntemente, invoco la funzione per l'ordinamento delle date o dei documenti */
            if (selectedLabelValue === 'sort_document') {
                sortDocument(container, items);
            } else if (selectedLabelValue === 'sort_date') {
                sortDate(container, items);
            }
            /* Se non invoco ancora la funzione mi dà problemi */
            showOrHideRegesto();
            bindDocumentLinkChronologicalIndex();
            /* Se il pulsante per l'ordinamento è correntemente settato su 'Ascending' ma 'al contrario'*/
        } else if (sortingOrderButtonValue === 'desc') {
            sortingOrderButton
                .attr('data-lang', 'ASCENDING_ORDER')
                .attr('data-button-sort', 'asc')
                .text(window.lang.convert('ASCENDING_ORDER', window.lang.currentLang));
            container.attr('data-sort', 'asc');
            sortinOrderBtnIcon
                .removeClass('fa-sort-amount-desc')
                .addClass('fa-sort-amount-asc');
            if (selectedLabelValue === 'sort_document') {
                sortDocument(container, items);
            } else if (selectedLabelValue === 'sort_date') {
                sortDate(container, items);
            }
            showOrHideRegesto();
            bindDocumentLinkChronologicalIndex();
        }
    });
}

/* Gestione del link alla prima pagina del documento corrispondente all'elemento della lista per l'indice cronologico */
function bindDocumentLinkChronologicalIndex() {
    $('#ul_listDocument .list_element .document_list_doc_link').click(function () {
    /* quando si clicca sullo span della lista che contiene la numerazione, si recupera il valore di 'data-value' che corrisponde al numero del documento */
        var elementListDoc = $(this).attr('data-value');
        /* vado a recuperare nella select dei documenti l'opzione che ha il valore dell'attributo 'data-value' uguale a quello appena recuperato */
        var navSelectDoc = $('#span_tt_select .main_tt_select .option_container').find(".option[data-value='" + elementListDoc + "']");
        var numero = navSelectDoc.attr('data-value');
        /* il valore dell'attributo 'data-first-page' dell'opzione recuperata mi dà il valore della prima pagina del documento  */
        var docFirstPage = navSelectDoc.attr('data-first-page');
        updateHash(elementListDoc, docFirstPage, "");

        /* funzione definita in ic_navigation.js */
    });
}
