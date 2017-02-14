// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbContent', $compile =>
    ({
        transclude: false,
        restrict: 'A',
        link(scope, element, attrs) {
            element.attr('ng-include', "bb_main");
            element.attr('onLoad', "initPage()");
            element.attr('bb-content', null);
            element.attr('ng-hide', "hide_page");
            scope.initPage = () => {
                scope.setPageLoaded();
                return scope.setLoadingPage(false);
            };

            return $compile(element)(scope);
        }
    })
);
