// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// bbCountTicketTypes
// returns the number of tickets selected, grouped by name
angular.module('BB.Directives').directive('bbCountTicketTypes', $rootScope =>
    ({
        restrict: 'A',
        scope: false,
        link(scope, element, attrs) {


            let countTicketTypes;
            $rootScope.connection_started.then(() => countTicketTypes());


            scope.$on("basket:updated", (event, basket) => countTicketTypes());


            return countTicketTypes = function (items) {

                items = scope.bb.basket.timeItems();

                let counts = [];
                for (let item of Array.from(items)) {
                    if (item.tickets) {
                        if (counts[item.tickets.name]) {
                            counts[item.tickets.name] += item.tickets.qty;
                        } else {
                            counts[item.tickets.name] = item.tickets.qty;
                        }
                        item.number = counts[item.tickets.name];
                    }
                }
                return scope.counts = counts;
            };
        }
    })
);
