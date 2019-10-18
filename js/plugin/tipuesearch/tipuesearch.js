/**
 * Tipue Search 3.1
 *
 * Copyright (c) 2013 Tipue
 * Tipue Search is released under the MIT License
 * http://www.tipue.com/search
 * 
 * changes by Jacopo Pugliese - JP 
 * @since 2013 @to 2015
 * 
 * changes by ChiaraDipi - CDP
 * @since 2015 
 */


function goToSearchResult(text_id, page_id, pos, setSuffix, inFront) {
     $('#toggle_search_cont' + setSuffix).trigger('click');
     var navToDoc;
     var navToPage;
     page_id = inFront ? undefined : page_id;
     if (text_id && page_id) {
          navToDoc = text_id;
          navToPage = page_id;
     } else {
          if (text_id && !page_id) {
               navToDoc = text_id;
               navToPage = $('[data-first-doc="'+text_id+'"]').attr('data-value');
               if (inFront) {
                    var switchReg = $('#switchReg');
                    if (switchReg && !switchReg.hasClass('active')) {
                         switchReg.trigger('click');
                    } else {
                         var switchFront = $('#switchFront');
                         if (switchFront && !switchFront.hasClass('active')) {
                              switchFront.trigger('click');
                         }
                    }
               }
          } else if (page_id && !text_id) {
               navToDoc = $('[data-value="'+page_id+'"]').attr('data-first-doc');
               navToPage = page_id;
          }
     }
     var newHash = '';
     if (navToDoc) {
          newHash += 'doc=' + navToDoc;
     }
     if (navToPage){
          newHash += '&page=' + navToPage;
     }
     if (window.location.hash !== '#' + newHash) {
          window.location.hash = newHash;
     }
     pos = pos.split('|');
     var pos_id = pos[0];
     var pos_label = pos[1];

     var posSelector;
     if (pos_label.indexOf('line') >= 0) {
          posSelector = {
               selector: 'data-line-id',
               id: pos_label.replace('line ', '')
          };
     } else if (pos_label.indexOf('par') >= 0) {
          posSelector = {
               selector: 'data-id',
               id: pos_label.replace('par ', '')
          };
     } else {
          posSelector = {
               selector: 'data-id',
               id: pos_label
          };
     }
     var elSelector = `[${posSelector.selector}="${posSelector.id}"]`;
     var elFound = document.querySelector(elSelector);
     if (elFound) {
          elFound.scrollIntoViewIfNeeded()
     } else {
          setTimeout(function () {
               elFound = document.querySelector('.highlight');
               if (elFound) {
                    elFound.scrollIntoViewIfNeeded();
               }
          }, 420);
     }
}

