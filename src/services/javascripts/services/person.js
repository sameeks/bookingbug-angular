angular.module('BBAdminServices').factory('AdminPersonService',  ($q, $window,
    $rootScope, halClient, SlotCollections, BookingCollections, BBModel,
    LoginService, $log) =>

  ({
    query(params) {
      let { company } = params;
      let defer = $q.defer();
      if (company.$has('people')) {
        company.$get('people', params).then(function(collection) {
          if (collection.$has('people')) {
            return collection.$get('people').then(function(people) {
              let models = (Array.from(people).map((p) => new BBModel.Admin.Person(p)));
              return defer.resolve(models);
            }
            , err => defer.reject(err));
          } else {
            let obj = new BBModel.Admin.Person(collection);
            return defer.resolve(obj);
          }
        }
        , err => defer.reject(err));
      } else {
        $log.warn('company has no people link');
        defer.reject('company has no people link');
      }
      return defer.promise;
    },

    block(company, person, data) {
      let deferred = $q.defer();
      person.$put('block', {}, data).then(response => {
        if (response.$href('self').indexOf('bookings') > -1) {
          let booking = new BBModel.Admin.Booking(response);
          BookingCollections.checkItems(booking);
          return deferred.resolve(booking);
        } else {
          let slot = new BBModel.Admin.Slot(response);
          SlotCollections.checkItems(slot);
          return deferred.resolve(slot);
        }
      }
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    },

    signup(user, data) {
      let defer = $q.defer();
      return user.$get('company').then(function(company) {
        let params = {};
        company.$post('people', params, data).then(function(person) {
          if (person.$has('administrator')) {
            return person.$get('administrator').then(function(user) {
              LoginService.setLogin(user);
              return defer.resolve(person);
            });
          } else {
            return defer.resolve(person);
          }
        }
        , err => defer.reject(err));
        return defer.promise;
      });
    }
  })
);

