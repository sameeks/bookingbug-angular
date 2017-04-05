let BBPeopleCtrl = function ($scope, $rootScope, $q, BBModel, PersonModel, FormDataStoreService, ValidatorService, LoadingService) {
    'ngInject';

    let new_person;
    this.$scope = $scope;

    let loader = null;

    let init = function () {
        $scope.selectItem = selectItem;
        $scope.selectAndRoute = selectAndRoute;
        $scope.setReady = setReady;

        loader = LoadingService.$loader($scope).notLoaded();

        $rootScope.connection_started.then(connectionStartedSuccess, connectionStartedFailure);
        $scope.$watch('person', personListener);
        $scope.$on("currentItemUpdate", currentItemUpdateHandler);

    };

    var connectionStartedSuccess = () => loadData();

    var connectionStartedFailure = err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong');

    var currentItemUpdateHandler = event => loadData();

    var loadData = function () {
        let bi = $scope.booking_item;

        if (!angular.isObject(bi.service) && !angular.isObject(bi.resource)) {
            loader.setLoaded();
            $scope.bb.company.$getPeople().then(people=>$scope.bookable_items = people);
            return;
        }

        loader.notLoaded();

        let ppromise = BBModel.Person.$query($scope.bb.company);
        ppromise.then(function (people) {
            if (bi.group) { // check they're part of any currently selected group
                people = people.filter(x => !x.group_id || (x.group_id === bi.group));
            }
            return $scope.all_people = people;
        }, function (err) { 
            console.log('Error: ', err); 
        });

        return BBModel.BookableItem.$query({
            company: $scope.bb.company,
            cItem: bi,
            wait: ppromise,
            item: 'person'
        }).then(function (items) {
            if (bi.group) { // check they're part of any currently selected group
                items = items.filter(x => !x.group_id || (x.group_id === bi.group));
            }

            let promises = [];
            for (var i of Array.from(items)) {
                promises.push(i.promise);
            }

            $q.all(promises).then(res => {
                    let person;
                    let people = [];
                    for (i of Array.from(items)) {
                        people.push(i.item);
                        if (bi && bi.person && (bi.person.id === i.item.id)) {
                            if ($scope.bb.current_item.settings.person !== -1) {
                                $scope.person = i.item;
                            }
                            $scope.selected_bookable_items = [i];
                        }
                    }

                    // if there's only 1 person and combine resources/staff has been turned on, auto select the person
                    // OR if the person has been passed into item_defaults, skip to next step
                    if ((items.length === 1) && $scope.bb.company.settings && $scope.bb.company.settings.merge_people) {
                        person = items[0];
                    }

                    if ($scope.bb.current_item.defaults.person) {
                        ({person} = $scope.bb.current_item.defaults);
                    }

                    if (person && !$scope.selectItem(person, $scope.nextRoute, {skip_step: true})) {
                        setPerson(people);
                        $scope.bookable_items = items;
                        $scope.selected_bookable_items = items;
                    } else {
                        setPerson(people);
                        $scope.bookable_items = items;
                        if (!$scope.selected_bookable_items) {
                            $scope.selected_bookable_items = items;
                        }
                    }
                    return loader.setLoaded();
                }
                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

            return ppromise['finally'](() => loader.setLoaded());
        }, function (err) {
            console.log('Error: ',err);
        });
    };

    // we're storing the person property in the form store but the angular select
    // menu has to have a reference to the same object memory address for it to
    // appear as selected as it's ng-model property is a Person object.
    var setPerson = function (people) {
        $scope.bookable_people = people;
        if ($scope.person) {
            return _.each(people, function (person) {
                if (person.id === $scope.person.id) {
                    return $scope.person = person;
                }
            });
        }
    };

    let getItemFromPerson = person => {
        if (person instanceof PersonModel) {
            if ($scope.bookable_items) {
                for (let item of Array.from($scope.bookable_items)) {
                    if (item.self === person.self) {
                        return item;
                    }
                }
            }
        }
        return person;
    };

    /**
     * @ngdoc method
     * @name selectItem
     * @methodOf BB.Directives:bbPeople
     * @description
     * Select an item into the current person list in according of item and route parameters
     *
     * @param {array} item Selected item from the list of current people
     * @param {string=} route A specific route to load
     */
    var selectItem = (item, route, options) => {
        if (options == null) {
            options = {};
        }
        if ($scope.$parent.$has_page_control) {
            $scope.person = item;
            return false;
        } else {
            new_person = getItemFromPerson(item);
            _.each($scope.booking_items, bi => bi.setPerson(new_person));
            if (options.skip_step) {
                $scope.skipThisStep();
            }
            $scope.decideNextPage(route);
            return true;
        }
    };

    /**
     * @ngdoc method
     * @name selectAndRoute
     * @methodOf BB.Directives:bbPeople
     * @description
     * Select and route person from list in according of item and route parameters
     *
     * @param {array} item Selected item from the list of current people
     * @param {string} route A specific route to load
     */
    var selectAndRoute = (item, route) => {
        new_person = getItemFromPerson(item);
        _.each($scope.booking_items, bi => bi.setPerson(new_person));
        $scope.decideNextPage(route);
        return true;
    };

    var personListener = (newval, oldval) => {
        if ($scope.person && $scope.booking_item) {
            if (!$scope.booking_item.person || ($scope.booking_item.person.self !== $scope.person.self)) { // only set and broadcast if it's changed
                new_person = getItemFromPerson($scope.person);
                _.each($scope.booking_items, item => item.setPerson(new_person));
                $scope.broadcastItemUpdate();
            }
        } else if (newval !== oldval) {
            _.each($scope.booking_items, item => item.setPerson(null));
            $scope.broadcastItemUpdate();
        }

        $scope.bb.current_item.defaults.person = $scope.person;
    };

    /**
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbPeople
     * @description
     * Called by bbPage to ready directive for transition to the next step
     */
    var setReady = () => {
        if ($scope.person) {
            new_person = getItemFromPerson($scope.person);
            _.each($scope.booking_items, item => item.setPerson(new_person));
            return true;
        } else {
            _.each($scope.booking_items, item => item.setPerson(null));
            return true;
        }
    };

    init();

};


angular.module('BB.Controllers').controller('BBPeopleCtrl', BBPeopleCtrl);
