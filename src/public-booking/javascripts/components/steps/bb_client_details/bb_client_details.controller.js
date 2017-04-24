angular.module('BB.Controllers').controller('ClientDetails', function ($scope, $attrs, $rootScope, LoginService, ValidatorService, AlertService, LoadingService, BBModel) {

    let handleError;
    let loader = LoadingService.$loader($scope).notLoaded();

    console.warn('Deprecation warning: validator.validateForm() will be removed from bbClientDetails in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
    $scope.validator = ValidatorService;

    $scope.existing_member = false;
    $scope.login_error = false;


    let options = $scope.$eval($attrs.bbClientDetails) || {};
    $scope.suppress_client_create = ($attrs.bbSuppressCreate != null) || options.suppress_client_create;

    $rootScope.connection_started.then(() => $scope.initClientDetails()

        , err => loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong'));


    $rootScope.$watch('member', function (oldmem, newmem) {
        if (!$scope.client.valid() && LoginService.isLoggedIn()) {
            return $scope.setClient(new BBModel.Client(LoginService.member()._data));
        }
    });


    /***
     * @ngdoc method
     * @name initClientDetails
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * initialise the client object
     */
    $scope.initClientDetails = function () {

        if (!$scope.client.valid() && LoginService.isLoggedIn()) {
            // make sure we set the client to the currently logged in member
            // we should also just check the logged in member is a member of the company they are currently booking with
            $scope.setClient(new BBModel.Client(LoginService.member()._data));
        }

        if (LoginService.isLoggedIn() && LoginService.member().$has("child_clients") && LoginService.member()) {
            LoginService.member().$getChildClients().then(children => {
                    $scope.bb.parent_client = new BBModel.Client(LoginService.member()._data);
                    $scope.bb.child_clients = children;
                    return $scope.bb.basket.parent_client_id = $scope.bb.parent_client.id;
                }
            );
        }

        if ($scope.client.client_details) {
            $scope.client_details = $scope.client.client_details;
            if ($scope.client_details.questions) {
                BBModel.Question.$checkConditionalQuestions($scope.client_details.questions);
            }
            return loader.setLoaded();
        } else {
            return BBModel.ClientDetails.$query($scope.bb.company).then(details => {
                    $scope.client_details = details;
                    if ($scope.client) {
                        $scope.client.pre_fill_answers($scope.client_details);
                    }
                    if ($scope.client_details.questions) {
                        BBModel.Question.$checkConditionalQuestions($scope.client_details.questions);
                    }
                    return loader.setLoaded();
                }
                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
        }
    };


    /***
     * @ngdoc method
     * @name validateClient
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Validate the client
     *
     * @param {string=} route A specific route to load
     */
    $scope.validateClient = route => {
        loader.notLoaded();
        $scope.existing_member = false;

        // we need to validate teh client information has been correctly entered here
        if ($scope.bb && $scope.bb.parent_client) {
            $scope.client.parent_client_id = $scope.bb.parent_client.id;
        }
        $scope.client.setClientDetails($scope.client_details);

        return BBModel.Client.$create_or_update($scope.bb.company, $scope.client).then(client => {
                loader.setLoaded();
                $scope.setClient(client);
                if ($scope.bb.isAdmin) {
                    $scope.client.setValid(true);
                }
                $scope.existing_member = false;
                return $scope.decideNextPage(route);
            }
            , err => handleError(err));
    };


    /***
     * @ngdoc method
     * @name clientLogin
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Client login
     */
    $scope.clientLogin = () => {
        $scope.login_error = false;
        if ($scope.login) {
            return LoginService.companyLogin($scope.bb.company, {}, {
                email: $scope.login.email,
                password: $scope.login.password
            }).then(client => {
                    $scope.setClient(new BBModel.Client(client));
                    $scope.login_error = false;
                    return $scope.decideNextPage();
                }
                , function (err) {
                    $scope.login_error = true;
                    loader.setLoaded();
                    return AlertService.raise('LOGIN_FAILED');
                });
        }
    };


    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
     */
    $scope.setReady = () => {

        $scope.client.setClientDetails($scope.client_details);

        if (!$scope.suppress_client_create) {

            let prom = BBModel.Client.$create_or_update($scope.bb.company, $scope.client);
            prom.then(client => {
                    loader.setLoaded();
                    $scope.setClient(client);
                    if (client.waitingQuestions) {
                        return client.gotQuestions.then(() => $scope.client_details = client.client_details);
                    }
                }
                , err => handleError(err));
            return prom;

        } else {

            return true;
        }
    };


    /***
     * @ngdoc method
     * @name clientSearch
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Client search
     */
    $scope.clientSearch = function () {
        if (($scope.client != null) && ($scope.client.email != null) && ($scope.client.email !== "")) {
            loader.notLoaded();
            return BBModel.Client.$query_by_email($scope.bb.company, $scope.client.email).then(function (client) {
                    if (client != null) {
                        $scope.setClient(client);
                        $scope.client = client;
                    }
                    return loader.setLoaded();
                }
                , err => loader.setLoaded());
        } else {
            $scope.setClient({});
            return $scope.client = {};
        }
    };


    /***
     * @ngdoc method
     * @name switchNumber
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Switch number
     *
     * @param {array} to Switch number to mobile
     */
    $scope.switchNumber = function (to) {
        $scope.no_mobile = !$scope.no_mobile;
        if (to === 'mobile') {
            $scope.bb.basket.setSettings({send_sms_reminder: true});
            return $scope.client.phone = null;
        } else {
            $scope.bb.basket.setSettings({send_sms_reminder: false});
            return $scope.client.mobile = null;
        }
    };


    /***
     * @ngdoc method
     * @name getQuestion
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Get question by id
     *
     * @param {integer} id The id question
     */
    $scope.getQuestion = function (id) {
        for (let question of Array.from($scope.client_details.questions)) {
            if (question.id === id) {
                return question;
            }
        }

        return null;
    };


    /***
     * @ngdoc method
     * @name useClient
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Use client by client
     *
     * @param {array} client The client
     */
    $scope.useClient = client => $scope.setClient(client);


    /***
     * @ngdoc method
     * @name recalc_question
     * @methodOf BB.Directives:bbClientDetails
     * @description
     * Recalculate question
     */
    $scope.recalc_question = function () {
        if ($scope.client_details.questions) {
            return BBModel.Question.$checkConditionalQuestions($scope.client_details.questions);
        }
    };


    return handleError = function (error) {
        if (error.data.error === "Please Login") {
            $scope.existing_member = true;
            AlertService.raise('ALREADY_REGISTERED');
        } else if (error.data.error === "Invalid Password") {
            AlertService.raise('PASSWORD_INVALID');
        }
        return loader.setLoaded();
    };
});
