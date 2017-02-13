angular.module('BB.Directives').directive('bbApiUrl', ($rootScope, $compile, $sniffer, $timeout, $window, $location) =>
  ({
    restrict: 'A',
    scope: {
      'apiUrl': '@bbApiUrl'
    },
    compile(tElem, tAttrs) {
      return {
        pre(scope, element, attrs) {
          if (!$rootScope.bb) { $rootScope.bb = {}; }
          $rootScope.bb.api_url = scope.apiUrl;
          let url = document.createElement('a');
          url.href = scope.apiUrl;

          if (($sniffer.msie && ($sniffer.msie <= 9)) || ($sniffer.webkit && ($sniffer.webkit < 537))) {
            if ((url.host !== '') && (url.host !== $location.host()) && (url.host !== `${$location.host()}:${$location.port()}`)) {
              let src;
              if (url.protocol[url.protocol.length - 1] === ':') {
                src = `${url.protocol}//${url.host}/ClientProxy.html`;
              } else {
                src = `${url.protocol}://${url.host}/ClientProxy.html`;
              }
              $rootScope.iframe_proxy_ready = false;

              return $compile(`<iframe id='ieapiframefix' name='${url.hostname}${`' src='${src}' style='visibility:false;display:none;'></iframe>`}`)(scope, (cloned, scope) => {
                cloned.bind("load", function() {
                  $rootScope.iframe_proxy_ready = true;
                  return $rootScope.$broadcast('iframe_proxy_ready', {iframe_proxy_ready: true});
                });
                return element.append(cloned);
              }
              );
            }
          }
        }
      };
    }
  })
);
