// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('selectFirstSlot', () =>
    ({
        link(scope, el, attrs) {
            return scope.$on('slotsUpdated', function (e, basket_item, slots) {
                // -------------------------------------
                // Only show TimeSlots in the future!
                // -------------------------------------
                slots = _.filter(slots, slot => slot.time_moment.isAfter(moment()));
                // --------------------------------------
                // Select the first available TimeSlot
                // --------------------------------------
                if (slots[0]) {
                    scope.bb.selected_slot = slots[0];
                    scope.bb.selected_date = scope.selected_date;
                    let hours = slots[0].time_24.split(":")[0];
                    let minutes = slots[0].time_24.split(":")[1];
                    scope.bb.selected_date.hour(hours).minutes(minutes).seconds(0);
                    scope.highlightSlot(slots[0], scope.selected_day);
                }
                return (() => {
                    let result = [];
                    for (let slot of Array.from(slots)) {
                        if (!slot.selected) {
                            result.push(slot.hidden = true);
                        }
                    }
                    return result;
                })();
            });
        }
    })
);
