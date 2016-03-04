angular.module('BBAdminDashboard').controller 'bbAdminRootPageController', ($scope,
      BookingCollections, user, company, services, resources, people, addresses) ->

  $scope.company = company
  $scope.bb.company = company
  $scope.services = services
  $scope.resources = resources
  $scope.people = people
  $scope.addresses = addresses

  $scope.include_unallocated = true

  $scope.selectedAll = true

  $scope.togglePerson = (item) =>
    item.show = !item.show
    $scope.selectedAll = ($scope.shownPeople().length == $scope.people.length) && $scope.include_unallocated
    $scope.$broadcast("refetchEvents")

  $scope.show_all_people = ->
    p.show = true for p in $scope.people
    $scope.selectedAll = true
    $scope.$broadcast("refetchEvents")

  $scope.hide_all_people = ->
    p.show = false for p in $scope.people
    $scope.selectedAll = false
    $scope.$broadcast("refetchEvents")

  $scope.shownPeople = () ->
    $scope.people.filter (p) -> p.show == true

  $scope.notShownPeople = () ->
    $scope.people.filter (p) -> p.show == false

  $scope.toggleUnallocated = () ->
    $scope.include_unallocated = !$scope.include_unallocated
    $scope.$broadcast("refetchEvents")

  $scope.toggle_all_people = () ->
    if $scope.selectedAll
      $scope.hide_all_people()
    else
      $scope.show_all_people()

  $scope.set_current_clinic = (clinic) ->
    $scope.current_clinic = clinic

  $scope.set_current_client = (client) ->
    $scope.current_client = client

  $scope.$on 'newCheckout', (event, total) =>
    if total.$has('admin_bookings') && BookingCollections.count() > 0
      total.$get('admin_bookings').then (bookings) ->

    $scope.shownPeople = () ->
      $scope.people.filter (p) -> p.show == true

    $scope.notShownPeople = () ->
        for booking in bookings
          b = new BBModel.Admin.Booking(booking)
          BookingCollections.checkItems(b)
    if total.$has('admin_slots') && SlotCollections.count() > 0
      total.$get('admin_slots').then (slots) ->
        for slot in slots
          s = new BBModel.Admin.Slot(slot)
          SlotCollections.checkItems(s)

