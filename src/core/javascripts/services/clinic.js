angular.module('BB.Services').factory('ClinicService',  ($q, BBModel, $window) =>

  ({
    query(params) {
      let { company } = params;
      let defer = $q.defer();
      if (params.id) { // request for a single one
        company.$get('clinics', params).then(function(clinic) {
          clinic = new BBModel.Clinic(clinic);
          return defer.resolve(clinic);
        }
        , err => defer.reject(err));
      } else {
        company.$get('clinics', params).then(collection =>
          collection.$get('clinics').then(function(clinics) {
            clinics = (Array.from(clinics).map((s) => new BBModel.Clinic(s)));
            return defer.resolve(clinics);
          }
          , err => defer.reject(err))
        
        , err => defer.reject(err));
      }
      return defer.promise;
    }
  })
);

