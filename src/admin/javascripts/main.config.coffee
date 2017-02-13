'use strict'

angular.module('BBAdmin').config ($logProvider) ->
  'ngInject'

  $logProvider.debugEnabled(true)
  return

angular.module('BB').config (FormTransformProvider) ->
  'ngInject'

  FormTransformProvider.setTransform 'edit', 'Admin_Booking', (form, schema, model) ->
    if model && model.status == 3 # blocked - don't disable the datetime
      disable_list = ['service', 'person_id', 'resource_id']
    else
      disable_list = ['datetime', 'service', 'person_id', 'resource_id']

    if form[0].tabs
      _.each form[0].tabs[0].items, (item) ->
        if _.indexOf(disable_list, item.key) > -1
          item.readonly = true
    else
      _.each form, (item) ->
        if _.indexOf(disable_list, item.key) > -1
          item.readonly = true
    form

  return