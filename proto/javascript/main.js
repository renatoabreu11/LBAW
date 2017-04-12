$(document).ready(function() {
    $(".sidebar-nav li a").click(function(){
        var dataTarget = $(this).data("target");
        console.log(dataTarget)
        $(dataTarget).addClass("in");
        $(dataTarget).siblings(".collapse").removeClass("in");

        if(dataTarget === "#rightSideUsers" || dataTarget === "#rightSideAuctions" || dataTarget === "#rightSideComments" || dataTarget === "#rightSideReviews"){
            $(".box-body").show();
        } else $(".box-body").hide();
    });

    $("#menu-toggle").click(function(e) {
        console.log(this);
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
    });
});