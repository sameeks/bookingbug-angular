'use strict';

angular.module('BB').provider('redux', function() {
    var $get;
    $get = function() {
        return Redux;
    };
    return {
        $get: $get
    };
});

angular.module('BB').provider('immutable', function() {
    var $get;
    $get = function() {
        return Immutable;
    };
    return {
        $get: $get
    };
});

angular.module('BB').provider('bbLoggerMiddleware', function() {
    'ngInject';
    var $get;
    $get = function() {
        return function(store) {
            return function(next) {
                return function(action) {
                    var result;
                    console.group(action.type);
                    console.info('dispatching', action);
                    result = next(action);
                    console.log('next state', store.getState());
                    console.groupEnd(action.type);
                    return result;
                };
            };
        };
    };
    return {
        $get: $get
    };
});

angular.module('BB').provider('bbPersistenceMiddleware', function($localStorageProvider) {
    'ngInject';
    var $get;
    $get = function() {
        return function(store) {
            return function(next) {
                return function(action) {
                    var result;
                    result = next(action);
                    $localStorageProvider.$get().setObject('bbState', store.getState());
                    return result;
                };
            };
        };
    };
    return {
        $get: $get
    };
});

angular.module('BB').provider('bbBasketReducer', function() {
    var $get;
    $get = function() {
        var reducer;
        reducer = function(state, action) {
            if ((angular.equals(state, {})) || (state == null)) {
                state = {
                    dateTime: new Date(),
                    number: 0
                };
            }
            switch (action.type) {
                case "datetime/update":
                    state = angular.copy(state);
                    state.dateTime = new Date();
                    break;
                case "number/increase":
                    state = angular.copy(state);
                    state.number++;
                    break;
                case "number/decrease":
                    state = angular.copy(state);
                    state.number--;
            }
            return state;
        };
        return reducer;
    };
    return {
        $get: $get
    };
});

angular.module('BB').provider('bbHistoryHigherOrderReducer', function($localStorageProvider) {
    'ngInject';
    var $get;
    $get = function() {
        var historyReducer;
        historyReducer = function(reducer) {
            var initialState;
            initialState = {
                past: [],
                present: $localStorageProvider.$get().getObject("bbState"),
                future: []
            };
            return function(state, action) {
                var newFuture, newPast, next, previous, previousStatePresent;
                if (state == null) {
                    state = initialState;
                }
                switch (action.type) {
                    case 'UNDO':
                        previous = state.past[state.past.length - 1];
                        if (angular.isUndefined(previous)) {
                            return state;
                        }
                        newPast = state.past.slice(0, state.past.length - 1);
                        newFuture = [angular.copy(state.present)].concat(state.future);
                        return {
                            past: newPast,
                            present: previous,
                            future: newFuture
                        };
                    case 'REDO':
                        next = state.future[0];
                        if (angular.isUndefined(next)) {
                            return state;
                        }
                        newPast = state.past.concat([state.present]);
                        newFuture = state.future.slice(1);
                        return {
                            past: newPast,
                            present: next,
                            future: newFuture
                        };
                    default:
                        previousStatePresent = state.present;
                        state.present = reducer(state.present, action);
                        if (state.present === previousStatePresent) {
                            return state;
                        }
                        return {
                            past: state.past.concat([previousStatePresent]),
                            present: state.present,
                            future: []
                        };
                }
            };
        };
        return historyReducer;
    };
    return {
        $get: $get
    };
});

angular.module('BB').config(function(reduxProvider, $ngReduxProvider, $localStorageProvider, bbBasketReducerProvider,
                                     bbLoggerMiddlewareProvider, bbPersistenceMiddlewareProvider, bbHistoryHigherOrderReducerProvider) {
    'ngInject';
    var enhancers, middleware, reducers;
    reducers = {
        basket: bbHistoryHigherOrderReducerProvider.$get()(bbBasketReducerProvider.$get()),
        basket2: bbBasketReducerProvider.$get()
    };
    middleware = [bbLoggerMiddlewareProvider.$get(), bbPersistenceMiddlewareProvider.$get()];
    enhancers = [];
    $ngReduxProvider.createStoreWith(
        reduxProvider.$get().combineReducers(reducers),
        middleware,
        enhancers,
        $localStorageProvider.$get().getObject("bbState")
    );
});

angular.module('BB').run(function($ngRedux) {
    'ngInject';
    window.$ngRedux = $ngRedux;
});

