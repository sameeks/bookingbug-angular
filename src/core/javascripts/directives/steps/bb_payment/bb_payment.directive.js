// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbPayment
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Renders payment iframe (where integrated payment has been configured) and handles payment success/failure.
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {array} total The total of payment
 *///


angular.module('BB.Directives').directive('bbPayment', ($window, $location,
                                                        $sce, GeneralOptions, AlertService) =>

    ({
        restrict: 'AE',
        replace: true,
        scope: true,
        controller: 'Payment',
        link(scope, element, attributes) {

            let error = (scope, message) => scope.error(message);

            let getHost = function (url) {
                let a = document.createElement('a');
                a.href = url;
                return a['protocol'] + '//' + a['host'];
            };

            let sendLoadEvent = function (element, origin, scope) {
                let custom_stylesheet;
                let referrer = $location.protocol() + "://" + $location.host();
                if ($location.port()) {
                    referrer += `:${$location.port()}`;
                }

                if (scope.payment_options.custom_stylesheet) {
                    if (scope.payment_options.custom_stylesheet.match(/http/)) {
                        // custom stylesheet as an absolute url, for ex. "http://bespoke.bookingbug.com/staging/custom-booking-widget.css"
                        ({custom_stylesheet} = scope.payment_options);
                    } else {
                        // custom stylesheet as a file, for ex. "custom-booking-widget.css"
                        custom_stylesheet = $location.absUrl().match(/.+(?=#)/) + scope.payment_options.custom_stylesheet;
                    }
                }

                let payload = JSON.stringify({
                    'type': 'load',
                    'message': referrer,
                    'custom_partial_url': scope.bb.custom_partial_url,
                    'custom_stylesheet': custom_stylesheet,
                    'scroll_offset': GeneralOptions.scroll_offset
                });

                return element.find('iframe')[0].contentWindow.postMessage(payload, origin);
            };

            scope.payment_options = scope.$eval(attributes.bbPayment) || {};
            scope.route_to_next_page = (scope.payment_options.route_to_next_page != null) ? scope.payment_options.route_to_next_page : true;

            element.find('iframe').bind('load', event => {
                    let url;
                    if (scope.bb && scope.bb.total && scope.bb.total.$href('new_payment')) {
                        url = scope.bb.total.$href('new_payment');
                    }
                    let origin = getHost(url);
                    sendLoadEvent(element, origin, scope);
                    return scope.$apply(() => scope.callSetLoaded());
                }
            );

            return $window.addEventListener('message', event => {
                    let data;
                    if (angular.isObject(event.data)) {
                        ({data} = event);
                    } else if (!event.data.match(/iFrameSizer/)) {
                        data = JSON.parse(event.data);
                    }
                    return scope.$apply(() => {
                            if (data) {
                                switch (data.type) {
                                    case "submitting":
                                        return scope.callNotLoaded();
                                    case "error":
                                        scope.$emit("payment:failed");
                                        scope.callNotLoaded();
                                        AlertService.raise('PAYMENT_FAILED');
                                        // reload the payment iframe
                                        return document.getElementsByTagName("iframe")[0].src += '';
                                    case "payment_complete":
                                        scope.callSetLoaded();
                                        return scope.paymentDone();
                                }
                            }
                        }
                    );
                }

                , false);
        }
    })
);
