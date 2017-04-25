// International Telephone Input directive
// http://www.tooorangey.co.uk/posts/that-international-telephone-input-umbraco-7-property-editor/
// https://github.com/Bluefieldscom/intl-tel-input
angular.module('BB.Directives').directive("bbIntTelNumber", ($bbug, $parse, $rootScope) => {
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


                if (attrs.prefix) {
                  $bbug(element).on("countrychange", function (e, countryData) {
                    scope.$eval(`${attrs.prefix} = "${countryData.dialCode}"`);
                    format(ctrl.$viewValue);
                    ctrl.$render();
                  });
                }

                ctrl.$render = function () {
                  ctrl.$setViewValue(ctrl.$modelValue);
                };

                let format = function (value) {
                    let str = "";
                    if (attrs.prefix) {
                        if (scope.$eval(attrs.prefix) != null) {
                            str += (`+${scope.$eval(attrs.prefix)} `);
                        }
                    } else {
                        if (scope.$eval(attrs.ngModel + '_prefix') != null) {
                            str += (`+${scope.$eval(attrs.ngModel + '_prefix')} `);
                        }
                    }
                    if (scope.$eval(attrs.ngModel) != null) {
                        str += scope.$eval(attrs.ngModel);
                    }
                    if (str[0] === "+") {
                        if (attrs.prefix) {
                            if (scope.$eval(attrs.ngModel) != null) {
                                element.intlTelInput("setNumber", `+${scope.$eval(attrs.prefix)} ${scope.$eval(attrs.ngModel)}`);
                            }
                        } else {
                            element.intlTelInput("setNumber", `+${scope.$eval(attrs.ngModel + '_prefix')} ${scope.$eval(attrs.ngModel)}`);
                        }
                        ctrl.$setValidity(attrs.ngModel, isValid(value));
                    }
                    return str;
                };


                let parse = function (value) {
                    let prefix = element.intlTelInput("getSelectedCountryData").dialCode;
                    let getter;
                    if (attrs.prefix) {
                        getter = $parse(attrs.prefix);
                    } else {
                        getter = $parse(attrs.ngModel + '_prefix');
                    }
                    getter.assign(scope, prefix);
                    ctrl.$setValidity(attrs.ngModel, isValid(value));
                    return value;
                };

                ctrl.$formatters.push(format);
                ctrl.$parsers.push(parse);
            }
        };
    }
);

