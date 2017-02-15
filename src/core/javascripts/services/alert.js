/***
 * @ngdoc service
 * @name BB.Services:Alert
 *
 * @description
 * Representation of an Alert Object
 *
 * @property {array} alerts The array with all types of alerts
 * @property {string} add Add alert message
 *///

angular.module('BB.Services').factory('AlertService', function ($rootScope, ErrorService, $timeout, $translate) {

    let alertService;
    $rootScope.alerts = [];

    /***
     * @ngdoc method
     * @name titleLookup
     * @methodOf BB.Services:Alert
     * @description
     * Title look up in according of type and title parameters
     *
     * @returns {boolean} The returned title
     */
    let titleLookup = function (type, title) {
        if (title) {
            return title;
        }
        switch (type) {
            case "error":
            case "danger":
                title = $translate.instant('CORE.ERROR_HEADING');
                break;
            default:
                title = null;
        }
        return title;
    };

    return alertService = {
        add(type, {title, msg, persist}) {
            if (persist == null) {
                persist = true;
            }
            $rootScope.alerts = [];
            let alert = {
                type,
                title: titleLookup(type, title),
                msg,
                close() {
                    return alertService.closeAlert(this);
                }
            };
            $rootScope.alerts.push(alert);
            if (!persist) {
                $timeout(() => $rootScope.alerts.splice($rootScope.alerts.indexOf(alert), 1)
                    , 3000);
            }
            return $rootScope.$broadcast("alert:raised");
        },


        /***
         * @ngdoc method
         * @name closeAlert
         * @methodOf BB.Services:Alert
         * @description
         * Close alert
         *
         * @returns {boolean}  close alert
         */
        closeAlert(alert) {
            return this.closeAlertIdx($rootScope.alerts.indexOf(alert));
        },

        /***
         * @ngdoc method
         * @name closeAlertIdx
         * @methodOf BB.Services:Alert
         * @description
         * Close alert index
         *
         * @returns {boolean}  The returned close alert index
         */
        closeAlertIdx(index) {
            return $rootScope.alerts.splice(index, 1);
        },

        /***
         * @ngdoc method
         * @name clear
         * @methodOf BB.Services:Alert
         * @description
         * Clear alert message
         *
         * @returns {array} Newly clear array of the alert messages
         */
        clear() {
            return $rootScope.alerts = [];
        },

        /***
         * @ngdoc error
         * @name clear
         * @methodOf BB.Services:Alert
         * @description
         * Error alert
         *
         * @returns {array} The returned error alert
         */
        error(alert) {
            if (!alert) {
                return;
            }
            return this.add('error', {title: alert.title, msg: alert.msg, persist: alert.persist});
        },

        /***
         * @ngdoc error
         * @name danger
         * @methodOf BB.Services:Alert
         * @description
         * Danger alert
         *
         * @returns {array} The returned danger alert
         */
        danger(alert) {
            if (!alert) {
                return;
            }
            return this.add('danger', {title: alert.title, msg: alert.msg, persist: alert.persist});
        },

        /***
         * @ngdoc error
         * @name info
         * @methodOf BB.Services:Alert
         * @description
         * Info alert
         *
         * @returns {array} The returned info alert
         */
        info(alert) {
            if (!alert) {
                return;
            }
            return this.add('info', {title: alert.title, msg: alert.msg, persist: alert.persist});
        },

        /***
         * @ngdoc error
         * @name warning
         * @methodOf BB.Services:Alert
         * @description
         * Warning alert
         *
         * @returns {array} The returned warning alert
         */
        warning(alert) {
            if (!alert) {
                return;
            }
            return this.add('warning', {title: alert.title, msg: alert.msg, persist: alert.persist});
        },


        /***
         * @ngdoc error
         * @name success
         * @methodOf BB.Services:Alert
         * @description
         * Success alert
         *
         * @returns {array} The returned warning alert
         */
        success(alert) {
            if (!alert) {
                return;
            }
            return this.add('success', {title: alert.title, msg: alert.msg, persist: alert.persist});
        },


        /***
         * @ngdoc error
         * @name raise
         * @methodOf BB.Services:Alert
         * @description
         * Raise alert
         *
         * @returns {array} The returned raise alert
         */
        raise(key) {
            if (!key) {
                return;
            }
            let alert = ErrorService.getAlert(key);
            if (alert) {
                return this.add(alert.type, {title: alert.title, msg: alert.msg, persist: alert.persist});
            }
        }
    };
});

