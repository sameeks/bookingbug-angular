(function (angular, Immutable) {
    angular.module('BB.Services').provider('bbOptions', function () {
        'ngInject';

        function isObjectProperty(prop) {
            return typeof prop === 'object' && !Array.isArray(prop) && prop !== null;
        }

        function setOption(options, option, value) {
            if (!options.hasOwnProperty(option))throw new Error('no option named:' + option);

            if (value === undefined) return Object.assign({}, options);

            if (!isObjectProperty(options[option])) {
                if (typeof  options[option] !== typeof value || Array.isArray(options[option]) !== Array.isArray(value)) {
                    throw new Error(`option "${option}" required type is "${ Array.isArray(options[option]) ? 'array' : typeof options[option]}"`);
                }
                return Immutable.fromJS(options).mergeDeep({[option]: value}).toJS();
            }

            let guardedVal = Object.assign({}, options[option]);

            if (!isObjectProperty(value)) throw new Error(`option "${option}" must be an object`);

            for (let [key] of Object.entries(value)) guardedVal = setOption(guardedVal, key, value[key]);

            return Immutable.fromJS(options).mergeDeep({[option]: guardedVal}).toJS();
        }

        this.setOption = setOption;

        this.$get = () => {
            return {
                setOption
            };
        };

    });
})(angular, Immutable);
