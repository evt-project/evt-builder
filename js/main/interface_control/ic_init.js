function prepareEditionLevel(xml) {
    return new Promise(function (resolve, reject) {
        var editionArray = $(xml).find('editions edition');
        editionArray.each(function () {
            var current_id = $(this).text();
            $('.main_ee_select .option_container').append(
                $('<div/>')
                    .attr("data-value", current_id.toLowerCase())
                    .attr("data-key", $(this).attr('data-key'))
                    .attr("lang", 'def')
                    .addClass('option')
                    .text(current_id.toUpperCase())
            );
        });

        var spanEEselect = $('#span_ee_select');
        // Se ho solo un livello di edizioni e non ho il regesto il pulsante TXT-TXT non serve più
        if (editionArray.length <= 1 && $(xml).find('regesto').length < 1) {
            $('#txttxt_link').remove();
            $('div.concave, div.extTop').css('width', '200px');
            $('div.botleftconcave').css('width', '176px');
        } else if (editionArray.length > 1) {
            $('#span_ee_select, #span_ee_select-add').removeClass('hidden');
        }
        // Se ho il regesto e un solo livello di edizione
        if ($(xml).find('regesto').length > 0 && editionArray.length == 1) {
            // Rimuovo i pulsanti dal menu inferiore perché inutili
            // (ricerca, liste, filtri)
            $('#search_link-add, #list_link-add, #span_list_select-add').remove();
            $('.font-size-controller').css('top', '7px');
            // Rimuovo il pulsante per aprire il selettore dei livelli di edizione
            // in quanto non è necessario
            spanEEselect.find('.open_select').remove();
            spanEEselect.find('.label_selected').css('margin-right', '4px');
        }
        var mainEEselect = $("#span_ee_select");
        mainEEselect.find(".option_container div:first-child").addClass("selected");

        var firstEE = mainEEselect.find('.option_container div:first').text();
        mainEEselect.find('.label_selected')
            .text(window.lang.convert(firstEE.toUpperCase(), window.lang.currentLang))
            .attr("data-value", mainEEselect.find('.option_container div:first').attr('data-value'))
            .trigger('change');

        // ADD BY FS
        // Se ho più di un'edizione e non è attiva la modalità txttxt non visualizzare l'opzione per la selezione dell'edizione di traduzione
        // => per EVT in generale si è deciso di permettere visualizzare l'opzione per la selezione della traduzione in ogni caso
        // Per disattivare la traduzione in modalità Testo-Immagine decommentare le seguenti righe
        // var translationOpts = $(".option[data-value='translation']");
        // if (translationOpts && (!$('#txttxt_link').hasClass('current_mode')) && $(xml).find('editions edition').length > 0) {
        //     translationOpts.hide();
        // }
        resolve();
    });
}

