// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let CompanyListBase = function($scope, $rootScope, $q, $attrs, LoadingService) {

  let loader = LoadingService.$loader($scope).notLoaded();

  let options = $scope.$eval($attrs.bbCompanies);

  $rootScope.connection_started.then(() => {
    if ($scope.bb.company.companies) {
      $scope.init($scope.bb.company);
      return $rootScope.parent_id = $scope.bb.company.id;
    } else if ($rootScope.parent_id) {
      $scope.initWidget({company_id:$rootScope.parent_id, first_page: $scope.bb.current_page});
      return;
    } else {
      return $scope.init($scope.bb.company);
    }
  }
  , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

  $scope.init = comp => {

    $scope.companies = $scope.bb.company.companies;
    if (!$scope.companies || ($scope.companies.length === 0)) {
      $scope.companies = [$scope.bb.company];
    }

    if ($scope.companies.length === 1) {
      $scope.skipThisStep();
      $scope.selectItem($scope.companies[0]);
    } else {
      if (options && options.hide_not_live_stores) {
        $scope.items = $scope.companies.filter(c => c.live);
      } else {
        $scope.items = $scope.companies;
      }
    }
    return loader.setLoaded();
  };

  $scope.selectItem = (item, route) => {

    // if company id is passed in, set the company id to this number
    let company_id;
    if (angular.isNumber(item)) {
      company_id = item;
    } else {
      company_id = item.id;
    }

    loader.notLoaded();
    let prms = {company_id};
    return $scope.initWidget(prms);
  };

  // TODO move this into a mothercare js file
  return $scope.splitString = function(company) {
    let result;
    let arr    = company.name.split(' ');
    return result = arr[2] ? arr[2] : "";
  };
};


angular.module('BB.Controllers').controller('CompanyList', CompanyListBase);
