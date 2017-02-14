// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive("cardSecurityCode", function () {

    let linker = (scope, element, attributes) =>
            scope.$watch('cardType', function (newValue) {
                if (newValue === 'american_express') {
                    element.attr('maxlength', 4);
                    return element.attr('placeholder', "••••");
                } else {
                    element.attr('maxlength', 3);
                    return element.attr('placeholder', "•••");
                }
            })
        ;

    return {
        restrict: "AC",
        link: linker,
        scope: {
            'cardType': '='
        }
    };
});