function preparePagePairs(xml, groupingPagesByDoc, optionTooltipInPages) {
    return new Promise(function (resolve, reject) {

        var pagesPairArray = $(xml).find('pages pair');
        if (pagesPairArray) {
            first_pp = pagesPairArray.find('pb').first().text();
            last_pp = pagesPairArray.find('pb').last().text();

            var f_pair, l_pair;
            f_pair = pagesPairArray.first().children('pb').eq(0).text();
            l_pair = pagesPairArray.first().children('pb').eq(1).text()
            first_dd = f_pair + "+" + l_pair;

            f_pair = pagesPairArray.last().children('pb').eq(0).text();
            l_pair = pagesPairArray.last().children('pb').eq(1).text()
            last_dd = f_pair + "+" + l_pair;

            // if ( groupingPagesByDoc ) {
            // 	//Group_dd
            // 	$(xml).find('textpage text').each(function(){
            // 		var text_ref, group_elem;
            // 		text_ref = $(this).attr('n').replace(/\s+/g, '');
            // 		group_elem = $('<div/>')
            // 						.attr("data-doc-group", text_ref)
            // 						.addClass('optionGroup')
            // 						.append($('<span>').text(text_ref));
            // 		$('.main_dd_select .option_container').append(group_elem);
            // 	});
            // }

            pagesPairArray.each(function () {
                var current_id, first_page_d, second_page_d;
                var current_label, first_label_d, second_label_d;
                var first_text_ref, second_text_ref;
                var first_page_in_front, second_page_in_front;

                var pbElem = $(this).children('pb');
                first_page_d = pbElem.eq(0).text();
                first_label_d = pbElem.eq(0).attr("n") != "" ? pbElem.eq(0).attr("n") : first_page_d;

                if (first_page_d.indexOf('-front') < 0) {
                    second_page_d = pbElem.eq(1).text();
                    second_label_d = pbElem.eq(1).attr("n") != "" ? pbElem.eq(1).attr("n") : second_page_d;

                    current_id = "";
                    current_label = "";

                    first_text_ref = $(xml)
                        .find('textpage text')
                        .find('pb:contains("' + first_page_d + '")')
                        .parent().attr('n');
                    if (first_text_ref === undefined) {
                        first_text_ref = $(xml)
                            .find('textpage text')
                            .find("pb[n='" + first_page_d + "']")
                            .parent().attr('n');
                    }
                    first_text_ref = first_text_ref.replace(/\s+/g, '');

                    if (second_page_d !== "") {
                        current_id = first_page_d + "+" + second_page_d;
                        current_label = first_label_d + " - " + second_label_d;
                        // if (groupingPagesByDoc) {
                        //	second_text_ref = $(xml)
                        // 						.find('textpage text')
                        // 						.find('pb:contains("'+second_page_d+'")')
                        // 						.parent().attr('n');
                        // 	second_text_ref = second_text_ref.replace(/\s+/g, '');

                        // 	if(first_text_ref !== second_text_ref){
                        // 		$(".main_dd_select [data-doc-group='"+second_text_ref+"']").append(
                        //			$('<div/>')
                        //				.attr("data-value", current_id)
                        // 				.attr("data-first-page-first-doc", first_text_ref)
                        // 				.addClass('option')
                        // 				.text(current_label)
                        // 		);
                        //	}
                        // }
                    } else {
                        current_id = first_page_d;
                        if (first_label_d.substr(-1).toLowerCase() == 'v') {
                            current_label = first_label_d + "<span lang='def'>PAGE_MISSING_RIGHT</span>";
                        } else {
                            current_label = "<span lang='def'>PAGE_MISSING_LEFT</span>" + first_label_d;
                        }
                    }

                    // if (groupingPagesByDoc) {
                    // 	$(".main_dd_select [data-doc-group='"+first_text_ref+"']").append(
                    //  	$('<div/>')
                    //			.attr("data-value", current_id)
                    //			.attr("data-first-page-first-doc", first_text_ref)
                    // 			.addClass('option')
                    // 			.text(current_label)
                    //	);
                    // } else {
                    $('.main_dd_select .option_container').append(
                        $('<div/>')
                            .attr("data-value", current_id)
                            .attr("data-label", current_label)
                            .attr("data-first-page-first-doc", first_text_ref)
                            .addClass('option')
                            .append(current_label)
                    );
                    // }
                }
            });
            $('.main_dd_select .option_container div.option:first-child').addClass('selected');
            $('.main_dd_select .label_selected')
                .text($('.main_dd_select .option_container div.option:first').text())
                .attr("data-value", $('.main_dd_select .option_container div.option:first').attr("data-value"))
                .attr("data-first-doc", $('.main_dd_select .option_container div.option:first').attr("data-first-page-first-doc"));
        }
        resolve();
    });
}

function prepareTextsAndPages(xml, groupingPagesByDoc, optionTooltipInPages) {
    return new Promise(function (resolve, reject) {
        var arrayTexts = $(xml).find('textpage text');
        if (arrayTexts) {
            arrayTexts.each(function () {
                var current_n, current_id, current_label, first_page_id;
                current_n = $(this).attr("n");
                current_label = $(this).attr("label");
                current_id = current_n.replace(/\s+/g, '');
                first_page_id = $(this).find(":first-child").text();

                $('.main_tt_select .option_container').append(
                    $('<div/>')
                        .attr("data-value", current_id)
                        .attr("data-first-page", first_page_id)
                        .attr("data-real-label", current_label)
                        .attr("title", current_label)
                        .addClass('option')
                        // GENERAL COMMAND .text(cropLongTextLabel(current_label, 12))
                        // SOLO X PELAVICINO
                        .text(cropLongTextLabel(current_label, 20))
                );

                if (groupingPagesByDoc) {
                    $('.main_pp_select .option_container').append(
                        $('<div/>')
                            .attr("data-doc-group", current_id)
                            .addClass('optionGroup')
                            .append($('<span>').text(current_label))
                    );
                }

                $(this).find('pb').each(function () {
                    var page_current_id = $(this).text();
                    var pageInFront = page_current_id.indexOf('-front') >= 0
                    page_current_id = page_current_id.replace('-front', '')

                    var page_current_label = $(this).attr("n");
                    arrayPages.push({
                        id: page_current_id,
                        label: page_current_label,
                        firstDoc: current_id
                    }); // Inserisco le pagine singole nell'array
                    if ((groupingPagesByDoc && $(".main_pp_select [data-doc-group='" + current_id + "'] .option[data-value='" + page_current_id + "']").length <= 0) ||
                        (!groupingPagesByDoc && $(".main_pp_select .option_container .option[data-value='" + page_current_id + "']").length <= 0)) {
                        var newOption = $('<div/>')
                            .attr("data-value", page_current_id)
                            .attr("data-label", page_current_label)
                            .attr("data-first-doc", current_id)
                            .attr("data-has-front", pageInFront)
                            .addClass('option')
                            .text(page_current_label);
                        if (groupingPagesByDoc) {
                            $(".main_pp_select [data-doc-group='" + current_id + "']").append(newOption);
                        } else {
                            $('.main_pp_select .option_container').append(newOption);
                        }
                    }

                    if ($("#thumb_cont figure[data-value='" + page_current_id + "']").length <= 0) {
                        var figure = $('<figure/>')
                            .addClass('thumb_single')
                            .attr('data-value', page_current_id)
                            .attr('data-first-doc', current_id);

                        $('<img />')
                            .addClass('thumb_single_img')
                            .attr("src", "images/empty-image.jpg")
                            .attr("data-state", "to-load")
                            .attr('data-src', 'data/input_data/images/single/' + page_current_id + '_small.' + image_ext)
                            .appendTo(figure);

                        $('<figcaption />')
                            .text(page_current_label)
                            .appendTo(figure);

                        $('#thumb_cont').append(figure);

                        $("img").error(function () {
                            $(this)
                                .unbind("error")
                                .attr("src", "images/no-image.png")
                                .css('opacity', '0.3');
                        });
                    }
                });
            });
        }

        createBrnav(arrayPages); // Invoca la funzione per creare la barra al primo caricamento dell'index

        $('.main_tt_select .option_container div.option:first-child').addClass('selected');
        $('.main_tt_select .label_selected')
            .text($('.main_tt_select .option_container div.option:first').text())
            .attr("data-value", $('.main_tt_select .option_container div.option:first').attr('data-value'));

        var mainPPSelect = $('.main_pp_select'),
            mainPPSelectOptionContainer = mainPPSelect.find('.option_container'),
            mainPPselectFirstOption = mainPPSelectOptionContainer.find('div.option:first');
        mainPPSelectOptionContainer.find('div.option:first-child').addClass('selected');
        mainPPSelect.find('.label_selected')
            .text(mainPPselectFirstOption.text())
            .attr("data-value", mainPPselectFirstOption.attr("data-value"))
            .attr("data-first-doc", mainPPselectFirstOption.attr("data-first-doc"));

        resolve();
    });
}

