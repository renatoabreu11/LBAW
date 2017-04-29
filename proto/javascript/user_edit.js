$(document).ready(function() {
  $('.btn-discard').click(function() {
    window.location.href=window.location.href;
  });

  $('.city-item').click(function() {
    let cityIndex = $(this).next('input[name=city-item-id]').val();
    let cityName = $(this).text();
    let cityDropDown = $(this).parent().parent();
    cityDropDown.children('.dropdown-city-element')
      .html(cityName + '<span class="caret"></span>');
    // Updates the hidden input.
    $('input[name=city-id]').val(cityIndex);
  });
});
