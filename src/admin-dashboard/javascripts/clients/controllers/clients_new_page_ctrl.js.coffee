'use strict';

ClientsNewPageCtrl = ($scope, BBModel, $state, ClientDetailsService, ClientService) ->
  
  init = () ->
    $scope.createClient = createClient
    return
  ClientDetailsService.query($scope.company).then (client_details) ->
    $scope.questions = client_details.questions
    #Using the pre-existing function to hide the conditional questions - may not be the best way
    BBModel.Question.$checkConditionalQuestions(client_details.questions)
    
  createClient = () ->
    $scope.newClientForm.$setSubmitted()
    if $scope.newClientForm.$valid is false
      return
    # $scope.new_client.questions = [{":id":{"706":{"answer":"please work"}}}]
    # $scope.new_client.questions = {"dt706": "please work"}
    $scope.newClient.questions = [{ "id" : "706", "answer": "asdfasf dasdas ddas"}]
    BBModel.Admin.Client.$post($scope.newClient, $scope.company.id).then (data)->
      console.log data
      
      $state.go('clients.all', {}, { reload: true });
    return  
  
  mapQuestions = () ->
    q = {}
    
    
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

