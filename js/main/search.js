/**
 * 
 * Search functions
 *  
 * author Jacopo Pugliese – JP
 * @from 2013 @to 2015
 *
 * author Chiara Di Pietro – CDP
 * @since 2015
 */
// [JACOPO] Search startup
var key_list = [];
$(function() {
    var URI = 'data/output_data';
    var jsonLocation = URI + '/' + "diplomatic" + '/' + 'diplomatic' + '.json';

    $('#span_ee_select-add .label_selected')
        .on('change', function(){
            updateTipueSearchLocation($(this).attr('data-value').toLowerCase(), '-add');
        });
    $('#span_ee_select .label_selected')
        .on('change', function(){
            updateTipueSearchLocation($(this).attr('data-value').toLowerCase(), '');
        });
    function updateTipueSearchLocation(newLocation, suffix){
        jsonLocation = URI + '/'+newLocation+'/' + newLocation + '.json';
        triggerTipueSearch(jsonLocation, suffix);
    }

    function triggerTipueSearch(jsonLocation, suffix) {
        $('#tipue_search_input'+suffix).tipuesearch({
            'showURL' : false,
            'mode' : 'json',
            'contentLocation' : jsonLocation,
            'suffix' : suffix
        });
    }
    
    // "Tastiera" per la ricerca
    // Inizio tastiera virtuale
    var queryInput;
    var search_box = document.getElementById("search_cont");
    var search_box_add = document.getElementById("search_cont-add");
    var keyboard = document.createElement('div');
    var keyboard_add = document.createElement('div');
    
    keyboard.setAttribute('id', 'keyboard');
    keyboard.className = 'keyboardSearch';
    keyboard.style.display = "none";

    keyboard_add.setAttribute('id', 'keyboard-add');
    keyboard_add.className = 'keyboardSearch';
    keyboard_add.style.display = "none";

    function loadXMLDoc(filename) {
        if (window.XMLHttpRequest) {
            xhttp = new XMLHttpRequest();
        } else {
            // code for IE5 and IE6
            xhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xhttp.open("GET", filename, false);
        xhttp.send();
        return xhttp.responseXML;
    }
    
    var keyboard_xml = loadXMLDoc('config/keyboard_config.xml');
    var key_group = keyboard_xml.getElementsByTagName('key-group');
    
    for (var i = 0; i < key_group.length; i++) {
        var keys = key_group[i].getElementsByTagName('key');
        for (var j = 0; j < keys.length; j++) {
            key_list.push(keys[j].textContent);
        }
    }

    // Tasti
    if ( key_list.length > 0 ) {
        var keys = document.createDocumentFragment();
        var keys_add = document.createDocumentFragment();
        for (var i in key_list) {
            var button = document.createElement('span');
            button.setAttribute('class','key');
            button.appendChild(document.createTextNode(key_list[i]));
            button.onclick = makeOnClick(key_list[i]);
            keys.appendChild(button);

            var button_add = document.createElement('span');
            button_add.setAttribute('class','key');
            button_add.appendChild(document.createTextNode(key_list[i]));
            button_add.onclick = makeOnClick(key_list[i]);
            keys_add.appendChild(button_add);
        }

        keyboard.appendChild(keys);
        search_box.appendChild(keyboard);

        keyboard_add.appendChild(keys_add);
        search_box_add.appendChild(keyboard_add);
    } else {
        document.getElementById('keyboard_link').className += ' hidden';
        document.getElementById('keyboard_link-add').className += ' hidden';
    }

    // Gestione onclick
    function makeOnClick(x) {
        return function() {
            field = this.parentNode.parentNode.getElementsByClassName('searchInput')[0];
            field.value += x;
            field.focus();
            $('#'+field.id).keyup();
        };
    }
    /* Disabilito pulsante TASTIERA VIRTUALE nella ricerca se non presente */
    if ( document.getElementsByClassName('key').length == 0 ) {
        document.getElementById('keyboard_link').className += " " + "inactive"
    }
    // Fine tastiera virtuale
    
});