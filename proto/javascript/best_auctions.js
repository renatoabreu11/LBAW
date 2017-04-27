$(document).ready(function(){

	$('.clock').each(function() {
		var date = $(this).find('p').text();
   		$(this).countdown(date)
		.on('update.countdown', function(event) {
		  var format = '%Hh:%Mm:%Ss';
		  if(event.offset.totalDays > 0) {
		    format = '%-d day%!d ' + format;
		  }
		  if(event.offset.weeks > 0) {
		    format = '%-w week%!w ' + format;
		  }
		  $(this).html(event.strftime(format));
		})
		.on('finish.countdown', function(event) {
		  $(this).html('This offer has expired!')
		    .parent().addClass('disabled');

		});
	});

	$('.auction_row').each(function() {
		$(this).show();
	});
    
});
