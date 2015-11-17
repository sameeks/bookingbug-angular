'use strict'

###**
* @ngdoc service
* @name BB.Models:AdminQueuer
*
* @description
* Representation of an Queuer Object
####

angular.module('BB.Models').factory "Admin.QueuerModel", ($q, BBModel, BaseModel) ->

  class Admin_Queuer extends BaseModel

    constructor: (data) ->
      super(data)
      @start = moment.parseZone(@start)
      @due = moment.parseZone(@due)
      @end = moment(@start).add(@duration, 'minutes')

    ###**
    * @ngdoc method
    * @name remaining
    * @methodOf BB.Models:AdminQueuer
    * @description
    * Get the remaining 
    *
    * @returns {object} Returns the remaining
    ###
    remaining: () ->
      d = @due.diff(moment.utc(), 'seconds')
      @remaining_signed = Math.abs(d);
      @remaining_unsigned = d

    ###**
    * @ngdoc method
    * @name startServing
    * @methodOf BB.Models:AdminQueuer
    * @param {object} person The person who start serving
    * @description
    * Start serving in according of the person parameter
    *
    * @returns {Promise} Returns a promise which resolve the start serving
    ###
    startServing: (person) ->
      defer = $q.defer()
      if @$has('start_serving')
        person.$flush('self')
        @$post('start_serving', {person_id: person.id}).then  (q) =>
          person.$get('self').then (p) -> person.updateModel(p)
          @updateModel(q)
          defer.resolve(@)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('start_serving link not available')
      defer.promise

    ###**
    * @ngdoc method
    * @name finishServing
    * @methodOf BB.Models:AdminQueuer
    * @description
    * Finish serving
    *
    * @returns {Promise} Returns a promise which resolve the finish serving
    ###
    finishServing: () ->
      defer = $q.defer()
      if @$has('finish_serving')
        @$post('finish_serving').then  (q) =>
          @updateModel(q)
          defer.resolve(@)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('finish_serving link not available')
      defer.promise

    ###**
    * @ngdoc method
    * @name extendAppointment
    * @methodOf BB.Models:AdminQueuer
    * @param {integer} minutes The duration in minutes
    * @description
    * Extend appointment in according of the minutes parameter
    *
    * @returns {Promise} Returns a promise which resolve the extended appointment
    ###
    extendAppointment: (minutes) ->
      defer = $q.defer()
      if @end.isBefore(moment())
        d = moment.duration(moment().diff(@start))
        new_duration = d.as('minutes') + minutes
      else
        new_duration = @duration + minutes
      @$put('self', {}, {duration: new_duration}).then (q) =>
        @updateModel(q)
        @end = moment(@start).add(@duration, 'minutes')
        defer.resolve(@)
      , (err) ->
        defer.reject(err)
      defer.promise

