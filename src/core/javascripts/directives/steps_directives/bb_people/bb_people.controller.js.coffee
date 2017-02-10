'use strict'

BBPeopleCtrl = ($scope, $rootScope, PageControllerService, $q, BBModel, PersonModel, FormDataStoreService, ValidatorService, LoadingService) ->
  'ngInject'

  @$scope = $scope

  angular.extend(this, new PageControllerService($scope, $q, ValidatorService, LoadingService))

  chosenService = null
  loader = null

  init = ->
    $scope.selectItem = selectItem
    $scope.selectAndRoute = selectAndRoute
    $scope.setReady = setReady

    loader = LoadingService.$loader($scope).notLoaded()

    $rootScope.connection_started.then connectionStartedSuccess, connectionStartedFailure
    $scope.$watch 'person', personListener
    $scope.$on "currentItemUpdate", currentItemUpdateHandler

    return

  connectionStartedSuccess = () ->
    loadData()

  connectionStartedFailure = (err) ->
    loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  currentItemUpdateHandler = (event) ->
    loadData()

  loadData = () ->
    bi = $scope.booking_item

    if not bi.service or bi.service is chosenService
      if not bi.service
        loader.setLoaded()
      return

    loader.notLoaded()

    chosenService = bi.service

    ppromise = BBModel.Person.$query($scope.bb.company)
    ppromise.then (people) ->
      if bi.group # check they're part of any currently selected group
        people = people.filter (x) -> !x.group_id or x.group_id is bi.group
      $scope.all_people = people

    BBModel.BookableItem.$query(
      company: $scope.bb.company
      cItem: bi
      wait: ppromise
      item: 'person'
    ).then (items) ->
      if bi.group # check they're part of any currently selected group
        items = items.filter (x) -> !x.group_id or x.group_id is bi.group

      promises = []
      for i in items
        promises.push(i.promise)

      $q.all(promises).then (res) =>
        people = []
        for i in items
          people.push(i.item)
          if bi and bi.person and bi.person.id is i.item.id
            $scope.person = i.item if $scope.bb.current_item.settings.person isnt -1
            $scope.selected_bookable_items = [i]

        # if there's only 1 person and combine resources/staff has been turned on, auto select the person
        # OR if the person has been passed into item_defaults, skip to next step
        if (items.length is 1 and $scope.bb.company.settings and $scope.bb.company.settings.merge_people)
          person = items[0]

        if $scope.bb.current_item.defaults.person
          person = $scope.bb.current_item.defaults.person

        if person and !$scope.selectItem(person, $scope.nextRoute, {skip_step: true})
          setPerson people
          $scope.bookable_items = items
          $scope.selected_bookable_items = items
        else
          setPerson people
          $scope.bookable_items = items
          if !$scope.selected_bookable_items
            $scope.selected_bookable_items = items
        loader.setLoaded()
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

      ppromise['finally'] ->
        loader.setLoaded()

  # we're storing the person property in the form store but the angular select
  # menu has to have a reference to the same object memory address for it to
  # appear as selected as it's ng-model property is a Person object.
  setPerson = (people) ->
    $scope.bookable_people = people
    if $scope.person
      _.each people, (person) ->
        if person.id is $scope.person.id
          $scope.person = person

  getItemFromPerson = (person) =>
    if (person instanceof PersonModel)
      if $scope.bookable_items
        for item in $scope.bookable_items
          if item.item.self is person.self
            return item
    return person

  ###*
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbPeople
  * @description
  * Select an item into the current person list in according of item and route parameters
  *
  * @param {array} item Selected item from the list of current people
  * @param {string=} route A specific route to load
  ###
  selectItem = (item, route, options = {}) =>
    if $scope.$parent.$has_page_control
      $scope.person = item
      return false
    else
      new_person = getItemFromPerson(item)
      _.each $scope.booking_items, (bi) -> bi.setPerson(new_person)
      if options.skip_step
        $scope.skipThisStep()
      $scope.decideNextPage(route)
      return true

  ###*
  * @ngdoc method
  * @name selectAndRoute
  * @methodOf BB.Directives:bbPeople
  * @description
  * Select and route person from list in according of item and route parameters
  *
  * @param {array} item Selected item from the list of current people
  * @param {string} route A specific route to load
  ###
  selectAndRoute = (item, route) =>
    new_person = getItemFromPerson(item)
    _.each $scope.booking_items, (bi) -> bi.setPerson(new_person)
    $scope.decideNextPage(route)
    return true

  personListener = (newval, oldval) =>
    if $scope.person and $scope.booking_item
      if !$scope.booking_item.person or $scope.booking_item.person.self != $scope.person.self # only set and broadcast if it's changed
        new_person = getItemFromPerson($scope.person)
        _.each $scope.booking_items, (item) -> item.setPerson(new_person)
        $scope.broadcastItemUpdate()
    else if newval != oldval
      _.each $scope.booking_items, (item) -> item.setPerson(null)
      $scope.broadcastItemUpdate()

    $scope.bb.current_item.defaults.person = $scope.person
    return

  ###*
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbPeople
  * @description
  * Called by bbPage to ready directive for transition to the next step
  ###
  setReady = () =>
    if $scope.person
      new_person = getItemFromPerson($scope.person)
      _.each $scope.booking_items, (item) -> item.setPerson(new_person)
      return true
    else
      _.each $scope.booking_items, (item) -> item.setPerson(null)
      return true

  init()

  return


angular.module('BB.Controllers').controller 'BBPeopleCtrl', BBPeopleCtrl
