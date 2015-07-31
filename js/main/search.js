// [JACOPO] Search startup
var key_list = [];
$(function() {
	var URI = 'data/output_data';
	var jsonLocation = URI + '/' + "diplomatic" + '/' + 'diplomatic' + '.json';
	console.log(jsonLocation);
	// c'è da fare un controllo per capire se mi trovo nella pagina con un solo box ricerca o due, quindi passare alla trigger di default il parametro
	// per ora commento
	//triggerTipueSearch(jsonLocation);
	// $("#span_ee_select .label_selected").on('change', function(){
 //        jsonLocation = URI + '/'+$(this).text().toLowerCase()+'/' + $(this).text().toLowerCase() + '.json';
	// 	console.log(jsonLocation);
	// 	triggerTipueSearch(jsonLocation);
	// });
	var ee_label_left = document.getElementById("span_ee_select-add").children[0].children[0];
    var ee_label_right = document.getElementById("span_ee_select").children[0].children[0];

	var params1 = [];
    ee_label_left.addEventListener("DOMAttrModified", function(e) {
		if (params1.length == 0){
			params1.push('#tipue_search_input-add', '#tipue_search_content-add', '#start_search-add', '#search_link-add', '#search_query-add', '#text_elem-add', '#search_foot-add',
			'#search_cont-add', '#toggle_search_cont-add', '#keyboard_link-add', '#search_results-add', "#span_ee_select-add");
		}
        updateTipueSearchLocation(e.newValue.toLowerCase(), params1, '-add');
    }, false);
	var params2 = [];
	ee_label_right.addEventListener("DOMAttrModified", function(e) {
        if (params2.length == 0) {
			params2.push('#tipue_search_input', '#tipue_search_content', '#start_search', '#search_link', '#search_query', '#text_elem', '#search_foot',
			'#search_cont', '#toggle_search_cont', '#keyboard_link', '#search_results', "#span_ee_select");
		}
        updateTipueSearchLocation(e.newValue.toLowerCase(), params2, '');
    }, false);
    
    function updateTipueSearchLocation(newLocation, params, id){
        jsonLocation = URI + '/'+newLocation+'/' + newLocation + '.json';
        console.log("CHANGED TO"+jsonLocation);
        triggerTipueSearch(jsonLocation, params, id);
    }

	function triggerTipueSearch(jsonLocation, params, id) {
		$(params[0]).tipuesearch({
			'showURL' : false,
			'mode' : 'json',
			'contentLocation' : jsonLocation,
			'elements' : params,
			'addID' : id
		});
	}
	
	// "Tastiera" per la ricerca
	// Inizio tastiera virtuale
	var queryInput;
    // = document.getElementById("tipue_search_input");
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

    // var keyboard = document.getElementById("keyboard");
    // queryInput.onfocus = function () {
    //     keyboard.style.display = "block";
    // };

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
	
	var keyboard_xml = loadXMLDoc('js/main/keyboard_config.xml');
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