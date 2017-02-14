// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// bbSlotGrouper
// group time slots together based on a given start time and end time
angular.module('BB.Directives').directive('bbSlotGrouper', () =>
    ({
        restrict: 'A',
        scope: true,
        link(scope, element, attrs) {
            let slots = scope.$eval(attrs.slots);
            if (!slots) {
                return;
            }
            scope.grouped_slots = [];
            for (let slot of Array.from(slots)) {
                if ((slot.time >= scope.$eval(attrs.startTime)) && (slot.time < scope.$eval(attrs.endTime))) {
                    scope.grouped_slots.push(slot);
                }
            }
            return scope.has_slots = scope.grouped_slots.length > 0;
        }
    })
);
