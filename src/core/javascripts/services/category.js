angular.module('BB.Services').factory("CategoryService", ($q, BBModel) =>

  ({
    query(company) {
      let deferred = $q.defer();
      if (!company.$has('categories')) {
        deferred.reject("No categories found");
      } else {
        company.$get('named_categories').then(resource => {
          return resource.$get('categories').then(items => {
            let categories = [];
            for (let _i = 0; _i < items.length; _i++) {
              let i = items[_i];
              let cat = new BBModel.Category(i);
              if (!cat.order) { cat.order = _i; }
              categories.push(cat);
            }
            return deferred.resolve(categories);
          }
          );
        }
        , err => {
          return deferred.reject(err);
        }
        );
      }
      return deferred.promise;
    }
  })
);

