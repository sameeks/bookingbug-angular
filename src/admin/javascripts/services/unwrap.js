// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("BB.Service.login", ($q, BBModel) =>
    ({
        unwrap(resource) {
            return new BBModel.Admin.Login(resource);
        }
    })
);


angular.module('BB.Services').factory("BB.Service.base_login", ($q, BBModel) =>
    ({
        unwrap(resource) {
            return new BBModel.Admin.Login(resource);
        }
    })
);

