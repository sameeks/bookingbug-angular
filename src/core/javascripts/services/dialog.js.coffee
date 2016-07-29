angular.module('BB.Services').factory 'Dialog', ($uibModal, $log, $document) ->

  controller = ($scope, $uibModalInstance, model, title, success, fail, body) ->

    $scope.body = body
    $scope.title = title

    $scope.ok = () ->
      $uibModalInstance.close(model)

    $scope.cancel = () ->
      event.preventDefault()
      event.stopPropagation()
      $uibModalInstance.dismiss('cancel')

    $uibModalInstance.result.then () ->
      success(model) if success
    , () ->
      fail() if fail

  confirm: (config) ->
    templateUrl = config.templateUrl if config.templateUrl
    templateUrl ||= 'dialog.html'
    $uibModal.open
      appendTo: angular.element($document[0].getElementById('bb'))
      templateUrl: templateUrl
      controller: controller
      size: config.size || 'sm'
      resolve:
        model: () -> config.model
        title: () -> config.title
        success: () -> config.success
        fail: () -> config.fail
        body: () -> config.body

