'use strict'

angular.module('BB.Controllers').controller 'DayListMa', (
  $scope, $rootScope, $q, AlertService, LoadingService, BBModel) ->

  $scope.controller = "public.controllers.DayList"
  loader = LoadingService.$loader($scope).notLoaded()


  $scope.WeekHeaders = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
  $scope.day_data = {}
  if !$scope.type
    $scope.type = "month"
  if !$scope.data_source
    $scope.data_source = $scope.bb.current_item

  # Load up some day based data
  $rootScope.connection_started.then =>
    if !$scope.current_date && $scope.last_selected_date
      $scope.current_date = $scope.last_selected_date.startOf($scope.type)
    else if !$scope.current_date
      $scope.current_date = moment().startOf($scope.type)
    $scope.loadData()
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  $scope.$on "currentItemUpdate", (event) ->
    $scope.loadData()

  ###**
  * @ngdoc method
  * @name setCalType
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Set cal type in acording of type
  *
  * @param {array} type The type of day list
  ###
  $scope.setCalType = (type) =>
    $scope.type = type

  ###**
  * @ngdoc method
  * @name setDataSource
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Set data source in according of source
  *
  * @param {string} source The source of day list
  ###
  $scope.setDataSource = (source) =>
    $scope.data_source = source

  ###**
  * @ngdoc method
  * @name format_date
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Format date and get current date
  *
  * @param {date} fmt The format date
  ###
  $scope.format_date = (fmt) =>
    if $scope.current_date
      $scope.current_date.format(fmt)

  ###**
  * @ngdoc method
  * @name format_start_date
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Format start date in according of fmt parameter
  *
  * @param {date} fmt The format date
  ###
  $scope.format_start_date = (fmt) =>
    $scope.format_date(fmt)

  ###**
  * @ngdoc method
  * @name format_end_date
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Format end date in according of fmt parameter
  *
  * @param {date} fmt The format date
  ###
  $scope.format_end_date = (fmt) =>
    if $scope.end_date
      $scope.end_date.format(fmt)

  ###**
  * @ngdoc method
  * @name selectDay
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Select day
  *
  * @param {date} day The day
  * @param {string=} route A specific route to load
  * @param {string} force The force
  ###
  $scope.selectDay = (day, route, force) =>
    if day.spaces == 0 && !force
      return false
    $scope.setLastSelectedDate(day.date)
    $scope.bb.current_item.setDate(day)
    if $scope.$parent.$has_page_control
      return
    else
      $scope.decideNextPage(route)

  ###**
  * @ngdoc method
  * @name setMonth
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Set month
  *
  * @param {date} month The month
  * @param {date} year The year
  ###
  $scope.setMonth = (month, year) =>
    $scope.current_date = moment().startOf('month').year(year).month(month-1)
    $scope.current_date.year()
    $scope.type = "month"

  ###**
  * @ngdoc method
  * @name setWeek
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Set month
  *
  * @param {date} week The week
  * @param {date} year The year
  ###
  $scope.setWeek = (week, year) =>
    $scope.current_date = moment().year(year).isoWeek(week).startOf('week')
    $scope.current_date.year()
    $scope.type = "week"

  ###**
  * @ngdoc method
  * @name add
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Add the current date in according of type and amount parameters
  *
  * @param {string} type The type
  * @param {string} amount The amount
  ###
  $scope.add = (type, amount) =>
    $scope.current_date.add(amount, type)
    $scope.loadData()

  ###**
  * @ngdoc method
  * @name subtract
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Substract the current date in according of type and amount
  *
  * @param {string} type The type
  * @param {string} amount The amount
  ###
  $scope.subtract = (type, amount) =>
    $scope.add(type, -amount)

  ###**
  * @ngdoc method
  * @name isPast
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Calculate if the current earlist date is in the past - in which case we might want to disable going backwards
  ###
  # calculate if the current earlist date is in the past - in which case we might want to disable going backwards
  $scope.isPast = () =>
    return true if !$scope.current_date
    return moment().isAfter($scope.current_date)

  ###**
  * @ngdoc method
  * @name loadData
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Load week if type is equals with week else load month
  ###
  $scope.loadData =  =>
    if $scope.type == "week"
      $scope.loadWeek()
    else
      $scope.loadMonth()

  ###**
  * @ngdoc method
  * @name loadMonth
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Load month
  ###
  $scope.loadMonth =  =>
    date = $scope.current_date

    $scope.month = date.month()
    loader.notLoaded()
    edate = moment(date).add(1, 'months')
    $scope.end_date = moment(edate).add(-1, 'days')

    if $scope.data_source
      BBModel.Day.$query({company: $scope.bb.company, cItem: $scope.data_source, 'month':date.format("MMYY"), client: $scope.client }).then (days) =>
        $scope.days = days
        for day in days
          $scope.day_data[day.string_date] = day
        weeks = []
        for w in [0..5]
          week = []
          for d in [0..6]
            week.push(days[w*7+d])
          weeks.push(week)
        $scope.weeks = weeks
        loader.setLoaded()
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    else
      loader.setLoaded()

  ###**
  * @ngdoc method
  * @name loadWeek
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Load week
  ###
  $scope.loadWeek = =>
    date = $scope.current_date
    loader.notLoaded()

    edate = moment(date).add(7, 'days')
    $scope.end_date = moment(edate).add(-1, 'days')
    if $scope.data_source
      BBModel.Day.$query({company: $scope.bb.company, cItem: $scope.data_source, date: date.toISODate(), edate: edate.toISODate(), client: $scope.client  }).then (days) =>
        $scope.days = days
        for day in days
          $scope.day_data[day.string_date] = day
        loader.setLoaded()
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    else
      loader.setLoaded()

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbMonthAvailability
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () =>
    if $scope.bb.current_item.date
      return true
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select a date" })
      return false
