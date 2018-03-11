//function to search in which position is first line number multiple of 5
function searchFiveMultiples(v) {
    var i = 0;
    while (i < v.length) {
        if ((parseInt(v[i].textContent) % 5 === 0)) {
            return i;
        }
        i++;
    }
}

function viewVerses() {
    var spazio = document.getElementsByClassName("spazio");
    var numeri = document.getElementsByClassName("cerchio");
    var numeriP = document.getElementsByClassName("dipl-lineN");
    var lb = document.getElementsByClassName("lb");

    $(".AnnMenuItem,.HighlightedAnnMenuItem,.SelectedAnnMenuItem,div.dipl-left,.dipl.line,div.interp-left,.interp.line").css('display', 'inline');

    for (var i = 1; i < lb.length; i++) {
        lb[i].innerHTML = "";
    }


    for (var i = 0; i < numeri.length; i++) {
        numeri[i].style.visibility = "hidden";
    }

    for (var i = 0; i < numeriP.length; i++) {
        numeriP[i].style.display = "none";
    }

    var x = searchFiveMultiples(numeri);

    for (var l = x; l < numeri.length; l = l + 5) {
        if (numeri[l] && numeri[l].style) {
            numeri[l].style.visibility = "visible";
            numeri[l].style.border = "none";
            numeri[l].style.background = "none";
            numeri[l].style.color = "grey";
        }
    }

    var bottone = document.getElementById("toggleVersesProseBtn");
    bottone.innerHTML = '<span lang="def">Prosa</span> <i class="fa fa-align-justify" aria-hidden="true"></i>';
    bottone.onclick = viewProse;



    for (var i = 1; i < spazio.length; i++) {
        spazio[i].innerHTML = "<br />";
    }

}

function viewProse() {
    var spazio = document.getElementsByClassName("spazio");
    var numeri = document.getElementsByClassName("cerchio");
    var numeriP = document.getElementsByClassName("dipl-lineN");
    var lb = document.getElementsByClassName("lb");

    $(".AnnMenuItem,.HighlightedAnnMenuItem,.SelectedAnnMenuItem,div.dipl-left,.dipl.line,div.interp-left,.interp.line").css('display', 'inline-block');

    for (var i = 1; i < lb.length; i++) {
        lb[i].innerHTML = "<br />";
    }

    for (var i = 1; i < spazio.length; i++) {
        spazio[i].innerHTML = "";
    }

    for (var i = 0; i < numeri.length; i++) {
        numeri[i].style.visibility = "visible";
    }

    for (var l = 4; l < numeri.length; l = l + 5) {
        numeri[l].style.border = "1px solid black";
        numeri[l].style.background = "blue";
        numeri[l].style.color = "white";

    }

    for (var i = 0; i < numeriP.length; i++) {
        numeriP[i].style.display = "inline";
    }

    var bottone = document.getElementById("toggleVersesProseBtn");
    bottone.innerHTML = '<span lang="def">Versi</span> <i class="fa fa-align-left" aria-hidden="true"></i>';
    bottone.onclick = viewVerses;
}

function initializeProse() {
    var lb = document.getElementsByClassName("lb");
    for (var i = 1; i < lb.length; i++) {
        lb[i].innerHTML = "<br />";
    }
}