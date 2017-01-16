'use strict'

###**
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
####
angular.module('BB.Directives').directive 'bbCapacityView', () ->
  restrict: 'A'
  template: '{{capacity_view_description}}'
  link: (scope, el, attrs) ->
    ticket_type = attrs.ticketTypeSingular || "ticket"
    killWatch = scope.$watch attrs.bbCapacityView, (item) ->
      if item
        killWatch()

        num_spaces_plural = if item.num_spaces > 1 then "s" else ""
        spaces_left_plural = if item.spaces_left > 1 then "s" else ""

        switch item.chain.capacity_view
          when "NUM_SPACES" then scope.capacity_view_description = scope.ticket_spaces = item.num_spaces + " " + ticket_type + num_spaces_plural
          when "NUM_SPACES_LEFT" then scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " " + ticket_type + spaces_left_plural + " available"
          when "NUM_SPACES_AND_SPACES_LEFT" then scope.capacity_view_description = scope.ticket_spaces = item.spaces_left + " of " + item.num_spaces + " " + ticket_type + num_spaces_plural + " available"
