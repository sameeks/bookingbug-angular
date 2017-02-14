// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminServices').directive('scheduleEdit', function () {

    let link = function (scope, element, attrs, ngModel) {

        ngModel.$render = () => scope.$$value$$ = ngModel.$viewValue;

        return scope.$watch('$$value$$', function (value) {
            if (value != null) {
                return ngModel.$setViewValue(value);
            }
        });
    };

    return {
        link,
        templateUrl: 'schedule_edit_main.html',
        require: 'ngModel',
        scope: {
            options: '='
        }
    };
});


angular.module('schemaForm').config(function (schemaFormProvider,
                                              schemaFormDecoratorsProvider, sfPathProvider) {

    schemaFormDecoratorsProvider.addMapping(
        'bootstrapDecorator',
        'schedule',
        'schedule_edit_form.html'
    );

    return schemaFormDecoratorsProvider.createDirective(
        'schedule',
        'schedule_edit_form.html'
    );
});

