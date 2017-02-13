// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("AddressListService", ($q, $window, halClient, UriTemplate) =>

  ({
    query(prms) {
      let deferred = $q.defer();
      let href = "/api/v1/company/{company_id}/addresses/{post_code}";
      let uri = new UriTemplate(href).fillFromObject({company_id: prms.company.id, post_code: prms.post_code });
      halClient.$get(uri, {}).then(addressList => deferred.resolve(addressList)
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    },

    getAddress(prms) {
      let deferred = $q.defer();
      let href = "/api/v1/company/{company_id}/addresses/address/{id}";
      let uri = new UriTemplate(href).fillFromObject({company_id: prms.company.id, id: prms.id});
      halClient.$get(uri, {}).then(customerAddress => deferred.resolve(customerAddress)
      , err => {
       return deferred.reject(err);
     }
      );
      return deferred.promise;
    }
  })
);

