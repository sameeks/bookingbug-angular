// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory('LoadingService', ($q, $window, $log, $rootScope, AlertService, ErrorService) => {

        // create a trackable loader - this in theory allows multiple trackable loading objects in a scope - meaning we're not tied to a per-scope faction
        // currently it's still just using the scope to store the status, but we're encapsulating it away so that we can change it later
        return {
            $loader(scope) {
                let lservice = this;
                let item = {
                    scope,
                    setLoaded() {
                        return lservice.setLoaded(scope);
                    },
                    setLoadedAndShowError(err, error_string) {
                        return lservice.setLoadedAndShowError(scope, err, error_string);
                    },
                    notLoaded() {
                        lservice.notLoaded(scope);
                        return this;  // return self, so you can create at set not loaded in a single line
                    }
                };
                return item;
            },


            // called from the scopes
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
                        if (this.areScopesLoaded(cscope)) {
                            cscope.scopeLoaded = true;
                        } else {
                            loadingFinished = false;
                        }
                    }
                    cscope = cscope.$parent;
                }

                if (loadingFinished) {
                    $rootScope.$broadcast('loading:finished');
                }
            },


            setLoadedAndShowError(scope, err, error_string) {
                $log.warn(err, error_string);
                scope.setLoaded(scope);
                if (err && (err.status === 409)) {
                    return AlertService.danger(ErrorService.getError('ITEM_NO_LONGER_AVAILABLE'));
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
                        if (!this.areScopesLoaded(child)) {
                            return false;
                        }
                        child = child.$$nextSibling;
                    }
                    return true;
                }
            },

            //set scope not loaded...
            notLoaded(cscope) {
                cscope.$emit('show:loader', cscope);
                cscope.isLoaded = false;
                // then look through all the scopes for the 'loading' scope, which is the
                // scope which has a 'scopeLoaded' property and set it to false, which makes
                // the ladoing gif show
                while (cscope) {
                    if (cscope.hasOwnProperty('scopeLoaded')) {
                        cscope.scopeLoaded = false;
                    }
                    cscope = cscope.$parent;
                }
            }
        };
    }
);

