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
