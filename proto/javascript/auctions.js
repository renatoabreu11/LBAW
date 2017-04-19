$(document).ready(function(){

  $("#listType .btn").click(function(){
    if(!$(this).hasClass("active")){
      $(this).addClass("active");
      $(this).siblings().removeClass("active");
      var dataTarget = $(this).data("target");
      $(dataTarget).addClass("in");
      if(dataTarget == "#auctionsList")
        $("#auctionsThumbnails").removeClass("in");
      else if(dataTarget == "#auctionsThumbnails")
        $("#auctionsList").removeClass("in");
    }
  });

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

  $('#searchBtn').click(function(){

    var name = $('#inputSearch').val();
    var category = $("#category option:selected").val();
    var fromPrice = $("#fromPrice option:selected").val();
    var toPrice = $("#toPrice option:selected").val();
    var fromTimeRem = $("#fromTimeRem option:selected").val();
    var toTimeRem = $("#toTimeRem option:selected").val();
    $.ajax({
          type : 'GET',
          url  : BASE_URL + 'api/auctions/search_auctions.php',
          data : {
              "name": name,
              "category": category,
              "fromPrice": fromPrice,
              "toPrice": toPrice,
              "fromTimeRem": fromTimeRem,
              "toTimeRem": toTimeRem
          },
          dataType: 'json',
          success: function(data){
            $('#auctions').empty();
            $('#auctionsThumbnails').empty();
            $('#auctions').append(data['list']);
            $('#auctionsThumbnails').append(data['listThumbnail']);
          },
          error: function(data){
              alert(data);
          }
      });
  });


});
