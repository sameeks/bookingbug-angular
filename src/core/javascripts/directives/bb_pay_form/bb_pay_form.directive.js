// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbPayForm
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of pay forms for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {array} total The total pay_form price
 * @property {array} card The card is used to payment
 *///


angular.module('BB.Directives').directive('bbPayForm', function ($window, $timeout,
                                                                 $sce, $http, $compile, $document, $location, GeneralOptions) {
    let applyCustomStylesheet;
    ({
        restrict: 'AE',
        replace: true,
        scope: true,
        controller: 'PayForm',
        link(scope, element, attributes) {
            return $window.addEventListener('message', event => {
                    let data;
                    if (angular.isObject(event.data)) {
                        ({data} = event);
                    } else if (angular.isString(event.data) && !event.data.match(/iFrameSizer/)) {
                        data = JSON.parse(event.data);
                    }
                    if (data) {
                        switch (data.type) {
                            case "load":
                                return scope.$apply(() => {
                                        scope.referrer = data.message;
                                        if (data.custom_partial_url) {
                                            applyCustomPartials(event.data.custom_partial_url, scope, element);
                                        }
                                        if (data.custom_stylesheet) {
                                            applyCustomStylesheet(data.custom_stylesheet);
                                        }
                                        if (data.scroll_offset) {
                                            return GeneralOptions.scroll_offset = data.scroll_offset;
                                        }
                                    }
                                );
                        }
                    }
                }
                , false);
        }
    });

    /***
     * @ngdoc method
     * @name applyCustomPartials
     * @methodOf BB.Directives:bbPayForm
     * @description
     * Apply the custom partials in according of custom partial url, scope and element parameters
     *
     * @param {string} custom_partial_url The custom partial url
     */
    var applyCustomPartials = function (custom_partial_url, scope, element) {
        if (custom_partial_url != null) {
            $document.domain = "bookingbug.com";
            return $http.get(custom_partial_url).then(custom_templates =>
                $compile(custom_templates.data)(scope, function (custom, scope) {
                    for (var e of Array.from(custom)) {
                        if (e.tagName === "STYLE") {
                            element.after(e.outerHTML);
                        }
                    }
                    let custom_form = ((() => {
                        let result = [];
                        for (e of Array.from(custom)) {
                            if (e.id === 'payment_form') {
                                result.push(e);
                            }
                        }
                        return result;
                    })());
                    if (custom_form && custom_form[0]) {
                        return $compile(custom_form[0].innerHTML)(scope, function (compiled_form, scope) {
                            let form = element.find('form')[0];
                            let {action} = form;
                            compiled_form.attr('action', action);
                            return $(form).replaceWith(compiled_form);
                        });
                    }
                })
            );
        }
    };

    /***
     * @ngdoc method
     * @name applyCustomStylesheet
     * @methodOf BB.Directives:bbPayForm
     * @description
     * Apply the custom stylesheet from href
     *
     * @param {string} href The href of the stylesheet
     */
    return applyCustomStylesheet = function (href) {
        let css_id = 'custom_css';
        if (!document.getElementById(css_id)) {
            let head = document.getElementsByTagName('head')[0];
            let link = document.createElement('link');
            link.id = css_id;
            link.rel = 'stylesheet';
            link.type = 'text/css';
            link.href = href;
            link.media = 'all';
            head.appendChild(link);

            // listen to load of css and trigger resize
            return link.onload = function () {
                if ('parentIFrame' in $window) {
                    return parentIFrame.size();
                }
            };
        }
    };
});
