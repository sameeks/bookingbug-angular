// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember.Services').factory("MemberService", ($q, halClient, $rootScope, BBModel) => {

        return {
            refresh(member) {
                let deferred = $q.defer();
                member.$flush('self');
                member.$get('self').then(member => {
                        member = new BBModel.Member.Member(member);
                        return deferred.resolve(member);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            current() {
                let deferred = $q.defer();
                let callback = () => deferred.resolve($rootScope.member);
                setTimeout(callback, 200);
                // member = () ->
                // deferred.resolve($rootScope.member)
                return deferred.promise;
            },

            updateMember(member, params) {
                let deferred = $q.defer();
                member.$put('self', {}, params).then(member => {
                        member = new BBModel.Member.Member(member);
                        return deferred.resolve(member);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            sendWelcomeEmail(member, params) {
                let deferred = $q.defer();
                member.$post('send_welcome_email', params).then(member => {
                        member = new BBModel.Member.Member(member);
                        return deferred.resolve(member);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            }
        };

    }
);
