// [JACOPO] Search startup
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
        console.log(jsonLocation);
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
	var queryInput = document.getElementById("tipue_search_input");
    var search_box = document.getElementById("search_cont");
    var keyboard = document.createElement('div');
    keyboard.setAttribute('id', 'keyboard');
    keyboard.style.display = "none";

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
	var key_list = [];
	for (var i = 0; i < key_group.length; i++) {
		var keys = key_group[i].getElementsByTagName('key');
		for (var j = 0; j < keys.length; j++) {
			key_list.push(keys[j].textContent);
		}
	}

    // Tasti
    var keys = document.createDocumentFragment();
    for (var i in key_list) {
        var button = document.createElement('span');
        button.setAttribute('class','key');
        button.appendChild(document.createTextNode(key_list[i]));
        button.onclick = makeOnClick(queryInput, key_list[i]);
        keys.appendChild(button);
    }

    // Backspace
    var backspace = document.createElement('span');
    backspace.setAttribute('class','key');
    backspace.appendChild(document.createTextNode('<-'));
    backspace.onclick = function() {
        queryInput.value = queryInput.value.slice(0, queryInput.value.length - 1);
        queryInput.focus();
        $('#tipue_search_input').keyup();
    }
    keys.appendChild(backspace);
    keyboard.appendChild(keys);
    
    search_box.appendChild(keyboard);
    // Gestione onclick
    function makeOnClick(field, x) {
        return function() {
            field.value += x;
            field.focus();
            $('#tipue_search_input').keyup();
        };
    }
    /* Disabilito pulsante TASTIERA VIRTUALE nella ricerca se non presente */
    if ( document.getElementsByClassName('key').length == 0 ) {
        document.getElementById('keyboard_link').className += " " + "inactive"
    }
    // Fine tastiera virtuale
	
});