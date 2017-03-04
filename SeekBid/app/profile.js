$(document).ready(function () {
  $('#wins [data-toggle="popover"]').popover();

  $("#wins .win-review-rating-stars .glyphicon").mouseover(function() {
    $(this).removeClass("glyphicon-star-empty").addClass("glyphicon-star");
    $(this).prevAll().removeClass("glyphicon-star-empty").addClass("glyphicon-star");
    $(this).nextAll().removeClass("glyphicon-star").addClass("glyphicon-star-empty");
  })
});
