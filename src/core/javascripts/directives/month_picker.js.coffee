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

    stopWatch = scope.$watch attrs.dayData, (dates) ->
      if dates
        scope.processDates(dates)
        stopWatch()

  controller : ($scope) ->

    $scope.processDates = (dates) ->
      datehash = {}
      for date in dates
        datehash[date.date.format("DDMMYY")] = date
        $scope.first_available_day = date.date if !$scope.first_available_day and date.spaces > 0

      # start at current month or the first month that has availability
      if $scope.picker_settings.start_at_first_available_day
        cur_month = $scope.first_available_day.clone().startOf('month')
      else
        cur_month = moment().startOf('month')
     
      last_date = _.last dates
      diff = last_date.date.diff(cur_month, 'months')
      diff = if diff > 0 then diff + 1 else 1
      
      # use picker settings or diff between first and last date to determine number of months to display
      $scope.num_months = if $scope.picker_settings and $scope.picker_settings.months then $scope.picker_settings.months else diff

      months = []
      for m in [1..$scope.num_months]
        date = cur_month.clone().startOf('week')
        month = {weeks: []}
        month.index = m - 1
        for w in [1..6]
          week = {days: []}
          for d in [1..7]

            month.start_date = date.clone() if date.isSame(date.clone().startOf('month'),'day') and !month.start_date
            day_data = datehash[date.format("DDMMYY")]

            day = {
              date      : date.clone(), 
              data      : day_data,
              available : day_data and day_data.spaces and day_data.spaces > 0,
              today     : moment().isSame(date, 'day'),
              past      : date.isBefore(moment(), 'day'),
              disabled  : !month.start_date or !date.isSame(month.start_date, 'month')
            }

            week.days.push(day)

            if $scope.selected_date and day.date.isSame($scope.selected_date, 'day')
              day.selected = true
              $scope.selected_day = day

            date.add(1, 'day')
            
          month.weeks.push(week)

        months.push(month)
        cur_month.add(1, 'month')

      $scope.months = months

      $scope.slick_config =
        nextArrow: ".month-next",
        prevArrow: ".month-prev",
        slidesToShow: if $scope.months.length >= $scope.picker_settings.months_to_show then $scope.picker_settings.months_to_show else $scope.months.length,
        infinite: false,
        responsive: [
          {breakpoint: 1200, settings: {slidesToShow: if $scope.months.length >= 2 then 2 else $scope.months.length}},
          {breakpoint: 992, settings: {slidesToShow: 1}}
        ],
        method: {},
        event:
          init: (event, slick) ->
            $timeout ->
              # scroll to the selected month
              if $scope.selected_day?
                for m in $scope.months
                  slick.slickGoTo(m.index) if m.start_date.month() is $scope.selected_day.date.month()

      
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


    $scope.getDay = (date) ->
      for month in $scope.months
        for week in month.weeks
          for day in week.days
            if day.date.isSame(date) and !day.disabled
              return day
