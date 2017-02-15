/***
 * @ngdoc directive
 * @name BB.Directives:bbDurations
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of durations for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {array} duration The duration list
 * @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
 *///


angular.module('BB.Directives').directive('bbDurations', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'DurationList'
        }
    }
);
