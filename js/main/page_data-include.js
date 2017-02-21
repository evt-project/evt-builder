/*
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
 */

function overChoice(choiceId){
   $("."+choiceId).each(function() {
        $(this).addClass("hover");
    });
}

function outChoice(choiceId){
   $("."+choiceId).each(function() {
        $(this).removeClass("hover");
    });
}
