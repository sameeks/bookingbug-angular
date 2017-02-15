angular.module('BB.Directives').directive('bbCurrencyField', $filter => {
        return {
            restrict: 'A',
            require: 'ngModel',
            link(scope, element, attrs, ctrl) {

                let convertToCurrency = value => value / 100;

                let convertToInteger = value => value * 100;

                ctrl.$formatters.push(convertToCurrency);
                return ctrl.$parsers.push(convertToInteger);
            }
        };
    }
);
