$(document).ready(function() {
    $("#comments .page").infinitescroll({
        navSelector: "nav.pagination",
        nextSelector: "nav.pagination a[rel=next]",
        itemSelector: "#comments div.comment"
    }, function (arrayOfNewElems) {
        $('.timeline-body', arrayOfNewElems).responsiveEqualHeightGrid();
    });
});