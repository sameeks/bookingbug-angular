angular.module('BB.Directives').directive 'bbMembershipLevels', ($rootScope, MembershipLevelsService) ->
  restrict: 'AE'
  replace: true
  scope : true
  controller = ($scope, $element, $attrs) ->

    $rootScope.connection_started.then ->
      $scope.initialise()

    $scope.initialise = () ->
      if $scope.bb.company and $scope.bb.company.$has('member_levels')
        $scope.notLoaded $scope
        MembershipLevelsService.getMembershipLevels($scope.bb.company).then (member_levels) ->
          $scope.setLoaded $scope
          $scope.membership_levels = member_levels
          #checkClientDefaults()
        , (err) ->
          $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


    $scope.selectMemberLevel = (level) ->
      if level and $scope.client
        $scope.client.member_level_id = level.id

        if $scope.$parent.$has_page_control
          return
        else
          $scope.decideNextPage()


    checkClientDefaults = () ->
      return if !$scope.bb.client_defaults.membership_ref
      for membership_level in $scope.membership_levels
        if membership_level.name is $scope.bb.client_defaults.membership_ref
          $scope.selectMemberLevel(membership_level)


    $scope.setReady = () ->
      return false if !$scope.client.member_level_id
      return true


    $scope.getMembershipLevel = (member_level_id) ->
      return _.find $scope.membership_levels, (level) -> level.id is member_level_id