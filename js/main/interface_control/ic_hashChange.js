function onHashChange(xml) {
    var hash_parts, newhash, current_doc_el, current_doc, current_page, checkpp, checkdd, pp_lab, dd_lab;
    var dd_page, temp_search;

    hash_parts = new Array();
    hash_parts = location.hash.substr(1).split('&');
    if (hash_parts != "") {
        for (var i = 0; i < hash_parts.length; i++) {
            if (hash_parts[i].indexOf("page") === 0) { //begins with "page"
                current_page = hash_parts[i].substr(5);
                if (current_page.indexOf("+") > 0) {
                    current_page = current_page.substr(0, current_page.indexOf("+"));
                }
            } else if (hash_parts[i].indexOf("doc") === 0) { //begins with "doc"
                current_doc = hash_parts[i].substr(4);
            }
        }
    } else {
        var selectPPfirstOption = $('.main_pp_select .option_container div.option:first');
        current_page = selectPPfirstOption.attr('data-value');
        current_doc = selectPPfirstOption.attr('data-first-doc');
    }

    if ($("#regesto_cont").length > 0) {
        updateRegestoContent(current_doc);
    }

    if ($("#front_cont").length > 0) {
        updateFrontContent(current_doc);
    }

    var currentPBelem = $(xml).find('pages pb:contains(' + current_page + ')');
    checkpp = currentPBelem.text();

    pp_lab = currentPBelem.attr("n") != "" ? currentPBelem.attr("n") : currentPBelem.text();

    dd_page = current_page.replace(/\./g, '\\.');

    temp_search = dd_page;

    checkdd = $(".main_dd_select").find(".option[data-value*='" + temp_search + "']"); // .attr("id").substr(6)

    var mainLeftArrow = $(".main_left_arrow, #BRicon_book_left, #BRicon_book_start"),
        mainRightArrow = $(".main_right_arrow, #BRicon_book_right, #BRicon_book_end");
    mainLeftArrow.removeClass("arrow_left_disable");
    mainRightArrow.removeClass("arrow_right_disable");

    if ((current_page === first_pp) || (current_page === first_dd)) {
        mainLeftArrow.addClass("arrow_left_disable");
    }
    if ((current_page === last_pp) || (current_page === last_dd)) {
        mainRightArrow.addClass("arrow_right_disable");
    }
    current_doc_el = $("#span_tt_select .option[data-value='" + current_doc + "']");

    var insideLeftArrow = $('#inside_left_arrow'),
        insideRightArrow = $('#inside_right_arrow');
    if (insideLeftArrow.length > 0 || insideRightArrow.length > 0) {
        var prefixText = window.lang.convert('GO_TO_TEXT', window.lang.currentLang);
        if (current_doc_el.prev().text() != "") {
            insideLeftArrow.attr('title', prefixText + ' ' + current_doc_el.prev().text());
        } else {
            insideLeftArrow.attr('title', '');
        }

        if (current_doc_el.next().text() != "") {
            insideRightArrow.attr('title', prefixText + ' ' + current_doc_el.next().text());
        } else {
            insideRightArrow.attr('title', '');
        }
    }

    if ((checkpp !== "") && (!$("#imgd_link").hasClass("current_mode"))) {
        UnInitialize(); //Add by JK for ITL
        UnInitializeHS(); //Add by JK for HS
        $("#mag_image_elem").empty(); // Add by JK for Mag
        if ($('#switchMag i').hasClass('fa-search-plus')) {
            magnifierON = true;
        }

        if (current_page != $('#text_elem').attr('data-page')) {
            // necessario per la navigazione per documenti in una stessa pagina
            gotopage(current_page, pp_lab, current_doc);
        }
        //window.location.hash = "doc="+current_doc+"&page="+current_page;
        //chooseZoomMag(); // Add by JK for Mag
    } else {
        $('#span_dd_select .label_selected').trigger('change');
        $("#mag_image_elem").empty(); // Add by JK for Mag
        if ($('#switchMag i').hasClass('fa-search-plus')) {
            magnifierON = true;
        }
        gotopage(current_page, pp_lab, current_doc);
    }
    selectPP(current_page, pp_lab, current_doc);
    selectTT(current_doc);
    // Aggiorna frecce navigazione per documento
    updateDocNav(insideLeftArrow, insideRightArrow);
    
    if ($('#txt_single').hasClass("current_mode")) {
        $('#header_collapse').css("left", '15px');
    }
    // IT: Cambia il titolo della pagina in base all'hash
    // document.title = 'The hash is ' + ( hash.replace( /^#/, '' ) || 'blank' ) + '.';
    resizeButtonsAndSelects();
}

function updateDocNav(insideLeftArrow, insideRightArrow) {
    if (insideLeftArrow.length > 0 || insideRightArrow.length > 0) {
        var selectTToptionContainer = $('#span_tt_select .option_container');
        if (selectTToptionContainer.find('.option:first-child').hasClass('selected')) {
            insideLeftArrow.addClass('disabled');
            $('#inside_left_arrow-add').addClass('disabled');
        } else {
            insideLeftArrow.removeClass('disabled');
            $('#inside_left_arrow-add').removeClass('disabled');
        }
        if (selectTToptionContainer.find('.option:last-child').hasClass('selected')) {
            insideRightArrow.addClass('disabled');
            $('#inside_right_arrow-add').addClass('disabled');
        } else {
            insideRightArrow.removeClass('disabled');
            $('#inside_right_arrow-add').removeClass('disabled');
        }
    }
}