// [JACOPO] Search startup
$(function() {
	var highlight = false;
	$('#span_ss_select').hide();
	$('#query').hide();
	$('#query').click(function () {
		if (!highlight) {
			$('#text').highlight($('#query').text());
			$(".highlight").css({ backgroundColor: "#FFFF88" });
			highlight = true;
		}
		else {
			$('#text').unhighlight();
			highlight = false;
		}
    });
	var URI = 'data/output_data';
	var jsonLocation = URI + '/' + $('#edition').val() + '/' + $('#edition').val() + '.json';
	console.log(jsonLocation);
	triggerTipueSearch(jsonLocation);
	$('#edition').change(function() {
		if ($(this).val() == 'diplomatic') {
			jsonLocation = URI + '/diplomatic/' + $('#edition').val() + '.json';
			console.log(jsonLocation);
			triggerTipueSearch(jsonLocation);
		}
		else {
			jsonLocation = URI + '/facsimile/' + $('#edition').val() + '.json';
			console.log(jsonLocation);
			triggerTipueSearch(jsonLocation);
		}
	});
	function triggerTipueSearch(jsonLocation) {
		$('#tipue_search_input').tipuesearch({
			'mode': 'json',
			'contentLocation': jsonLocation 
		});
	}
});