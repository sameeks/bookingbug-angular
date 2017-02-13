angular.module('BBAdmin.Services').factory('AdminClinicService',  ($q, BBModel,
  ClinicCollections, $window) =>

  ({
    query(params) {
      let { company } = params;
      let defer = $q.defer();
      if (params.id) { // reuqest for a single one
        company.$get('clinics', params).then(function(clinic) {
          clinic = new BBModel.Admin.Clinic(clinic);
          return defer.resolve(clinic);
        }
        , err => defer.reject(err));
      } else {
        let existing = ClinicCollections.find(params);
        if (existing && !params.skip_cache) {
          defer.resolve(existing);
        } else {
          if (params.skip_cache) {
            if (existing) { ClinicCollections.delete(existing); }
            company.$flush('clinics', params);
          }
          company.$get('clinics', params).then(collection =>
            collection.$get('clinics').then(function(clinics) {
              let models = (Array.from(clinics).map((s) => new BBModel.Admin.Clinic(s)));
              clinics = new $window.Collection.Clinic(collection, models, params);
              ClinicCollections.add(clinics);
              return defer.resolve(clinics);
            }
            , err => defer.reject(err))
          
          , err => defer.reject(err));
        }
      }
      return defer.promise;
    },

    create(prms, clinic) {
      let { company } = prms;
      let deferred = $q.defer();
      company.$post('clinics', {}, clinic.getPostData()).then(clinic => {
        clinic = new BBModel.Admin.Clinic(clinic);
        ClinicCollections.checkItems(clinic);
        return deferred.resolve(clinic);
      }
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    },

    cancel(clinic) {
      let deferred = $q.defer();
      clinic.$post('cancel', clinic).then(clinic => {
        clinic = new BBModel.Admin.Clinic(clinic);
        ClinicCollections.deleteItems(clinic);
        return deferred.resolve(clinic);
      }
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    },

    update(clinic) {
      let deferred = $q.defer();
      clinic.$put('self', {}, clinic.getPostData()).then(c => {
        clinic = new BBModel.Admin.Clinic(c);
        ClinicCollections.checkItems(clinic);
        return deferred.resolve(clinic);
      }
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    }
  })
);

