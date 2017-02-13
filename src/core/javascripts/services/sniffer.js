angular.module('BB.Services').config($provide =>

  $provide.decorator('$sniffer', function($delegate) {

    let regexp = /Safari\/([\d.]+)/;
    let result = regexp.exec(navigator.userAgent);
    let webkit_version = result ? parseFloat(result[1]) : null;

    _.extend($delegate, {webkit: webkit_version});

    return $delegate;
  })
);

