
/*
Tipue Search 3.1
Copyright (c) 2013 Tipue
Tipue Search is released under the MIT License
http://www.tipue.com/search
*/ 


(function($) {

     $.fn.tipuesearch = function(options) {

          var set = $.extend( {
          
               'show'                   : 7,
               'newWindow'              : false,
               'showURL'                : true,
               'minimumLength'          : 3,
               'descriptiveWords'       : 25,
               'highlightTerms'         : true,
               'highlightEveryTerm'     : false,
               'mode'                   : 'static',
               'liveDescription'        : '*',
               'liveContent'            : '*',
               'contentLocation'        : 'tipuesearch/tipuesearch_content.json'
          
          }, options);

          return this.each(function() {

               var tipuesearch_in = {
                    pages: []
               };
               $.ajaxSetup({
                    async: true
               });

               if (set.mode == 'live')
               {
                    for (var i = 0; i < tipuesearch_pages.length; i++)
                    {
                         $.get(tipuesearch_pages[i], '',
                              function (html)
                              {
                                   var cont = $(set.liveContent, html).text();
                                   cont = cont.replace(/\s+/g, ' ');
                                   var desc = $(set.liveDescription, html).text();
                                   desc = desc.replace(/\s+/g, ' ');
                                                                      
                                   var t_1 = html.toLowerCase().indexOf('<title>');
                                   var t_2 = html.toLowerCase().indexOf('</title>', t_1 + 7);
                                   if (t_1 != -1 && t_2 != -1)
                                   {
                                        var tit = html.slice(t_1 + 7, t_2);
                                   }
                                   else
                                   {
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

               if (set.mode == 'json')
               {
					console.log("SONO IN MODE JSON");
					console.log(set.contentLocation);
                    $.getJSON(set.contentLocation,
                         function(json)
                         {
                              tipuesearch_in = $.extend({}, json);
							  console.log(tipuesearch_in);
                         }
                    );
               }

               if (set.mode == 'static')
               {
                    tipuesearch_in = $.extend({}, tipuesearch);
               }                              
               
               var tipue_search_w = '';
               if (set.newWindow)
               {
                    tipue_search_w = ' target="_blank"';      
               }

               function getURLP(name)
               {
                    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20')) || null;
               }
               if (getURLP('q'))
               {
                    $('#tipue_search_input').val(getURLP('q'));
                    getTipueSearch(0, true);
               }                      
               $('#start_search').click(function()
               {
					console.log("RICERCA ON");
					console.log(set.mode);
					console.log(set.contentLocation);
               		//if ($('#span_si').is(':visible')) {
                              if ($('#tipue_search_input').val() != "") {
	 						if ($('#text_elem').is(':visible')) {
	 							//$('#text_elem').fadeOut(400);
								//$('#image_cont').css({opacity: "0.3"});
								getTipueSearch(0, true);
                    			     $('#search_query').html($('#tipue_search_input').val());
	 						}
	 						else {
								$('#keyboard').hide();
                    			     getTipueSearch(0, true);
                    			     $('#search_query').html($('#tipue_search_input').val());
               		     }
                    	}
                    	// else {
                     //          $('#tipue_search_content').html("<div>Enter your query into the search box above!</div>");
                     //     }
                         if ( $('#search_cont').hasClass('closed') ) {
                              $('#toggle_search_cont').trigger('click');
                         }
                         if ( $('#switchReg').hasClass('active') && $('#txtimg_link').hasClass('current_mode') ) {
                              $('#switchReg').trigger('click');
                         }
                    //}
               });

               $(this).keyup(function(event)
               {
                    if(event.keyCode == '13')
                    {
                    	/*if ($('#span_si').is(':visible')) {
                    		if ($('#tipue_search_input').val() != "") {
                         		getTipueSearch(0, true);
                         		$('#query').html($('#tipue_search_input').val());
						 	}
						 	else
						 	   $('#tipue_search_content').html("<div>Enter your query into the search box above!</div>");
						}*/
                         $("#start_search").trigger('click');
                    }
               });

               function getTipueSearch(start, replace)
               {
                    $('#tipue_search_content').hide();
                    var out = '';
                    var results = '';
                    var show_replace = false;
                    var show_stop = false;
                    
                    var d = $('#tipue_search_input').val().toLowerCase();
                    d = $.trim(d);
                    var d_w = d.split(' ');
                    d = '';
                    for (var i = 0; i < d_w.length; i++)
                    {
                         var a_w = true;
                         for (var f = 0; f < tipuesearch_stop_words.length; f++)
                         {
                              if (d_w[i] == tipuesearch_stop_words[f])
                              {
                                   a_w = false;
                                   show_stop = true;          
                              }
                         }
                         if (a_w)
                         {
                              d = d + ' ' + d_w[i];
                         }
                    }
                    d = $.trim(d);
                    d_w = d.split(' ');
                    
                    if (d.length >= set.minimumLength)
                    {
                         if (replace)
                         {
                              var d_r = d;
                              for (var i = 0; i < d_w.length; i++)
                              {
                                   for (var f = 0; f < tipuesearch_replace.words.length; f++)
                                   {
                                        if (d_w[i] == tipuesearch_replace.words[f].word)
                                        {
                                             d = d.replace(d_w[i], tipuesearch_replace.words[f].replace_with);
                                             show_replace = true;
                                        }
                                   }
                              }
                              d_w = d.split(' ');
                         }                   
                         
                         var d_t = d;
                         for (var i = 0; i < d_w.length; i++)
                         {
                              for (var f = 0; f < tipuesearch_stem.words.length; f++)
                              {
                                   if (d_w[i] == tipuesearch_stem.words[f].word)
                                   {
                                        d_t = d_t + ' ' + tipuesearch_stem.words[f].stem;
                                   }
                              }
                         }
                         d_w = d_t.split(' ');

                         var c = 0;
                         found = new Array();
						 console.log(tipuesearch_in);
                         for (var i = 0; i < tipuesearch_in.pages.length; i++)
                         {
                              var score = 1000000000;
                              var s_t = tipuesearch_in.pages[i].text;
                              for (var f = 0; f < d_w.length; f++)
                              {
                                   var pat = new RegExp(d_w[f], 'i');
                                   if (tipuesearch_in.pages[i].line.search(pat) != -1)
                                   {
                                        score -= (200000 - i);
                                   }
                                   if (tipuesearch_in.pages[i].text.search(pat) != -1)
                                   {
                                        score -= (150000 - i);
                                   }
                                   
                                   if (set.highlightTerms)
                                   {
                                        if (set.highlightEveryTerm) 
                                        {
                                             var patr = new RegExp('(' + d_w[f] + ')', 'gi');
                                        }
                                        else
                                        {
                                             var patr = new RegExp('(' + d_w[f] + ')', 'i');
                                        }
                                        s_t = s_t.replace(patr, "<span class='bold_search'>$1</span>");
                                   }
                                   if (tipuesearch_in.pages[i].tags.search(pat) != -1)
                                   {
                                        score -= (100000 - i);
                                   }
                    
                              }
                              if (score < 1000000000)
                              {
                                   found[c++] = score + '^' + tipuesearch_in.pages[i].line + '^' + s_t + '^' + tipuesearch_in.pages[i].loc + '^' + tipuesearch_in.pages[i].tags;                                                                   
                              }
                         }                         
                         
                         if (c != 0)
                         {
                              if (show_replace == 1)
                              {
                                   out += '<div id="tipue_search_warning_head">Showing results for ' + d + '</div>';
                                   out += '<div id="tipue_search_warning">Search for <a href="javascript:void(0)" id="tipue_search_replaced">' + d_r + '</a></div>'; 
                              }
                              if (c == 1)
                              {
                                   //out += '<div id="tipue_search_results_count">1 result</div>';
                                   $('#search_results').html('<div id="tipue_search_results_count">1 result</div>');
                              }
                              else
                              {
                                   c_c = c.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                                   // out += '<div id="tipue_search_results_count">' + 'We have found ' + c_c + ' results into the ' + $("#span_ee_select .label_selected").text().toLowerCase() + ' edition </div>';
                                   $('#search_results').html('<div id="tipue_search_results_count">' + 'We have found ' + c_c + ' results in the current edition.</div>');
                              }
                              
                              found.sort();
                              console.log(found);
                              var l_o = 0;
                              for (var i = 0; i < found.length; i++)
                              {
                                   var fo = found[i].split('^');
                                   if (l_o >= start && l_o < set.show + start)
                                   {
                                        //out += '<div class="tipue_search_content_title"><a href="' + 'index.html#' + fo[3] + '"' + tipue_search_w + ' target="_blank">' + fo[4] + '/' + fo[3] + '/' + fo[1] + '</a></div>';
                                                                                
                                        var t = fo[2];
                                        var t_d = '';
                                        var t_w = t.split(' ');

                                        if (t_w.length < set.descriptiveWords)
                                        {
                                             t_d = t;
                                        }
                                        else
                                        {
                                             var d_index = t.toLowerCase().indexOf(d);
                                             var pre_text = t.substring(0, d_index);
                                             var post_text = t.substring(d_index);

                                             var pre_text_w = pre_text.split(' ');
                                             var post_text_w = post_text.split(' ');
                                             
                                             var half_desc_words = (set.descriptiveWords-1)/2;
                                             var pre_text_stop = pre_text_w.length - (half_desc_words+1);

                                             for (var f = pre_text_w.length-1; (f > 0 && f > pre_text_stop); f--) {
                                                  t_d = pre_text_w[f]+' '+t_d;
                                             }
                                             
                                             for (var f = 0; (f < post_text_w.length && f < half_desc_words); f++) {
                                                  t_d += post_text_w[f]+' ';
                                             }
                                             // for (var f = 0; f < set.descriptiveWords; f++)
                                             // {
                                             //      t_d += t_w[f] + ' '; 	
                                             // }
                                        }
                                        t_d = $.trim(t_d);
                                        if (t_d.charAt(t_d.length - 1) != '.')
                                        {
                                             t_d += '...';
                                        }

                                        out += '<div class="tipue_search_content_text">' + t_d + '</div>';
                                        out += '<div class="tipue_search_found_text">';
                                        out += '<span class="tipue_search_go_to_result" onclick="window.location.hash = \'doc='+fo[4]+'&page='+fo[3]+'\'; $(\'#toggle_search_cont\').trigger(\'click\');">';
                                        out += fo[4] + ' par ' + fo[1] + ' (page ' + fo[3]  + ')</span></div>';
                                        //out += '<p>-</p>';
                                        out += '<hr />';
                                        
                                        if (set.showURL)
                                        {  
                                             out += '<div class="tipue_search_content_loc"><a href="' + fo[3] + '"' + tipue_search_w + ' target="_blank">' + 'index.html#' + fo[3] + '</a></div>';
                                        }
                                   }
                                   l_o++;     
                              }
                              
                              if (c > set.show)
                              {
                                   var pages = Math.ceil(c / set.show);
                                   var page = (start / set.show);
                                   var foot_out = "";
                                   foot_out += '<div id="tipue_search_foot"><ul id="tipue_search_foot_boxes">';
                                   
                                   if (start > 0)
                                   {
                                       foot_out += '<li><span class="tipue_search_foot_box" id="' + (start - set.show) + '_' + replace + '">&#171; </span></li>'; 
                                   }
                                                       
                                   if (page <= 2)
                                   {
                                        var p_b = pages;
                                        if (pages > 3)
                                        {
                                             p_b = 3;
                                        }                    
                                        for (var f = 0; f < p_b; f++)
                                        {
                                             if (f == page)
                                             {
                                                  foot_out += '<li class="current">' + (f + 1) + '</li>';
                                             }
                                             else
                                             {
                                                  foot_out += '<li><span class="tipue_search_foot_box" id="' + (f * set.show) + '_' + replace + '">' + (f + 1) + '</span></li>';
                                             }
                                        }
                                   }
                                   else
                                   {
                                        var p_b = page + 10;
                                        if (p_b > pages)
                                        {
                                             p_b = pages; 
                                        }

                                        for (var f = page; f < p_b; f++)
                                        {
                                             if (f == page)
                                             {
                                                  foot_out += '<li class="current">' + (f + 1) + '</li>';
                                             }
                                             else
                                             {
                                                  foot_out += '<li><span class="tipue_search_foot_box" id="' + (f * set.show) + '_' + replace + '">' + (f + 1) + '</span></li>';
                                             }
                                        }                         
                                   }
                                                      
                                   if (page + 1 != pages)
                                   {
                                       foot_out += '<li><span class="tipue_search_foot_box" id="' + (start + set.show) + '_' + replace + '"> &#187;</span></li>'; 
                                   }                    
                                   
                                   foot_out += '</ul></div>';

                                   $('#search_foot').html(foot_out).show();
                              } else {
                                   $('#search_foot').hide();
                              }                       
                         }
                         else
                         {
                              out += '<div id="tipue_search_warning_head">Nothing found</div>';
                         }
                    }
                    else
                    {
                         if (show_stop)
                         {
                              out += '<div id="tipue_search_warning_head">Nothing found</div><div id="tipue_search_warning">Common words are largely ignored</div>';
                         }
                         else
                         {
                              out += '<div id="tipue_search_warning_head">Search too short</div>';
                              if (set.minimumLength == 1)
                              {
                                   out += '<div id="tipue_search_warning">Should be one character or more</div>';
                              }
                              else
                              {
                                   out += '<div id="tipue_search_warning">Should be ' + set.minimumLength + ' characters or more</div>';
                              }
                         }
                    }
               
                    $('#tipue_search_content').html(out);
                    $('#tipue_search_content').slideDown(200);
                    
                    $('#tipue_search_replaced').click(function()
                    {
                         getTipueSearch(0, false);
                    });                
               
                    $('.tipue_search_foot_box').click(function()
                    {
                         var id_v = $(this).attr('id');
                         var id_a = id_v.split('_');
                    
                         getTipueSearch(parseInt(id_a[0]), id_a[1]);
                    });                                                       
               }          
          
          });
     };
   
})(jQuery);




