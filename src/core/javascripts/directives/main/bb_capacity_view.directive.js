// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbCapacityView
 * @restrict A
 * @description
 * Assigns an appropriate description of ticket availability based
 * on the value of the "Select spaces view" dropdown in the admin console
 * @param
 * {object} The event object
 * @attribute ticket-type-singular
 * {String} Custom name for the ticket
 * @example
 * <span bb-capacity-view='event' ticket-type-singular='seat'></span>
 * @example_result
 * <span bb-capacity-view='event' ticket-type-singular='seat' class='ng-binding'>5 of 10 seats available</span>
 *///
angular.module('BB.Directives').directive('bbCapacityView', () =>
    ({
        restrict: 'A',
        template: '{{capacity_view_description}}',
        link(scope, el, attrs) {
            let killWatch;
            let ticket_type = attrs.ticketTypeSingular || "ticket";
            return killWatch = scope.$watch(attrs.bbCapacityView, function (item) {
                if (item) {
                    killWatch();

                    let num_spaces_plural = item.num_spaces > 1 ? "s" : "";
                    let spaces_left_plural = item.spaces_left > 1 ? "s" : "";

                    switch (item.chain.capacity_view) {
                        case "NUM_SPACES":
                            return scope.capacity_view_description = scope.ticket_spaces = item.num_spaces + " " + ticket_type + num_spaces_plural;
                        case "NUM_SPACES_LEFT":
                            return scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " " + ticket_type + spaces_left_plural + " available";
                        case "NUM_SPACES_AND_SPACES_LEFT":
                            return scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " of " + item.num_spaces + " " + ticket_type + num_spaces_plural + " available";
                    }
                }
            });
        }
    })
);
