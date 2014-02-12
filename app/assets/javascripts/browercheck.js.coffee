$ ->
        userAgent = window.navigator.userAgent.toLowerCase()
        appVersion = window.navigator.appVersion.toLowerCase()

        if appVersion.indexOf("msie 6.") != -1
                $(".ie-alert").append("<div class=\"alert alert-danger\">Kooleye.comはInternet Explorer 6に対応しておりません。本サイトを閲覧するためにはGoogle Chrome,Mozilla Firefox等のブラウザをご利用ください</div>")
        else if appVersion.indexOf("msie 7.") != -1
                $(".ie-alert").append("<div class=\"alert alert-danger\">Kooleye.comはInternet Explorer 7に対応しておりません。本サイトを閲覧するためにはGoogle Chrome,Mozilla Firefox等のブラウザをご利用ください</div>")
