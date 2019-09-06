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
function toggleListCont(toggler) {
	var boxSuffix = $(toggler).attr('data-boxsuffix'),
		listsCont = $('#lists_cont'),
		listsSelector = $('#span_list_select');

	if (listsCont.hasClass('collapsed')) {
		var top, mainContainerHeight;
		top = 0;
		listsContParent = listsCont.parents("div[id*='main_']");
		mainContainerHeight = listsContParent.outerHeight();
		if (listsContParent.find('.top-menu').hasClass('menuClosed')) {
			top = -listsContParent.find('.top-menu').outerHeight();
			listsCont.css('height', mainContainerHeight + 'px');
		}
		listsCont.animate({
			top: top + 'px'
		}, 400);
		$(toggler).find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');
		listsCont.removeClass('collapsed');

		var listsElementsOpened = $('.list:visible').find('.list_element_opened');
		if (listsElementsOpened.length > 0) {
			listsElementsOpened.find('.occurences').show();
		}
		if (listsSelector.length > 0 && !listsSelector.hasClass('not_active')) {
			listsSelector.addClass('not_active').css('opacity', '0.5');
		}
	} else {
		scrollDownListContainer(400);
		$(toggler).find('.fa').removeClass('fa-angle-double-down').addClass('fa-angle-double-up');

		if (listsSelector.length > 0 && listsSelector.hasClass('not_active')) {
			var switchRegBtn = $('#switchReg' + boxSuffix);
			if (switchRegBtn.length > 0 && !switchRegBtn.hasClass('disabled')) {
				if (!switchRegBtn.hasClass('active')) {
					listsSelector.removeClass('not_active').css('opacity', '1');
				}
			} else {
				listsSelector.removeClass('not_active').css('opacity', '1');
			}
		}
	}
}

/*= CLOSE LISTS CONTAINER =*/
function closeListsBox(speed) {
	$('#lists_cont')
		.removeClass('bottomBoxOpened')
		.hide('slide', {
			direction: 'down'
		}, 'linear', speed);
	$('#list_link').removeClass('active');

	updateTextContHeight();

	$('#text_cont')
		.find('.selected_from_list')
		.removeClass('selected_from_list');
}

/*= OPEN LISTS CONTAINER =*/
function openListsBox(speed) {
	var labelList = $('.labelList.active');
	labelList = labelList ? labelList : $('.labelList')[0];
	labelList.trigger('click');
	var listsCont = $('#lists_cont');
	listsCont.addClass('bottomBoxOpened');
	$('#list_link').addClass('active');
	var openDivLists = function () {
		// var newSearchContTop = listsCont.parents("div[id*='main_']").outerHeight() - ($('#text_tool').outerHeight()*2) - $('#search_header').outerHeight() - 6;
		// listsCont.css({
		//  'top': newSearchContTop+'px'
		// });

		if (listsCont.hasClass('collapsed')) {
			return listsCont.show();
		} else {
			return listsCont.show('slide', {
				direction: 'down'
			}, 'linear', speed);
		}

	};

	$.when(openDivLists()).done(function () {
		showHideListsNavBtn();
	});
}

function showHideListsNavBtn() {
	var totListHeadersWidth = 0;
	$('.labelList').each(function (el) {
		totListHeadersWidth += $(this).outerWidth();
	});
	var totInnerWidth = $('#list_header_elements').innerWidth();

	if (totListHeadersWidth < totInnerWidth) {
		$('#navListHeadersLx').hide();
		$('#navListHeadersRx').hide();
		$('#list_header_elements_contents').animate({
			'left': 0
		}, 42);
	} else {
		$('#navListHeadersLx').show();
		$('#navListHeadersRx').show();
	}
	// updateTextContHeight();
}

function appendItemsInList(items, listName) {
	if (items) {
		var ulList = $('#ul_list_' + listName);
		ulList.empty();
		items.forEach(function (key) {
			var el = LISTS_MODEL[listName]._items[key];
			if (listName === 'listDoc' && !el.getAttribute('data-normalized-sort-date')) {
				/* per ogni items converto il valore della data in una forma più standard. Creo un attributo 'data-normalized-sort-date' e gli assegno questo valore */
				var attrDate = el.getAttribute("data-sort-date");
				attrDate = attrDate ? attrDate.split(' ')[0] : undefined
				var date = attrDate ? attrDate.split("-") : undefined;
				var standardDate;
				if (date) {
					standardDate = date.length === 3 ? date[0] + " " + date[1] + " " + date[2] : date[0] + " " + date[1] + " 01";
				}
				standardDate = standardDate ? new Date(standardDate).getTime() : "";
				el.setAttribute("data-normalized-sort-date", standardDate);
			}
			ulList.append(el);
		});
	}
	bindShowListElementOccurrences(listName);
	InitializeRefs();
	window.lang.run();
}
/*= HANDLE NAVIGATION LIST ELEMENTS PER LETTER =*/
function filterListElements(filter) {
	var activeList = $(".labelList.active");
	if (activeList.attr("id") !== "header_listDoc") {
		doFilterListElements(filter, activeList);
	}
}

