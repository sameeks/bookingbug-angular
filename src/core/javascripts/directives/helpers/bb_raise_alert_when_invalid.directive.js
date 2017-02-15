// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// Form directive to allow users to specify if they want the form to raise alerts when
// there is invalid input.
angular.module('BB.Directives').directive('bbRaiseAlertWhenInvalid', $compile => {
        return {
            require: '^form',
            link(scope, element, attr, ctrl) {
                ctrl.raise_alerts = true;

                let options = scope.$eval(attr.bbRaiseAlertWhenInvalid);
                if (options && options.alert) {
                    return ctrl.alert = options.alert;
                }
            }
        };
    }
);
