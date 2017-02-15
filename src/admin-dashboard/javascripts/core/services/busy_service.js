// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc service
 * @name BBAdminDashboard.BusyService
 *
 * @description
 */
angular.module('BBAdminDashboard').factory("BusyService", ($q, $log, $rootScope, AlertService, ErrorService) => {

        return {
            notLoaded(cscope) {
                cscope.$emit('show:loader', cscope);
                cscope.isLoaded = false;
                // then look through all the scopes for the 'loading' scope, which is the
                // scope which has a 'scopeLoaded' property and set it to false, which makes
                // the ladoing gif show;
                while (cscope) {
                    if (cscope.hasOwnProperty('scopeLoaded')) {
                        cscope.scopeLoaded = false;
                    }
                    cscope = cscope.$parent;
                }
            },


            setLoaded(cscope) {
                cscope.$emit('hide:loader', cscope);
                // set the scope loaded to true...
                cscope.isLoaded = true;
                // then walk up the scope chain looking for the 'loading' scope...
                let loadingFinished = true;

                while (cscope) {
                    if (cscope.hasOwnProperty('scopeLoaded')) {
                        // then check all the scope objects looking to see if any scopes are
                        // still loading
                        if ($scope.areScopesLoaded(cscope)) {
                            cscope.scopeLoaded = true;
                        } else {
                            loadingFinished = false;
                        }
                    }
                    cscope = cscope.$parent;
                }

                if (loadingFinished) {
                    return $rootScope.$broadcast('loading:finished');
                }
            },


            setPageLoaded(scope) {
                return null;
            },


            setLoadedAndShowError(scope, err, error_string) {
                $log.warn(err, error_string);
                this.setLoaded(scope);
                if (err.status === 409) {
                    if (err.data.error === 'Rule checking failed') {
                        return AlertService.danger(ErrorService.createCustomError(err.data.message));
                    } else {
                        return AlertService.danger(ErrorService.getError('ITEM_NO_LONGER_AVAILABLE'));
                    }
                } else if (err.data && (err.data.error === "Number of Bookings exceeds the maximum")) {
                    return AlertService.danger(ErrorService.getError('MAXIMUM_TICKETS'));
                } else {
                    return AlertService.danger(ErrorService.getError('GENERIC'));
                }
            },


            // go around schild scopes - return false if *any* child scope is marked as
            // isLoaded = false
            areScopesLoaded(cscope) {
                if (cscope.hasOwnProperty('isLoaded') && !cscope.isLoaded) {
                    return false;
                } else {
                    let child = cscope.$$childHead;
                    while (child) {
                        if (!$scope.areScopesLoaded(child)) {
                            return false;
                        }
                        child = child.$$nextSibling;
                    }
                    return true;
                }
            }
        };
    }
);
