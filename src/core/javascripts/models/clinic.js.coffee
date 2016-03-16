'use strict'

###**
* @ngdoc service
* @name BB.Models:Clinic
*
* @description
* Representation of an Clinic Object
*
* @property {string} setTimes Set times for the clinic
* @property {string} setResourcesAndPeople Set resources and people for the clinic
* @property {object} settings Clinic settings
* @property {string} resources Clinic resources
* @property {number} resource_ids Clinic resources ids
* @property {string} people Clinic people
* @property {number} person_ids Clinic Person ids
* @property {string} services Clinic services
* @property {number} services_ids Clinic service ids
* @property {string} uncovered TUncovered
* @property {string} className TCass Name
* @property {string} start_time Clinic startime
* @property {string} start Clinic start
* @property {string} end_time Clinic endtime
* @property {string} end Clinic end
* @property {string} title Title
####

angular.module('BB.Models').factory "ClinicModel", ($q, BBModel, BaseModel, ClinicService) ->

  class Clinic extends BaseModel

    constructor: (data) ->
      super(data)
      @setTimes()
      @setResourcesAndPeople()
      @settings ||= {}

    ###**
    * @ngdoc method
    * @name setResourcesAndPeople
    * @methodOf BB.Models:Clinic
    * @description
    * (!!check)
    * Sets the resources and people for clinic.
    *
    * @returns {object} The returned resources and people
    ###
    setResourcesAndPeople: () ->
      @resources = _.reduce(@resource_ids, (h, id) ->
        h[id] = true
        h
      , {})
      @people = _.reduce(@person_ids, (h, id) ->
        h[id] = true
        h
      , {})
      @services = _.reduce(@service_ids, (h, id) ->
        h[id] = true
        h
      , {})
      @uncovered = !@person_ids || @person_ids.length == 0
      if @uncovered
        @className = "clinic_uncovered"
      else
        @className = "clinic_covered"

    ###**
    * @ngdoc method
    * @name setTimes
    * @methodOf BB.Models:Clinic
    * @description
    * (!!check)
    * Sets the time for clinic.
    *
    * @returns {object} The returned time
    ###
    setTimes: () ->
      if @start_time
        @start_time = moment(@start_time)
        @start = @start_time
      if @end_time
        @end_time = moment(@end_time)
        @end = @end_time
      @title = @name

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Clinic
    * @description
    * Static function that loads an array of clinics from a company object.
    *
    * @returns {promise} A returned promise
    ###
    @$query: (params) ->
      ClinicService.query(params)
