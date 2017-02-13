// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbMonthPicker', (PathSvc, $timeout) =>
  ({
    restrict: 'AE',
    replace: true,
    scope: true,
    require: ['^?bbEvents', '^?bbMultiCompanyEvents'],
    templateUrl(element, attrs) {
      return PathSvc.directivePartial("_month_picker");
    },
    link(scope, el, attrs) {

      scope.picker_settings = scope.$eval(attrs.bbMonthPicker) || {};
      scope.picker_settings.months_to_show = scope.picker_settings.months_to_show || 3;

      $(window).resize(() =>
        $timeout(function() {
          let width = el.width();
          return scope.rebuildSlideToWidth(width);
        }
        , 500)
      );

      return scope.$watch(attrs.dayData, function(dayData) {
        if (dayData) {
          if (!dayData.length) { scope.months = null; }
          if (dayData.length) { scope.processDates(dayData); }
          let width = el.width();
          return scope.rebuildSlideToWidth(width);
        }
      });
    },

    controller($scope) {

      $scope.processDates = function(dates) {

        let first_carousel_month;
        if (!dates.length) { dates = null; }

        let datehash = {};
        for (let date of Array.from(dates)) {
          datehash[date.date.format("DDMMYY")] = date;
          if (!$scope.first_available_day && (date.spaces > 0)) { $scope.first_available_day = date.date; }
        }

        // start at current month or the first month that has availability
        if ($scope.picker_settings.start_at_first_available_day) {
          first_carousel_month = $scope.first_available_day.clone().startOf('month');
        } else {
          first_carousel_month = moment().startOf('month');
        }
     
        let last_date = _.last(dates);
        let diff = last_date.date.diff(first_carousel_month, 'months');
        diff = diff > 0 ? diff + 1 : 1;
      
        // use picker settings or diff between first and last date to determine number of months to display
        $scope.num_months = $scope.picker_settings && $scope.picker_settings.months ? $scope.picker_settings.months : diff;

        return $scope.months = $scope.getMonths($scope.num_months, first_carousel_month, datehash);
      };
      
      // listen to date changes from the date filter and clear the selected day
      $scope.$on('event_list_filter_date:changed', function(event, date) {

        let newDay = $scope.getDay(date);

        if ($scope.selected_day) {
          if ($scope.selected_day.date.isSame(date)) {
            return $scope.selected_day.selected = !$scope.selected_day.selected;
          } else {
            $scope.selected_day.selected = false;
            if (newDay) {
              $scope.selected_day = newDay;
              return $scope.selected_day.selected = true;
            }
          }
        } else {
          if (newDay) {
            $scope.selected_day = newDay;
            return $scope.selected_day.selected = true;
          }
        }
      });

      $scope.$on('event_list_filter_date:cleared', function() {
        if ($scope.selected_day) { return $scope.selected_day.selected = false; }
      });

      
      $scope.toggleDay = function(day) {

        if (!day || (day.data && ((day.data.spaces === 0) || day.disabled || !day.available)) || (!day.data && !day._d)) { return; }

        // toggle when same day selected
        if ($scope.selected_day && $scope.selected_day.date.isSame(day.date)) {
          $scope.selected_day.selected = !$scope.selected_day.selected;
        }

        // swap when new day selected
        if ($scope.selected_day && !$scope.selected_day.date.isSame(day.date)) {
          $scope.selected_day.selected = false;
          $scope.selected_day = day;
          $scope.selected_day.selected = true;
        }

        // set new selected day
        if (!$scope.selected_day) {
          $scope.selected_day = day;
          $scope.selected_day.selected = true;
        }

        // TODO refactor to call showDay via controller
        return $scope.showDay(day.date);
      };

      $scope.rebuildSlide = function(n) {

        let months;
        let last_carousel_month = moment().startOf('month');
        let num_empty_months_to_add = 0;

        if ($scope.months && $scope.months.length) {
          // remove filler months before rebuilding
          months = [];
          for (let month of Array.from($scope.months)) {
            if (month && !month.filler) {
              months.push(month);
            }
          }


          if (months.length) { $scope.months = months; }
          // set required vars
          last_carousel_month = angular.copy($scope.months[$scope.months.length - 1].start_date);
          last_carousel_month.add(1, 'month');

          num_empty_months_to_add = n - ($scope.months.length % n);
          if (num_empty_months_to_add === n) { num_empty_months_to_add = 0; }
        } else { 
          // set required vars
          num_empty_months_to_add = n;
          last_carousel_month = moment().startOf('month');
        }

        let monthCollection = [];
        let slide = [];
      
        if (!$scope.months) { $scope.months = []; }

        let fillerMonths = $scope.getMonths(num_empty_months_to_add, last_carousel_month);
        $scope.months = $scope.months.concat(fillerMonths);

        // displays months in sets per slide
        for (let value of Array.from($scope.months)) {
        if (slide.length === n) {
            monthCollection.push(slide);
            slide = [];
            }
        slide.push(value);
        }
        monthCollection.push(slide);
        return $scope.monthCollection = monthCollection;
      };

      $scope.getMonths = function(months_to_display, start_month, datehash) {
        let months = [];
        // generates dates for carousel
        for (let m = 0, end = months_to_display, asc = 0 <= end; asc ? m < end : m > end; asc ? m++ : m--) {
          let date = start_month.clone().startOf('week');
          let month = {weeks: []};
          month.index = m - 1;
          for (let w = 1; w <= 6; w++) {
            let week = {days: []};
            for (let d = 1; d <= 7; d++) {

              var day_data;
              if (date.isSame(date.clone().startOf('month'),'day') && !month.start_date) { month.start_date = date.clone(); }
              if (datehash) { day_data = datehash[date.format("DDMMYY")]; }

              let day = {
                date      : date.clone(), 
                data      : datehash ? day_data : null,
                available : datehash ? day_data && day_data.spaces && (day_data.spaces > 0) : false,
                today     : moment().isSame(date, 'day'),
                past      : date.isBefore(moment(), 'day'),
                disabled  : !month.start_date || !date.isSame(month.start_date, 'month')
              };
              week.days.push(day);

              if ($scope.selected_date && day.date.isSame($scope.selected_date, 'day')) {
                day.selected = true;
                $scope.selected_day = day;
              }

              date.add(1, 'day');
            }

            if (!datehash) { month.filler = true; }
            month.weeks.push(week);
          }
          
          months.push(month);
          start_month.add(1, 'month');
        }

        return months;
      };

      $scope.rebuildSlideToWidth = function(width) {
        // TODO - add code for 4 and 5?
        let num_slides_to_display;
        if (width > 750) {
          // desktop
          num_slides_to_display = 3;
          return $scope.rebuildSlide(num_slides_to_display);
        } else if (width > 550) {
          // tablet
          num_slides_to_display = 2;
          return $scope.rebuildSlide(num_slides_to_display);
        } else {
          // phone
          num_slides_to_display = 1;
          return $scope.rebuildSlide(num_slides_to_display);
        }
      };


      return $scope.getDay = function(date) {
        for (let month of Array.from($scope.months)) {
          for (let week of Array.from(month.weeks)) {
            for (let day of Array.from(week.days)) {
              if (day.date.isSame(date) && !day.disabled) {
                return day;
              }
            }
          }
        }
      };
    }
  })
);