function initLists(listsArray) {
    return new Promise(function (resolve, reject) {
        var listContainer = $('#lists_cont');
        var totLists = listsArray ? listsArray.length : 0;
        if (totLists > 0) {
            var listsLoaded = 0;
            $('#toggle_list_cont')
                .unbind("click")
                .click(function () {
                    toggleListCont(this);
                });

            $('<div />')
                .attr('id', 'lists_cont_temp')
                .css('display', 'none')
                .appendTo('body');
            listsArray.each(function () {
                // if ($(this).attr('active') == '1') {
                var listName, listLabel;
                listName = $(this).get(0).tagName;
                listLabel = $(this).text();
                LISTS_MODEL[listName] = {
                    _indexes: [],
                    _items: {},
                    _filterIndexes: []
                };

                var ulListContainer = $('<ul>');
                ulListContainer.attr('id', 'ul_list_' + listName);
                ulListContainer.addClass('ul_list');

                var list_container = $('<div />');

                list_container.attr('id', 'list_' + listName);
                list_container.addClass('list');
                list_container.append(ulListContainer);
                list_container.appendTo('#lists_cont');


                $('<span />')
                    .addClass('labelList')
                    .attr('id', 'header_' + listName)
                    .attr('data-list-name', listName)
                    .attr('lang', 'def')
                    .text(listLabel)
                    .unbind("click")
                    .click(function () {
                        openList(this, listName);
                    })
                    .appendTo('#list_header_elements_contents');

                var listElement = $('#list_' + listName);
                $.ajax({
                    type: "GET",
                    url: "data/output_data/liste/" + listName + ".html",
                    dataType: "html",
                    success: function (html) {
                        var htmlEl = $(html);
                        if (htmlEl.find('li').length == 0) {
                            listElement.remove();
                            $('#header_' + listName).remove();

                            if ($('#list_header_elements_contents').find('.labelList').length == 0) {
                                $('#lists_cont').remove();
                                $('#list_link').remove();
                            }
                        } else {
                            htmlEl.find('.list_element[id]').each(function () {
                                if (listName !== 'listDoc') {
                                    var orderListLetter = this.getAttribute('data-order-list')
                                    if (orderListLetter) {
                                        orderListLetter = orderListLetter.toUpperCase();
                                        if (orderListLetter === 'Ç') {
                                            orderListLetter = "C";
                                        }
                                        if (!LISTS_MODEL[listName][orderListLetter]) {
                                            LISTS_MODEL[listName][orderListLetter] = [];
                                            LISTS_MODEL[listName]._filterIndexes.push(orderListLetter);
                                        }
                                        LISTS_MODEL[listName][orderListLetter].push(this.id);
                                        LISTS_MODEL[listName]._items[this.id] = this;
                                    }
                                    htmlEl.find('.list_element[id="' + this.id + '"]:gt(0)').remove();
                                } else {
                                    LISTS_MODEL[listName]._items[this.id] = this;
                                    LISTS_MODEL[listName]._indexes.push(this.id);
                                }
                            });
                            if (htmlEl.find('#occorrenze_' + listName)) {
                                LISTS_MODEL[listName]._occurrences = htmlEl.find('#occorrenze_' + listName)[0];
                            }
                        }
                        listsLoaded++;
                        if (listsLoaded === totLists) {
                            bindChronologicalIndex();
                            resolve();
                        }
                    }
                });
                // }
            });

            if ($.browser.safari) {
                $('#list_header .labelList').css('top', '1px');
            } else if ($.browser.webkit) {
                //$('#list_header .labelList').css('top', '-5.5px');
            }
        } else {
            listContainer.remove();
            $('#list_link').remove();
            resolve();
        }
    })
}

