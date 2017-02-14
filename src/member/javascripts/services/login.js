// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember.Services').factory("MemberLoginService", ($q,
                                                                   $rootScope, $sessionStorage, halClient, BBModel) =>

    ({
        login(form, options) {
            let defer = $q.defer();
            let url = `${$rootScope.bb.api_url}/api/v1/login`;
            if (options.company_id != null) {
                url = `${url}/member/${options.company_id}`;
            }
            halClient.$post(url, options, form).then(function (login) {
                    if (login.$has('member')) {
                        return login.$get('member').then(function (member) {
                            member = new BBModel.Member.Member(member);
                            let auth_token = member._data.getOption('auth_token');
                            $sessionStorage.setItem("login", member.$toStore());
                            $sessionStorage.setItem("auth_token", auth_token);
                            return defer.resolve(member);
                        });
                    } else if (login.$has('members')) {
                        return defer.resolve(login);
                    } else {
                        return defer.reject("No member account for login");
                    }
                }
                , err => {
                    if (err.status === 400) {
                        let login = halClient.$parse(err.data);
                        if (login.$has('members')) {
                            return defer.resolve(login);
                        } else {
                            return defer.reject(err);
                        }
                    } else {
                        return defer.reject(err);
                    }
                }
            );
            return defer.promise;
        }
    })
);
