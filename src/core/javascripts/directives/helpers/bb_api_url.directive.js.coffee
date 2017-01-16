'use strict'

angular.module('BB.Directives').directive 'bbApiUrl', ($rootScope, $compile, $sniffer, $timeout, $window, $location) ->
  restrict: 'A'
  scope:
    'apiUrl': '@bbApiUrl'
  compile: (tElem, tAttrs) ->
    pre: (scope, element, attrs) ->
      $rootScope.bb ||= {}
      $rootScope.bb.api_url = scope.apiUrl
      url = document.createElement('a')
      url.href = scope.apiUrl

      if ($sniffer.msie and $sniffer.msie <= 9) or ($sniffer.webkit and $sniffer.webkit < 537)
        unless url.host == '' || url.host == $location.host() || url.host == "#{$location.host()}:#{$location.port()}"
          if url.protocol[url.protocol.length - 1] == ':'
            src = "#{url.protocol}//#{url.host}/ClientProxy.html"
          else
            src = "#{url.protocol}://#{url.host}/ClientProxy.html"
          $rootScope.iframe_proxy_ready = false

          $compile("<iframe id='ieapiframefix' name='" + url.hostname + "' src='#{src}' style='visibility:false;display:none;'></iframe>") scope, (cloned, scope) =>
            cloned.bind "load", ->
              $rootScope.iframe_proxy_ready = true
              $rootScope.$broadcast('iframe_proxy_ready', {iframe_proxy_ready: true})
            element.append(cloned)
