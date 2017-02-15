angular.module('BB.Services').factory("CompanyService", ($q, halClient, BBModel) => {

        return {
            query(company_id, options) {
                if (!options['root']) {
                    options['root'] = "";
                }
                let url = options['root'] + "/api/v1/company/" + company_id;
                let deferred = $q.defer();
                halClient.$get(url, options).then(company => {
                        return deferred.resolve(company);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            queryChildren(company) {
                let deferred = $q.defer();
                if (!company.$has('companies')) {
                    deferred.reject("No child companies found");
                } else {
                    company.$get('companies').then(resource => {
                            return resource.$get('companies').then(items => {
                                    let companies = [];
                                    for (let i of Array.from(items)) {
                                        companies.push(new BBModel.Company(i));
                                    }
                                    return deferred.resolve(companies);
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

