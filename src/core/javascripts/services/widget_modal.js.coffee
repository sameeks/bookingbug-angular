'use strict'

###**
* @ngdoc service
* @name BB.Services:WidgetModalService
*
* @description
* Service for opening widgets in modals
*
#### 


angular.module('BB.Services').factory 'WidgetModalService', ($uibModal, $timeout, $document, $uibModalStack, AlertService) ->
  # you can store data in WidgetModalService config block 
  # to then be used as prms in base controller initWidget2()
  config = 
    clear_member: false
    template: 'main'
    member: false 
    admin: false
  isOpen: false

  open: (config) ->
    @isOpen = true
    $uibModal.open
      size: 'lg'
      controller: ($scope, $rootScope, WidgetModalService, $uibModalInstance, config, $window, AlertService, GeneralOptions) ->
        usingStudioInterface = true if $rootScope.user
        if $scope.bb && $scope.bb.current_item and onStudioInterface
          delete $scope.bb.current_item
        WidgetModalService.config = config
        $scope.config = angular.extend(WidgetModalService.config, config)
        $scope.config.company_id ||= $scope.company.id if $scope.company

        if usingStudioInterface?
          merge_resources: GeneralOptions.merge_resources
          merge_people: GeneralOptions.merge_people

        $scope.cancel = () ->
          WidgetModalService.close()
      templateUrl: 'widget_modal.html'
      resolve:
        config: () -> config 

  close: () ->
    @isOpen = false
    AlertService.clear()
    openModal = $uibModalStack.getTop()
    $uibModalStack.close(openModal.key)
