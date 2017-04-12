angular.module('BB.i18n').provider('bbi18nOptions', function () {
    'ngInject';

    function isObjectProperty(prop) {
        return typeof prop === 'object' && !Array.isArray(prop) && prop !== null;
    }

    function setValue(options, option, value) {
        if (!options.hasOwnProperty(option))throw new Error('no option named:' + option);

        if (value === undefined) return Object.assign({}, options);

        if (!isObjectProperty(options[option])) {
            if (typeof  options[option] !== typeof value || Array.isArray(options[option]) !== Array.isArray(value)) {
                throw new Error(`option "${option}" required type is "${ Array.isArray(options[option]) ? 'array' : typeof options[option]}"`);
            }
            return Object.assign({}, options, {[option]: value});
        }

        let guardedVal = Object.assign({}, options[option]);

        if (!isObjectProperty(value)) throw new Error(`option "${option}" must be an object`);

        for (let [key] of Object.entries(value)) guardedVal = setValue(guardedVal, key, value[key]);

        return Object.assign({}, options, {[option]: guardedVal});
    }

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
        options = setValue(options, option, value);
    };

    this.getOption = function (option) {
        return options[option];
    };

    this.$get = () => options;

});