function doFilterListElements(filter, activeList) {
	var filterValue, filterEl;
	filterEl = $(filter);
	filterValue = filterEl.attr('data-value');
	$('.filter_active').removeClass('filter_active');
	filterEl.addClass('filter_active');

	$('.occurences:visible').hide();
	$('.list_element_opened').removeClass('list_element_opened');

	var listName = activeList.attr('data-list-name');
	try {
		appendItemsInList(LISTS_MODEL[listName][filterValue], listName);
	} catch (e) { console.log(e); }
}

function updateKeysVisibility(listName) {
	var listFilter = $('.filter_active');
	var filterActiveValue = listFilter ? listFilter.attr('data-value') : '';
	var listLetters = document.getElementById('list_letters');
	listLetters.innerHTML = '';
	var orderedIndexes = LISTS_MODEL[listName]._filterIndexes.sort(function (a, b) {
		if (a < b) return -1;
		if (a > b) return 1;
		return 0;
	});
	orderedIndexes.forEach(function (key) {
		var indexEl = document.createElement('span');
		indexEl.setAttribute('data-filter-type', 'first_letter');
		indexEl.setAttribute('data-value', key);
		indexEl.className = 'list_filter';
		if (filterActiveValue === key) {
			indexEl.className = ' filter_active';
		}
		indexEl.textContent = key;
		indexEl.setAttribute('onclick', 'filterListElements(this)');
		listLetters.append(indexEl);
	});
}
/*= OPEN SINGLE LIST =*/
function openList(elem, listName) {
	var listCont = $('#lists_cont');
	var listElem = $('#list_' + listName);
	if (!listElem.hasClass('list_opened')) {
		updateKeysVisibility(listName);

		if (listCont.hasClass('collapsed')) {
			$('#toggle_list_cont').trigger('click');
		}

		$('.labelList.active').removeClass('active');
		$(elem).addClass('active');
		$('.list.list_opened').hide().removeClass('list_opened');
		listElem.addClass('list_opened').show();
		listCont.attr('data-list-active', listName);

		if (listName !== 'listDoc') {
			var listFilter = $('.filter_active');
			listFilter = listFilter && listFilter.length > 0 ? listFilter : $('.list_filter:first');
			listFilter.trigger('click');
		} else {
			appendItemsInList(Object.keys(LISTS_MODEL[listName]._items), listName);
			var container = $("#ul_list_listDoc");
			container.attr('data-sort', 'asc');
			var items = $("#ul_list_listDoc .list_element");
			/* Invoco la funzione per l'ordinamento delle date */
			sortDate(container, items);
		}
	} else {
		if (listCont.hasClass('collapsed')) {
			$('#toggle_list_cont').trigger('click');
		}
	}
}

