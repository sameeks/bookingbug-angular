angular.module('BB.i18n').provider('bbi18nOptions', function (bbOptionsProvider) {
    'ngInject';

    let options = {
        default_language: 'en',
        use_browser_language: true,
        available_languages: ['en'],
        available_language_associations: {
            'en_*': 'en'
        },
        default_time_zone: 'Europe/London',
        use_browser_time_zone: false,
        use_company_time_zone: true,

        timeZone: {
            options: {
                useMomentNames: false,
                limitTimeZonesBy: null,
                excludeTimeZonesBy: null,
                daylightTimeZones: null,
                standardTimeZones: null
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
