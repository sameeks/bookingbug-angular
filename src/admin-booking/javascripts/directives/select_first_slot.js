angular
    .module('BB.Directives')
    .directive('selectFirstSlot', bbSelectFirstSlot);

function bbSelectFirstSlot() {
    let directive = {
        link
    }

    return directive;

    function link(scope, elem, attrs) {
        scope.$on('slotsUpdated', (e, basket_item, slots) => {
            let timeNow = moment();
            // -------------------------------------
            // Only show TimeSlots in the future!
            // -------------------------------------
            slots = _.filter(slots, slot => slot.datetime.isAfter(timeNow));
            // --------------------------------------
            // Select the first available TimeSlot
            // --------------------------------------
            if (slots[0]) {
                let firstSlot = slots[0];

                scope.bb.selected_slot = firstSlot;
                scope.bb.selected_date = scope.selected_date;
                let hours = moment(firstSlot.datetime).format("HH");
                let minutes = moment(firstSlot.datetime).format("mm");
                scope.bb.selected_date.hour(hours).minutes(minutes).seconds(0);
                scope.highlightSlot(firstSlot, scope.selected_day);
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
}

