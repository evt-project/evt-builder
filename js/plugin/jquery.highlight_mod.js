/*
 * jQuery Highlight plugin
 *
 * Based on highlight v3 by Johann Burkard
 * http://johannburkard.de/blog/programming/javascript/highlight-javascript-text-higlighting-jquery-plugin.html
 *
 * Code a little bit refactored and cleaned (in my humble opinion).
 * Most important changes:
 *  - has an option to highlight only entire words (wordsOnly - false by default),
 *  - has an option to be case sensitive (caseSensitive - false by default)
 *  - highlight element tag and class names can be specified in options
 *
 * Usage:
 *   // wrap every occurrance of text 'lorem' in content
 *   // with <span class='highlight'> (default options)
 *   $('#content').highlight('lorem');
 *
 *   // search for and highlight more terms at once
 *   // so you can save some time on traversing DOM
 *   $('#content').highlight(['lorem', 'ipsum']);
 *   $('#content').highlight('lorem ipsum');
 *
 *   // search only for entire word 'lorem'
 *   $('#content').highlight('lorem', { wordsOnly: true });
 *
 *   // don't ignore case during search of term 'lorem'
 *   $('#content').highlight('lorem', { caseSensitive: true });
 *
 *   // wrap every occurrance of term 'ipsum' in content
 *   // with <em class='important'>
 *   $('#content').highlight('ipsum', { element: 'em', className: 'important' });
 *
 *   // remove default highlight
 *   $('#content').unhighlight();
 *
 *   // remove custom highlight
 *   $('#content').unhighlight({ element: 'em', className: 'important' });
 *
 *
 * Copyright (c) 2009 Bartek Szopka
 *
 * Licensed under MIT license.
 *
 */

jQuery.extend({
    highlight: function (node, re, nodeName, className) {
        function getItemData (node) {
        	var obj = {}, d;
        	if (node.nodeType === 3) {
        		obj.text = node.data;
        		obj.array = [{ 'ref': node, 'length': node.data.length, 'split': false }];
        	} else if (node.nodeType === 1 || node.tagName === 'SPAN') {
        		if (node.childNodes.length === 0)
        			return undefined;
        		if (node.className.match('facs-reg'))
        			return undefined;
        		if (node.className === 'dipl-lineN' || node.className === 'facs-lineN')
        			return undefined;
        		obj.array = [], obj.text = "";
        		for (var i = 0; i < node.childNodes.length; i++) {
        			d = getItemData(node.childNodes[i]);
        			if (d !== undefined) {
        				obj.text += d.text;
        				obj.array.push.apply(obj.array, d.array);
        			}
        		}
        	} else
        		console.error("Errore in getItemData al nodo", node);
        	return obj;
        }
        
        function getSiblingLength (node) {
        	if (node.nodeType === 3) {
        		return node.data.length;
        	} else if (node.nodeType === 1 && node.tagName === 'SPAN' &&
        			   node.childNodes.length === 1) {
        		return node.childNodes[0].data.length;
        	} else
        		console.error("Errore in getSiblingLength al nodo", node);
        }
        
        var match, map = [], string = "", toBeHighLighted = [];
        $(node).children().each(function (index, children) {
        	var kids = children.childNodes;
        	for (var i = 0; i < kids.length; i++) {
        		var item = kids[i];
        		var obj = getItemData(item);
        		if (obj) {
        			map.push.apply(map, obj.array);
        			string += obj.text;
        		}
        	}
        	//console.log(index, string);
        });
		//var c = 0, i = 0;
		while ((match = re.exec(string)) !== null) {
			var start = match.index,
				end = re.lastIndex,
				length = end - start,
				sibling, newnode, lastnode;
			//console.log(match, start, end);
			var c = 0, i = 0;
			while (i < map.length) {
				if (start >= c + map[i].length) {
					c += map[i].length;
					i++;
					continue;
				}
				if (map[i].split) {
					sibling = map[i].ref;
					while (start >= c + getSiblingLength(sibling)) {
						c += getSiblingLength(sibling);
						sibling = sibling.nextSibling;
					}
					var siblingLength = getSiblingLength(sibling);
					if (end <= c + siblingLength) {
						if (c == start) {
							lastnode = sibling.splitText(end - c);
							toBeHighLighted.push(lastnode.previousSibling);
						}
						newnode = sibling.splitText(start - c);
						if (end < c + siblingLength) {
							lastnode = newnode.splitText(length);
							toBeHighLighted.push(lastnode.previousSibling);
						} else {
							toBeHighLighted.push(newnode);
						}
						break;
					}
					if (c == start) {
						toBeHighLighted.push(sibling);
					} else {
						newnode = sibling.splitText(start - c);
						toBeHighLighted.push(newnode);
					}
					c += getSiblingLength(sibling);
					start = c;
					i++;
					continue;
				}
				if (end <= c + map[i].length) {
					if (c == start) {
						if (end == c + map[i].length) {
							toBeHighLighted.push(map[i].ref);
							break;
						}
						lastnode = map[i].ref.splitText(end - c);
						map[i].split = true;
						toBeHighLighted.push(lastnode.previousSibling);
						break;
					}
					newnode = map[i].ref.splitText(start - c);
					map[i].split = true;
					if (end < c + map[i].length) {
						lastnode = newnode.splitText(length);
						toBeHighLighted.push(lastnode.previousSibling);
					} else {
						toBeHighLighted.push(newnode);
					}
					break;
				}
				if (c == start) {
					toBeHighLighted.push(map[i].ref);
					c += map[i].length;
					start = c;
					i++;
					continue;
				}
				newnode = map[i].ref.splitText(start - c);
				map[i].split = true;
				toBeHighLighted.push(newnode);
				c += map[i].length;
				start = c;
				i++;
			}
		}
		jQuery.each (toBeHighLighted, function(idx, elem) {
			var highlight = document.createElement(nodeName || 'span');
			highlight.className = className || 'highlight';
			var clone = elem.cloneNode(true);
			highlight.appendChild(clone);
			elem.parentNode.replaceChild(highlight, elem);
		});
        return 0;
    }
});

jQuery.fn.unhighlight = function (options) {
    var settings = { className: 'highlight', element: 'span' };
    jQuery.extend(settings, options);

    return this.find(settings.element + "." + settings.className).each(function () {
        /*var parent = this.parentNode;
        parent.replaceChild(this.firstChild, this);
        parent.normalize();*/
        $(this).contents().unwrap();
    }).end();
};

jQuery.fn.highlight = function (words, options) {
    var settings = { className: 'highlight', element: 'span', caseSensitive: true, wordsOnly: false };
    jQuery.extend(settings, options);
    
    if (words.constructor === String) {
        words = [words];
    }
    words = jQuery.grep(words, function(word, i){
      return word != '';
    });
    words = jQuery.map(words, function(word, i) {
      return word.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
    });
    if (words.length == 0) { return this; };

    var flag = "g" + (settings.caseSensitive ? "" : "i");
    /*if (settings.wordsOnly) {
        pattern = "\\b" + pattern + "\\b";
    }*/
    var pattern = words[0].split("");
    pattern = pattern.join("\s*");
    var re = new RegExp(pattern, flag);
    //console.log("Ricerca eseguita su", words);
    
    return this.each(function () {
        jQuery.highlight(this, re, settings.element, settings.className);
    });
};

