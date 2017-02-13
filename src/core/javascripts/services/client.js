// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("ClientService", function($q, BBModel, MutexService) {

  let setDefaultCompanyId = function(company, client) {
    // set the default_company_id on the client so that we can filter search results by child company if AdminBookingOptions.use_default_company_id is set
    client.default_company_id = company.id;
  };

  return {
    create(company, client) {
      let deferred = $q.defer();
      if (!company.$has('client')) {
        deferred.reject("Cannot create new people for this company");
      } else {
        MutexService.getLock().then(function(mutex) {
          setDefaultCompanyId(company, client);
          return company.$post('client', {}, client.getPostData()).then(cl => {
            deferred.resolve(new BBModel.Client(cl));
            return MutexService.unlock(mutex);
          }
          , err => {
            deferred.reject(err);
            return MutexService.unlock(mutex);
          }
          );
        });
      }
      return deferred.promise;
    },


    update(company, client) {
      let deferred = $q.defer();
      MutexService.getLock().then(function(mutex) {
        setDefaultCompanyId(company, client);
        return client.$put('self', {}, client.getPostData()).then(cl => {
          deferred.resolve(new BBModel.Client(cl));
          return MutexService.unlock(mutex);
        }
        , err => {
          deferred.reject(err);
          return MutexService.unlock(mutex);
        }
        );
      });
      return deferred.promise;
    },

    create_or_update(company, client) {
      if (client.$has('self')) {
        return this.update(company, client);
      } else {
        return this.create(company, client);
      }
    },

    query_by_email(company, email) {
      let deferred = $q.defer();
      if ((company != null) && (email != null)) {
        company.$get("client_by_email", {email}).then(client => {
          if (client != null) {
            return deferred.resolve(new BBModel.Client(client));
          } else {
            return deferred.resolve({});
          }
        }
        , err => deferred.reject(err));
      } else {
        deferred.reject("No company or email defined");
      }
      return deferred.promise;
    }
  };
});
