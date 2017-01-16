'use strict'

# bbCountTicketTypes
# returns the number of tickets selected, grouped by name
angular.module('BB.Directives').directive 'bbCountTicketTypes', ($rootScope) ->
  restrict: 'A'
  scope: false
  link: (scope, element, attrs) ->


    $rootScope.connection_started.then () ->
      countTicketTypes()


    scope.$on "basket:updated", (event, basket) ->
      countTicketTypes()


    countTicketTypes = (items) ->

      items = scope.bb.basket.timeItems()

      counts = []
      for item in items
        if item.tickets
          if counts[item.tickets.name] then counts[item.tickets.name] += item.tickets.qty else counts[item.tickets.name] = item.tickets.qty
          item.number = counts[item.tickets.name]
      scope.counts = counts
