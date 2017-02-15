// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbPaypalExpressButton', ($compile, $sce, $http, $templateCache, $q, $log, $window, UriTemplate) => {

        return {
            restrict: 'EA',
            replace: true,
            template: `\
<a ng-href="{{href}}" ng-click="showLoader()">Pay</a>\
`,
            scope: {
                total: '=',
                bb: '=',
                decideNextPage: '=',
                paypalOptions: '=bbPaypalExpressButton',
                notLoaded: '='
            },
            link(scope, element, attributes) {

                let {total} = scope;
                let {paypalOptions} = scope;
                scope.href = new UriTemplate(total.$link('paypal_express').href).fillFromObject(paypalOptions);

                return scope.showLoader = function () {
                    if (scope.notLoaded) {
                        return scope.notLoaded(scope);
                    }
                };
            }
        };
    }
);
