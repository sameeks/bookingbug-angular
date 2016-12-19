'use strict'

angular.module('BB.Services').factory 'WidgetModalService', ($uibModal, $timeout, $document, $uibModalStack, AlertService) ->
  # you can store data in WidgetModalService config block 
  # to then be used as prms in base controller initWidget2()
  config = 
    clear_member: false
    template: 'main'
    member: false 
    admin: false
  is_open: false

  open: (config) ->
    @is_open = true
    $uibModal.open
      size: 'lg'
      controller: ($scope, WidgetModalService, $uibModalInstance, config, $window, AlertService) ->
        if $scope.bb && $scope.bb.current_item 
          delete $scope.bb.current_item
        WidgetModalService.config = config
        $scope.config = angular.extend(WidgetModalService.config, config)
        $scope.config.company_id ||= $scope.company.id if $scope.company
        $scope.cancel = () ->
          WidgetModalService.is_open = false
          AlertService.clear()
          $uibModalInstance.dismiss('cancel')
      templateUrl: 'widget_modal.html'
      resolve:
        config: () -> config 

  close: () ->
    @is_open = false
    AlertService.clear()
    open_modal = $uibModalStack.getTop()

    $uibModalStack.close(open_modal.key)
