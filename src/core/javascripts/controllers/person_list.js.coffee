'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbPeople
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of peoples for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} items The items of the person list
* @property {array} bookable_people The bookable people from the person list
* @property {array} bookable_items The bookable items from the person list
* @property {array} booking_item The booking item from the person list
####


angular.module('BB.Directives').directive 'bbPeople', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'PersonList'
  link : (scope, element, attrs) ->
  
    if attrs.bbItems
      scope.booking_items = scope.$eval(attrs.bbItems) or []
      scope.booking_item  = scope.booking_items[0]
    else
      scope.booking_item = scope.$eval(attrs.bbItem) or scope.bb.current_item
      scope.booking_items = [scope.booking_item]


angular.module('BB.Controllers').controller 'PersonList',
($scope, $rootScope, PageControllerService, PersonService, ItemService, $q, BBModel, PersonModel, FormDataStoreService) ->

  $scope.controller = "public.controllers.PersonList"

  $scope.notLoaded $scope
  angular.extend(this, new PageControllerService($scope, $q))

  $rootScope.connection_started.then ->
    loadData()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  loadData = () ->

    bi = $scope.booking_item

    # do nothing if nothing has changed
    if !bi.service or bi.service is $scope.change_watch_item
      # if there's no service - we have to wait for one to be set - so we're kind of done loading for now!
      if !bi.service
        $scope.setLoaded $scope
      return

    $scope.change_watch_item = bi.service
    $scope.notLoaded $scope

    ppromise = PersonService.query($scope.bb.company)
    ppromise.then (people) ->
      if bi.group # check they're part of any currently selected group
        people = people.filter (x) -> !x.group_id or x.group_id is bi.group
      $scope.all_people = people

    ItemService.query(
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
            $scope.person = i.item
            $scope.selected_bookable_items = [i]

        # if there's only 1 person and combine resources/staff has been turned on, auto select the person
        if (items.length is 1 and $scope.bb.company.settings and $scope.bb.company.settings.merge_people)
          if !$scope.selectItem(items[0], $scope.nextRoute )
            setPerson people
            $scope.bookable_items = items
            $scope.selected_bookable_items = items
          else
            $scope.skipThisStep()
        else
          setPerson people
          $scope.bookable_items = items
          if !$scope.selected_bookable_items
            $scope.selected_bookable_items = items
        $scope.setLoaded $scope
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  ###**
  * @ngdoc method
  * @name setPerson
  * @methodOf BB.Directives:bbPeople
  * @description
  * Storing the person property in the form store
  *
  * @param {array} people The people 
  ###
  # we're storing the person property in the form store but the angular select
  # menu has to have a reference to the same object memory address for it to
  # appear as selected as it's ng-model property is a Person object.
  setPerson = (people) ->
    $scope.bookable_people = people
    if $scope.person
        _.each people, (person) ->
          if person.id is $scope.person.id
            $scope.person = person


  ###**
  * @ngdoc method
  * @name getItemFromPerson
  * @methodOf BB.Directives:bbPeople
  * @description
  * Get item from person
  *
  * @param {array} person The person
  ###
  getItemFromPerson = (person) =>
    if (person instanceof  PersonModel)
      if $scope.bookable_items
        for item in $scope.bookable_items
          if item.item.self is person.self
            return item
    return person


  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbPeople
  * @description
  * Select an item into the current person list in according of item and route parameters
  *
  * @param {array} item Selected item from the list of current people
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route) =>
    if $scope.$parent.$has_page_control
      $scope.person = item
      return false
    else
      new_person = getItemFromPerson(item)
      _.each $scope.booking_items, (bi) -> bi.setPerson(new_person)
      $scope.decideNextPage(route)
      return true


  ###**
  * @ngdoc method
  * @name selectAndRoute
  * @methodOf BB.Directives:bbPeople
  * @description
  * Select and route person from list in according of item and route parameters
  *
  * @param {array} item Selected item from the list of current people
  * @param {string} route A specific route to load
  ###
  $scope.selectAndRoute = (item, route) =>
    new_person = getItemFromPerson(item)
    _.each $scope.booking_items, (bi) -> bi.setPerson(new_person)
    $scope.decideNextPage(route)
    return true


  $scope.$watch 'person',(newval, oldval) =>
    if $scope.person and $scope.booking_item
      if !$scope.booking_item.person or $scope.booking_item.person.self != $scope.person.self
        # only set and broadcast if it's changed
        new_person = getItemFromPerson($scope.person)
        _.each $scope.booking_items, (item) -> item.setPerson(new_person)
        $scope.broadcastItemUpdate()
    else if newval != oldval
      _.each $scope.booking_items, (item) -> item.setPerson(null)
      $scope.broadcastItemUpdate()


  $scope.$on "currentItemUpdate", (event) ->
    loadData()


  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbPeople
  * @description
  * Called by bbPage to ready directive for transition to the next step
  ###
  $scope.setReady = () =>
    if $scope.person
      new_person = getItemFromPerson($scope.person)
      _.each $scope.booking_items, (item) -> item.setPerson(new_person)
      return true
    else
      _.each $scope.booking_items, (item) -> item.setPerson(null)
      return true

