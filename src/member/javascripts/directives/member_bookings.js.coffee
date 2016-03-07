angular.module('BBMember').directive 'memberBookings', ($rootScope) ->
  templateUrl: 'member_bookings_tabs.html'
  scope:
    member: '='
  link: (scope, element, attrs) ->
    # methods
