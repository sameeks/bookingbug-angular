angular.module('BB.Services').factory 'ModalForm', ($uibModal, $log, Dialog) ->

  newForm = ($scope, $uibModalInstance, company, title, new_rel, post_rel,
      success, fail) ->

    $scope.loading = true
    $scope.title = title
    $scope.company = company
    if $scope.company.$has(new_rel)
      $scope.company.$get(new_rel).then (schema) ->
        $scope.form = _.reject schema.form, (x) -> x.type == 'submit'
        $scope.schema = checkSchema(schema.schema)
        $scope.form_model = {}
        $scope.loading = false
    else
      $log.warn("company does not have '#{new_rel}' rel")

    $scope.submit = (form) ->
      $scope.$broadcast('schemaFormValidate')
      $scope.loading = true
      $scope.company.$post(post_rel, {}, $scope.form_model).then (model) ->
        $scope.loading = false
        $uibModalInstance.close(model)
        success(model) if success
      , (err) ->
        $scope.loading = false
        $uibModalInstance.close(err)
        $log.error 'Failed to create'
        fail(err) if fail

    $scope.cancel = (event) ->
      event.preventDefault()
      event.stopPropagation()
      $uibModalInstance.dismiss('cancel')



  # THIS IS CRUFTY AND SHOULD BE REMOVE WITH AN API UPDATE THAT TIDIES UP THE SCEMA RESPONE
  # fix the issues we have with the the sub client and question blocks being in doted notation, and not in child objects
  checkSchema = (schema) ->
    for k,v of schema.properties
      vals = k.split(".")
      if vals[0] == "questions" && vals.length > 1
        schema.properties.questions ||= {type: "object", properties: {} }
        schema.properties.questions.properties[vals[1]] ||= {type: "object", properties: {answer: v} }
      if vals[0] == "client" && vals.length > 2
        schema.properties.client ||= {type: "object", properties: {q: {type: "object", properties: {}}} }
        schema.properties.client.properties.q.properties[vals[2]] ||= {type: "object", properties: {answer: v} }
    return schema


  editForm = ($scope, $uibModalInstance, model, title, success, fail) ->
    $scope.loading = true
    $scope.title = title
    $scope.model = model
    if $scope.model.$has('edit')
      $scope.model.$get('edit').then (schema) ->
        $scope.form = _.reject schema.form, (x) -> x.type == 'submit'
        $scope.schema = checkSchema(schema.schema)
        $scope.form_model = $scope.model
        $scope.loading = false
    else
      $log.warn("model does not have 'edit' rel")

    $scope.submit = (form) ->
      $scope.$broadcast('schemaFormValidate')
      $scope.loading = true
      if $scope.model.$update
        $scope.model.$update($scope.form_model).then () ->
          $scope.loading = false
          $uibModalInstance.close($scope.model)
          success($scope.model) if success
        , (err) ->
          $scope.loading = false
          $uibModalInstance.close(err)
          $log.error 'Failed to create'
          fail() if fail
      else
        $scope.model.$put('self', {}, $scope.form_model).then (model) ->
          $scope.loading = false
          $uibModalInstance.close(model)
          success(model) if success
        , (err) ->
          $scope.loading = false
          $uibModalInstance.close(err)
          $log.error 'Failed to create'
          fail() if fail

    $scope.cancel = (event) ->
      event.preventDefault()
      event.stopPropagation()
      $uibModalInstance.dismiss('cancel')

    $scope.success = (response) ->
      event.preventDefault()
      event.stopPropagation()
      $modalInstance.close()
      success(response) if success


    $scope.cancelEvent = (event, type = 'booking') ->
      event.preventDefault()
      event.stopPropagation()
      $uibModalInstance.close()
      Dialog.confirm
        model: model
        body: "Are you sure you want to cancel this #{type}?"
        success: (model) ->
          model.$del('self').then (response) ->
            success(response) if success

  bookForm = ($scope, $uibModalInstance, model, company, title, success, fail) ->
    $scope.loading = true
    $scope.title = title
    $scope.model = model
    $scope.company = company
    if $scope.model.$has('new_booking')
      $scope.model.$get('new_booking').then (schema) ->
        $scope.form = _.reject schema.form, (x) -> x.type == 'submit'
        $scope.schema = checkSchema(schema.schema)
        $scope.form_model = {}
        $scope.loading = false
    else
      $log.warn("model does not have 'new_booking' rel")

    $scope.submit = (form) ->
      $scope.$broadcast('schemaFormValidate')
      if form.$valid
        $scope.loading = true
        $scope.company.$post('bookings', {}, $scope.form_model).then (booking) ->
          $scope.loading = false
          $uibModalInstance.close(booking)
          success(booking) if success
        , (err) ->
          $scope.loading = false
          $uibModalInstance.close(err)
          $log.error 'Failed to create'
          fail() if fail
      else
        $log.warn 'Invalid form'

    $scope.cancel = (event) ->
      event.preventDefault()
      event.stopPropagation()
      $uibModalInstance.dismiss('cancel')


  new: (config) ->
    templateUrl = config.templateUrl if config.templateUrl
    templateUrl ||= 'modal_form.html'
    $uibModal.open
      templateUrl: templateUrl
      controller: newForm
      size: config.size
      resolve:
        company: () -> config.company
        title: () -> config.title
        new_rel: () -> config.new_rel
        post_rel: () -> config.post_rel
        success: () -> config.success
        fail: () -> config.fail

  edit: (config) ->
    templateUrl = config.templateUrl if config.templateUrl
    templateUrl ||= 'modal_form.html'
    $uibModal.open
      templateUrl: templateUrl
      controller: editForm
      size: config.size
      resolve:
        model: () -> config.model
        title: () -> config.title
        success: () -> config.success
        fail: () -> config.fail

  book: (config) ->
    templateUrl = config.templateUrl if config.templateUrl
    templateUrl ||= 'modal_form.html'
    $uibModal.open
      templateUrl: templateUrl
      controller: bookForm
      size: config.size
      resolve:
        model: () -> config.model
        company: () -> config.company
        title: () -> config.title
        success: () -> config.success
        fail: () -> config.fail

