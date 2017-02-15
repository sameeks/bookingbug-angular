angular.module('BB.i18n').provider('bbi18nOptions', function () {
    'ngInject';

    let options = {
        default_language: 'en',
        use_browser_language: true,
        available_languages: ['en', 'de', 'es', 'fr'],
        available_language_associations: {
            'en_*': 'en',
            'de_*': 'de',
            'es_*': 'de',
            'fr_*': 'fr'
        }
    };

    this.setOption = function (option, value) {
        if (options.hasOwnProperty(option)) {
            options[option] = value;
        }
    };

    this.getOption = function (option) {
        if (options.hasOwnProperty(option)) {
            return options[option];
        }
    };

    this.$get = () => options;

});
