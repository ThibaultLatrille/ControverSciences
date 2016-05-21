(function () {
    $.fn.extend({
        prettyTextDiff: function (options) {
            var dmp, settings;
            settings = {
                originalContainer: ".original",
                changedContainer: ".changed",
                diffContainer: ".diff",
                cleanup: true
            };
            settings = $.extend(settings, options);
            dmp = new diff_match_patch();
            return this.each(function () {
                var changed, diffs, original, patches;
                original = $(settings.originalContainer, this).text();
                patches = dmp.patch_fromText($(settings.changedContainer, this).text());
                changed = dmp.patch_apply(patches, original)[0];
                diffs = dmp.diff_main(original, changed);
                dmp.diff_cleanupSemantic(diffs);
                $.fn.prettyTextDiff.fillContainer(diffs, settings, this, dmp);
                return this;
            });
        }
    });
    $.fn.prettyTextDiff.fillContainer = function (diffs, settings, self) {
        var diff_as_html = $.map(diffs, function (diff) {
            return $.fn.prettyTextDiff.createHTML(diff);
        });
        $(settings.diffContainer, self).html(diff_as_html.join(''));
        return true
    };
    $.fn.prettyTextDiff.createHTML = function (diff) {
        var data, html, operation, pattern_amp, pattern_gt, pattern_lt, pattern_para, text;
        html = [];
        pattern_amp = /&/g;
        pattern_lt = /</g;
        pattern_gt = />/g;
        pattern_para = /\n/g;
        operation = diff[0], data = diff[1];
        if (data != '') {
            text = data.replace(pattern_amp, '&amp;').replace(pattern_lt, '&lt;').replace(pattern_gt, '&gt;').replace(pattern_para, '<br>');
            switch (operation) {
                case DIFF_INSERT:
                    return '<ins>' + text + '</ins>';
                case DIFF_DELETE:
                    return '<del>' + text + '</del>';
                case DIFF_EQUAL:
                    return '<span>' + text + '</span>';
            }
        }
    };

}).call(this);
$(".pretty").prettyTextDiff({
    cleanup: true,
    originalContainer: "#original",
    changedContainer: "#patches",
    diffContainer: "#diff"
});