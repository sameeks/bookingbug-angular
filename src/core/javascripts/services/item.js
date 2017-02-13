// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("ItemService", ($q, BBModel) =>
  ({
    query(prms) {
      let deferred = $q.defer();
      if (prms.cItem.service && (prms.item !== 'service')) {
        if (!prms.cItem.service.$has('items')) {
          prms.cItem.service.$get('item').then(base_item => {
            return this.build_items(base_item.$get('items'), prms, deferred);
          }
          );
        } else {
          this.build_items(prms.cItem.service.$get('items'), prms, deferred);
        }
      } else if (prms.cItem.resource && !prms.cItem.anyResource() && (prms.item !== 'resource')) {
        if (!prms.cItem.resource.$has('items')) {
          prms.cItem.resource.$get('item').then(base_item => {
            return this.build_items(base_item.$get('items'), prms, deferred);
          }
          );
        } else {
          this.build_items(prms.cItem.resource.$get('items'), prms, deferred);
        }
    
      } else if (prms.cItem.person && !prms.cItem.anyPerson() && (prms.item !== 'person')) {
        if (!prms.cItem.person.$has('items')) {
          prms.cItem.person.$get('item').then(base_item => {
            return this.build_items(base_item.$get('items'), prms, deferred);
          }
          );
        } else {
          this.build_items(prms.cItem.person.$get('items'), prms, deferred);
        }
      } else {
        deferred.reject("No service link found");
      }
  
      return deferred.promise;
    },

    build_items(base_items, prms, deferred) {
      let wait_items = [base_items];
      if (prms.wait) {
        wait_items.push(prms.wait);
      }
      return $q.all(wait_items).then(resources => {
        let resource = resources[0];  // the first one was my own data
        return resource.$get('items').then(found => {
          let matching = [];
          let wlist = [];
          for (let v of Array.from(found)) {
            if (v.type === prms.item) {
              matching.push(new BBModel.BookableItem(v));
            }
          }
          return $q.all((Array.from(matching).map((m) => m.ready.promise))).then(() => deferred.resolve(matching));
        }
        );
      }
      );
    }
  })
);

