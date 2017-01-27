'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.clients.controllers.controller:ClientsNewPageCtrl
#
* @description
* Controller for the clients new page
###
angular.module('BBAdminDashboard.clients.controllers')
.controller 'ClientsNewPageCtrl', ($scope, halClient, $q) ->

  deferred = $q.defer()
  
  url = $scope.bb.api_url + '/api/v1/admin/' + $scope.bb.company_id + '/client'

  $scope.create = (prms) ->
    prms = $scope.new_client
    console.log prms
    halClient.$post(url, {}, prms).then (client) ->
      console.log client
    , (err) =>
      deferred.reject(err)
      

