(function (angular) {
    angular.module('BB.Services').provider('bbOptions', function () {
        'ngInject';

        function isObjectProperty(prop) {
            return typeof prop === 'object' && !Array.isArray(prop) && prop !== null;
        }

        function setOption(options, option, value) {
            guardNonExistingProperty(options, option);

            if (value === undefined) return Object.assign({}, options);

            if (!isObjectProperty(options[option])) {
                guardNonObjectProps(options, option, value);

                return angular.merge({}, options, {[option]: value});
            }

            guardNonObjectValue(options, value);

            let guardedVal = Object.assign({}, options[option]);
            for (let [key] of Object.entries(value)) guardedVal = setOption(guardedVal, key, value[key]);
            return angular.merge({}, options, {[option]: guardedVal});
        }

        function guardNonExistingProperty(options, option) {
            if (!options.hasOwnProperty(option))throw new Error('no option named:' + option);
        }

        function guardNonObjectProps(options, option, value) {
            if (typeof  options[option] !== typeof value || Array.isArray(options[option]) !== Array.isArray(value)) {
                throw new Error(`option "${option}" required type is "${ Array.isArray(options[option]) ? 'array' : typeof options[option]}"`);
            }
        }

        function guardNonObjectValue(option, value) {
            if (!isObjectProperty(value)) throw new Error(`option "${option}" must be an object`);
        }

        this.setOption = setOption;

        this.$get = () => {
            return {
                setOption
            };
        };

    });
})(angular);
