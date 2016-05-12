// This is a manifest file that'll be compiled into home.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.bookblock.js

var nameHash = ["L’enthousiaste", "Le sphinx", "Le Seigneur des titres", "L'encyclopédique", "L’analyste", "Le juge", "L’écrivain", "L’évaluateur", "Le bienveillant"];
var Page = (function () {

    var config = {
            $nav: $('.img-icons'),
            $bookBlock: $('#bb-bookblock'),
            $pageRight: $('#bb-right-page'),
            $navNext: $('#bb-nav-next'),
            $pageLeft: $('#bb-left-page'),
            $navPrev: $('#bb-nav-prev')
        },
        init = function () {
            config.$bookBlock.bookblock({
                speed: 800,
                shadowSides: 0.8,
                shadowFlip: 0.7,
                onEndFlip: function (old, page, isLimit) {
                    config.$nav.removeClass('bb-current');
                    config.$nav.eq(page).addClass('bb-current');
                    $(".text", config.$navPrev).text(nameHash[page == 0 ? 8 : page - 1]);
                    $(".text", config.$navNext).text(nameHash[(page + 1) % 9]);
                    return false;
                }
            });

            initEvents();
        },
        initEvents = function () {

            var $slides = config.$bookBlock.children();

            // add navigation events

            config.$navPrev.on('click touchstart', function () {
                config.$bookBlock.bookblock('prev');
                return false;
            });

            config.$navPrev.on('mouseenter', function () {
                config.$bookBlock.bookblock('prevHover');
                return false;
            }).on('mouseleave', function () {
                config.$bookBlock.bookblock('hideHover');
                return false;
            });

            config.$pageLeft.on('click touchstart', function () {
                config.$bookBlock.bookblock('prev');
                return false;
            });

            config.$pageLeft.on('mouseenter', function () {
                config.$bookBlock.bookblock('prevHover');
                return false;
            }).on('mouseleave', function () {
                config.$bookBlock.bookblock('hideHover');
                return false;
            });

            config.$navNext.on('click touchstart', function () {
                config.$bookBlock.bookblock('next');
                return false;
            });

            config.$navNext.on('mouseenter', function () {
                config.$bookBlock.bookblock('nextHover');
                return false;
            }).on('mouseleave', function () {
                config.$bookBlock.bookblock('hideHover');
                return false;
            });

            config.$pageRight.on('click touchstart', function () {
                config.$bookBlock.bookblock('next');
                return false;
            });

            config.$pageRight.on('mouseenter', function () {
                config.$bookBlock.bookblock('nextHover');
                return false;
            }).on('mouseleave', function () {
                config.$bookBlock.bookblock('hideHover');
                return false;
            });

            // add navigation events
            config.$nav.each(function (i) {
                $(this).on('click touchstart', function (event) {
                    config.$bookBlock.bookblock('jump', i + 1);
                    return false;
                });
            });

            // add swipe events
            $slides.on({
                'swipeleft': function (event) {
                    config.$bookBlock.bookblock('next');
                    return false;
                },
                'swiperight': function (event) {
                    config.$bookBlock.bookblock('prev');
                    return false;
                }
            });

            // add keyboard events
            $(document).keydown(function (e) {
                var keyCode = e.keyCode || e.which,
                    arrow = {
                        left: 37,
                        up: 38,
                        right: 39,
                        down: 40
                    };

                switch (keyCode) {
                    case arrow.left:
                        config.$bookBlock.bookblock('prev');
                        break;
                    case arrow.right:
                        config.$bookBlock.bookblock('next');
                        break;
                }
            });
        };

    return {init: init};

})();
Page.init();
$('#bb-zoom-in').on('click touchstart', function () {
    $('#comics').toggleClass("col-md-offset-1 col-md-10 col-lg-offset-2 col-lg-8");
    $('.glyphicon', this).toggleClass("glyphicon-zoom-in");
    $('.glyphicon', this).toggleClass("glyphicon-zoom-out");
    $('#bb-bookblock').delay(100).bookblock('resize');
    return false;
});