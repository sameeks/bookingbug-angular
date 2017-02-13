// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminServices').directive('serviceTable', function($uibModal, $log,
  ModalForm, BBModel) {

  let controller = function($scope) {
    $scope.fields = ['id', 'name'];
    $scope.getServices = function() {
      let params =
        {company: $scope.company};
      return BBModel.Admin.Service.$query(params).then(services => $scope.services = services);
    };

    $scope.newService = () =>
      ModalForm.new({
        company: $scope.company,
        title: 'New Service',
        new_rel: 'new_service',
        post_rel: 'services',
        success(service) {
          return $scope.services.push(service);
        }
      })
    ;

    $scope.delete = service =>
      service.$del('self').then(() => $scope.services = _.reject($scope.services, service)
      , err => $log.error("Failed to delete service"))
    ;

    $scope.edit = service =>
      ModalForm.edit({
        model: service,
        title: 'Edit Service'
      })
    ;

    return $scope.newBooking = service =>
      ModalForm.book({
        model: service,
        company: $scope.company,
        title: 'New Booking',
        success(booking) {
          return $log.info('Created new booking ', booking);
        }
      })
    ;
  };

  let link = function(scope, element, attrs) {
    if (scope.company) {
      return scope.getServices();
    } else {
      return BBModel.Admin.Company.query(attrs).then(function(company) {
        scope.company = company;
        return scope.getServices();
      });
    }
  };

  return {
    controller,
    link,
    templateUrl: 'service_table_main.html'
  };});

