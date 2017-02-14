// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbPaypal', PathSvc =>
    ({
        restrict: 'A',
        replace: true,
        scope: {
            ppDetails: "=bbPaypal"
        },
        templateUrl: PathSvc.directivePartial("paypal_button"),
        link(scope, element, attrs) {
            scope.inputs = [];

            if (!scope.ppDetails) {
                return;
            }

            let keys = _.keys(scope.ppDetails);
            //  convert the paypal data to an array of input objects
            return _.each(keys, function (keyName) {
                let obj = {
                    name: keyName,
                    value: scope.ppDetails[keyName]
                };
                return scope.inputs.push(obj);
            });
        }
    })
);

