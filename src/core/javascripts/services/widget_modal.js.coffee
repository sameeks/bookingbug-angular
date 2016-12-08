'use strict'

angular.module('BB.Services').factory 'WidgetModalService', ($uibModal, $timeout, $document) ->
  # you can store data in WidgetModalService config block 
  # to then be used as prms in base controller initWidget2()
  config = 
    clear_member: false
    template: 'main'
    member: false 
    admin: false

  open: (config) ->
    $uibModal.open
      size: 'lg'
      controller: ($scope, WidgetModalService, $uibModalInstance, config, $window) ->
        if $scope.bb && $scope.bb.current_item 
          delete $scope.bb.current_item
        WidgetModalService.config = config
        $scope.config = angular.extend(WidgetModalService.config, config)
        $scope.config.company_id ||= $scope.company.id if $scope.company
        $scope.cancel = () ->
          $uibModalInstance.dismiss('cancel')
      templateUrl: 'widget_popup.html'
      resolve:
        config: () -> config 