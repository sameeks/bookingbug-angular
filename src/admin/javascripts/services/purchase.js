// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory('AdminPurchaseService', ($q, halClient, BBModel) =>

  ({
    query(params) {
      let defer = $q.defer();
      let uri = params.url_root+"/api/v1/admin/purchases/"+params.purchase_id;
      halClient.$get(uri, params).then(function(purchase) {
        purchase = new BBModel.Purchase.Total(purchase);
        return defer.resolve(purchase);
      }
      , err => defer.reject(err));
      return defer.promise;
    },


    markAsPaid(params) {
      let company_id;
      let defer = $q.defer();

      if (!params.purchase || !params.url_root) {
        defer.reject("invalid request");
        return defer.promise;
      }

      if (params.company) {
        company_id = params.company.id;
      }
      
      let uri = params.url_root+`/api/v1/admin/${company_id}/purchases/${params.purchase.id}/pay`;

      let data = {};
      if (params.company) { data.company_id = params.company.id; }
      if (params.notify_admin) { data.notify_admin = params.notify_admin; }
      if (params.payment_status) { data.payment_status = params.payment_status; }
      if (params.amount) { data.amount = params.amount; }
      if (params.notes) { data.notes = params.notes; }
      if (params.transaction_id) { data.transaction_id = params.transaction_id; }
      if (params.notify) { data.notify = params.notify; }
      if (params.payment_type) { data.payment_type = params.payment_type; }

      halClient.$put(uri, params, data).then(function(purchase) {
        purchase = new BBModel.Purchase.Total(purchase);
        return defer.resolve(purchase);
      }
      , err => defer.reject(err));
      return defer.promise;
    }
  })
);

