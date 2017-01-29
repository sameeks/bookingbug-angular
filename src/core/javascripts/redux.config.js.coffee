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
      if !state?
        state =
          dateTime: new Date()
          number: 0

      switch action.type

        when "datetime/update"
          state.dateTime = new Date()
        when "number/increase"
          state.number++

        when "number/decrease"
          state.number--

      return state

    return reducer

  return {
    $get: $get
  }

angular.module('BB').provider 'historyReducer', (immutableProvider) ->
  'ngInject'

  immutable = immutableProvider.$get()

  $get = () ->
    ###*
    # {Function} reducer - higher order reducer
    ###
    historyReducer = (reducer) ->
      initialState = {
        past: immutable.List([]),
        present: undefined,
        future: immutable.List([])
      }

      initialState.present = reducer(initialState.present, {type: 'bb/init'}) # by that time state should be already initialised - @@redux/INIT, should $localStorage restoring happen here ?

      return (state = initialState, action) ->
        switch action.type
          when 'UNDO'
            previous = state.past.last()
            if angular.isUndefined previous
              return state

            newPast = state.past.slice(0, state.past.count() - 1)
            newFuture = immutable.List([state.present]).concat(state.future)

            return {
              past: newPast,
              present: previous,
              future: newFuture
            }
          when 'REDO'
            next = state.future.first()
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
              future: immutable.List([])
            }

    return historyReducer
  return {
    $get: $get
  }


angular.module('BB').config (reduxProvider, $ngReduxProvider, $localStorageProvider, bbBasketReducerProvider, bbLoggerMiddlewareProvider, bbPersistenceMiddlewareProvider) ->
  'ngInject'

  window.$ngReduxProvider = $ngReduxProvider # exposed just for testing

  reducers =
    basket: bbBasketReducerProvider.$get(),
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

