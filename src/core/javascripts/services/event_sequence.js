// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("EventSequenceService", ($q, BBModel) => {

        return {
            query(company, params) {
                let deferred = $q.defer();
                if (!company.$has('event_sequences')) {
                    deferred.reject("company does not have event_sequences");
                } else {
                    company.$get('event_sequences', params).then(resource => {
                            return resource.$get('event_sequences', params).then(event_sequences => {
                                    event_sequences = Array.from(event_sequences).map((event_sequence) =>
                                        new BBModel.EventSequence(event_sequence));
                                    return deferred.resolve(event_sequences);
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
        };
    }
);

