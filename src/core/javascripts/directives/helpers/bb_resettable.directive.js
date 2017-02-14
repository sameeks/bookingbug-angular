// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// bbResettable
// Registers inputs with the bbFormResettable controller allowing them to be cleared
angular.module('BB.Directives').directive('bbResettable', () =>
    ({
        restrict: 'A',
        require: ['ngModel', '^bbFormResettable'],
        link(scope, element, attrs, ctrls) {
            let ngModelCtrl = ctrls[0];
            let formResettableCtrl = ctrls[1];
            return formResettableCtrl.registerInput(attrs.ngModel, ngModelCtrl);
        }
    })
);
