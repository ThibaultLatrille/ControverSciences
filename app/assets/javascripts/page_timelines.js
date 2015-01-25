$(document).ready(function() {
    $("#timelines .page").infinitescroll({
        extraScrollPx: 250,
        navSelector: "nav.pagination",
        nextSelector: "nav.pagination a[rel=next]",
        itemSelector: "#timelines div.timeline"
    }, function(arrayOfNewElems) {
        $('.timeline-name', arrayOfNewElems).responsiveEqualHeightGrid();
        $('.timeline-body', arrayOfNewElems).responsiveEqualHeightGrid();
        $('[data-toggle="tooltip"]').tooltip({container: 'body'});
        $('.collapse').on('shown.bs.collapse', function () {
            $(".timeline-body", arrayOfNewElems).responsiveEqualHeightGrid();
        });
        $(function() {
            $('[data-validate]', arrayOfNewElems).click(function() {
                $this = $(this);
                $.get($this.data('validate'), {
                    id: $this.val()
                }).success(function() {
                    var $like = $('#like'+$this.val());
                    $like.text(' '+(parseInt($like.text())+1));
                }).error(function() {
                    $('#iptaken').modal('show');
                });
            });
        });
    });
});
