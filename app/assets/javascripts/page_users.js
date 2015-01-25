$(document).ready(function() {
    $("#users .page").infinitescroll({
        navSelector: "nav.pagination",
        nextSelector: "nav.pagination a[rel=next]",
        itemSelector: "#users tr.user"
    });
});