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
* @property {integer} resource_ids Clinic resources ids
* @property {string} people Clinic people
* @property {integer} person_ids Clinic Person ids
* @property {string} services Clinic services
* @property {integer} services_ids Clinic service ids
* @property {string} uncovered The uncovered
* @property {string} className The class Name
* @property {string} start_time The clinic start thime
* @property {string} start The clinic start
* @property {string} end_time The clinic end time
* @property {string} end The clinic end
* @property {string} title The title
####


angular.module('BB.Models').factory "ClinicModel", ($q, BBModel, BaseModel) ->

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
    * Set resources and people for clinic
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
    * Set time for clinic
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

