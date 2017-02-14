// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// Filters
angular.module('BB.Services').factory('FormDataStoreService', function ($rootScope,
                                                                        $window, $log, $parse) {

    let registeredWidgetArr = [];
    let dataStore = {};
    let toId = 0; // timeout id
    let div = '___';

    // enabale this to see datastore log info
    let log = function () {
    };
    //  $log.debug.apply(this, arguments)

    // displays datastore info. only handy for development purposes
    let showInfo = () => log(dataStore);
    // log registeredWidgetArr

    // utility to set values on the scope if they are undefined. avoids issue if
    // value is false.
    let setIfUndefined = function (keyName, val) {
        let scope = this;
        let getter = $parse(keyName);

        if (typeof getter(scope) === 'undefined') {
            return getter.assign(scope, val);
        }
    };


    // resets the scope values. when the clear method is called it removes the
    // values from the datastore but it doesn't reset the values on the scope,
    // which means the values on the scope are added back into the datastore on the
    // next digest. so we have to reset them as well.
    let resetValuesOnScope = function (scope, props) {
        for (let prop of Array.from(props)) {
            prop = $parse(prop);
            let setter = prop.assign;
            setter(scope, null);
        }
    };


    // clear all form data stored in dataStore if scope is passed in. if datastore
    // key is passed in then just delete that instance. 'keepScopeValues' stops the
    // values on the scope object being reset. so the datastore is cleared but not
    // the scope. this is really only necessary when the destroy method is called.
    let clear = function (scope, keepScopeValues) {
        let data;
        if (!scope) {
            throw new Error('Missing scope object. Cannot clear form data without scope');
        }

        // check for datastore key first
        if (_.isString(scope)) {
            data = dataStore[scope];
            if (!keepScopeValues) {
                resetValuesOnScope(data[0], data[1]);
            }
            delete dataStore[scope];
            return;
        }

        scope = getParentScope(scope);
        // destroy all data
        if (scope && scope.bb) {
            let widgetId = scope.bb.uid;
            removeWidget(scope);

            for (let key in dataStore) {
                data = dataStore[key];
                if (key.indexOf(widgetId) !== -1) {
                    // remove any event handlers if the have been set in setListeners().
                    if (data[3]) {
                        _.each(data[3], function (func) {
                            // angular returns a function when setting listeners, which when
                            // called removes the listener.
                            if (_.isFunction(func)) {
                                return func();
                            }
                        });
                    }
                    // remove the stored data
                    if (!keepScopeValues) {
                        resetValuesOnScope(data[0], data[1]);
                    }
                    delete dataStore[key];
                }
            }
        }
    };


    // called after digest loop finishes. loop through the properties on the scope
    // and store the values if they are registered
    let storeFormData = function () {
        log('formDataStore ->', dataStore);
        for (let key in dataStore) {
            let step = dataStore[key];
            log('\t', key);
            let scope = step[0]; // scope object
            let props = step[1]; // array of key names
            let ndata = step[2]; // object containing stored values, matching names in props

            if (!ndata) {
                ndata = step[2] = {};
            }

            for (let prop of Array.from(props)) {
                let val = ndata[prop];
                // destroy the data here
                if (val === 'data:destroyed') {
                    ndata[prop] = null;
                } else {
                    val = angular.copy((scope.$eval(prop)));
                    ndata[prop] = val;
                }
                log('\t\t', prop, val);
            }
            // log 1, step
            log('\n');
        }
    };


    // put the stored values back onto the scope object.
    let setValuesOnScope = function (currentPage, scope) {
        let cpage = dataStore[currentPage];
        let storedValues = cpage[2];
        log('Decorating scope ->', currentPage, storedValues);

        if (_.isObject(storedValues)) {
            _.each(_.keys(storedValues), function (keyName) {
                if ((typeof storedValues[keyName] !== 'undefined') && (storedValues[keyName] !== 'data:destroyed')) {
                    // parse the keyname as it might be stored as using dot notation i.e.
                    // {"admin.person.age" : someval} needs to be parsed unless the value
                    // will be stored on the scope as "admin.person.age" and not a nested
                    // object as it should be
                    let getter = $parse(keyName);
                    return getter.assign(scope, storedValues[keyName]);
                }
            });
        }

        cpage[0] = scope;
        log(scope);
        log('\n');
    };


    // returns the BBCtrl scope from the supplied scope by walking up the scope
    // chain looking for it's controller id
    var getParentScope = function (scope) {
        while (scope) {
            // find the controller's rootscope
            if (scope.hasOwnProperty('cid') && (scope.cid === 'BBCtrl')) {
                return scope;
            }
            scope = scope.$parent;
        }
    };


    // the scope argument belongs to the controller which is requesting data to be
    // stored. we check if it's parent widget (BBCtrl) has been registered to store
    // data. BBCtrl is the root scope for all booking journeys.
    let checkRegisteredWidgets = function (scope) {
        let isRegistered = false;
        scope = getParentScope(scope);

        for (let rscope of Array.from(registeredWidgetArr)) {
            if (rscope === scope) {
                isRegistered = true;
            }
        }
        return isRegistered;
    };


    // generates an array of listeners and normalises the properties to be stored
    // i.e. 'bb.stacked_items->change:storeLocation' becomes
    // ['bb.stacked_items'] ['change:storeLocation']
    let checkForListeners = function (propsArr) {
        let watchArr = [];
        _.each(propsArr, function (propName, index) {
            let split = propName.split('->');
            if (split.length === 2) {
                watchArr.push(split);
                return propsArr[index] = split[0];
            }
        });

        return watchArr;
    };


    // creates the listeners for any items that require them and then destroy their
    // data if the eventhandler is called. i.e. registering the following
    // 'bb.stacked_items->change:storeLocation'
    // means the data on '$scope.bb.stack_items' will be stored unless the event
    // 'change:storeLocation', at which point the data will be cleared
    let setListeners = function (scope, listenerArr, currentPage) {
        if (listenerArr.length) {
            let cpage = dataStore[currentPage];
            let listenersArr = cpage[3] || [];

            _.each(listenerArr, function (item, index) {
                let func = $rootScope.$on(item[1], function () {
                    // because of the async nature of events we can't just null the data
                    // here as it could be restored in the storeFormData() method, which
                    // runs after the digest loop has finished. so we mark it as destroyed
                    try {
                        return cpage[2][item[0]] = 'data:destroyed';
                    }
                    catch (e) {
                        return log(e);
                    }
                });
                // store the registered listeners so we can remove when the widget is
                // destroyed
                return listenersArr.push(func);
            });
            // store the listeners along with the other widget information
            return cpage[3] = listenersArr;
        }
    };


    // uid is used along with the 'current_page' property and widget uid to create
    // an individual keyname to store the values. we do this as there can be
    // multiple widgets containing multiple controllers on a single page. the
    // 'propsArr' array contains a list of key names on the scope which are to  be
    // stored i.e. ['name', 'email', 'address1']
    let init = function (uid, scope, propsArr) {
        if (checkRegisteredWidgets(scope)) {
            let currentPage = scope.bb.uid + div + scope.bb.current_page + div + uid;
            currentPage = currentPage.toLowerCase();
            let watchArr = checkForListeners(propsArr);
            // return a function which has the current page as a closure. the
            // controller which is initalising the form data can call this at any point
            // to clear the data for it's controller .i.e $scope.clearStoredData()
            scope.clearStoredData = (currentPage =>
                    function () {
                        clear(currentPage);
                    })(currentPage);

            if (!currentPage) {
                throw new Error("Missing current step");
            }

            // if the step exists return the values as the form has been there before.
            if (dataStore[currentPage]) {
                setValuesOnScope(currentPage, scope);
                return;
            }

            log('Controller registered ->', currentPage, scope, '\n\n');
            dataStore[currentPage] = [scope, propsArr];
            setListeners(scope, watchArr, currentPage);
            return;
        }
    };


    // remove any registered scopes from the array when they are destroyed
    var removeWidget = function (scope) {
        registeredWidgetArr = _.without(registeredWidgetArr, scope);
    };


    // the service will only store data for widgets which have registered
    // themselves with the store. the scope object should always be BBCtrl's scope
    // object which is always the root scope for all widgets
    let register = function (scope) {
        let registered = false;
        // go up the scope chain to find the app's rootscope, which will be the scope
        // with the bbctrl property

        // step down a scope first - just in case this is on the same as the widget and iot's isloated!
        if (scope && scope.$$childHead) {
            scope = scope.$$childHead;
        }

        while (!_.has(scope, 'cid')) {
            scope = scope.$parent;
        }

        if (!scope) {
            return;
        }

        if (scope.cid !== 'BBCtrl') {
            throw new Error("This directive can only be used with the BBCtrl");
        }
        // check to make sure scope isn't already registered.
        _.each(registeredWidgetArr, function (stored) {
            if (scope === stored) {
                return registered = true;
            }
        });

        if (!registered) {
            log('Scope registered ->', scope);
            scope.$on('destroy', removeWidget);
            return registeredWidgetArr.push(scope);
        }
    };

    // when digest loop is triggered wait until after the last loop is run and then
    // store the values
    $rootScope.$watch(function () {
        $window.clearTimeout(toId);
        toId = setTimeout(storeFormData, 300);
    });

    $rootScope.$on('save:formData', storeFormData);
    $rootScope.$on('clear:formData', clear);

    return {
        init,
        destroy(scope) {
            return clear(scope, true);
        },
        showInfo,
        register,
        setIfUndefined
    };
});

