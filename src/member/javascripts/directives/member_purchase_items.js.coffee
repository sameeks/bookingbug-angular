angular.module('BBMember').directive 'bbMemberPurchaseItems', ($rootScope) ->
  scope:
    purchase: '='
  link: (scope, element, attrs) ->

    getItems = () ->
      scope.purchase.getItems().then (items) ->
        scope.items = items
        console.log(scope.items)

    scope.$watch 'purchase', () ->
      console.log('i get called')
      getItems()