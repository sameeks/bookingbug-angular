/**
 * @ngdoc directive
 * @name BB.i18n:bbLanguagePicker
 * @scope
 * @restrict A
 *
 * @description
 * Responsible for providing a ui representation of available translations
 *
 */
angular.module('BB.i18n').directive('bbLanguagePicker', function () {
    'ngInject';

    let link = function (scope, element, attrs) {
        if (scope.vm.availableLanguages.length <= 1) {
            angular.element(element).addClass('hidden');
        }

    };

    return {
        controller: 'bbLanguagePickerController',
        controllerAs: 'vm',
        link,
        restrict: 'A',
        scope: true,
        templateUrl: 'i18n/language_picker.html'
    };
});

