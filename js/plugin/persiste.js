;(function(window, $, undefined) {
  var persiste = {
    form: null,
    formDati: {},
    salvataggio: function() {
      localStorage.setItem('jquery-persiste', JSON.stringify(persiste.formDati)); 
    },
    caricamento: function() {
      persiste.formDati = JSON.parse(localStorage.getItem('jquery-persiste')); 
      if (persiste.formDati) {
        $.each(Object.keys(persiste.formDati), persiste.Valoredefault);
      } else {
        persiste.formDati = {};
      }
    }, 
    salvaDati: function() {
      var box = $(this),
          label = box.attr('name');
          
      if (box.is(':checkbox') || box.is(':radio')) {
          var valori = [];
              
          valori.push(box.val());
          box.siblings(':checked').each(function() {
            valori.push($(this).val());
          });

          persiste.formDati[label] = valori;
      } else {
        persiste.formDati[label] = box.val();
      }     
            
      persiste.salvataggio();
    },
    Valoredefault: function(key, valore) {
      var box = persiste.form.find('[name="'+valore+'"]'),
          valore = persiste.formDati[valore];
      
			if (typeof box == 'Array') {
				box.filter('[valore="' + valore + '"]').prop("checked", true);
			} else {
				if (!box.is(':submit')) {
					box.val(valore);
				}
			}
    } 
  };

  $.fn.persiste = function() {
    persiste.form = $(this);
    persiste.caricamento();
    persiste.form.find('input, select, textarea').on('change', persiste.salvaDati);

    return $(this);
  };  
})(window, jQuery);