// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbMembershipLevels', ($rootScope, BBModel) =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller($scope, $element, $attrs, LoadingService) {

      let loader = LoadingService.$loader($scope);

      $rootScope.connection_started.then(() => $scope.initialise());

      $scope.initialise = function() {
        if ($scope.bb.company && $scope.bb.company.$has('member_levels')) {
          loader.notLoaded();
          return BBModel.MembershipLevels.$getMembershipLevels($scope.bb.company).then(function(member_levels) {
            loader.setLoaded();
            return $scope.membership_levels = member_levels;
          }
            //checkClientDefaults()
          , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
        }
      };

      $scope.selectMemberLevel = function(level) {
        if (level && $scope.client) {
          $scope.client.member_level_id = level.id;

          if ($scope.$parent.$has_page_control) {
            return;
          } else {
            return $scope.decideNextPage();
          }
        }
      };

      let checkClientDefaults = function() {
        if (!$scope.bb.client_defaults.membership_ref) { return; }
        return (() => {
          let result = [];
          for (let membership_level of Array.from($scope.membership_levels)) {
            let item;
            if (membership_level.name === $scope.bb.client_defaults.membership_ref) {
              item = $scope.selectMemberLevel(membership_level);
            }
            result.push(item);
          }
          return result;
        })();
      };

      $scope.setReady = function() {
        if (!$scope.client.member_level_id) { return false; }
        return true;
      };

      return $scope.getMembershipLevel = member_level_id => _.find($scope.membership_levels, level => level.id === member_level_id);
    }
  })
);

