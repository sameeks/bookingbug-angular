// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbAccordionRangeGroup
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Use to group TimeSlot's by specified range for use with AngularUI Bootstrap accordion control
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @param {hash} bbAccordionRangeGroup  A hash of options
 * @property {boolean} collapse_when_time_selected Collapse when time is selected
 * @property {string} setRange Set time range for start and end
 * @property {string} start_time The start time
 * @property {string} end_time The end time
 * @property {array} accordion_slots The accordion slots
 * @property {boolean} is_open Time is open
 * @property {boolean} has_availability Group has have availability
 * @property {boolean} is_selected Group is selected
 * @property {string} source_slots Source of slots
 * @property {boolean} selected_slot Range group selected slot
 * @property {boolean} hideHeading Range group hide heading
 *///


angular.module('BB.Directives').directive('bbAccordionRangeGroup', PathSvc =>
    ({
        restrict: 'AE',
        replace: false,
        scope: {
            day: '=',
            slots: '=',
            selectSlot: '=',
            disabled_slot: "=disabledSlot"
        },
        controller: 'AccordionRangeGroup',
        link(scope, element, attrs) {
            return scope.options = scope.$eval(attrs.bbAccordionRangeGroup) || {};
        },
        templateUrl(element, attrs) {
            return PathSvc.directivePartial("_accordion_range_group");
        }
    })
);
