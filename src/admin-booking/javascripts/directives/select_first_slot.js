angular.module('BB.Directives').directive('selectFirstSlot', () => {
        return {
            link(scope, el, attrs) {
                return scope.$on('slotsUpdated', function (e, basket_item, slots) {
                    // -------------------------------------
                    // Only show TimeSlots in the future!
                    // -------------------------------------
                    slots = _.filter(slots, slot => slot.datetime.isAfter(moment()));
                    // --------------------------------------
                    // Select the first available TimeSlot
                    // --------------------------------------
                    if (slots[0]) {
                        scope.bb.selected_slot = slots[0];
                        scope.bb.selected_date = scope.selected_date;
                        let hours = slots[0].datetime.hours();
                        let minutes = slots[0].datetime.minutes();
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
        };
    }
);
