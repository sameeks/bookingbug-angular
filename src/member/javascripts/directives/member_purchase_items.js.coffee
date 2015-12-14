angular.module('BBMember').directive 'bbMemberPurchaseItems', ($rootScope) ->
  scope: true
  link: (scope, element, attrs) ->

    getItems = () ->
      scope.purchase.getItems().then (items) ->
        scope.items = items

    scope.$watch 'purchase', () ->
      getItems()