/*= SHOW LIST ELEMENT OCCURRENCES =*/
function showListElementOccurrences(elem, listName) {
	if ($(elem).hasClass('list_element_opened')) {
		// $(elem).find('.small-note, .occurences').toggle();
		$(elem).find('.fa').removeClass('fa-angle-down').addClass('fa-angle-right');
		$(elem).removeClass('list_element_opened');
	} else {
		if ($(elem).find('.occurences').length <= 0) {
			prepareOccurrencesList(elem, listName);
		}
		// $(elem).parents('.list').find('.occurences:visible').hide();
		var elemList = $(elem).parents('.list');
		elemList.find('.small-note:visible').hide();
		elemList.find('.list_element_opened')
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
function prepareOccurrencesList(elem, listName) {
	var occ_ref;
	var list_ref, list_occ;
	list_ref = $(elem).attr('id');
	list_occ = $("<div/>").addClass('occurences');
	occ_ref = $(LISTS_MODEL[listName]._occurrences)
		.find("span[data-ref='" + list_ref + "']");
	if (occ_ref.length > 0) {
		occ_ref.each(function () {
			var pb, doc, pb_n;
			var doc_lab;
			pb = $(this).attr('data-pb');
			pb_n = $(this).attr('data-pb-n');
			doc = $(this).attr('data-doc');
			doc_lab = $("#span_tt_select .option_container .option[data-value='" + doc + "']").attr('title');
			var occElem = $(list_occ).find("span[data-pb='" + pb + "'][data-doc='" + doc + "']");
			if (occElem.length > 0) {
				var occ;
				occ = occElem.attr('data-occ') * 1;
				occ++;
				occElem
					.attr('data-occ', occ)
					.attr('title', occ + " " + window.lang.convert('OCCURRENCES', window.lang.currentLang));
				$(this).remove();
			} else {
				$(this)
					.attr('data-occ', '1')
					.attr('title', "1 " + window.lang.convert('OCCURRENCE', window.lang.currentLang))
					.text(window.lang.convert('FOL', window.lang.currentLang) + " " + pb_n + " - " + window.lang.convert('DOC', window.lang.currentLang) + " " + doc_lab)
					.click(function () {
						goToOccurrencePage(this, pb, doc);
					})
					.detach()
					.appendTo(list_occ);
			}
		});
	} else {
		$(list_occ).append("<span class='no_occ' lang='" + window.lang.currentLang + "'>" + window.lang.convert('NO_MATCHES_FOUND', window.lang.currentLang) + "</span>");
	}
	$(elem).append(list_occ);
	window.lang.run();
}

/*= GO TO OCCURRECE PAGE =*/
function goToOccurrencePage(elem, pb, doc) {
	var current_pp, current_tt;
	if ($('.current_mode').attr('id') === 'txtimg_link' && $('#regesto_cont').is(':visible')) {
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
			$("#text .doc[data-doc='" + doc + "']").trigger('click');
		}
		// Attiva occorrenza in lista
		if ($('.list').length > 0 && $('.list_element.list_element_opened').length > 0) {
			$('.selected_from_list').removeClass('selected_from_list');
			var ref;
			ref = $('.list_element_opened').attr('id');
			$("#text span[data-ref='" + ref + "']").addClass('selected_from_list');
		}

		$('#text_cont').scrollTop($('.selected_from_list').position().top);
	}
	$('#toggle_list_cont').trigger('click');
}

/*= COLLAPSE LISTS CONTAINER =*/
function scrollDownListContainer(speed) {
	var newTop;
	var mainContainerHeight, bottomBoxHeaderHeight;

	mainContainerHeight = $('#lists_cont').parents("div[id*='main_']").outerHeight();
	bottomBoxHeaderHeight = $('#search_header').outerHeight();

	if ($('#right_header').hasClass('menuClosed')) {
		newTop = mainContainerHeight - (bottomBoxHeaderHeight * 2) - 16;
	} else {
		var bottomMenuHeight;
		bottomMenuHeight = $('#text_tool').outerHeight();
		newTop = mainContainerHeight - (bottomMenuHeight * 2) - bottomBoxHeaderHeight - 6;
	}
	$('#lists_cont')
		.addClass('collapsed')
		.animate({
			top: newTop + 'px'
		}, speed);
}

/*= SHOW ITEM FROM TEXT INTO LIST =*/
function showItemInList(id_ref, listName) {
	var top, mainContainerHeight;
	var list_filter_pos;
	var list, list_id;

	// Open the list where the element is
	var entityEl = LISTS_MODEL[listName]._items[id_ref];
	if (entityEl) {
		var listsCont = $('#lists_cont');
		list_id = 'list_' + listName;
		list = $('#' + list_id);
		if (!list.hasClass('list_opened')) {
			$('.occurences:visible').hide();
			$('.list_element_opened').removeClass('list_element_opened');

			$('.list_opened').hide();
			$('.list_opened').removeClass('list_opened');
			$('.labelList.active').removeClass('active');
			$("#header_" + listName).addClass('active');
			$('#' + list_id).addClass('list_opened').show();
		}
		updateKeysVisibility(listName);
		// Open the letter of the element
		list_filter_pos = $(entityEl).attr('data-order-list');
		$(".list_filter[data-value='" + list_filter_pos.toUpperCase() + "']").trigger('click');

		scrollDownListContainer(0);
		listsCont.show(0);

		top = 0;
		mainContainerHeight = $('#central_wrapper').height();
		if ($('#right_header').hasClass('menuClosed')) {
			top = -$('#right_header').height();
			listsCont.css('height', mainContainerHeight + 'px');
		}
		listsCont.animate({
			top: top + 'px'
		}, 200, function () {
			$('#' + list_id).animate({
				scrollTop: 0
			}, function () {
				if (!$(entityEl).hasClass('list_element_opened')) {
					$(entityEl).find('.toggle_list_element').trigger('click');
				}
				$(entityEl).addClass('highlight');
				setTimeout(function () {
					$(entityEl).removeClass('highlight');
				}, 1000);
				$('#' + list_id).scrollTop($(entityEl).position().top);
			});
		});
		$('#toggle_list_cont').find('.fa').removeClass('fa-angle-double-up').addClass('fa-angle-double-down');

		$('#list_link').addClass('active');
		//updateTextContHeight();
		listsCont.removeClass('collapsed');
	}
}

/*= INITIALIZE LINK BETWEEN TEXT TRIGGER AND LIST ELEMENT =*/
function InitializeLinkTextList() {
	$('span.tooltip span.entity_name.link_active').unbind('click').click(function () {
		var id_ref, listName, order_list;

		$(this).parent('.tooltip').siblings('.trigger').trigger('click');
		id_ref = $(this).attr('data-ref');
		listName = $(this).attr('data-list');

		if (!LISTS_MODEL[listName]._items[id_ref]) {
			alert('There was an error in opening the entity reference. Please try later.');
		} else {
			showItemInList(id_ref, listName);
		}
	});
}

/* ******** */
/* BINDINGS */
/* ******** */

/*= BIND TOGGLE LISTS BUTTON CLICK EVENT =*/
function bindListsBtnClick() {
	var listHeaderContents = $('#list_header_elements_contents');
	$('#navListHeadersLx').unbind('click').click(function (event) {
		// Scroll fino a left = 0;
		var currentLeft = parseInt(listHeaderContents.css('left').replace(/px/g, ""));
		if (currentLeft < -29) {
			listHeaderContents.animate({
				'left': currentLeft + 30
			}, 42);
		} else {
			listHeaderContents.animate({
				'left': 0
			}, 42);
		}
	});
	$('#navListHeadersRx').click(function (event) {
		var listHeadersWidth = 0;
		$('.labelList').each(function (el) {
			listHeadersWidth += $(this).outerWidth();
		});
		var listHeadersInnerWidth = $('#list_header_elements').innerWidth();
		// Scroll fino a left = listHeadersInnerWidth - listHeadersWidth
		var currentLeft = parseInt(listHeaderContents.css('left').replace(/px/g, ""));
		if (currentLeft > (listHeadersInnerWidth - listHeadersWidth + 29)) {
			listHeaderContents.animate({
				'left': currentLeft - 30
			}, 42);
		} else {
			listHeaderContents.animate({
				'left': listHeadersInnerWidth - listHeadersWidth
			}, 42);
		}
	});

	$('#list_link').click(function (event) {
		var listSelect = $('#span_list_select');
		var searchLink = $('#search_link');
		var listCont = $('#lists_cont');
		if (listCont.is(":visible")) {
			closeListsBox(0);

			if ($('#span_list_select').length > 0) {
				if ($('#switchReg').length > 0) {
					if (!$('#switchReg').hasClass('active')) {
						listSelect.removeClass('not_active').css('opacity', '1');
					}
				} else {
					listSelect.removeClass('not_active').css('opacity', '1');
				}
			}

		} else {
			// chiudi il div della ricerca
			if (searchLink.length > 0 && searchLink.hasClass('active')) {
				var boxSuffix = $('#search_link.active').attr('data-boxsuffix') || '';
				closeSearchBox(0, boxSuffix);
			}
			openListsBox(0);
			if ($('.labelList.active').length === 0) {
				listCont.find('.labelList').first().trigger('click');
			}
			if (!listCont.hasClass('collapsed')) {
				if (listSelect.length > 0) {
					listSelect.addClass('not_active').css('opacity', '0.5');
				}
			}
		}
		updateTextContHeight();
	});
}

/* --funzioni per la gestione dell'indice cronologico-- */

/* CDM: Ho creato una funzione esterna per l'ordinamento della data, che prende in input
 * il contenitore della lista e gli elementi.  */
function sortDate(container, items) {
	var sortingOrder = container.attr('data-sort');
	// Recupero il valore dell'attributo 'sort' del contenitore (#ul_list_listDoc) nel quale ho memorizzato il tipo di ordinamento (asc/desc)
	items.sort(function (a, b) {
		/* Ordino gli elementi sulla base del valore del nuovo attributo */
		a = parseFloat($(a).attr("data-normalized-sort-date"));
		b = parseFloat($(b).attr("data-normalized-sort-date"));
		/* verifico se l'ordinamento deve essere ascendente o discendente e restituisco il risultato conseguente */
		if (!isNaN(a) && !isNaN(b)) {
			if (sortingOrder === "asc") {
				return a < b ? -1 : a > b ? 1 : 0;
			} else if (sortingOrder === "desc") {
				return a > b ? -1 : a < b ? 1 : 0;
			}
		}
		return 0;
	});
	/* inserisco gli elementi nel contenitore dopo averlo svuotato */
	container.empty().prepend(items);
}

/* Anche per l'ordinamento dei documenti ho creato una funzione esterna, in cui recupero il valore
 * dell'attributo 'sort' del contenitore e ordino gli elementi di conseguenza, poi li inserisco nel contenitore */
function sortDocument(container, items, sortingOrder) {
	items.sort(function (a, b) {
		a = parseFloat($(a).attr("data-sort-num"));
		b = parseFloat($(b).attr("data-sort-num"));
		if (sortingOrder === 'asc') {
			return a > b ? -1 : a < b ? 1 : 0;
		} else if (sortingOrder === 'desc') {
			return a < b ? -1 : a > b ? 1 : 0;
		}
	}).each(function () {
		container.prepend(this);
	});
}

/* CDM: Ho creato una funzione di preparazione dell'indice cronologico, che viene eseguita quando si clicca sull'etichetta corrispondente.
Quello che voglio ottenere all'apertura è un indice già ordinato per data crescente, dalla più antica alla più recente,
 * e visualizzare solo i primi caratteri (ho messo 300) del regesto, con la possibilità di espanderlo e poi ridurlo */
function bindChronologicalIndex() {
	$('#header_listDoc').click(function () {
		var container = $("#ul_list_listDoc");
		if (!container.attr('data-init')) {
			console.log('header_listDoc CLICK');
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
			container.attr('data-sort', 'asc');
			
			/* Gestisco la riduzione del regesto */
			var minimized_text = $('#ul_list_listDoc .list_element .document_list_regesto .text');
			var minimized_character_count = 300;
			minimized_text.each(function() {
				var text = $(this).text();
				if (text.length >= minimized_character_count) {
					$(this).html(
						text.slice(0, minimized_character_count) + '<span class="regestoEllipsis"></span>' +
						'<span class="regestoExpansion">' + text.slice(minimized_character_count, text.length) + '</span>');
				} else {
					try { 
						var expandBtn = $(this).next();
						expandBtn.hide(); 
						expandBtn.removeClass('visible');
					} catch(e){}
				}
			});
			container.attr('data-init', true)
		}
		var items = container.find(".list_element");
		/* Invoco la funzione per l'ordinamento delle date */
		sortDate(container, items);
		showOrHideRegesto();
		// bindDocumentLinkChronologicalIndex();
	});
}

/* CDM: Ho gestito questa parte del codice per la gestione del regesto in una funzione esterna per non
 * doverla ripetere più volte. */
function toggleRegestoInIndex(el) {
	var action = $(el).attr('data-action');
	$(el).siblings('.toggleRegestoInList').addClass('active');
	$(el).removeClass('active');
	var documentRegesto = $(el).parent();
	if (action === 'expand') {
		// Sto gestendo il pulsante MORE
		documentRegesto.find('.regestoExpansion').show();
		documentRegesto.find('.regestoEllipsis').hide();
	} else {
		// Sto gestendo il pulsante LESS
		documentRegesto.find('.regestoExpansion').hide();
		documentRegesto.find('.regestoEllipsis').show();
	}
}

function showOrHideRegesto() {
	$('#ul_list_listDoc .list_element .toggleRegestoInList').click(function(event) {
		var action = $(this).attr('data-action');
		$(this).siblings('.toggleRegestoInList').addClass('visible');
		$(this).removeClass('visible');
		if (action === 'expand') {
			// Sto gestendo il pulsante MORE
			$(this).parent().find('.text .regestoExpansion').show();
			$(this).parent().find('.text .regestoEllipsis').hide();
		} else {
			// Sto gestendo il pulsante LESS
			$(this).parent().find('.text .regestoExpansion').hide();
			$(this).parent().find('.text .regestoEllipsis').show();
		}
	});
}

/* La funzione per la gestione della selezione del parametro di ordinamento è ridotta rispetto alla versione
 * precedente. */
function bindDocListSortSelectClick() {
	$(".docList_sort_attribute_select .option_container .option").click(function () {
		if (!$(this).hasClass('selected')) {
			/* se l'opzione non è già selezionata, recupero il contenitori, gli elementi della lista e il valore su cui effettuare l'ordinamento */
			var container = $("#ul_list_listDoc");
			var sortingOrder = container.attr('data-sort');
			var items = $("#ul_list_listDoc .list_element");
			var value = $(this).attr('data-value');
			/* In base a cosa devo ordinare, invoco la funzione per l'ordinamento delle date o dei documenti */
			if (value === "sort_date") {
				sortDate(container, items, sortingOrder);
				/* Devo invocare questa funzione sia qui che nell'else. Se non lo faccio,
				 * dopo aver effettuato un cambio nell'ordinamento nel testo si visualizza
				 * show more/show less che però non espandono né riducono il regesto. */
			} else if (value === "sort_document") {
				sortDocument(container, items, sortingOrder);
			}
			$(this).removeClass('selected');
		} else {
			//Is currently selected
			return;
		}
	})
}

/* Questa funzione gestisce il cambio ascendente/discendente */
function toggleSortingOrder(el) {
	var sortingContainer = $(el);
	// Update sorting order
	/* Recupero lo span del pulsante di ordinamento e il valore del suo attributo 'data-button-sort'. La prima
		* volta che viene eseguito questo codice, questo sarà 'asc', perché così impostato all'apertura della lista */
	var sortingOrderButton = sortingContainer.find('span');
	var sortingOrderButtonValue = sortingOrderButton.attr('data-button-sort');
	var sortinOrderBtnIcon = sortingContainer.find('i');
	/* Recupero l'opzione della select correntemente selezionata*/
	var selectedLabelValue = $('#span_listDoc_select .docList_sort_attribute_select .label_selected').attr('data-value');
	/*Recupero il contenitore della lista e gli elementi  */
	var container = $("#ul_list_listDoc");
	var items = $("#ul_list_listDoc .list_element");
	/* Se il pulsante per l'ordinamento è correntemente settato su 'Ascending' */
	if (sortingOrderButtonValue === 'asc') {
		/* Cambio il valore del suo attributo 'data-button-sort' in 'desc' e assegno questo valore anche all'attributo 'sort' di #ul_list_listDoc */
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
			sortDocument(container, items, 'desc');
		} else if (selectedLabelValue === 'sort_date') {
			sortDate(container, items, 'desc');
		}
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
			sortDocument(container, items, 'asc');
		} else if (selectedLabelValue === 'sort_date') {
			sortDate(container, items, 'asc');
		}
	}
}

