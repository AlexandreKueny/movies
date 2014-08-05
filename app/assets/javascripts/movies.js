jQuery(function () {
    var get_status;
    get_status = function (url) {
        return $.getJSON(url).done(function (reponse) {
            if (reponse.display) {
                $("#meter_val").attr('style', reponse.display).html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + reponse.value + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            }
            if (reponse.value === 100) {
                $("#bar").powerTimer('stop');
                return $("#spinner").hide();
            }
        });
    };
    return $("a#fs").on("ajax:beforeSend", function () {
        $("#spinner").show();
        return $("#bar").hide();
    }).on("ajax:complete", function () {
        $("#bar").show();
        return $("#bar").powerTimer({
            interval: 250,
            func: function () {
                return get_status($("a#fs_path").attr("href"));
            }
        });
    });
});
