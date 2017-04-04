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


angular.module('BB.Directives').directive('bbAccordionRangeGroup', PathSvc => {
    return {
        restrict: 'AE',
        replace: false,
        scope: {
            day: '=',
            slots: '=',
            selectSlot: '=',
            disabled_slot: "=disabledSlot"
        },
        controller: 'AccordionRangeGroup',
        link(scope, elem, attrs) {
            let nextElem, next = 0; //the next element and counter/position
            let numChildren = 0; //the number of slots available
            //capture enter and arrow keys to navigate slot
            elem.bind('keydown', (e) => {
                //on key enter
                if ((e.keyCode === 13) || (e.keyCode === 32)) {
                    scope.is_open = !scope.is_open; //toggle accordion
                    numChildren = elem.find('#time-slots li').length;
                }
                //if up and down arrows pressed and accordion group open, cycle focus through the options
                if (!!scope.is_open && numChildren > 0) {
                    if (e.keyCode === 40) {
                        next++;
                        next = (next > numChildren)?1:next;
                    }
                    if(e.keyCode === 38){
                        next--;
                        next = (next < 1)?numChildren:next;
                    }
                    nextElem = elem.find('#time-slots li:nth-child(' + next + ')');
                    nextElem.focus();
                }
                scope.$apply();
            });
            return scope.options = scope.$eval(attrs.bbAccordionRangeGroup) || {};
        },
        templateUrl(elem, attrs) {
            return PathSvc.directivePartial("_accordion_range_group");
        }
    };
}
);
