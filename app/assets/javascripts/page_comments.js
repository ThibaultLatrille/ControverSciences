$(document).ready(function() {
    $("#comments .page").infinitescroll({
        navSelector: "nav.pagination",
        nextSelector: "nav.pagination a[rel=next]",
        itemSelector: "#comments div.comment"
    }, function (arrayOfNewElems) {
        $('.image-user', arrayOfNewElems).imagesLoaded().progress( function( instance, image ) {
            if (image.isLoaded) {
                $(image.img).addClass("loaded");
            }
        });
        $('.timeline-body', arrayOfNewElems).responsiveEqualHeightGrid();
    });
});