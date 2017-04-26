$(document).ready(function() {

    $.validator.addMethod("productCategoriesSelected", function(value, element, arg){
        return (value.length > 0 && value.length < 3);
    }, "At least one category must be selected.");

    $.validator.addMethod("numberOfImages", function(value, element, arg){
        var images = $("#input-24").val();
        return (images !== "");
    }, "At least one image must be selected.");

    var validator = $("#createAuctionForm").validate({
        rules:
            {
                name: {
                    required: true,
                    maxlength: 64
                },
                quantity: {
                    required: true,
                    digits: true
                },
                description: {
                    required: true,
                    maxlength: 512
                },
                condition:{
                    required: true,
                    maxlength: 512
                },
                category:{
                    productCategoriesSelected: true
                },
                "input24[]":{
                    numberOfImages: true
                }
            },
        messages:
            {
                name:{
                    required: "Please, enter the product name.",
                    maxlength: "The product name must be no more than 64 characters."
                },
                quantity:{
                    required: "Please, enter the number of products that are up to sell.",
                    digits: "Only digits are allowed."
                },
                condition:{
                    required: "Please, enter the product condition.",
                    maxlength: "The product condition must be no more than 255 characters."
                },
                description:{
                    required: "Please, enter the product description.",
                    maxlength: "The product condition must be no more than 255 characters."
                },
                category:{
                    productCategoriesSelected: "Please, select a category."
                }
            },
        errorPlacement: function(error, element) {
            if($(element).attr("name") === "description" || $(element).attr("name") === "condition")
                error.insertAfter(element);
            else{
                var parentDiv = $(element).parents(".input-group");
                error.insertAfter(parentDiv);
            }
        }
    });

    var navListItems = $('ul.setup-panel li a'), allWells = $('.setup-content');
    allWells.hide();

    navListItems.click(function (e) {
        e.preventDefault();
        var $target = $($(this).attr('href')),
            $item = $(this).closest('li');

        if (!$item.hasClass('disabled')) {
            navListItems.closest('li').removeClass('active');
            $item.addClass('active');
            allWells.hide();
            $target.show();
        }
    });

    $('ul.setup-panel li.active a').trigger('click');

    $('#activate-step-2').on('click', function (e) {
        validator.element("#step-1");
        $('ul.setup-panel li:eq(1)').removeClass('disabled');
        $('ul.setup-panel li a[href="#step-2"]').trigger('click');
        $(this).remove();
    })

    $('#activate-step-3').on('click', function (e) {
        $('ul.setup-panel li:eq(2)').removeClass('disabled');
        $('ul.setup-panel li a[href="#step-3"]').trigger('click');
        $(this).remove();
    })

    $('input[type=radio][name=optradio]').change(function() {
        var parent = $(this).parents(".input-group");
        $(parent).find("button.apiProduct").toggleClass("hidden");
    });

    var footerTemplate = '<div class="file-thumbnail-footer" style ="height:94px">\n' +
        '   <div style="margin:5px 0">\n' +
        '       <input class="kv-input kv-new form-control input-sm text-center {TAG_CSS_NEW}" value="{caption}" placeholder="Enter caption...">\n' +
        '       <input class="kv-input kv-init form-control input-sm text-center {TAG_CSS_INIT}" value="{TAG_VALUE}" placeholder="Enter caption...">\n' +
        '   </div>\n' +
        '   {size} {actions}\n' +
        '</div>';

    var main = "<div class=\'input-group {class}\'>\n" +
        "   <div class=\'input-group-btn\'>\n" +
        "       {browse}\n" +
        "       {remove}\n" +
        "   </div>\n" +
        "   {caption}\n" +
        "</div>" + "{preview}\n";

    var actions=  '<div class="file-actions">\n' +
    '    <div class="file-footer-buttons">\n' +
    '        {delete} {zoom}' +
    '    </div>\n' +
    '    {drag}\n' +
    '    <div class="file-upload-indicator" title="{indicatorTitle}">{indicator}</div>\n' +
    '    <div class="clearfix"></div>\n' +
    '</div>';


    $("#input-24").fileinput({
        uploadUrl: "/", // server upload action
        uploadAsync: true,
        overwriteInitial: false,
        maxFileSize: 10000,
        allowedFileExtensions: ["png", "jpg", "bmp", "jpeg"],
        previewClass: "bg-warning",
        layoutTemplates: {actions: actions, main1: main, footer: footerTemplate, size: '<samp><small>({sizeText})</small></samp>',},
        minFileCount: 1,
        maxFileCount: 10,
        previewThumbTags: {
            '{TAG_VALUE}': '',        // no value
            '{TAG_CSS_NEW}': '',      // new thumbnail input
            '{TAG_CSS_INIT}': 'hide'  // hide the initial input
        }
    });

});