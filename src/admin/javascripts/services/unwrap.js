angular.module('BB.Services').factory("BB.Service.login", ($q, BBModel) => {
        return {
            unwrap(resource) {
                return new BBModel.Admin.Login(resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.base_login", ($q, BBModel) => {
        return {
            unwrap(resource) {
                return new BBModel.Admin.Login(resource);
            }
        };
    }
);

