angular.module('BB.Directives').directive 'datetimepicker', ()->

  controller = ($scope) ->

    $scope.open = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.opened = true

    $scope.$watch '$$value$$', (value) ->
      $scope.updateModel(value) if value?
        

  link = (scope, element, attrs, ngModel) ->

    ngModel.$render = () ->
      if ngModel.$viewValue
        if moment.isMoment(ngModel.$viewValue)
          scope.$$value$$ = ngModel.$viewValue.format()
        else
          scope.$$value$$ = ngModel.$viewValue
      else
        scope.$$value$$ = new Date()

    scope.updateModel = (value) ->
      ngModel.$setViewValue(moment(value).format())


  require: 'ngModel'
  link: link
  controller: controller
  scope:
    schemaValidate: '='
  templateUrl: 'datetimepicker.html'
