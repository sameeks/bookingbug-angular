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
            useBrowser: false,
            useCompany: true,
            useMomentNames: true,
            filters: {
                limitTimeZonesBy: ['Canada'],
                excludeTimeZonesBy: [],
                daylightTimeZones: ['Canada/Newfoundland', 'Canada/Atlantic', 'Canada/Eastern', 'Canada/Central', 'Canada/Mountain', 'Canada/Pacific', 'Canada/Yukon'],
                standardTimeZones: ['Canada/Newfoundland', 'Canada/Atlantic', 'Canada/Eastern', 'Canada/Central', 'Canada/East-Saskatchewan', 'Canada/Saskatchewan', 'Canada/Mountain', 'Canada/Pacific']
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
