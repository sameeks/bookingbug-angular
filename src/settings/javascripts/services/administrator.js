angular.module('BBAdmin.Services').factory('AdminAdministratorService', ($q, BBModel) =>

  ({
    query(params) {
      let { company } = params;
      let defer = $q.defer();
      company.$get('administrators').then(collection =>
        collection.$get('administrators').then(function(administrators) {
          let models = (Array.from(administrators).map((a) => new BBModel.Admin.Administrator(a)));
          return defer.resolve(models);
        }
        , err => defer.reject(err))
      
      , err => defer.reject(err));
      return defer.promise;
    }
  })
);

