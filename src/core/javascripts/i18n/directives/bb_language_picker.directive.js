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
angular
    .module('BB.i18n')
    .directive('bbLanguagePicker', function () {

        return {
            link: bbLanguagePickerLink,
            controller: bbLanguagePickerController,
            controllerAs: 'vm',
            restrict: 'A',
            scope: true,
            templateUrl: 'i18n/language_picker.html'
        };

    });

    function bbLanguagePickerLink(scope, element, attrs) {

        if (scope.vm.availableLanguages.length <= 1) {
            angular.element(element).addClass('hidden');
        }

    }

    function bbLanguagePickerController(bbLocale, $locale, $rootScope, tmhDynamicLocale, $translate, bbi18nOptions, $scope) {
        'ngInject';

        /*jshint validthis: true */
        let vm = this;

        vm.language = null;
        vm.availableLanguages = [];
        vm.enableSearch = false;

        let init = function () {
            setAvailableLanguages();
            setCurrentLanguage();
            $scope.$on('BBLanguagePicker:refresh', setCurrentLanguage);
            vm.pickLanguage = pickLanguage;
        };

        var setAvailableLanguages = function () {
            angular.forEach(bbi18nOptions.available_languages, languageKey => vm.availableLanguages.push(createLanguage(languageKey)));
            vm.enableSearch = vm.availableLanguages.length >= 10;
        };

        var setCurrentLanguage = function () {
            tmhDynamicLocale.set(bbLocale.getLocale()).then(function () {
                vm.language =
                    {selected: createLanguage(bbLocale.getLocale())};
            });

        };

        /*
         * @param {String]
         */
        var createLanguage = languageKey => {
            return {
                identifier: languageKey,
                label: `COMMON.LANGUAGE.${languageKey.toUpperCase()}`
            };
        };

        /*
         * @param {String]
         */
        var pickLanguage = function (languageKey) {
            tmhDynamicLocale.set(languageKey).then(function () {
                bbLocale.setLocale(languageKey, 'bbLanguagePicker.pickLanguage');
                $rootScope.$broadcast('BBLanguagePicker:languageChanged');
            });
        };

        init();
    }
