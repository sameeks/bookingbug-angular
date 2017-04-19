angular.module('BB.i18n').provider('bbi18nOptions', function (bbOptionsProvider) {
    'ngInject';

    let options = {
        default_language: 'en',
        use_browser_language: true,
        available_languages: ['en'],
        available_language_associations: {
            'en_*': 'en',
            'fr_*': 'fr'
        },
        timeZone: {
            default: 'Europe/London',
            useBrowser: true,
            useCompany: true,
            useMomentNames: false,
            overwriteBrowser: { browser: '', replaceWith: ''},
            filters: {
                limitTo: [],
                exclude: [],
                daylightSaving: [],
                standard: []
            }
        }
    };

    this.setOption = function (option, value) {
        options = bbOptionsProvider.setOption(options, option, value);
    };

    this.getOption = function (option) {
        return options[option];
    };

    this.$get = () => options;

});
