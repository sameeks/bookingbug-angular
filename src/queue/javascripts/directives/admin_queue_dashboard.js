// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue').directive('bbIfLogin', function ($q, $compile, BBModel) {

    let compile = () =>
            ({
                pre(scope, element, attributes) {
                    this.whenready = $q.defer();
                    scope.loggedin = this.whenready.promise;
                    return BBModel.Admin.Company.$query(attributes).then(function (company) {
                        scope.company = company;
                        return this.whenready.resolve();
                    });
                }
                ,
                post(scope, element, attributes) {
                }
            })
        ;

    let link = function (scope, element, attrs) {
    };
    return {
        compile: $compile
    };
});


angular.module('BBQueue').directive('bbQueueDashboard', function () {

    let link = (scope, element, attrs) =>
            scope.loggedin.then(() => scope.getSetup())
        ;

    return {
        link,
        controller: 'bbQueueDashboardController'
    };
});


angular.module('BBQueue').directive('bbQueues', function () {

    let link = (scope, element, attrs) =>
            scope.loggedin.then(() => scope.getQueues())
        ;

    return {
        link,
        controller: 'bbQueues'
    };
});

angular.module('BBQueue').directive('bbQueueServers', function () {

    let link = (scope, element, attrs) =>
            scope.loggedin.then(() => scope.getServers())
        ;

    return {
        link,
        controller: 'bbQueueServers'
    };
});

