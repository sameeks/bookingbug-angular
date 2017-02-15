// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbEventGroups
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of event groups for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {integer} total_entries The event total entries
 * @property {array} events The events array
 * @property {hash} filters A hash of filters
 * @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
 *///


angular.module('BB.Directives').directive('bbEventGroups', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'EventGroupList',
            link(scope, element, attrs) {
                if (attrs.bbItem) {
                    scope.booking_item = scope.$eval(attrs.bbItem);
                }
                if (attrs.bbShowAll) {
                    scope.show_all = true;
                }
            }
        }
    }
);
