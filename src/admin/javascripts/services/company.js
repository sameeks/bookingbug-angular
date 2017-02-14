// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory('AdminCompanyService', ($q, $rootScope, $sessionStorage, BBModel) =>

    ({
        query(params) {
            let defer = $q.defer();
            if (!$rootScope.bb) {
                $rootScope.bb = {};
            }

            if (!$rootScope.bb.api_url) {
                $rootScope.bb.api_url = $sessionStorage.getItem("host");
            }
            if (!$rootScope.bb.api_url) {
                $rootScope.bb.api_url = params.apiUrl;
            }
            if (!$rootScope.bb.api_url) {
                $rootScope.bb.api_url = "";
            }

            BBModel.Admin.Login.$checkLogin(params).then(function () {
                if ($rootScope.user && $rootScope.user.company_id) {
                    if (!$rootScope.bb) {
                        $rootScope.bb = {};
                    }
                    $rootScope.bb.company_id = $rootScope.user.company_id;
                    return $rootScope.user.$get('company').then(company => defer.resolve(new BBModel.Admin.Company(company))
                        , err => defer.reject(err));
                } else {
                    let login_form = {
                        email: params.adminEmail,
                        password: params.adminPassword
                    };
                    let options =
                        {company_id: params.companyId};
                    return BBModel.Admin.Login.$login(login_form, options).then(user =>
                            user.$get('company').then(company => defer.resolve(new BBModel.Admin.Company(company))
                                , err => defer.reject(err))

                        , err => defer.reject(err));
                }
            });
            return defer.promise;
        }
    })
);

