angular.module('BBAdminBooking').directive('bbAdminBookingClients', () => {
        return {
            restrict: 'AE',
            replace: false,
            scope: true,
            controller: 'adminBookingClients',
            templateUrl: 'admin_booking_clients.html'
        };
    }
);


angular.module('BBAdminBooking').controller('adminBookingClients', function ($scope, $rootScope, $q, AlertService, ValidatorService, ErrorService, $log, BBModel, $timeout, LoadingService, AdminBookingOptions, $translate) {

    console.warn('Deprecation warning: validator.validateForm() will be removed from bbAdminBookingClients in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
    $scope.validator = ValidatorService;

    $scope.admin_options = AdminBookingOptions;
    $scope.clients = new BBModel.Pagination({page_size: 10, max_size: 5, request_page_size: 10});
    let loader = LoadingService.$loader($scope);

    $scope.sort_by_options = [
        {key: 'first_name', name: $translate.instant('ADMIN_BOOKING.CUSTOMER.SORT_BY_FIRST_NAME')},
        {key: 'last_name', name: $translate.instant('ADMIN_BOOKING.CUSTOMER.SORT_BY_LAST_NAME')},
        {key: 'email', name: $translate.instant('ADMIN_BOOKING.CUSTOMER.SORT_BY_EMAIL')}
    ];

    $scope.sort_by = $scope.sort_by_options[0].key;


    $rootScope.connection_started.then(() => $scope.clearClient());

    $scope.selectClient = (client, route) => {
        $scope.setClient(client);
        $scope.client.setValid(true);
        return $scope.decideNextPage(route);
    };


    $scope.createClient = route => {

        loader.notLoaded();

        // we need to validate the client information has been correctly entered here
        if ($scope.bb && $scope.bb.parent_client) {
            $scope.client.parent_client_id = $scope.bb.parent_client.id;
        }

        if ($scope.client_details) {
            $scope.client.setClientDetails($scope.client_details);
        }

        return BBModel.Client.$create_or_update($scope.bb.company, $scope.client).then(client => {
                loader.setLoaded();
                return $scope.selectClient(client, route);
            }
            , function (err) {

                if (err.data && (err.data.error === "Please Login")) {
                    loader.setLoaded();
                    return AlertService.raise('EMAIL_IN_USE');
                } else if (err.data && (err.data.error === "Sorry, it appears that this phone number already exists")) {
                    loader.setLoaded();
                    return AlertService.raise('PHONE_NUMBER_IN_USE');
                } else {
                    return loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
                }
            });
    };


    $scope.getClients = function (params, options) {

        if (options == null) {
            options = {};
        }
        $scope.search_triggered = true;

        $timeout(() => $scope.search_triggered = false
            , 1000);

        if (!params || (params && !params.filter_by)) {
            return;
        }

        $scope.params = {
            company: params.company || $scope.bb.company,
            per_page: params.per_page || $scope.clients.request_page_size,
            filter_by: params.filter_by,
            search_by_fields: params.search_by_fields || 'phone,mobile',
            order_by: params.order_by || $scope.sort_by,
            order_by_reverse: params.order_by_reverse,
            page: params.page || 1
        };
        if (AdminBookingOptions.use_default_company_id) {
            $scope.params.default_company_id = $scope.bb.company.id;
        }

        $scope.notLoaded($scope);

        return BBModel.Admin.Client.$query($scope.params).then(function (result) {

            $scope.search_complete = true;

            if (options.add) {
                $scope.clients.add(params.page, result.items);
            } else {
                $scope.clients.initialise(result.items, result.total_entries);
            }

            return loader.setLoaded();
        });
    };


    $scope.searchClients = function (search_text) {
        let defer = $q.defer();
        let params = {
            filter_by: search_text,
            company: $scope.bb.company
        };
        if (AdminBookingOptions.use_default_company_id) {
            params.default_company_id = $scope.bb.company.id;
        }
        BBModel.Admin.Client.$query(params).then(clients => {
                return defer.resolve(clients.items);
            }
        );
        return defer.promise;
    };


    $scope.typeHeadResults = function ($item, $model, $label) {

        let item = $item;
        $scope.client = item;

        return $scope.selectClient($item);
    };


    $scope.clearSearch = function () {
        $scope.clients.initialise();
        $scope.typeahead_result = null;
        return $scope.search_complete = false;
    };


    $scope.edit = item => $log.info("not implemented");


    $scope.pageChanged = function () {

        let [items_present, page_to_load] = Array.from($scope.clients.update());

        if (!items_present) {
            $scope.params.page = page_to_load;
            return $scope.getClients($scope.params, {add: true});
        }
    };


    return $scope.sortChanged = function (sort_by) {
        $scope.params.order_by = sort_by;
        $scope.params.page = 1;
        return $scope.getClients($scope.params);
    };
});
