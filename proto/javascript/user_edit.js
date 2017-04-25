var countryIndex;
var cityIndex;

$(document).ready(function() {

    var a = "<?php echo $user.id; ?>";
    console.warn(a);

    $(".btn-discard").click(function() {
        window.location.href=window.location.href;
    });

    $(".country-item").click(function() {
        countryIndex = $(this).index();
        var countryName = $(this).text();
        var countryDropdown = $(this).parent().parent();
        countryDropdown.children(".dropdown-country-element").html(countryName + '<span class="caret"></span>');
        $("input[name=country-id]").val(countryIndex);     // Updates the hidden input.
    });

    $(".city-item").click(function() {
        cityIndex = $(this).index();
        var cityName = $(this).text();
        var cityDropdown = $(this).parent().parent();
        cityDropdown.children(".dropdown-city-element").html(cityName + '<span class="caret"></span>');
        $("input[name=city-id]").val(cityIndex);     // Updates the hidden input.    
    });
})