function initEvents(xml, groupingPagesByDoc, optionTooltipInPages) {
    return new Promise(function (resolve, reject) {
        /* Lanciato dal click sulla thumbnail */
        /* Recupera l'identificativo della pagina di sx e di quella di dx dall'hash se impostato
           (altrimenti dal selettore delle pagine singole)
           e aggiorna l'hash che poi provocherà il caricamento della nuova immagine */
        $(".main_dd_select").on('imgd_thumb', function () {
            var hash_parts, temp_pp, temp_tt, first_page, second_page, newhash;
            var first_page_lab, second_page_lab, newlab;

            hash_parts = new Array();
            hash_parts = location.hash.substr(1).split('&');
            if (hash_parts != "") {
                for (var i = 0; i < hash_parts.length; i++) {
                    if (hash_parts[i].indexOf("page") === 0) {
                        temp_pp = hash_parts[i].substr(5);
                    } else if (hash_parts[i].indexOf("doc") === 0) {
                        temp_tt = hash_parts[i].substr(4);
                    }
                }
            } else {
                var mainPPselectFirstOption = $('.main_pp_select .option_container .option:first-child')
                temp_pp = mainPPselectFirstOption.attr('data-value');
                temp_tt = mainPPselectFirstOption.attr('data-first-doc');
            }

            // first page of bookreader
            first_page = $(xml)
                .find('pair:contains(' + temp_pp + ')')
                .children()
                .eq(0).text();
            first_page_lab = $(xml)
                .find('pair:contains(' + temp_pp + ')')
                .children()
                .eq(0).attr("n");
            first_page_lab = first_page_lab != "" ? first_page_lab : first_page;

            // second page of bookreader
            second_page = $(xml)
                .find('pair:contains(' + temp_pp + ')')
                .children()
                .eq(1).text();
            second_page_lab = $(xml)
                .find('pair:contains(' + temp_pp + ')')
                .children()
                .eq(1).attr("n");
            second_page_lab = second_page_lab != "" ? second_page_lab : second_page;

            if (typeof (second_page_lab) == 'undefined') {
                newhash = first_page;
                second_page_lab = window.lang.convert('PAGE_MISSING_RIGHT', window.lang.currentLang);
            } else {
                newhash = first_page + "+" + second_page;
            }
            newlab = first_page_lab + second_page_lab;
            $(".main_dd_select .label_selected")
                .text(newlab)
                .attr("data-value", newhash)
                .attr("data-first-doc", temp_tt);
            window.location.hash = "doc=" + temp_tt + "&page=" + newhash;
        });

        /* Lanciato sul click della modalità bookreader */
        /* Recupera l'identificativo della pagina di sx e di quella di dx dal selettore delle pagine singole
           e aggiorna l'hash che poi provocherà il caricamento della nuova immagine */
        $(".main_dd_select").on('imgd_mode', function () {
            var temp_pp, temp_tt, first_page, second_page, newhash;
            var first_page_lab, second_page_lab, newlab;
            var mainPPselectLabelSelected = $(".main_pp_select .label_selected");
            temp_pp = mainPPselectLabelSelected.attr("data-value");
            temp_tt = mainPPselectLabelSelected.attr("data-first-doc");

            // first page of bookreader
            var firstPageElem = $(xml).find('pair:contains(' + temp_pp + ')').children().eq(0);
            first_page = firstPageElem.text();
            first_page_lab = firstPageElem.attr("n");
            first_page_lab = first_page_lab != "" ? first_page_lab : first_page;

            // second page of bookreader
            var secondPageElem = $(xml).find('pair:contains(' + temp_pp + ')').children().eq(1);
            second_page = secondPageElem.text();
            second_page_lab = secondPageElem.attr("n");
            second_page_lab = second_page_lab != "" ? second_page_lab : second_page;

            if (typeof (second_page_lab) != 'undefined') {
                newhash = first_page + "+" + second_page;
            } else {
                newhash = first_page;
            }
            var newLab = $(".main_dd_select .option_container .option[data-value='" + newhash + "']").text();
            $(".main_dd_select .label_selected")
                .text(newlab)
                .attr("data-value", newhash)
                .attr("data-first-doc", temp_tt);

            updateHash(temp_tt, newhash);
            $(window).hashchange();
        });

        /* APERTURA TOOLTIP PAGE */
        /* Recupera gli identificativi della pagina selezionata e del primo documento in essa contenuto.
           Ricerca gli altri testi che iniziano sulla stessa pagina
           e aggiorna il contenuto del tooltip con tale elenco. */

        if (optionTooltipInPages) {
            $('<span/>')
                .addClass('option_tooltip')
                .prependTo('.main_pp_select');

            $('<span/>')
                .addClass('option_tooltip_dd')
                .prependTo('.main_dd_select');

            $(".main_pp_select .option_container .option").hover(function (e) {
                var first_doc, pp_val, tt_val, temp_tt, docs;

                pp_val = $(this).attr('data-value');
                tt_val = $(this).attr('data-first-doc');
                docs = "";
                if (groupingPagesByDoc) {
                    var selectPPoptionElem = $(this).parents('.main_pp_select').find(".option[data-value='" + pp_val + "']");
                    selectPPoptionElem.each(function () {
                        if ($(this).attr('data-value') != tt_val) {
                            var temp_tt_val;
                            temp_tt_val = $(this).parents('.optionGroup').attr('data-doc-group');
                            temp_tt = $("#span_tt_select .option[data-value='" + temp_tt_val + "']").attr('data-real-label');
                            docs += "<span>" + temp_tt + "</span>";
                        }
                    });
                    if (selectPPoptionElem.length == 1) {
                        docs = '<span lang="' + window.lang.currentLang + '">' + window.lang.convert('DOCUMENT', window.lang.currentLang) + '</span>' + docs;
                    } else {
                        docs = '<span lang="' + window.lang.currentLang + '">' + window.lang.convert('DOCUMENTS', window.lang.currentLang) + '</span>' + docs;
                    }
                } else {
                    var spanTTselectOptionContainer = $("#span_tt_select .option_container");
                    first_doc = "<span>" + spanTTselectOptionContainer.find(".option[data-value='" + tt_val + "']").attr('data-real-label') + "</span>";
                    spanTTselectOptionContainer.find(".option[data-first-page='" + pp_val + "']").each(function () {
                        if ($(this).attr('data-value') != tt_val) {
                            temp_tt = $(this).attr('data-real-label');
                            docs += "<span>" + temp_tt + "</span>";
                        }
                    });
                    if (docs == "") {
                        docs = '<span lang="' + window.lang.currentLang + '">' + window.lang.convert('DOCUMENT', window.lang.currentLang) + '</span>' + first_doc;
                    } else {
                        docs = '<span lang="' + window.lang.currentLang + '">' + window.lang.convert('DOCUMENTS', window.lang.currentLang) + '</span>' + first_doc + docs;
                    }
                }
                $(this).parents('.main_pp_select').find(".option_tooltip")
                    .append(docs)
                    .show()
                    .offset({
                        top: ($(this).offset().top)
                    });

            }, function () {
                $(this).parents('.main_pp_select').find(".option_tooltip")
                    .empty()
                    .hide();
            });
            if (groupingPagesByDoc) {
                $(".main_dd_select .option_container .option").hover(function (e) {
                    var first_doc, pp_vals, tt_vals, temp_tt, docs;
                    pp_vals = $(this).attr('data-value').split('+');

                    tt_vals = [];

                    for (var i = 0; i < pp_vals.length; i++) {
                        if (pp_vals[i] != '' && pp_vals[i] != '(<span lang="' + window.lang.currentLang + '">' + window.lang.convert('PAGE_MISSING', window.lang.currentLang) + '</span>)') {
                            $("#span_pp_select .option[data-value='" + pp_vals[i] + "']").each(function () {
                                var temp_tt_val;
                                temp_tt_val = $(this).parents('.optionGroup').attr('data-doc-group');
                                temp_tt = $("#span_tt_select .option[data-value='" + temp_tt_val + "']").attr('data-real-label');
                                if (tt_vals[tt_vals.length - 1] != temp_tt) {
                                    tt_vals.push(temp_tt);
                                }
                                // docs += "<span>"+temp_tt+"</span>";
                            });
                        }
                    }

                    if (tt_vals.length == 1) {
                        docs = '<span lang="' + window.lang.currentLang + '">' + window.lang.convert('DOCUMENT', window.lang.currentLang) + '</span>' + tt_vals[0];
                    } else {
                        docs = '<span lang="' + window.lang.currentLang + '">' + window.lang.convert('DOCUMENTS', window.lang.currentLang) + '</span>';
                        for (var i = 0; i < tt_vals.length; i++) {
                            docs += '<span>' + tt_vals[i] + '</span>';
                        }
                    }

                    $("#span_dd_select .option_tooltip_dd")
                        .append(docs)
                        .show()
                        .offset({
                            top: ($(this).offset().top)
                        });

                }, function () {
                    $("#span_dd_select .option_tooltip_dd")
                        .empty()
                        .hide();
                });
            }
        }

        // GM
        if ($(xml).find('idno')) { // Se l'elemento xml idno esiste
            var shelfmark = $(xml).find('idno').text(); // La variabile shelfmark prende l'elementto text dell'elemento idno
            //alert(shelfmark);
            $('<div />') // Creo un div con id uguale a shelfmark
                .attr('id', shelfmark)
                .addClass('viscoll_idno')
                .appendTo('#viscoll');
        }

        /* PAGE SELECT CLICK  */
        bindPPselectClick();

        /* DOCUMENT SELECT CLICK  */
        bindTTselectClick();

        /* EDITION LEVEL SELECT  CLICK / SWITCH ON/OFF REGESTO */
        bindEEselectClick();

        /* DOUBLE PAGE SELECT CLICK */
        bindDDselectClick();

        /* FILTER SELECT CLICK */
        bindFilterOptionClick();

        /* BIND LIST TOOL SELECT CLICK */
        bindDocListSortSelectClick();

        /* GENERIC SELECT CLICK */
        bindOptionClick();

        /* GENERIC SELECT HOVER */
        bindOptionHover();

        $('.like_select').each(function () {
            updateSelectLength(this);
        });

        /* BIND GLOBAL WRAPPER MOUSE DOWN EVENT */
        bindGlobarWrapperMouseDown();

        /* CLICK SU SINGOLA THUMBNAIL */
        bindThumbClick();

        resolve();
    });
}

