'use strict'

angular.module('BB.Services').config ($provide) ->

  $provide.decorator '$sniffer', ($delegate) ->

    regexp = /Safari\/([\d.]+)/
    result = regexp.exec(navigator.userAgent)
    webkit_version = if result then parseFloat(result[1]) else null

    _.extend($delegate, {webkit: webkit_version})

    $delegate

