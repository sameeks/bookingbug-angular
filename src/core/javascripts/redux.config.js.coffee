'use strict'

angular.module('BB').provider 'redux', () ->
  $get = () ->
    return Redux

  return {
    $get: $get
  }

angular.module('BB').provider 'immutable', () ->
  $get = () ->
    return Immutable

  return {
    $get: $get
  }

angular.module('BB').provider 'bbLoggerMiddleware', () ->
  'ngInject'

  $get = () ->
    return (store) -> (next) -> (action) ->
      console.group(action.type)
      console.info('dispatching', action)
      result = next(action)
      console.log('next state', store.getState())
      console.groupEnd(action.type)
      return result

  return {
    $get: $get
  }

angular.module('BB').provider 'bbPersistenceMiddleware', ($localStorageProvider) ->
  'ngInject'

  $get = () ->
    return (store) -> (next) -> (action) ->
      result = next(action)
      $localStorageProvider.$get().setObject('bbState', store.getState())
      return result

  return {
    $get: $get
  }


angular.module('BB').provider 'bbBasketReducer', () ->
  $get = () ->
    reducer = (state, action) ->
      debugger # test

      if (angular.equals state, {}) or (!state?)
        state =
          dateTime: new Date()
          number: 0

      switch action.type
        when "datetime/update"
          state = angular.copy(state)
          state.dateTime = new Date()
        when "number/increase"
          state = angular.copy(state)
          state.number++
        when "number/decrease"
          state = angular.copy(state)
          state.number--

      return state

    return reducer

  return {
    $get: $get
  }

angular.module('BB').provider 'bbHistoryHigherOrderReducer', ($localStorageProvider) ->
  'ngInject'

  $get = () ->

    historyReducer = (reducer) ->
      initialState = {
        past: [],
        present: $localStorageProvider.$get().getObject("bbState"),
        future: []
      }

      return (state = initialState, action) ->
        switch action.type
          when 'UNDO'
            previous = state.past[state.past.length - 1]
            if angular.isUndefined previous
              return state

            newPast = state.past.slice(0, state.past.length - 1)
            newFuture = [angular.copy(state.present)].concat(state.future)

            return {
              past: newPast,
              present: previous,
              future: newFuture
            }
          when 'REDO'
            next = state.future[0]
            if angular.isUndefined next
              return state

            newPast = state.past.concat([state.present])
            newFuture = state.future.slice(1)

            return {
              past: newPast
              present: next,
              future: newFuture
            }
          else
            previousStatePresent = state.present
            state.present = reducer(state.present, action)

            if state.present is previousStatePresent
              return state

            return {
              past: state.past.concat([previousStatePresent])
              present: state.present
              future: []
            }

    return historyReducer
  return {
    $get: $get
  }


angular.module('BB').config (reduxProvider, $ngReduxProvider, $localStorageProvider, bbBasketReducerProvider, bbLoggerMiddlewareProvider, bbPersistenceMiddlewareProvider, bbHistoryHigherOrderReducerProvider) ->
  'ngInject'

  reducers =
    basket: bbHistoryHigherOrderReducerProvider.$get()(bbBasketReducerProvider.$get())
    basket2: bbBasketReducerProvider.$get()

  middleware = [
    bbLoggerMiddlewareProvider.$get()
    bbPersistenceMiddlewareProvider.$get()
  ]
  enhancers = []

  $ngReduxProvider.createStoreWith(reduxProvider.$get().combineReducers(reducers), middleware, enhancers, $localStorageProvider.$get().getObject("bbState"))

  return

angular.module('BB').run ($ngRedux) ->
  'ngInject'

  window.$ngRedux = $ngRedux # exposed just for testing

  #unsubscribe = $ngRedux.connect(this.mapState, this.mapDispatch)(this);
  #unsubscribe = $ngRedux.connect(this.mapState, this.mapDispatch)((selectedState, actions) -> {/* ... */});
  #unsubscribe = $ngRedux.subscribe(changeHandler)
  # $ngRedux.getState()
  #@onDestory = () -> unsubscribe()

  return

