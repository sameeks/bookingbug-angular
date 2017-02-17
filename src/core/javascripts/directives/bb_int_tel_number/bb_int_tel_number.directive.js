// International Telephone Input directive
// http://www.tooorangey.co.uk/posts/that-international-telephone-input-umbraco-7-property-editor/
// https://github.com/Bluefieldscom/intl-tel-input
angular.module('BB.Directives').directive("bbIntTelNumber", $parse => {
        return {
            restrict: "A",
            require: "ngModel",

            link(scope, element, attrs, ctrl) {

                let options = scope.$eval(attrs.bbIntTelNumber);

                // apply plugin
                element.intlTelInput(options);


                let isValid = function (value) {
                    if (value) {
                        return element.intlTelInput("isValidNumber");
                    } else {
                        return true;
                    }
                };


                let format = function (value) {

                    let str = "";
                    if (scope.$eval(attrs.ngModel + '_prefix') != null) {
                        str += (`+${scope.$eval(attrs.ngModel + '_prefix')} `);
                    }
                    if (scope.$eval(attrs.ngModel) != null) {
                        str += scope.$eval(attrs.ngModel);
                    }
                    if (str[0] === "+") {
                        element.intlTelInput("setNumber", `+${scope.$eval(attrs.ngModel + '_prefix')} ${scope.$eval(attrs.ngModel)}`);
                        ctrl.$setValidity("phone", isValid(value));
                    }
                    return str;
                };


                let parse = function (value) {
                    let prefix = element.intlTelInput("getSelectedCountryData").dialCode;
                    let getter = $parse(attrs.ngModel + '_prefix');
                    getter.assign(scope, prefix);
                    ctrl.$setValidity("phone", isValid(value));
                    return value;
                };

                ctrl.$formatters.push(format);
                return ctrl.$parsers.push(parse);
            }
        };
    }
);

