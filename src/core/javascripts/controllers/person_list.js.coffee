'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbPeople
* @restrict AE
* @scope true
*
* @description
* Loads a list of peoples for the currently in scope company.
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbPeople Hash options
* @param {object} bbItem Specific basket item to reference
* @param {boolean} waitForService Wait for the service to be loaded before loading People
* @param {boolean} hideDisabled In an admin widget, disabled resources shown by default, you can choose to hide disabled resources
* @property {array} booking_item Current basket item being referred to
* @property {array} all_people An array of all people
* @property {array} bookable_people Bookable people from the person list
* @property {array} bookable_items Bookable items from the person list
* @property {array} booking_item Booking items from the person list
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://dev01.bookingbug.com'>
*   <div  bb-widget='{company_id:37167}'>
*     <div bb-people>
*        <ul>
*          <li ng-repeat='person in all_people'> {{person.name}}</li>
*        </ul>
*     </div>
*     </div>
*     </div>
*   </file>
*  </example>
####

angular.module('BB.Directives').directive 'bbPeople', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'PersonList'
  link : (scope, element, attrs) ->
    if attrs.bbItem
      scope.booking_item = scope.$eval( attrs.bbItem )
    scope.options = scope.$eval(attrs.bbPeople) or {}
    scope.options.hide_disabled = attrs.hideDisabled if attrs.hideDisabled
    scope.options.wait_for_service = attrs.waitForService if attrs.waitForService
    scope.directives = "public.PersonList"

angular.module('BB.Controllers').controller 'PersonList',
($scope, $attrs, $rootScope, PageControllerService, $q, BBModel, PersonModel, FormDataStoreService, LoadingService) ->

  $scope.controller = "public.controllers.PersonList"

  loader = LoadingService.$loader($scope).notLoaded()
  angular.extend(this, new PageControllerService($scope, $q))

  $rootScope.connection_started.then ->
    loadData()
  , (err) ->  loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  $scope.options = $scope.$eval($attrs.bbServices) or {}


  loadData = () ->
    $scope.booking_item ||= $scope.bb.current_item
    bi = $scope.booking_item

    # do nothing if nothing has changed
    if $scope.options.wait_for_service
      if !bi.service || bi.service == $scope.change_watch_item
        # if there's no service - we have to wait for one to be set - so we're kind of done loadig for now!
        if !bi.service
          loader.setLoaded()
        return

    $scope.change_watch_item = bi.service
    loader.notLoaded()

    ppromise = BBModel.Person.$query($scope.bb.company)
    ppromise.then (people) ->
      if bi.group # check they're part of any currently selected group
        people = people.filter (x) -> !x.group_id || x.group_id == bi.group
      if $scope.options.hide_disabled
        # this might happen to have been an admin api call which would include disabled people - and we migth to hide them
        people = people.filter (x) -> !x.disabled && !x.deleted
      $scope.all_people = people

    if $scope.booking_item && $scope.booking_item.canLoadItem("person")
      BBModel.BookableItem.$query(
        company: $scope.bb.company
        cItem: bi
        wait: ppromise
        item: 'person'
      ).then (items) ->
        if bi.group # check they're part of any currently selected group
          items = items.filter (x) -> !x.group_id || x.group_id == bi.group

        promises = []

        for i in items
          promises.push(i.promise)

        $q.all(promises).then (res) =>
          people = []
          if $scope.options.hide_disabled
            # this might happen to have been an admin api call which would include disabled people - and we migth to hide them
            items = items.filter (x) -> !x.item? || (!x.item.disabled && !x.item.deleted)
          for i in items
            people.push(i.item)
            if bi && bi.person && bi.person.self == i.item.self
              $scope.person = i.item
              $scope.selected_bookable_items = [i]
            if bi && bi.selected_person && bi.selected_person.item.self == i.item.self
              bi.selected_person = i

          # if there's only 1 person and combine resources/staff has been turned on, auto select the person
          if (items.length == 1 && $scope.bb.company.settings && $scope.bb.company.settings.merge_people)
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
          loader.setLoaded()
      , (err) ->  loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    else
      ppromise['finally'] ->
        loader.setLoaded()

  ###**
  * @ngdoc method
  * @name setPerson
  * @methodOf BB.Directives:bbPeople
  * @description
  * Store the person property in the form store.
  *
  * @param {array} people People
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
  * Get item from person.
  *
  * @param {array} person Person
  ###
  getItemFromPerson = (person) =>
    if (person instanceof  PersonModel)
      if $scope.bookable_items
        for item in $scope.bookable_items
          if item.item.self == person.self
            return item
    return person

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbPeople
  * @description
  * Select an item into the current person list according to item and route parameters.
  *
  * @param {array} item Selected item from the list of current people
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route) =>
    if $scope.$parent.$has_page_control
      $scope.person = item
      return false
    else
      $scope.booking_item.setPerson(getItemFromPerson(item))
      $scope.decideNextPage(route)
      return true

  ###**
  * @ngdoc method
  * @name selectAndRoute
  * @methodOf BB.Directives:bbPeople
  * @description
  * Select and route person from list according to item and route parameters.
  *
  * @param {array} item Selected item from the list of current people
  * @param {string=} route A specific route to load
  ###
  $scope.selectAndRoute = (item, route) =>
   $scope.booking_item.setPerson(getItemFromPerson(item))
   $scope.decideNextPage(route)
   return true


  $scope.$watch 'person',(newval, oldval) =>
    if $scope.person and $scope.booking_item
      if !$scope.booking_item.person || $scope.booking_item.person.self != $scope.person.self
        # only set and broadcast if it's changed
        $scope.booking_item.setPerson(getItemFromPerson($scope.person))
        $scope.broadcastItemUpdate()
    else if newval != oldval
      $scope.booking_item.setPerson(null)
      $scope.broadcastItemUpdate()

  $scope.$on "currentItemUpdate", (event) ->
    loadData()

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbPeople
  * @description
  * Sets page section as ready.
  ###
  $scope.setReady = () =>
    if $scope.person
      $scope.booking_item.setPerson(getItemFromPerson($scope.person))
      return true
    else
      $scope.booking_item.setPerson(null)
      return true
