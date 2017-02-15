/***
 * @ngdoc directive
 * @name BB.Directives:bbMonthCalendar
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of month availability for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {string} message The message text
 * @property {string} setLoaded  Set the day list loaded
 * @property {object} setLoadedAndShowError Set loaded and show error
 * @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
 */


angular.module('BB.Directives').directive('bbMonthCalendar', () => {
        return {
            restrict: 'A',
            replace: true,
            scope: true,
            controller: 'MonthCalendar'
        };
    }
);
