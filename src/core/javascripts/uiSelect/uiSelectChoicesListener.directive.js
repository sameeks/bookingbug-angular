(function () {

    angular
        .module('BB.uiSelect')
        .directive('uiSelectChoicesListener', uiSelectChoicesListenerDirective);

    function uiSelectChoicesListenerDirective() {

        return function (scope, elm, attr) {
            scope.$on('UISelect:closeSelect', function () {
                return scope.$select.close();
            });
        };
    }

})();
