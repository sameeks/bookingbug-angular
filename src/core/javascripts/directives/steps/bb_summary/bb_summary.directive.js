// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbSummary
 * @restrict AE
 * @scope true
 *
 * @description
 * Loads a summary of the booking
 *
 *
 *///


angular.module('BB.Directives').directive('bbSummary', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'Summary'
        };
    }
);