function prepareMsDesc(xml) {
    return new Promise(function (resolve, reject) {
        if (($(xml).find('msDesc').length > 0) && ($(xml).find('msDesc').attr('active') == 1)) {
            $('#msDesc_cont').load("data/output_data/prefatory_matter/ms_desc.html #msDesc", function () {
                if ($('#msDesc_cont').is(':empty')) {
                    $('#switch_msDesc, #msDesc_cont').remove();
                    resizeButtonsAndSelects();
                } else {
                    bindMsDescBtnClick();
                }
                /* Integration by LS */
                if ($("[lang!='" + window.lang.currentLang + "']").length > 0) {
                    window.lang.run();
                }
                /* /end Integration by LS */
                resizeGlobalTopBar();
                resolve();
            });
        } else {
            resolve();
        }
    });
}

function prepareTranslation(xml) {
    return new Promise(function (resolve, reject) {
        if (($(xml).find('trad').attr('active') == 1)) {
            $('#trad_cont').load("data/output_data/translate/page__translate.html #trad", function () {
                if ($('#trad_cont').is(':empty')) {
                    $('#switch_trad, #trad_cont').remove();
                    resizeButtonsAndSelects();
                } else {
                    bindMsDescBtnClick();
                }
                resizeGlobalTopBar();
                resolve();
            });
        } else {
            resolve();
        }
    });
}

