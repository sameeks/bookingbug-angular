// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory("AdminLoginService", ($q, halClient, $rootScope, BBModel, $sessionStorage, $cookies, UriTemplate, shared_header) => {

        return {
            login(form, options) {
                let login_model;
                let deferred = $q.defer();
                let url = `${$rootScope.bb.api_url}/api/v1/login/admin`;
                if ((options != null) && (options.company_id != null)) {
                    url = `${url}/${options.company_id}`;
                }

                halClient.$post(url, options, form).then(login => {
                        if (login.$has('administrator')) {
                            return login.$get('administrator').then(user => {
                                    // user.setOption('auth_token', login.getOption('auth_token'))
                                    user = this.setLogin(user);
                                    return deferred.resolve(user);
                                }
                            );
                        } else if (login.$has('administrators')) {
                            login_model = new BBModel.Admin.Login(login);
                            return deferred.resolve(login_model);
                        } else {
                            return deferred.reject("No admin account for login");
                        }
                    }
                    , err => {
                        if (err.status === 400) {
                            let login = halClient.$parse(err.data);
                            if (login.$has('administrators')) {
                                login_model = new BBModel.Admin.Login(login);
                                return deferred.resolve(login_model);
                            } else {
                                return deferred.reject(err);
                            }
                        } else {
                            return deferred.reject(err);
                        }
                    }
                );
                return deferred.promise;
            },


            ssoLogin(options, data) {
                let deferred = $q.defer();
                let url = $rootScope.bb.api_url + "/api/v1/login/sso/" + options['company_id'];

                halClient.$post(url, {}, data).then(login => {
                        let params = {auth_token: login.auth_token};
                        return login.$get('user').then(user => {
                                user = this.setLogin(user);
                                return deferred.resolve(user);
                            }
                        );
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },


            isLoggedIn() {
                let deferred = $q.defer();
                this.checkLogin().then(function () {
                        if ($rootScope.user) {
                            return deferred.resolve(true);
                        } else {
                            return deferred.reject(false);
                        }
                    }
                    , err => deferred.reject(false));
                return deferred.promise;
            },

            setLogin(user) {
                user = new BBModel.Admin.User(user);
                let auth_token = user.getOption('auth_token');
                $sessionStorage.setItem("user", user.$toStore());
                $sessionStorage.setItem("auth_token", auth_token);
                $rootScope.user = user;
                return user;
            },

            user() {
                return this.checkLogin().then(() => $rootScope.user);
            },

            checkLogin(params) {
                if (params == null) {
                    params = {};
                }
                let defer = $q.defer();
                if ($rootScope.user) {
                    defer.resolve();
                }
                let user = $sessionStorage.getItem("user");
                if (user) {
                    $rootScope.user = new BBModel.Admin.User(halClient.createResource(user));
                    defer.resolve();
                } else {
                    let auth_token = $cookies.get('Auth-Token');
                    if (auth_token) {
                        let url;
                        if ($rootScope.bb.api_url) {
                            url = `${$rootScope.bb.api_url}/api/v1/login{?id,role}`;
                        } else {
                            url = "/api/v1/login{?id,role}";
                        }
                        params.id = params.companyId || params.company_id;
                        params.role = 'admin';
                        let href = new UriTemplate(url).fillFromObject(params || {});
                        let options = {auth_token};
                        halClient.$get(href, options).then(login => {
                                if (login.$has('administrator')) {
                                    return login.$get('administrator').then(function (user) {
                                        $rootScope.user = new BBModel.Admin.User(user);
                                        return defer.resolve();
                                    });
                                } else {
                                    return defer.resolve();
                                }
                            }
                            , () => defer.resolve());
                    } else {
                        defer.resolve();
                    }
                }
                return defer.promise;
            },

            logout() {
                let defer = $q.defer();
                let url = `${$rootScope.bb.api_url}/api/v1/login`;
                halClient.$del(url).finally(function () {
                        $rootScope.user = null;
                        $sessionStorage.removeItem("user");
                        $sessionStorage.removeItem("auth_token");
                        $cookies.remove('Auth-Token');
                        shared_header.del('auth_token');
                        return defer.resolve();
                    }
                    , () => defer.reject());
                return defer.promise;
            },

            getLogin(options) {
                let defer = $q.defer();
                let url = `${$rootScope.bb.api_url}/api/v1/login/admin/${options.company_id}`;
                halClient.$get(url, options).then(login => {
                        if (login.$has('administrator')) {
                            return login.$get('administrator').then(user => {
                                    user = this.setLogin(user);
                                    return defer.resolve(user);
                                }
                                , err => defer.reject(err));
                        } else {
                            return defer.reject();
                        }
                    }
                    , err => defer.reject(err));
                return defer.promise;
            },

            setCompany(company_id) {
                let defer = $q.defer();
                let url = `${$rootScope.bb.api_url}/api/v1/login/admin`;
                let params = {company_id};
                halClient.$put(url, {}, params).then(login => {
                        if (login.$has('administrator')) {
                            return login.$get('administrator').then(user => {
                                    user = this.setLogin(user);
                                    return defer.resolve(user);
                                }
                                , err => defer.reject(err));
                        } else {
                            return defer.reject();
                        }
                    }
                    , err => defer.reject(err));
                return defer.promise;
            }
        };

    }
);

