'use strict'

angular.module('BB.Directives').directive 'bbMonthPicker', (PathSvc, $timeout) ->
  restrict: 'AE'
  replace: true
  scope: true
  require: ['^?bbEvents', '^?bbMultiCompanyEvents']
  templateUrl: (element, attrs) ->
    PathSvc.directivePartial "_month_picker"
  link: (scope, el, attrs) ->

    scope.picker_settings = scope.$eval(attrs.bbMonthPicker) or {}
    scope.picker_settings.months_to_show = scope.picker_settings.months_to_show or 3

    $(window).resize () ->
      $timeout ->
        width = el.width()
        scope.rebuildSlideToWidth width
      , 500

    scope.$watch attrs.dayData, (dayData) ->
      if dayData
        scope.months = null if !dayData.length
        scope.processDates(dayData) if dayData.length
        width = el.width()
        scope.rebuildSlideToWidth width

  controller : ($scope) ->

    $scope.processDates = (dates) ->

      dates = null if !dates.length

      datehash = {}
      for date in dates
        datehash[date.date.format("DDMMYY")] = date
        $scope.first_available_day = date.date if !$scope.first_available_day and date.spaces > 0

      # start at current month or the first month that has availability
      if $scope.picker_settings.start_at_first_available_day
        first_carousel_month = $scope.first_available_day.clone().startOf('month')
      else
        first_carousel_month = moment().startOf('month')
     
      last_date = _.last dates
      diff = last_date.date.diff(first_carousel_month, 'months')
      diff = if diff > 0 then diff + 1 else 1
      
      # use picker settings or diff between first and last date to determine number of months to display
      $scope.num_months = if $scope.picker_settings and $scope.picker_settings.months then $scope.picker_settings.months else diff

      $scope.months = $scope.getMonths($scope.num_months, first_carousel_month, datehash)
      
    # listen to date changes from the date filter and clear the selected day
    $scope.$on 'event_list_filter_date:changed', (event, date) ->

      newDay = $scope.getDay(date)

      if $scope.selected_day
        if $scope.selected_day.date.isSame(date)
          $scope.selected_day.selected = !$scope.selected_day.selected
        else
          $scope.selected_day.selected = false
          if newDay
            $scope.selected_day = newDay
            $scope.selected_day.selected = true
      else
        if newDay
          $scope.selected_day = newDay
          $scope.selected_day.selected = true

    $scope.$on 'event_list_filter_date:cleared', () ->
      $scope.selected_day.selected = false if $scope.selected_day

      
    $scope.toggleDay = (day) ->

      return if !day || day.data and (day.data.spaces == 0 or day.disabled or !day.available) or (!day.data and !day._d)

      # toggle when same day selected
      if $scope.selected_day and $scope.selected_day.date.isSame(day.date)
        $scope.selected_day.selected = !$scope.selected_day.selected

      # swap when new day selected
      if $scope.selected_day and !$scope.selected_day.date.isSame(day.date)
        $scope.selected_day.selected = false
        $scope.selected_day = day
        $scope.selected_day.selected = true

      # set new selected day
      if !$scope.selected_day
        $scope.selected_day = day
        $scope.selected_day.selected = true

      # TODO refactor to call showDay via controller
      $scope.showDay(day.date)

    $scope.rebuildSlide = (n) ->

      last_carousel_month = moment().startOf('month')
      num_empty_months_to_add = 0

      if $scope.months and $scope.months.length
        # remove filler months before rebuilding
        months = []
        for month in $scope.months
          if month and !month.filler
            months.push month


        $scope.months = months if months.length
        # set required vars
        last_carousel_month = angular.copy($scope.months[$scope.months.length - 1].start_date)
        last_carousel_month.add(1, 'month')

        num_empty_months_to_add = n - ($scope.months.length % n)
        num_empty_months_to_add = 0 if num_empty_months_to_add is n
      else 
        # set required vars
        num_empty_months_to_add = n
        last_carousel_month = moment().startOf('month')

      monthCollection = []
      slide = []
      
      $scope.months = [] if !$scope.months

      fillerMonths = $scope.getMonths(num_empty_months_to_add, last_carousel_month)
      $scope.months = $scope.months.concat fillerMonths

      # displays months in sets per slide
      for value in $scope.months
          if slide.length is n
              monthCollection.push slide
              slide = []
          slide.push value
      monthCollection.push slide
      $scope.monthCollection = monthCollection

    $scope.getMonths = (months_to_display, start_month, datehash) ->
      months = []
      # generates dates for carousel
      for m in [0...months_to_display]
        date = start_month.clone().startOf('week')
        month = {weeks: []}
        month.index = m - 1
        for w in [1..6]
          week = {days: []}
          for d in [1..7]

            month.start_date = date.clone() if date.isSame(date.clone().startOf('month'),'day') and !month.start_date
            day_data = datehash[date.format("DDMMYY")] if datehash

            day = {
              date      : date.clone(), 
              data      : if datehash then day_data else null,
              available : if datehash then day_data and day_data.spaces and day_data.spaces > 0 else false,
              today     : moment().isSame(date, 'day'),
              past      : date.isBefore(moment(), 'day'),
              disabled  : !month.start_date or !date.isSame(month.start_date, 'month')
            }
            week.days.push(day)

            if $scope.selected_date and day.date.isSame($scope.selected_date, 'day')
              day.selected = true
              $scope.selected_day = day

            date.add(1, 'day')

          month.filler = true if !datehash
          month.weeks.push(week)
          
        months.push month
        start_month.add(1, 'month')

      return months

    $scope.rebuildSlideToWidth = (width) ->
      # TODO - add code for 4 and 5?
      if width > 750
        # desktop
        num_slides_to_display = 3
        $scope.rebuildSlide num_slides_to_display
      else if width > 550
        # tablet
        num_slides_to_display = 2
        $scope.rebuildSlide num_slides_to_display
      else
        # phone
        num_slides_to_display = 1
        $scope.rebuildSlide num_slides_to_display


    $scope.getDay = (date) ->
      for month in $scope.months
        for week in month.weeks
          for day in week.days
            if day.date.isSame(date) and !day.disabled
              return day
