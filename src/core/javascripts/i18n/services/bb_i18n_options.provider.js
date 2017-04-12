angular.module('BB.i18n').provider('bbi18nOptions', function () {
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

        use_moment_names: false,
        limit_time_zones: null,
        exclude_time_zones: null,
        daylight_time_zones: null,
        standard_time_zones: null

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
