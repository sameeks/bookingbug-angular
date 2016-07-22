# 'use strict'
#
# describe 'cardSecurityCode', () ->
#   $compile = null
#   $rootScope = null
#   $scope = null
#
#   setup = () ->
#     module 'BB'
#
#     inject ($injector) ->
#       $compile = $injector.get '$compile'
#       $rootScope = $injector.get '$rootScope'
#       $scope = $rootScope.$new()
#       return
#
#     return
#
#   beforeEach setup
#
#   it 'should set maxlength to 4 for american express', ->
#     scope = $rootScope.$new()
#     element = angular.element('<input type="number" card-security-code card-type="card_type"/>')
#     $compile(element)(scope)
#     scope.card_type = 'american_express'
#     scope.$digest()
#     expect(element.attr('maxlength')).toBe('4')
#
#   return
