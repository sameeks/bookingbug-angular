angular.module('BB.Directives').directive 'bbMembershipLevels', ($rootScope) ->

  link = (scope, element, attrs) ->

    getMembershiplevels = () ->
      scope.getMembershiplevels()

    getMembershiplevels()

  {
    link: link
    controller: 'MembershipLevels'
  }

angular.module('BB.Controllers').controller 'MembershipLevels', ($rootScope, MembershipLevelsService, $scope) ->


  $scope.getMembershiplevels = () ->
    if $scope.bb.company and $scope.bb.company.$has('member_levels')
      $scope.notLoaded $scope
      MembershipLevelsService.getMembershipLevels($scope.bb.company).then (member_levels) ->
        $scope.setLoaded $scope
        $scope.membership_levels = member_levels
      , (err) ->
        $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.selectMemberLevel = (level) ->
    if level and $scope.client
      $scope.client.member_level_id = level.id
      $scope.decideNextPage()




