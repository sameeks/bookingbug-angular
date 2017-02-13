angular.module('BBAdmin.Services').factory('AdminSlotService', ($q, $window,
    halClient, SlotCollections, BBModel, UriTemplate) =>

  ({
    query(prms) {
      let deferred = $q.defer();

      // see if a colection of slots matching this quesry is already being monitored
      let existing = SlotCollections.find(prms);
      if (existing) {
        deferred.resolve(existing);
      } else if (prms.user) {
        prms.user.$get('company').then(company =>
          company.$get('slots', prms).then(slots_collection =>
            slots_collection.$get('slots').then(function(slots) {
              let slot_models = (Array.from(slots).map((s) => new BBModel.Admin.Slot(s)));
              return deferred.resolve(slot_models);
            }
            , err => deferred.reject(err))
          )
        );
      } else {
        let url = "";
        if (prms.url) { ({ url } = prms); }
        let href = url + "/api/v1/admin/{company_id}/slots{?start_date,end_date,date,service_id,resource_id,person_id,page,per_page}";
        let uri = new UriTemplate(href).fillFromObject(prms || {});

        halClient.$get(uri, {}).then(found => {
          return found.$get('slots').then(items => {
            let sitems = [];
            for (let item of Array.from(items)) {
              sitems.push(new BBModel.Admin.Slot(item));
            }
            let slots  = new $window.Collection.Slot(found, sitems, prms);
            SlotCollections.add(slots);
            return deferred.resolve(slots);
          }
          );
        }
        , err => {
          return deferred.reject(err);
        }
        );
      }

      return deferred.promise;
    },


    create(prms, data) {

      let url = "";
      if (prms.url) { ({ url } = prms); }
      let href = url + "/api/v1/admin/{company_id}/slots";
      let uri = new UriTemplate(href).fillFromObject(prms || {});

      let deferred = $q.defer();

      halClient.$post(uri, {}, data).then(slot => {
        slot = new BBModel.Admin.Slot(slot);
        SlotCollections.checkItems(slot);
        return deferred.resolve(slot);
      }
      , err => {
        return deferred.reject(err);
      }
      );

      return deferred.promise;
    },

    delete(item) {

      let deferred = $q.defer();
      item.$del('self').then(slot => {
        slot = new BBModel.Admin.Slot(slot);
        SlotCollections.deleteItems(slot);
        return deferred.resolve(slot);
      }
      , err => {
        return deferred.reject(err);
      }
      );

      return deferred.promise;
    },

    update(item, data) {

      let deferred = $q.defer();
      item.$put('self', {}, data).then(slot => {
        slot = new BBModel.Admin.Slot(slot);
        SlotCollections.checkItems(slot);
        return deferred.resolve(slot);
      }
      , err => {
        return deferred.reject(err);
      }
      );

      return deferred.promise;
    }
  })
);

