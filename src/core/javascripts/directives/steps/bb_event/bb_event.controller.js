angular.module('BB.Controllers').controller('Event', function ($scope, $attrs, $rootScope, EventService, $q, BBModel, ValidatorService, FormDataStoreService, LoadingService) {

    let initTickets;
    let loader = LoadingService.$loader($scope).notLoaded();

    console.warn('Deprecation warning: validator.validateForm() will be removed from bbEvent in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
    $scope.validator = ValidatorService;

    $scope.event_options = $scope.$eval($attrs.bbEvent) || {};

    let ticket_refs = [];

    FormDataStoreService.init('Event', $scope, [
        'selected_tickets',
        'event_options'
    ]);

    $rootScope.connection_started.then(function () {

            if ($scope.bb.company) {
                return init($scope.bb.company);
            }
        }

        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));


    var init = function (comp) {

        // clear selected tickets if there are no stacked items (i.e. because a new event has been selected)
        if ($scope.bb.stacked_items && ($scope.bb.stacked_items.length === 0)) {
            delete $scope.selected_tickets;
        }

        $scope.event = $scope.bb.current_item.event;

        $scope.event_options.use_my_details = ($scope.event_options.use_my_details == null) ? true : $scope.event_options.use_my_details;

        let promises = [
            $scope.bb.current_item.event_group.$getImages(),
            $scope.event.prepEvent()
        ];

        if ($scope.client) {
            promises.push($scope.getPrePaidsForEvent($scope.client, $scope.event));
        }

        return $q.all(promises).then(function (result) {

                let images;
                if (result[0] && (result[0].length > 0)) {
                    images = result[0];
                }
                let event = result[1];
                if (result[2] && (result[2].length > 0)) {
                    let prepaids = result[2];
                }

                $scope.event = event;

                if (images) {
                    initImage(images);
                }

                if ($scope.bb.current_item.tickets && ($scope.bb.current_item.tickets.qty > 0)) {

                    // flag that we're editing tickets already in the basket so that view can indicate this
                    $scope.edit_mode = true;

                    // already added to the basket
                    loader.setLoaded();
                    $scope.selected_tickets = true;

                    // set tickets and current tickets items as items with the same event id
                    $scope.current_ticket_items = _.filter($scope.bb.basket.timeItems(), item => item.event_id === $scope.event.id);

                    $scope.tickets = ((() => {
                        let result1 = [];
                        for (let item of Array.from($scope.current_ticket_items)) {
                            result1.push(item.tickets);
                        }
                        return result1;
                    })());

                    $scope.$watch('current_ticket_items', (items, olditems) => $scope.bb.basket.total_price = $scope.bb.basket.totalPrice()
                        , true);
                    return;

                } else {

                    initTickets();
                }

                $scope.$broadcast("bbEvent:initialised");

                return loader.setLoaded();
            }

            , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
    };


    /***
     * @ngdoc method
     * @name selectTickets
     * @methodOf BB.Directives:bbEvent
     * @description
     * Processes the selected tickets and adds them to the basket
     */
    $scope.selectTickets = function () {

        let item, ref;
        loader.notLoaded();
        $scope.bb.emptyStackedItems();
        // NOTE: basket is not cleared here as we might already have one!

        let base_item = $scope.bb.current_item;

        for (let ticket of Array.from($scope.event.tickets)) {
            if (ticket.qty) {
                switch ($scope.event.chain.ticket_type) {
                    case "single_space":
                        for (let c = 1, end = ticket.qty, asc = 1 <= end; asc ? c <= end : c >= end; asc ? c++ : c--) {
                            item = new BBModel.BasketItem();
                            ({ref} = item);
                            angular.extend(item, base_item);
                            item.ref = ref;
                            ticket_refs.push(item.ref);
                            delete item.id;
                            item.tickets = angular.copy(ticket);
                            item.tickets.qty = 1;
                            $scope.bb.stackItem(item);
                        }
                        break;
                    case "multi_space":
                        item = new BBModel.BasketItem();
                        ({ref} = item);
                        angular.extend(item, base_item);
                        item.ref = ref;
                        ticket_refs.push(item.ref);
                        item.tickets = angular.copy(ticket);
                        delete item.id;
                        item.tickets.qty = ticket.qty;
                        $scope.bb.stackItem(item);
                        break;
                }
            }
        }

        // ok so we have them as stacked items
        // now push the stacked items to a basket
        if ($scope.bb.stacked_items.length === 0) {
            loader.setLoaded();
            return;
        }

        $scope.bb.pushStackToBasket();

        return $scope.updateBasket().then(() => {

                // basket has been saved
                loader.setLoaded();
                $scope.selected_tickets = true;
                $scope.stopTicketWatch();

                // set tickets and current tickets items as the newly created basket items
                $scope.current_ticket_items = _.filter($scope.bb.basket.timeItems(), item => _.contains(ticket_refs, item.ref));

                $scope.tickets = ((() => {
                    let result = [];
                    for (item of Array.from($scope.current_ticket_items)) {
                        result.push(item.tickets);
                    }
                    return result;
                })());

                // watch the basket items so the price is updated
                return $scope.$watch('current_ticket_items', (items, olditems) => $scope.bb.basket.total_price = $scope.bb.basket.totalPrice()
                    , true);
            }

            , err => $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong'));
    };


    /***
     * @ngdoc method
     * @name selectItem
     * @methodOf BB.Directives:bbEvent
     * @description
     * Select an item event in according of item and route parameter
     *
     * @param {array} item The Event or BookableItem to select
     * @param {string=} route A specific route to load
     */
    $scope.selectItem = (item, route) => {
        if ($scope.$parent.$has_page_control) {
            $scope.event = item;
            return false;
        } else {
            $scope.bb.current_item.setEvent(item);
            $scope.bb.current_item.ready = false;
            $scope.decideNextPage(route);
            return true;
        }
    };


    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbEvent
     * @description
     * Set this page section as ready
     */
    $scope.setReady = () => {

        for (let item of Array.from($scope.current_ticket_items)) {
            item.setEvent($scope.event);
        }

        $scope.bb.event_details = {
            name: $scope.event.chain.name,
            image: $scope.event.image,
            address: $scope.event.chain.address,
            datetime: $scope.event.date,
            end_datetime: $scope.event.end_datetime,
            duration: $scope.event.duration,
            tickets: $scope.event.tickets
        };

        if ($scope.event_options.suppress_basket_update) {
            return true;
        } else {
            return $scope.updateBasket();
        }
    };


    /***
     * @ngdoc method
     * @name getPrePaidsForEvent
     * @methodOf BB.Directives:bbEvent
     * @description
     * Get pre paids for event in according of client and event parameter
     *
     * @param {array} client The client
     * @param {array} event The event
     */
    $scope.getPrePaidsForEvent = function (client, event) {
        let defer = $q.defer();
        let params = {event_id: event.id};
        client.$getPrePaidBookings(params).then(function (prepaids) {
                $scope.pre_paid_bookings = prepaids;
                return defer.resolve(prepaids);
            }
            , err => defer.reject(err));
        return defer.promise;
    };


    var initImage = function (images) {
        let image = images[0];
        if (image) {
            image.background_css = {'background-image': `url(${image.url})`};
            return $scope.event.image = image;
        }
    };
    // TODO pick most promiment image
    // colorThief = new ColorThief()
    // colorThief.getColor image.url


    return initTickets = function () {

        // no need to init tickets if some have been selected already
        if ($scope.selected_tickets) {
            return;
        }

        // if a default number of tickets is provided, set only the first ticket type to that default
        $scope.event.tickets[0].qty = $scope.event_options.default_num_tickets ? $scope.event_options.default_num_tickets : 0;

        // for multiple ticket types (adult entry/child entry etc), default all to zero except for the first ticket type
        if ($scope.event.tickets.length > 1) {
            for (let ticket of Array.from($scope.event.tickets.slice(1))) {
                ticket.qty = 0;
            }
        }

        // lock the ticket number dropdown box if only 1 ticket is available to puchase at a time (one-on-one training etc)
        if ($scope.event_options.default_num_tickets && $scope.event_options.auto_select_tickets && ($scope.event.tickets.length === 1) && ($scope.event.tickets[0].max_num_bookings === 1)) {
            $scope.selectTickets();
        }

        $scope.tickets = $scope.event.tickets;
        $scope.bb.basket.total_price = $scope.bb.basket.totalPrice();
        return $scope.stopTicketWatch = $scope.$watch('tickets', function (tickets, oldtickets) {
                $scope.bb.basket.total_price = $scope.bb.basket.totalPrice();
                return $scope.event.updatePrice();
            }
            , true);
    };
});