function prepareFrontMatter(xml) {
    return new Promise(function (resolve, reject) {
        if (($(xml).find('headerInfo').length > 0) && ($(xml).find('headerInfo').attr('active') == 1)) {
            $('#headerInfo_cont').load("data/output_data/prefatory_matter/header_info.html #headerInfo", function (response, status, xhr) {
                if (response != undefined) {
                    /* Integration by LS */
                    if ($("[lang!='" + window.lang.currentLang + "']").length > 0) {
                        window.lang.run();
                    }
                    /* /end Integration by LS */

                    /* Integration by IT */
                    $(document).ready(function () {
                        var headerInfoNavTabs = $("#headerInfo_nav_tabs");
                        headerInfoNavTabs.detach().insertBefore('#headerInfo_content');
                        // $(".box_tab").hide();
                        // $("#headerInfo_nav_tabs li:first").addClass("active").show();
                        // $(".box_tab:first").show();

                        headerInfoNavTabs.find("li").unbind("click").click(function () {
                            var activeTabTrigger = headerInfoNavTabs.find("li.active");
                            var activeTab = $(activeTabTrigger.attr('data-tab'));
                            activeTab.hide();
                            // $("#headerInfo_nav_tabs li").removeClass("active");
                            activeTabTrigger.removeClass('active');
                            $(this).addClass("active");
                            // $(".box_tab").hide();

                            var activeTab = $(this).find("a").attr("href");
                            $($(this).attr('data-tab')).show();
                            // return false;
                        });
                        headerInfoNavTabs.find("li:first").trigger('click');
                        resolve();
                    });
                    /* /end Integration by IT */
                } else {
                    $('#info_link').remove();
                    resolve();
                }
            });

            bindTextInfoBtnClick();

            bindHeaderInfoBtnClick();

            resizeGlobalTopBar();
        } else {
            if ($('#info_link')) {
                $('#info_link').remove();
            }
            resolve();
        }

    });
}

