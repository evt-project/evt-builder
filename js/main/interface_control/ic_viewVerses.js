//function to search in which position is first line number multiple of 5
function searchFiveMultiples(v) {
    var i = 0;
    while (i < v.length) {
        if ((parseInt($(v[i]).text()) % 5 === 0)) {
            return i;
        }
        i++;
    }
}

function toggleProseVerses(el) {
    var frame = $(el).closest(".main_frame");
    var activeStatus = $(el).attr("data-active-status");

    if (activeStatus === "prose") { // Then VIEW VERSES
        viewVerses(frame);
        $(el).html('<span lang="def">PROSE</span> <i class="fa fa-align-justify" aria-hidden="true"></i>');
        $(el).attr("data-active-status", "verses");
    } else if (activeStatus === "verses") { // Then VIEW PROSE
        viewProse(frame);
        $(el).html('<span lang="def">VERSES</span> <i class="fa fa-align-left" aria-hidden="true"></i>');
        $(el).attr("data-active-status", "prose");
    }
    window.lang.run();
}

function initializeProse() {
    var lb = document.getElementsByClassName("lb");
    for (var i = 1; i < lb.length; i++) {
        $(lb[i]).html("<br />");
    }
}

function viewVerses(frame) {
    var spazio = frame.find(".spazio");
    var numeri = frame.find(".cerchio");
    var numeriP = frame.find(".dipl-lineN, .interp-lineN");
    var lb = frame.find(".lb");

    frame.find(".AnnMenuItem,.HighlightedAnnMenuItem,.SelectedAnnMenuItem,div.dipl-left,.dipl.line,div.interp-left,.interp.line").css('display', 'inline');

    for (var i = 1; i < lb.length; i++) {
        $(lb[i]).html("");
    }


    for (var i = 0; i < numeri.length; i++) {
        $(numeri[i]).css("visibility", "hidden");
    }

    for (var i = 0; i < numeriP.length; i++) {
        $(numeriP[i]).css("display", "none");
    }

    var x = searchFiveMultiples(numeri);

    for (var l = x; l < numeri.length; l = l + 5) {
        $(numeri[l]).addClass("lineNumberPoetry");
    }

    for (var i = 1; i < spazio.length; i++) {
        $(spazio[i]).html("<br />");
    }
}

function viewProse(frame) {
    var spazio = frame.find(".spazio");
    var numeri = frame.find(".cerchio");
    var numeriP = frame.find(".dipl-lineN, .interp-lineN");
    var lb = frame.find(".lb");

    frame.find(".AnnMenuItem,.HighlightedAnnMenuItem,.SelectedAnnMenuItem,div.dipl-left,.dipl.line,div.interp-left,.interp.line").css('display', 'inline-block');

    for (var i = 1; i < lb.length; i++) {
        $(lb[i]).html("<br />");
    }

    for (var i = 1; i < spazio.length; i++) {
        $(spazio[i]).html("");
    }

    for (var i = 0; i < numeri.length; i++) {
        $(numeri[i]).css("visibility", "visible");
    }

    for (var l = 4; l < numeri.length; l = l + 5) {
        $(numeri[l]).removeClass("lineNumberPoetry");
    }

    for (var i = 0; i < numeriP.length; i++) {
        $(numeriP[i]).css("display", "inline");
    }
}