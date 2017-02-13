// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue.Services').factory('QueuerService', ($q, UriTemplate, halClient, BBModel) =>

	({
		query(params) {
			let deferred = $q.defer();

			let url = "";
			if (params.url) { ({ url } = params); }
			let href = url + "/api/v1/queuers/{id}";
			let uri = new UriTemplate(href).fillFromObject(params || {});

			halClient.$get(uri, {}).then(found => {
				return deferred.resolve(found);
			}
			);

			return deferred.promise;
		},

		removeFromQueue(params) {
			let deferred = $q.defer();

			let url = "";
			if (params.url) { ({ url } = params); }
			let href = url + "/api/v1/queuers/{id}";
			let uri = new UriTemplate(href).fillFromObject(params || {});

			halClient.$del(uri).then(found => {
				return deferred.resolve(found);
			}
			);

			return deferred.promise;
		}
	})
);

