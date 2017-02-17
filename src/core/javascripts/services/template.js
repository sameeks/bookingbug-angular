// Service for loading templates and partials. return rasterized dom elements
angular.module('BB.Services').factory("TemplateSvc", ($q, $http, $templateCache, BBModel) => {

        return {
            get(path) {
                let deferred = $q.defer();
                let cacheTmpl = $templateCache.get(path);

                if (cacheTmpl) {
                    deferred.resolve(angular.element(cacheTmpl));
                } else {
                    $http({
                        method: 'GET',
                        url: path
                    }).success(function (tmpl, status) {
                        $templateCache.put(path, tmpl);
                        return deferred.resolve(angular.element(tmpl));
                    }).error((data, status) => deferred.reject(data));
                }
                return deferred.promise;
            }
        };
    }
);

