var cityIndex;

$(document).ready(function() {
    $(".btn-discard").click(function() {
        window.location.href=window.location.href;
    });

    $(".city-item").click(function() {
        cityIndex = $(this).next("input[name=city-item-id]").val()
        var cityName = $(this).text();
        var cityDropdown = $(this).parent().parent();
        cityDropdown.children(".dropdown-city-element").html(cityName + '<span class="caret"></span>');
        $("input[name=city-id]").val(cityIndex);     // Updates the hidden input.    
    });
})