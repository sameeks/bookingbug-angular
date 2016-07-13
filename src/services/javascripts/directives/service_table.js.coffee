angular.module('BBAdminServices').directive 'serviceTable', ($modal, $log,
  ModalForm, AdminCompanyService, BBModel) ->

  controller = ($scope) ->
    $scope.fields = ['id', 'name']
    $scope.getServices = () ->
      params =
        company: $scope.company
      BBModel.Admin.Service.$query(params).then (services) ->
        $scope.services = services

    $scope.newService = () ->
      ModalForm.new
        company: $scope.company
        title: 'New Service'
        new_rel: 'new_service'
        post_rel: 'services'
        success: (service) ->
          $scope.services.push(service)

    $scope.delete = (service) ->
      service.$del('self').then () ->
        $scope.services = _.reject $scope.services, service
      , (err) ->
        $log.error "Failed to delete service"

    $scope.edit = (service) ->
      ModalForm.edit
        model: service
        title: 'Edit Service'

    $scope.newBooking = (service) ->
      ModalForm.book
        model: service
        company: $scope.company
        title: 'New Booking'
        success: (booking) ->
          $log.info 'Created new booking ', booking

  link = (scope, element, attrs) ->
    if scope.company
      scope.getServices()
    else
      AdminCompanyService.query(attrs).then (company) ->
        scope.company = company
        scope.getServices()

  {
    controller: controller
    link: link
    templateUrl: 'service_table_main.html'
  }
