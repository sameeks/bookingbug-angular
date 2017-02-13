let BBBlockTimeCtrl = function($scope, $element, $attrs, BBModel, BookingCollections, $rootScope, BBAssets) {
  'ngInject';

  // All options (resources, people) go to the same select
  $scope.resources = [];
  $scope.resourceError = false;

  BBAssets.getAssets($scope.bb.company).then(assets=> $scope.resources = assets);

  if (!moment.isMoment($scope.bb.to_datetime)) {
    $scope.bb.to_datetime = moment($scope.bb.to_datetime);
  }

  if (!moment.isMoment($scope.bb.from_datetime)) {
    $scope.bb.from_datetime = moment($scope.bb.from_datetime);
  }

  if (!moment.isMoment($scope.bb.to_datetime)) {
    $scope.bb.to_datetime = moment($scope.bb.to_datetime);
  }

  if ($scope.bb.min_date && !moment.isMoment($scope.bb.min_date)) {
    $scope.bb.min_date = moment($scope.bb.min_date);
  }

  if ($scope.bb.max_date && !moment.isMoment($scope.bb.max_date)) {
    $scope.bb.max_date = moment($scope.bb.max_date);
  }

  $scope.all_day = false;

  $scope.hideBlockAllDay = Math.abs($scope.bb.from_datetime.diff($scope.bb.to_datetime, 'days')) > 0;

  if ($scope.bb.company_settings && $scope.bb.company_settings.$has('block_questions')) {
    $scope.bb.company_settings.$get("block_questions", {}).then(details => {
      return $scope.block_questions = new BBModel.ItemDetails(details);
    }
    );
  }

  $scope.blockTime = function(form){
    if (form == null) {
      console.error('blockTime requires form as first argument');
      return false;
    }

    form.$setSubmitted();

    if (form.$invalid || !isValid()) {
      return false;
    }

    $scope.loading = true;

    let params = {
      start_time: $scope.bb.from_datetime,
      end_time: $scope.bb.to_datetime,
      booking: true,
      allday: $scope.all_day
    };

    if ($scope.block_questions) {
      params.questions = $scope.block_questions.getPostData();
    }

    if (typeof $scope.bb.current_item.person === 'object') {
      // Block call
      return BBModel.Admin.Person.$block($scope.bb.company, $scope.bb.current_item.person, params).then(response=> blockSuccess(response));
    } else if (typeof $scope.bb.current_item.resource === 'object') {
      // Block call
      return BBModel.Admin.Resource.$block($scope.bb.company, $scope.bb.current_item.resource, params).then(response=> blockSuccess(response));
    }
  };

  var isValid = function(){
    $scope.resourceError = false;
    if  ((typeof $scope.bb.current_item.person !== 'object') && (typeof $scope.bb.current_item.resource !== 'object')) {
      $scope.resourceError = true;
    }

    if  (((typeof $scope.bb.current_item.person !== 'object') && (typeof $scope.bb.current_item.resource !== 'object')) || ($scope.bb.from_datetime == null) || !$scope.bb.to_datetime) {
      return false;
    }

    return true;
  };

  var blockSuccess = function(response){
    $rootScope.$broadcast('refetchBookings');
    $scope.loading = false;
    // Close modal window
    return $scope.cancel();
  };

  $scope.changeBlockDay = blockDay=> $scope.all_day = blockDay;
 //   if blockDay
 //     $scope.bb.from_datetime = $scope.bb.min_date.format()
 //     $scope.bb.to_datetime = $scope.bb.max_date.format()

};


angular.module('BBAdminBooking').directive('bbBlockTime', () =>
  ({
    scope: true,
    restrict: 'A',
    controller: BBBlockTimeCtrl
  })
);