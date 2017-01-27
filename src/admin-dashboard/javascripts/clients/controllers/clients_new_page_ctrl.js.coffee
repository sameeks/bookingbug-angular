'use strict';

ClientsNewPageCtrl = ($scope, BBModel, $state) ->
  
  init = () ->
    $scope.create = create
    return
  
  create = () ->
    BBModel.Admin.Client.$post($scope.new_client, $scope.company.id).then (data)->
      $state.go('clients.all', {}, { reload: true });
    return  
    
  init()    
  return

###*
* @ngdoc controller
* @name BBAdminDashboard.clients.controllers.controller:ClientsNewPageCtrl
#
* @description
* Controller for the clients new page
###
angular.module('BBAdminDashboard.clients.controllers').controller 'ClientsNewPageCtrl', ClientsNewPageCtrl