/* Gestione del link alla prima pagina del documento corrispondente all'elemento della lista per l'indice cronologico */
function navToDocumentFromList(el) {
	/* quando si clicca sullo span della lista che contiene la numerazione, si recupera il valore di 'data-value' che corrisponde al numero del documento */
	var elementListDoc = $(el).attr('data-value');
	/* vado a recuperare nella select dei documenti l'opzione che ha il valore dell'attributo 'data-value' uguale a quello appena recuperato */
	var navSelectDoc = $('#span_tt_select .main_tt_select .option_container').find(".option[data-value='" + elementListDoc + "']");
	var numero = navSelectDoc.attr('data-value');
	/* il valore dell'attributo 'data-first-page' dell'opzione recuperata mi dà il valore della prima pagina del documento  */
	var docFirstPage = navSelectDoc.attr('data-first-page');
	updateHash(elementListDoc, docFirstPage, "");
	$('#toggle_list_cont').trigger('click');
}

function bindShowListElementOccurrences(listName) {
	$('.list_element').find('.toggle_list_element, .entity_name').click(function () {
		showListElementOccurrences($(this).parent(), listName);
	});
	/* Integration by LS */
	if ($("[lang!='" + window.lang.currentLang + "']").length > 0) {
		window.lang.update(window.lang.currentLang);
	}
	/* /end Integration by LS */
	InitializeRefs();
	// If chronological index there are no letters
}