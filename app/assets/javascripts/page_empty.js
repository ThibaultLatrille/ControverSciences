$(document).ready(function() {
    $("#empties .page").infinitescroll({
        navSelector: "nav.pagination",
        nextSelector: "nav.pagination a[rel=next]",
        itemSelector: "#empties div.empty"
    }, function (arrayOfNewElems) {
        $('[data-toggle="tooltip"]', arrayOfNewElems).tooltip({container: 'body'});
        $('.collapse', arrayOfNewElems).on('show.bs.collapse', function () {
            $(this).parent(".panel").find(".glyphicon-chevron-down").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up");

        });
        $('.collapse', arrayOfNewElems).on('hide.bs.collapse', function () {
            $(this).parent("div").parent("div").find(".glyphicon-chevron-up").removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-down");
        });
        $('.my-collapse', arrayOfNewElems).on('click', function () {
            $($(this).data('target'), arrayOfNewElems).collapse('toggle');
        });
    });
});