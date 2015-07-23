$(document).ready(function () {
    $("#timelines .page").infinitescroll({
        extraScrollPx: 250,
        navSelector: "nav.pagination",
        nextSelector: "nav.pagination a[rel=next]",
        itemSelector: "#timelines div.timeline"
    }, function (arrayOfNewElems) {
        $('.timeline-name', arrayOfNewElems).responsiveEqualHeightGrid();
        $('.timeline-body', arrayOfNewElems).responsiveEqualHeightGrid();
        $('[data-toggle="tooltip"]', arrayOfNewElems).tooltip({container: 'body'});
        $('.collapse', arrayOfNewElems).on('shown.bs.collapse', function () {
            $(".timeline-body", arrayOfNewElems).responsiveEqualHeightGrid();
        });
        $(function () {
            $('[data-validate]', arrayOfNewElems).click(function () {
                var self = $(this);
                self.hide();
                self.after('<svg version="1.1" class="loader-like" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="40px" height="40px" viewBox="0 0 50 50" style="enable-background:new 0 0 50 50;" xml:space="preserve"> <path fill="#000" d="M25.251,6.461c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615V6.461z"> <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 25 25" to="360 25 25" dur="0.6s" repeatCount="indefinite"/></path></svg>');
                $.ajax(self.data('validate'), {
                    url: self.data('validate'),
                    data: {id: self.val()},
                    method: 'POST',
                    statusCode: {
                        201: function (response){
                            $('.loader-like').remove();
                            self.show();
                            var like = $('.glyphicon', self);
                            self.addClass('btn-success');
                            self.removeClass('btn-default');
                            self.removeClass('green');
                            self.attr('data-original-title', "Moi et " + self.attr('data-original-title'));
                            like.text(' ' + (parseInt(like.text()) + 1));
                        },
                        204: function (response){
                            $('.loader-like').remove();
                            self.show();
                            var like = $('.glyphicon', self);
                            self.removeClass('btn-success');
                            self.addClass('btn-default');
                            self.addClass('green');
                            self.attr('data-original-title', self.attr('data-original-title').replace('Moi et ', ''));
                            like.text(' ' + (parseInt(like.text()) - 1));
                        },
                        401: function (response){
                            $('.loader-like').remove();
                            self.show();
                            $('#iptaken').modal('show');
                        }
                    }
                })
            });
        });
    });
});
