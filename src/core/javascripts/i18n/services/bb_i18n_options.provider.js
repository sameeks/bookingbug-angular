angular.module('BB.i18n').provider('bbi18nOptions', function (bbOptionsProvider) {
    'ngInject';

    let options = {
        default_language: 'en',
        use_browser_language: true,
        available_languages: ['en'],
        available_language_associations: {
            'en_*': 'en'
        },
        timeZone: {
            default: 'Europe/London',
            options: {
                useMomentNames: false,
                limitTimeZonesBy: null,
                excludeTimeZonesBy: null,
                daylightTimeZones: null,
                standardTimeZones: null
            },
            useBrowser: false,
            useCompany: true
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