function prepareBibliography(xml) {
    return new Promise(function (resolve, reject) {
        if (($(xml).find('bibliography').length > 0) && ($(xml).find('bibliography').attr('active') == 1)) {
            $('#generalBiblio_cont').load("data/output_data/prefatory_matter/bibliography.html #generalBiblio", function (response, status, xhr) {
                if (response != undefined) {
                    InitializeRefs()
                    bindHeaderInfoBtnClick();
                    resolve();
                } else {
                    $('#biblio_link').remove();
                    $('#generalBiblio_cont').remove();
                    resolve();
                }
            });
        } else {
            if ($('#generalBiblio_cont')) {
                $('#generalBiblio_cont').remove();
            }
            if ($('#biblio_link')) {
                $('#biblio_link').remove();
            }
            resolve();
        }
    });
}

function concludeUIinit() {
    return new Promise(function (resolve, reject) {
        var editionIdentifier = document.getElementById("home_title").textContent.replace(/\s/g, "");
        var welcomeCookie = getCookie('welcome_' + editionIdentifier);
        if (welcomeCookie === undefined || welcomeCookie === '') {
            $('#welcomeInfo_cont').show('fade', 0);
        }

        if ($('#generalBiblio_cont').length == 0) {
            $('#biblio_link').remove();
        }

        resizeGlobalTopBar();
        if (createSliderTxtImg) {
            createSliderTxtImg();
        }

        $('.mainButtons').each(function () {
            var full_button_width = $(this).outerWidth();
            $(this).attr('data-full-width', full_button_width);
        });

        // Sistemo interfaccia per Safari
        if ($.browser.safari) {
            $('#toggle_list_cont, #toggle_search_cont, #start_search, #toggle_search_cont-add, #start_search-add, #keyboard_link, #keyboard_link-add, #search_case_sensitive_toggler, #search_case_sensitive_toggler-add').css('top', '-1px');
        }

        $(".like_select.filter").each(function () {
            if ($(this).find('.option_container .option').length <= 2) {
                // ci sono solo gli elementi "Seleziona tutto" e "Pulisci selezione"
                $(this).remove();
            }
        });

        /* *********************** */
        /* Gestione click e eventi */
        /* *********************** */
        $("#home_title").unbind("click").click(function () {
            window.location = "index.html";
        });

        $('#poweredBy').unbind("click").click(function () {
            $('#EVTinfo_cont').show('fade', 0);
        });

        /*= TOGGLE SHORTCUTS =*/
        bindShortcutsBtnClick();

        /*= SELECTORS =*/
        bindOpenSelectClick();

        /*= BUTTONS =*/
        bindBtnClick();

        /*= Collapse menus =*/
        bindCollapseMenuBtnClick();

        /*= Internal boxes fullscreen =*/
        bindInternalFullscreenBtnClick();

        /*= Font size controllers =*/
        bindFontSizeControllerBtnClick();

        /*= BIBLIOGRAPHY =*/
        bindBiblioRefClick();
        bindBiblioBtnClick();

        /*= FRONT MATTER =*/
        bindToggleFrontBtnClick();

        /*= SEARCH =*/
        bindSearchBtnsClick();

        /*= ARROWS NAVIGATION =*/
        bindArrowsBtnsClick();

        /*= LISTS =*/
        bindListsBtnClick();
        bindChronologicalIndex();

        /*= VIEW MODES =*/
        bindViewModesBtnsClick();

        /*= ARROWS BRnav =*/
        bindArrowsBRnavClick();

        /* ****************** */
        /* Integrazione by LS */
        /* ****************** */
        /*= SETTINGS =*/
        bindSettingsBtnClick();

        /*= LANG =*/
        initializeLang();

        /* *********************** */
        /* /END Integrazione by LS */
        /* *********************** */

        /*= RESIZE =*/
        resizeButtonsAndSelects();

        if ($("[id*='toggleVersesProseBtn']")) {
            initializeProse();
        }
        /* ***************************** */
        /* / END Gestione click e eventi */
        /* ***************************** */
        setTimeout(function () {
            resolve();
        }, 420);
    });
}

