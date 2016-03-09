$(document).ready(function () {
    $("#timelines .page").infinitescroll({
        extraScrollPx: 250,
        navSelector: "nav.pagination",
        nextSelector: "nav.pagination a[rel=next]",
        itemSelector: "#timelines div.timeline"
    }, function (arrayOfNewElems) {
        $('.loading-image', arrayOfNewElems).imagesLoaded().progress( function( instance, image ) {
            if (image.isLoaded) {
                $(image.img).addClass("loaded");
            }
        });
        $('.timeline-name', arrayOfNewElems).responsiveEqualHeightGrid();
        $('.timeline-frame', arrayOfNewElems).responsiveEqualHeightGrid();
        $('.timeline-body', arrayOfNewElems).responsiveEqualHeightGrid();
        $('[data-toggle="tooltip"]', arrayOfNewElems).tooltip({container: 'body'});
        setupSuscribe(arrayOfNewElems);
    });
});
