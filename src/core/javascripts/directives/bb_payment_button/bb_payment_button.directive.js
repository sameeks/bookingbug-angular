// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbPaymentButton', ($compile, $sce, $http, $templateCache, $q, $log, TemplateSvc, $translate) =>
    ({
        restrict: 'EA',
        replace: true,
        scope: {
            total: '=',
            bb: '=',
            decideNextPage: '=',
            notLoaded: '=',
            setLoaded: '='
        },
        link(scope, element, attributes) {

            let getTemplate = function (type, scope) {
                switch (type) {
                    case 'button_form':
                        return getButtonFormTemplate(scope);
                    case 'page':
                        return TemplateSvc.get("payment.html");
                    case 'location':
                        return "<a href='{{payment_link}}'>{{label}}</a>";
                    default:
                        return "";
                }
            };

            var getButtonFormTemplate = function (scope) {
                let src = $sce.parseAsResourceUrl(`'${scope.payment_link}'`)();
                return $http.get(src, {}).then(response => response.data);
            };

            let setClassAndValue = function (scope, element, attributes) {
                let main_tag;
                switch (scope.link_type) {
                    case 'button_form':
                        let inputs = element.find("input");
                        main_tag = (Array.from(inputs).filter((i) => $(i).attr('type') === 'submit').map((i) => i))[0];
                        if (attributes.value) {
                            $(main_tag).attr('value', $translate.instant(attributes.value));
                        }
                        break;
                    case 'page':
                    case 'location':
                        main_tag = element.find("a")[0];
                        break;
                }
                if (attributes.class) {
                    return Array.from(attributes.class.split(" ")).map((c) =>
                        ($(main_tag).addClass(c),
                            $(element).removeClass(c)));
                }
            };

            var killWatch = scope.$watch('total', function (total) {
                if (total && total.$has('new_payment')) {
                    killWatch();
                    scope.bb.payment_status = "pending";
                    scope.bb.total = scope.total;
                    scope.link_type = scope.total.$link('new_payment').type;
                    scope.label = attributes.value || "Make Payment";
                    scope.payment_link = scope.total.$href('new_payment');
                    let url = scope.total.$href('new_payment');
                    return $q.when(getTemplate(scope.link_type, scope)).then(function (template) {
                            element.html(template).show();
                            $compile(element.contents())(scope);
                            return setClassAndValue(scope, element, attributes);
                        }
                        , function (err) {
                            $log.warn(err.data);
                            return element.remove();
                        });
                } else {
                    element.hide();
                    return console.warn("new_payment link missing: payment configuration maybe incorrect");
                }
            });


        }
    })
);


angular.module('BB.Directives').directive('bbPaypalExpressButton', ($compile, $sce, $http, $templateCache, $q, $log, $window, UriTemplate) =>

    ({
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
    })
);
