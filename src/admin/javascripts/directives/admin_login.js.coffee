'use strict'

angular.module('BBAdmin.Directives').directive 'adminLogin', ($uibModal,
  $log, $rootScope, $q, $document, BBModel) ->

  loginAdminController = ($scope, $uibModalInstance, company_id) ->
    $scope.title = 'Login'
    $scope.schema =
      type: 'object'
      properties:
        email: { type: 'string', title: 'Email' }
        password: { type: 'string', title: 'Password' }
    $scope.form = [{
      key: 'email',
      type: 'email',
      feedback: false,
      autofocus: true
    },{
      key: 'password',
      type: 'password',
      feedback: false
    }]
    $scope.login_form = {}

    $scope.submit = (form) ->
      options =
        company_id: company_id
      BBModel.Admin.Login.$login(form, options).then (admin) ->
        admin.email = form.email
        admin.password = form.password
        $uibModalInstance.close(admin)
      , (err) ->
        $uibModalInstance.dismiss(err)

    $scope.cancel = () ->
      $uibModalInstance.dismiss('cancel')


  pickCompanyController = ($scope, $uibModalInstance, companies) ->
    $scope.title = 'Pick Company'
    $scope.schema =
      type: 'object'
      properties:
        company_id: { type: 'integer', title: 'Company' }
    $scope.schema.properties.company_id.enum = (c.id for c in companies)
    $scope.form = [{
      key: 'company_id',
      type: 'select',
      titleMap: ({value: c.id, name: c.name} for c in companies),
      autofocus: true
    }]
    $scope.pick_company_form = {}

    $scope.submit = (form) ->
      $uibModalInstance.close(form.company_id)

    $scope.cancel = () ->
      $uibModalInstance.dismiss('cancel')


  link = (scope, element, attrs) ->
    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    loginModal = () ->
      modalInstance = $uibModal.open
        appendTo: angular.element($document[0].getElementById('bb'))
        templateUrl: 'login_modal_form.html'
        controller: loginAdminController
        resolve:
          company_id: () -> scope.companyId
      modalInstance.result.then (result) ->
        scope.adminEmail = result.email
        scope.adminPassword = result.password
        if result.$has('admins')
          result.$get('admins').then (admins) ->
            scope.admins = admins
            $q.all(m.$get('company') for m in admins).then (companies) ->
              pickCompanyModal(companies)
        else
          scope.admin = result
      , () ->
        loginModal()

    pickCompanyModal = (companies) ->
      modalInstance = $uibModal.open
        appendTo: angular.element($document[0].getElementById('bb'))
        templateUrl: 'pick_company_modal_form.html'
        controller: pickCompanyController
        resolve:
          companies: () -> companies
      modalInstance.result.then (company_id) ->
        scope.companyId = company_id
        tryLogin()
      , () ->
        pickCompanyModal()

    tryLogin = () ->
      login_form =
        email: scope.adminEmail
        password: scope.adminPassword
      options =
        company_id: scope.companyId
      BBModel.Admin.Login.$login(login_form, options).then (result) ->
        if result.$has('admins')
          result.$get('admins').then (admins) ->
            scope.admins = admins
            $q.all(a.$get('company') for a in admins).then (companies) ->
              pickCompanyModal(companies)
        else
          scope.admin = result
      , (err) ->
        loginModal()


    if scope.adminEmail && scope.adminPassword
      tryLogin()
    else
      loginModal()

  {
    link: link
    scope:
      adminEmail: '@'
      adminPassword: '@'
      companyId: '@'
      apiUrl: '@'
      admin: '='
    transclude: true
    template: """
<div ng-hide='admin'><img src='/BB_wait.gif' class="loader"></div>
<div ng-show='admin' ng-transclude></div>
"""
  }

