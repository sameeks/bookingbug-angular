/**
 * @ngdoc directive
 * @name BB.Directives:bbPage
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of page for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 */
(function () {
    'use strict';

    angular.module('BB').directive('bbPage', function () {
        'ngInject';

        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'BBPageCtrl',
            controllerAs: '$bbPageCtrl'
        };
    });

})();
