angular.module('BB.Directives').directive('pricepicker', function(){

  let controller = $scope =>

    $scope.$watch('price', function(price) {
      if (price != null) { return $scope.updateModel(price); }
    })
  ;


  let link = function(scope, element, attrs, ngModel) {

    ngModel.$render = function() {
      if (ngModel.$viewValue) {
        return scope.price = ngModel.$viewValue;
      }
    };

    return scope.updateModel = value => ngModel.$setViewValue(value);
  };


  return {
    require: 'ngModel',
    link,
    controller,
    scope: {
      currency: '@'
    },
    template: `\
<span>{{0 | currency: currency | limitTo: 1}}</span>
  <input type="number" ng-model="price" class="form-control" step="0.01">\
`
  };
});

