angular.module('BBAdmin.Services').factory('AdminAddressService',  ($q, BBModel) =>

  ({
    query(params) {
      let { company } = params;
      let defer = $q.defer();
      company.$get('addresses').then(collection =>
        collection.$get('addresses').then(function(addresss) {
          let models = (Array.from(addresss).map((s) => new BBModel.Admin.Address(s)));
          return defer.resolve(models);
        }
        , err => defer.reject(err))
      
      , err => defer.reject(err));
      return defer.promise;
    }
  })
);