function loadStructureAndPrepareUI() {
    return new Promise(function (resolve, reject) {
        $.ajax({
            type: "GET",
            url: "data/output_data/structure.xml",
            dataType: "xml",
            success: function (xml) {
                hideGlobalLoading('loading_structure_msg');

                /* ============== */
                /* GESTIONE LISTE */
                var listsArray = $(xml).find('liste [active=1]');
                if (listsArray && listsArray.length > 0) {
                    addLoadingMsg('PREPARING_LISTS', 'loading_lists_msg');
                }
                initLists(listsArray).then(function () {
                    hideGlobalLoading('loading_lists_msg');
                }); // ic_lists.js
                /* ==/ GESTIONE LISTE */
                /* ================== */

                /* =================== */
                /* LOAD EDITION LEVELS */
                addLoadingMsg('PREPARING_EDITION_LEVELS', 'edition_level_prep_msg');
                prepareEditionLevel(xml).then(function () {
                    hideGlobalLoading('edition_level_prep_msg');
                });
                /* ==/ LOAD EDITION LEVELS */
                /* ======================= */

                /* =============== */
                /* LOAD PAGE PAIRS */
                addLoadingMsg('PREPARING_PAGE_PAIRS', 'page_pairs_prep_msg');
                preparePagePairs(xml, groupingPagesByDoc, optionTooltipInPages).then(function () {
                    hideGlobalLoading('page_pairs_prep_msg');
                });
                /* ==/ LOAD PAGE PAIRS */
                /* =================== */

                /* ==================== */
                /* LOAD TEXTS AND PAGES */
                addLoadingMsg('PREPARING_TEXTS_PAGES', 'texts_pages_prep_msg');
                prepareTextsAndPages(xml, groupingPagesByDoc, optionTooltipInPages).then(function () {
                    hideGlobalLoading('texts_pages_prep_msg');
                });
                /* ==/ LOAD TEXTS AND PAGES */
                /* ======================== */

                /* ==================== */
                /* LOAD BIBLIOGRAPHY */
                addLoadingMsg('PREPARING_BIBLIOGRAPHY', 'biblio_prep_msg');
                prepareBibliography(xml).then(function () {
                    hideGlobalLoading('biblio_prep_msg');
                });
                /* ==/ LOAD BIBLIOGRAPHY */
                /* ======================== */


                /* ========================= */
                /* GESTIONE EVENTI POST AJAX */
                /* Gestione eventi per elementi creati in base alla lettura del file structure.xml */
                addLoadingMsg('PREPARING_UI', 'events_prep_msg');
                initEvents(xml, groupingPagesByDoc, optionTooltipInPages).then(function () {
                    hideGlobalLoading('events_prep_msg');
                });

                /* ****************** */
                /* Integrazione by AB */
                /* ****************** */

                /* ====================== */
                /* MANUSCRIPT DESCRIPTION */
                addLoadingMsg('PREPARING_MS_DESC', 'msDesc_prep_msg');
                prepareMsDesc(xml).then(function () {
                    hideGlobalLoading('msDesc_prep_msg');
                });

                /* ====================== */
                /* TRANSLATE */
                addLoadingMsg('PREPARING_TRANSLATION', 'translation_prep_msg');
                prepareTranslation(xml).then(function () {
                    hideGlobalLoading('translation_prep_msg');
                });

                /* ============ */
                /* FRONT MATTER */
                addLoadingMsg('PREPARING_FRONT_MATTER', 'front_matter_prep_msg');
                prepareFrontMatter(xml).then(function () {
                    hideGlobalLoading('front_matter_prep_msg');
                });

                /* *********************** */
                /* Fine integrazione by AB */
                /* *********************** */

                /* ==/ GESTIONE EVENTI POST AJAX */
                /* ============================= */

                /* =========================== */
                /* HASH CHANGE - ba.bbq plugin */
                // IT: Associa un evento a windows.onhashchange; quando l'hash cambia, ottiene il suo valore per usarlo in diverse funzioni
                $(window).hashchange(function () {
                    onHashChange(xml);
                });
                /* //= HASH CHANGE - ba.bbq plugin */
                /* =============================== */

                window.onresize = function() {
                    resizeButtonsAndSelects();
                    var mainLeftFrame = $("#main_left_frame");
                    if (mainLeftFrame) {
                        updateLinesWidth(mainLeftFrame, true);
                    }
                    var mainRightFrame = $("#main_right_frame");
                    if (mainRightFrame) {
                        updateLinesWidth(mainRightFrame, true);
                    }
                };

                // IT: Al primo caricamento aggiorno l'id della pagina in modo che indichi pagina singola
                var first_hash_parts = new Array();
                first_hash_parts = location.hash.substr(1).split('&');
                if (first_hash_parts != "") {
                    var first_hash_pp, first_hash_doc;
                    var updateHashNeeded = false;
                    for (var i = 0; i < first_hash_parts.length; i++) {
                        if (first_hash_parts[i].indexOf("page") === 0) { //begins with "page"
                            first_hash_pp = first_hash_parts[i].substr(5);
                            if (first_hash_pp.indexOf("+") > 0) {
                                first_hash_pp = first_hash_pp.substr(0, first_hash_pp.indexOf("+"));
                                updateHashNeeded = true;
                            }
                        } else if (first_hash_parts[i].indexOf("doc") === 0) { //begins with "doc"
                            first_hash_doc = first_hash_parts[i].substr(4);
                        }
                    }
                    // controllo che i riferimenti a documento e pagina
                    // siano effettivamente relativi all'edizione corrente
                    if ($("#span_tt_select .option[data-value='" + first_hash_doc + "']").length < 1 ||
                        $("#span_pp_select .option[data-value='" + first_hash_pp + "']").length < 1) {
                        window.location.hash = '';
                    } else {
                        if (updateHashNeeded) {
                            updateHash(first_hash_doc, first_hash_pp);
                        }
                        $(window).hashchange();
                    }
                } else {
                    // IT: L'evento viene attivato quando cambia l'hash della pagina
                    $(window).hashchange();
                }
                resizeGlobalTopBar();
                resolve();
            }
        });
    });
}