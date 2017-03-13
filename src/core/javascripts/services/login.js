angular.module('BB.Services').factory("LoginService", ($q, halClient, $rootScope, BBModel, $sessionStorage, $localStorage) => {

        return {
            companyLogin(company, params, form) {
                let deferred = $q.defer();
                company.$post('login', params, form).then(login => {
                        return login.$get('member').then(member => {
                                this.setLogin(member);
                                return deferred.resolve(member);
                            }
                            , err => {
                                return deferred.reject(err);
                            }
                        );
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },


            login(form, options) {
                let deferred = $q.defer();
                if (!options['root']) {
                    options['root'] = "";
                }
                let url = options['root'] + "/api/v1/login";
                halClient.$post(url, options, form).then(login => {
                        return login.$get('member').then(member => {
                                this.setLogin(member);
                                return deferred.resolve(member);
                            }
                        );
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },


            FBLogin(company, prms) {
                let deferred = $q.defer();
                company.$post('facebook_login', {}, prms).then(login => {
                        return login.$get('member').then(member => {
                                member = new BBModel.Member.Member(member);
                                $sessionStorage.setItem("fb_user", true);
                                this.setLogin(member);
                                return deferred.resolve(member);
                            }
                            , err => {
                                return deferred.reject(err);
                            }
                        );
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },


            companyQuery: id => {
                if (id) {
                    let comp_promise = halClient.$get(location.protocol + '//' + location.host + '/api/v1/company/' + id);
                    return comp_promise.then(company => {
                            return company = new BBModel.Company(company);
                        }
                    );
                }
            },


            memberQuery: params => {
                if (params.member_id && params.company_id) {
                    let member_promise = halClient.$get(location.protocol + '//' + location.host + `/api/v1/${params.company_id}/` + "members/" + params.member_id);
                    return member_promise.then(member => {
                            return member = new BBModel.Member.Member(member);
                        }
                    );
                }
            },


            ssoLogin(options, data) {
                let deferred = $q.defer();
                if (!options['root']) {
                    options['root'] = "";
                }
                let url = options['root'] + "/api/v1/login/sso/" + options['company_id'];
                halClient.$post(url, {}, data).then(login => {
                        return login.$get('member').then(member => {
                                member = new BBModel.Member.Member(member);
                                this.setLogin(member, true);
                                return deferred.resolve(member);
                            }
                        );
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },


            // check if we're logged in as a member - but not an admin
            isLoggedIn() {
                this.checkLogin();
                return $rootScope.member && (!$rootScope.user || ($rootScope.user === undefined));
            },


            setLogin(member, persist) {
                let auth_token = member.getOption('auth_token');
                member = new BBModel.Member.Member(member);
                $sessionStorage.setItem("login", member.$toStore());
                $sessionStorage.setItem("auth_token", auth_token);
                $rootScope.member = member;
                if (persist) {
                    $localStorage.setItem("auth_token", auth_token);
                }
                return member;
            },


            member() {
                this.checkLogin();
                return $rootScope.member;
            },


            checkLogin() {
                if ($rootScope.member) {
                    return true;
                }

                let member = $sessionStorage.getItem("login");
                if (member) {
                    member = halClient.createResource(member);
                    $rootScope.member = new BBModel.Member.Member(member);
                    return true;
                } else {
                    return false;
                }
            },


            logout(options) {

                $rootScope.member = null;
                let deferred = $q.defer();

                if (!options) {
                    options = {};
                }
                if (!options['root']) {
                    options['root'] = "";
                }
                let url = options['root'] + "/api/v1/logout";

                $sessionStorage.clear();
                $localStorage.clear();

                halClient.$del(url, options, {}).then(logout => {
                        $sessionStorage.clear();
                        $localStorage.clear();
                        return deferred.resolve(true);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },


            FBLogout(options) {
                $sessionStorage.removeItem("fb_user");
                return this.logout(options);
            },


            sendPasswordReset(company, params) {
                let deferred = $q.defer();
                company.$post('email_password_reset', {}, params).then(() => {
                        return deferred.resolve(true);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },


            updatePassword(member, params) {
                params.auth_token = member.getOption('auth_token');
                if (member && params['new_password'] && params['confirm_new_password']) {
                    let deferred = $q.defer();
                    member.$post('update_password', {}, params).then(login => {
                            return login.$get('member').then(member => {
                                    this.setLogin(member, params.persist_login);
                                    return deferred.resolve(member);
                                }
                                , err => {
                                    return deferred.reject(err);
                                }
                            );
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                    return deferred.promise;
                }
            }
        };
    }
);