(function ($) {
     $.fn.tipuesearch = function (options) {

          var set = $.extend({

               'show': 7,
               'newWindow': false,
               'showURL': true,
               'minimumLength': 3,
               'descriptiveWords': 25,
               'highlightTerms': true,
               'highlightEveryTerm': false,
               'mode': 'static',
               'liveDescription': '*',
               'liveContent': '*',
               'contentLocation': 'tipuesearch/tipuesearch_content.json'

          }, options);

          return this.each(function () {

               var tipuesearch_in = {
                    pages: []
               };
               $.ajaxSetup({
                    async: true
               });

               if (set.mode == 'live') {
                    var caseSensitive = false;
                    if ($('#search_case_sensitive_toggler'+set.suffix).hasClass('active')) {
                         caseSensitive = true;
                    }
                    for (var i = 0; i < tipuesearch_pages.length; i++) {
                         $.get(tipuesearch_pages[i], '',
                              function (html) {
                                   var cont = $(set.liveContent, html).text();
                                   cont = cont.replace(/\s+/g, ' ');
                                   var desc = $(set.liveDescription, html).text();
                                   desc = desc.replace(/\s+/g, ' ');

                                   var t_1, t_2;
                                   if (caseSensitive) {
                                        /* CASE SENSITIVE SEARCH */
                                        t_1 = html.indexOf('<title>');
                                        t_2 = html.indexOf('</title>', t_1 + 7);
                                   } else {
                                        /* CASE INSENSITIVE SEARCH */
                                        t_1 = html.toLowerCase().indexOf('<title>');
                                        t_2 = html.toLowerCase().indexOf('</title>', t_1 + 7);
                                   }

                                   if (t_1 != -1 && t_2 != -1) {
                                        var tit = html.slice(t_1 + 7, t_2);
                                   }
                                   else {
                                        var tit = 'No title';
                                   }

                                   tipuesearch_in.pages.push({
                                        "title": tit,
                                        "text": desc,
                                        "tags": cont,
                                        "loc": tipuesearch_pages[i]
                                   });
                              }
                         );
                    }
               }

               if (set.mode == 'json') {
                    // console.log("SONO IN MODE JSON");
                    // console.log(set.contentLocation);
                    $.getJSON(set.contentLocation,
                         function (json) {
                              tipuesearch_in = $.extend({}, json);
                              // console.log(tipuesearch_in);
                              if ($('#search_link' + set.suffix).hasClass('active') && $('#search_query' + set.suffix).attr('data-value') != '') {
                                   getTipueSearch(0, true);
                              }
                         }
                    );
               }

               if (set.mode == 'static') {
                    tipuesearch_in = $.extend({}, tipuesearch);
               }

               var tipue_search_w = '';
               if (set.newWindow) {
                    tipue_search_w = ' target="_blank"';
               }

               function getURLP(name) {
                    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [, ""])[1].replace(/\+/g, '%20')) || null;
               }
               if (getURLP('q')) {
                    $('#tipue_search_input' + set.suffix).val(getURLP('q'));
                    getTipueSearch(0, true);
               }
               // START SEARCH         
               $('#start_search' + set.suffix).click(function () {
                    if ($('#tipue_search_input' + set.suffix).val() != "") {
                         if (!$('#text_elem' + set.suffix).is(':visible')) {
                              $('#keyboard').hide();
                         }
                         $('#search_query' + set.suffix)
                              .attr('data-value', $('#tipue_search_input' + set.suffix).val())
                              .empty()
                              .append('<span lang="def">SEARCH_FOR</span> <strong>' + $('#tipue_search_input' + set.suffix).val() + '</strong>');
                         getTipueSearch(0, true);
                         window.lang.run();
                    } else {
                         $('#tipue_search_input' + set.suffix).trigger('keyup');
                         $('#search_query' + set.suffix)
                              .attr('data-value', '')
                              .empty()
                              .append('<span lang="def">ENTER_YOUR_QUERY_INTO_THE_SEARCH_BOX_ABOVE</span>');
                         $('#tipue_search_content' + set.suffix, '#tipue_search_results_count' + set.suffix, '#search_foot' + set.suffix).text('');
                         window.lang.run();
                    }
                    if ($('#search_cont' + set.suffix).hasClass('collapsed')) {
                         $('#toggle_search_cont' + set.suffix).trigger('click');
                    }
                    if ($('#txtimg_link').hasClass('current_mode')) {
                         $('#switchReg.active').trigger('click');
                    }
                    $('#keyboard_link' + set.suffix + '.active').trigger('click');
               });

               $('#start_search' + set.suffix).dblclick(function () {
                    var updateSearch = false;
                    var currentSearchCS;
                    var newSearchQuery = $('#tipue_search_input' + set.suffix).val();
                    try {
                         currentSearchCS = $('#caseSensitiveInfo' + set.suffix).attr('data-status');
                         currentSearchCS = currentSearchCS === 'sensitive';
                    } catch (e){ }
                    var currSearchQuery;
                    try {
                         currSearchQuery = $('#search_query' + set.suffix).attr('data-value');
                    } catch(e) {}
                    var newSearchCS = false;
                    if (currentSearchCS !== undefined) {
                         if ($('#search_case_sensitive_toggler'+set.suffix).hasClass('active')) {
                              newSearchCS = true;
                         }
                         if (currentSearchCS !== newSearchCS) {
                              updateSearch = true;
                         }
                    }
                    console.log(currentSearchCS, newSearchCS);
                    if (currSearchQuery !== newSearchQuery) {
                         updateSearch = true;
                    }
                    if (updateSearch) {
                         $('#search_query' + set.suffix)
                                   .attr('data-value', newSearchQuery)
                                   .empty()
                                   .append('<span lang="def">SEARCH_FOR</span> <strong>' + newSearchQuery + '</strong>');
                         getTipueSearch(0, true);
                         window.lang.run();
                    }
               });
               $(this).keyup(function (event) {
                    if (event.keyCode == '13') {
                         /*if ($('#span_si').is(':visible')) {
                    		if ($('#tipue_search_input'+set.suffix).val() != "") {
                         		getTipueSearch(0, true);
                         		$('#query').html($('#tipue_search_input'+set.suffix).val());
						 	}
						 	else
						 	   $('#tipue_search_content'+set.suffix).html("<div>Enter your query in the search box above!</div>");
						}*/

                         $('#start_search' + set.suffix).trigger('click');
                    }
               });

               function getTipueSearch(start, replace) {
                    $('#tipue_search_content' + set.suffix).hide();
                    var out = '';
                    var results = '';
                    var show_replace = false;
                    var show_stop = false;

                    var caseSensitive = false;
                    if ($('#search_case_sensitive_toggler'+set.suffix).hasClass('active')) {
                         caseSensitive = true;
                    }
                    var d;
                    if (caseSensitive) {
                         /* CASE SENSITIVE SEARCH */
                         d = $('#tipue_search_input'+set.suffix).val();
                    } else {
                         /* CASE INSENSITIVE SEARCH */
                         d = $('#tipue_search_input' + set.suffix).val().toLowerCase();
                    }

                    d = $.trim(d);
                    var d_w = d.split(' ');
                    d = '';
                    for (var i = 0; i < d_w.length; i++) {
                         var a_w = true;
                         for (var f = 0; f < tipuesearch_stop_words.length; f++) {
                              if (d_w[i] == tipuesearch_stop_words[f]) {
                                   a_w = false;
                                   show_stop = true;
                              }
                         }
                         if (a_w) {
                              d = d + ' ' + d_w[i];
                         }
                    }
                    d = $.trim(d);
                    d_w = d.split(' ');

                    if (d.length >= set.minimumLength ||
                         (d.length == 1 && key_list.indexOf(d) >= 0)) {
                         if (replace) {
                              var d_r = d;
                              for (var i = 0; i < d_w.length; i++) {
                                   for (var f = 0; f < tipuesearch_replace.words.length; f++) {
                                        if (d_w[i] == tipuesearch_replace.words[f].word) {
                                             d = d.replace(d_w[i], tipuesearch_replace.words[f].replace_with);
                                             show_replace = true;
                                        }
                                   }
                              }
                              d_w = d.split(' ');
                         }

                         var d_t = d;
                         for (var i = 0; i < d_w.length; i++) {
                              for (var f = 0; f < tipuesearch_stem.words.length; f++) {
                                   if (d_w[i] == tipuesearch_stem.words[f].word) {
                                        d_t = d_t + ' ' + tipuesearch_stem.words[f].stem;
                                   }
                              }
                         }
                         d_w = d_t.split(' ');

                         var c = 0;
                         found = new Array();
                         // console.log(tipuesearch_in);
                         for (var i = 0; i < tipuesearch_in.pages.length; i++) {
                              var score = 1000000000;
                              var s_t = tipuesearch_in.pages[i].text;
                              for (var f = 0; f < d_w.length; f++) {
                                   // var pat = new RegExp(d_w[f], 'i');
                                   var pat = d_w[f];
                                   if (caseSensitive) {
                                        if (tipuesearch_in.pages[i].line.indexOf(pat) != -1) {
                                             score -= (200000 - i);
                                        }
                                        if (tipuesearch_in.pages[i].text.indexOf(pat) != -1) {
                                             score -= (150000 - i);
                                        }
                                   } else {
                                        if (tipuesearch_in.pages[i].line.toLowerCase().indexOf(pat) != -1) {
                                             score -= (200000 - i);
                                        }
                                        if (tipuesearch_in.pages[i].text.toLowerCase().indexOf(pat) != -1) {
                                             score -= (150000 - i);
                                        }
                                   }

                                   if (set.highlightTerms) {
                                        var highlightRegexConfig = '';
                                        if (set.highlightEveryTerm) {
                                             highlightRegexConfig = 'g';
                                        }
                                        if (!caseSensitive) {
                                             highlightRegexConfig += 'i';
                                        }
                                        var patr = new RegExp('(' + d_w[f] + ')', highlightRegexConfig);
                                        s_t = s_t.replace(patr, "<span class='bold_search'>$1</span>");
                                   }
                                   if (tipuesearch_in.pages[i].tags.indexOf(pat) != -1) {
                                        score -= (100000 - i);
                                   }

                              }
                              if (score < 1000000000) {
                                   found[c++] = score + '*|*|*' + tipuesearch_in.pages[i].line + '*|*|*' + s_t + '*|*|*' + tipuesearch_in.pages[i].loc + '*|*|*' + tipuesearch_in.pages[i].tags + '*|*|*' + tipuesearch_in.pages[i].inFront;
                              }
                         }
                         if (c != 0) {
                              if (show_replace == 1) {
                                   out += '<div id="tipue_search_warning_head' + set.suffix + '"><span lang="def">SHOWING_RESULTS_FOR</span>' + d + '</div>';
                                   out += '<div id="tipue_search_warning' + set.suffix + '"><span lanf="def">SEARCH_FOR</span><a href="javascript:void(0)" id="tipue_search_replaced' + set.suffix + '">' + d_r + '</a></div>';
                              }
                              var results_text;
                              if (c == 1) {
                                   //out += '<div id="tipue_search_results_count">1 result</div>';
                                   results_text = '<span lang="def">WE_HAVE_FOUND</span><span lang="def">ONE_RESULT</span>';
                              } else {
                                   c_c = c.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                                   // out += '<div id="tipue_search_results_count">' + 'We have found ' + c_c + ' results in the ' + $("#span_ee_select .label_selected").text().toLowerCase() + ' edition </div>';
                                   results_text = '<span lang="def">WE_HAVE_FOUND</span>' + c_c + ' <span lang="def">RESULTS</span>';
                              }

                              if ($('#span_ee_select' + set.suffix + " .option_container .option").length > 1) {
                                   results_text += ' <span lang="def">IN_THE_CURRENT_EDIION</span> ';
                                   // results_text += $('#span_ee_select'+set.suffix + " .label_selected").text().toLowerCase() + ' <span lang="def">EDITION</span>.';
                              }
                              var pages = Math.ceil(c / set.show);
                              results_text += '<span id="caseSensitiveInfo'+ set.suffix +'" data-status="'+ (caseSensitive ? 'sensitive' : 'insensitive') + '"></span> ';
                              $('#search_results' + set.suffix).html('<div id="tipue_search_results_count' + set.suffix + '" class="tipue_search_results_count">' + results_text + '</div>');
                              $('#search_cont_results' + set.suffix).attr('data-pages', pages);
                              found.sort();
                              // console.log(found);
                              var l_o = 0;
                              var page, page_id, page_n;
                              var text, text_id, text_label;
                              var pos, pos_id, pos_label;
                              var inFront;
                              var caseSensitive = false;
                              if ($('#search_case_sensitive_toggler'+set.suffix).hasClass('active')) {
                                   caseSensitive = true;
                              }
                              for (var i = 0; i < found.length; i++) {
                                   var fo = found[i].split('*|*|*'); // => [score, line, text, loc, tags, inFront]
                                   if (l_o >= start && l_o < set.show + start) {
                                        //out += '<div class="tipue_search_content_title"><a href="' + 'index.html#' + fo[3] + '"' + tipue_search_w + ' target="_blank">' + fo[4] + '/' + fo[3] + '/' + fo[1] + '</a></div>';
                                        var text = fo[2];
                                        var t_d = '';
                                        var textWords = text.split(' ');

                                        if (textWords.length < set.descriptiveWords) {
                                             t_d = text;
                                        } else {
                                             var d_index;
                                             if (caseSensitive) {
                                                  /* CASE SENSITIVE SEARCH */
                                                  d_index = text.indexOf(d);
                                             } else {
                                                  /* CASE INSENSITIVE SEARCH */
                                                  d_index = text.toLowerCase().indexOf(d);
                                             }

                                             var preText = text.substring(0, d_index);
                                             var postText = text.substring(d_index);

                                             var preTextW = preText.split(' ');
                                             var postTextW = postText.split(' ');

                                             var half_desc_words = (set.descriptiveWords - 1) / 2;
                                             var pre_text_stop = preTextW.length - (half_desc_words + 1);
                                             // if (pre_text_stop < 0) {
                                             //      pre_text_stop = pre_text_w.length - 1;
                                             // }
                                             for (var f = preTextW.length - 1; (f > 0 && f > pre_text_stop); f--) {
                                                  t_d = preTextW[f] + ' ' + t_d;
                                             }

                                             for (var f = 0; (f < postTextW.length && f < half_desc_words); f++) {
                                                  t_d += postTextW[f] + ' ';
                                             }
                                             // for (var f = 0; f < set.descriptiveWords; f++)
                                             // {
                                             //      t_d += t_w[f] + ' '; 	
                                             // }
                                        }
                                        t_d = $.trim(t_d);
                                        if (t_d.charAt(t_d.length - 1) != '.' && t_d !== text) {
                                             t_d += '...';
                                        }
                                        page = fo[3].split('|');
                                        page_id = page[0];
                                        page_n = page[1];

                                        text = fo[4].split('|');
                                        text_id = text[0];
                                        text_label = text[1];

                                        pos = fo[1].split('|');
                                        pos_id = pos[0];
                                        pos_label = pos[1];

                                        inFront = fo[5];
                                        if (t_d.indexOf("class='bold_search'>") === 0) { // PATCH
                                             t_d = '<span ' + t_d;
                                        }
                                        t_d = t_d.replace("<span class='bold_search'> ", "<span class='bold_search'>"); // PATCH
                                        out += '<div class="tipue_search_content_text">' + t_d + '</div>';
                                        out += '<div class="tipue_search_found_text">';

                                        out += `<span class="tipue_search_go_to_result" 
                                                  onclick="goToSearchResult('${text_id}', '${page_id}', '${fo[1]}', '${set.suffix}', '${inFront}')">`;
                                        out += '<span lang="def">FOUND_IN</span> ';

                                        if (text_label !== undefined) {
                                             out += text_label + ' ';
                                        }
                                        if (inFront == 'true') {
                                             var switchReg = $('#switchReg');
                                             var frontLabel = '<front>';
                                             if (switchReg) {
                                                  frontLabel = '<span lang="def">REGESTO</span>'
                                             } else {
                                                  var switchFront = $('#switchFront');
                                                  if (switchFront) {
                                                       frontLabel = '<span lang="def">INFO</span>'
                                                  }
                                             }
                                             out += '('+frontLabel+')';
                                        } else {
                                             if (page_n !== undefined) {
                                                  out += ' <span lang="def">PAGE</span> ' + page_n + ' ';
                                             }
                                             if (pos_label !== undefined) {
                                                  if (pos_label.indexOf('line') >= 0) {
                                                       out += ' <span lang="def">LINE</span> ' + pos_label.replace('line ', '');
                                                  } else if (pos_label.indexOf('par') >= 0) {
                                                       out += ' <span lang="def">PAR</span> ' + pos_label.replace('par ', '');
                                                  } else {
                                                       out += pos_label;
                                                  }
                                             }
                                        }
                                        out += '</span></div><hr />';

                                        if (set.showURL) {
                                             out += '<div class="tipue_search_content_loc"><a href="' + fo[3] + '"' + tipue_search_w + ' target="_blank">' + 'index.html#' + fo[3] + '</a></div>';
                                        }
                                   }
                                   l_o++;
                              }

                              if (c > set.show) {
                                   var pages = Math.ceil(c / set.show);
                                   var page = (start / set.show);
                                   var foot_out = "";
                                   if (set.suffix == undefined) set.suffix = '';
                                   foot_out += '<div id="tipue_search_foot' + set.suffix + '"><ul id="tipue_search_foot_boxes' + set.suffix + '">';

                                   if (start > 0) {
                                        foot_out += '<li><span class="tipue_search_foot_box" id="' + (start - set.show) + '_' + replace + '">&#171; </span></li>';
                                   }

                                   if (page <= 2) {
                                        var p_b = pages;
                                        if (pages > 3) {
                                             p_b = 3;
                                        }
                                        for (var f = 0; f < p_b; f++) {
                                             if (f == page) {
                                                  foot_out += '<li class="current">' + (f + 1) + '</li>';
                                             }
                                             else {
                                                  foot_out += '<li><span class="tipue_search_foot_box" id="' + (f * set.show) + '_' + replace + '">' + (f + 1) + '</span></li>';
                                             }
                                        }
                                   }
                                   else {
                                        var p_b = page + 10;
                                        if (p_b > pages) {
                                             p_b = pages;
                                        }

                                        for (var f = page; f < p_b; f++) {
                                             if (f == page) {
                                                  foot_out += '<li class="current">' + (f + 1) + '</li>';
                                             }
                                             else {
                                                  foot_out += '<li><span class="tipue_search_foot_box" id="' + (f * set.show) + '_' + replace + '">' + (f + 1) + '</span></li>';
                                             }
                                        }
                                   }

                                   if (page + 1 != pages) {
                                        foot_out += '<li><span class="tipue_search_foot_box" id="' + (start + set.show) + '_' + replace + '"> &#187;</span></li>';
                                   }

                                   foot_out += '</ul></div>';
                                   $('#search_foot' + set.suffix).html(foot_out).show();
                              } else {
                                   $('#search_foot' + set.suffix).hide();
                              }
                         }
                         else {
                              $('#search_results' + set.suffix).empty()
                                   .html('<div id="tipue_search_results_count' + set.suffix + '" class="tipue_search_results_count"><span lang="def">NOTHING_FOUND</span></div>' + 
                                        '<span id="caseSensitiveInfo'+ set.suffix +'" data-status="'+ (caseSensitive ? 'sensitive' : 'insensitive') + '"></span> ');
                              $('#search_foot' + set.suffix).empty();
                         }
                    }
                    else {
                         if (show_stop) {
                              out += '<div id="tipue_search_warning_head' + set.suffix + '"><span lang="def">NOTHING_FOUND</span></div>';
                              out += '<div id="tipue_search_warning' + set.suffix + '"><span lang="def">COMMON_WORDS_IGNORED</span></div>';
                              $('#search_results' + set.suffix).empty();
                              $('#search_foot' + set.suffix).empty();
                         }
                         else {
                              out += '<div id="tipue_search_warning_head' + set.suffix + '"><span lang="def">SEARCH_TOO_SHORT</span></div>';
                              if (set.minimumLength == 1) {
                                   out += '<div id="tipue_search_warning' + set.suffix + '"><span lang="def">MORE_CHARACTER_ALERT</span></div>';
                                   $('#search_results' + set.suffix).empty();
                                   $('#search_foot' + set.suffix).empty();
                              }
                              else {
                                   out += '<div id="tipue_search_warning' + set.suffix + '"><span lang="def">SHOULD_BE</span> ' + set.minimumLength + ' <span lang="def">CHARACTERS_OR_MORE</span></div>';
                                   $('#search_results' + set.suffix).empty();
                                   $('#search_foot' + set.suffix).empty();
                              }
                              $('#search_results' + set.suffix).empty();
                              $('#search_foot' + set.suffix).empty();
                         }
                    }

                    $('#tipue_search_content' + set.suffix)
                         .html(out)
                         .slideDown(200);

                    $('#tipue_search_replaced' + set.suffix).click(function () {
                         getTipueSearch(0, false);
                    });

                    $('.tipue_search_foot_box').click(function () {
                         var id_v = $(this).attr('id');
                         var id_a = id_v.split('_');

                         getTipueSearch(parseInt(id_a[0]), id_a[1]);
                    });

                    /* Integrazione by LS*/
                    window.lang.run();
               }
          });
     };

})(jQuery);




