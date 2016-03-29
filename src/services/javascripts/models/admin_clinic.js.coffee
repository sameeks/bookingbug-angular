'use strict'

###**
* @ngdoc service
* @name BB.Models:AdminClinic
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
* @property {integer} person_ids Clinic person ids
* @property {string} services Clinic services
* @property {integer} services_ids Clinic service ids
* @property {string} uncovered Uncovered
* @property {string} className Class name
* @property {string} start_time Clinic start thime
* @property {string} end_time Clinic end time
####

angular.module('BB.Models').factory "Admin.ClinicModel", ($q, BBModel, BaseModel, ClinicModel) ->

  class Admin_Clinic extends ClinicModel

    constructor: (data) ->
      super(data)
      @repeat_rule ||= {}
      @repeat_rule.rules ||= {}

    ###**
    * @ngdoc method
    * @name calcRepeatRule
    * @methodOf BB.Models:AdminClinic
    * @description
    * Calculates the repeat rule
    *
    * @returns {object} Returns an object with various information
    ###
    calcRepeatRule: () ->
      vals = {}
      vals.name = @name
      vals.start_time = @start_time.format("HH:mm")
      vals.end_time = @end_time.format("HH:mm")
      vals.address_id = @address_id
      vals.resource_ids = []
      for id, en of @resources
        vals.resource_ids.push(id) if en
      vals.person_ids = []
      for id, en of @people
        vals.person_ids.push(id) if en
      vals.service_ids = []
      for id, en of @services
        vals.service_ids.push(id) if en

      @repeat_rule.properties = vals
      return @repeat_rule

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:AdminClinic
    * @description
    * Gets post data
    *
    * @returns {object} Returns data object
    ###
    getPostData: () ->
      data = {}
      data.name = @name
      data.repeat_rule = @repeat_rule
      data.start_time = @start_time
      data.end_time = @end_time
      data.resource_ids = []
      data.update_for_repeat = @update_for_repeat
      for id, en of @resources
        data.resource_ids.push(id) if en
      data.person_ids = []
      for id, en of @people
        data.person_ids.push(id) if en
      data.service_ids = []
      for id, en of @services
        data.service_ids.push(id) if en
      data.address_id = @address.id if @address
      data.settings = @settings if @settings
      if @repeat_rule && @repeat_rule.rules && @repeat_rule.rules.frequency
        data.repeat_rule = @calcRepeatRule()
      data

    ###**
    * @ngdoc method
    * @name save
    * @methodOf BB.Models:AdminClinic
    * @description
    * Save person id, resource id and service id
    *
    * @returns {array} Returns an array with resources and peoples
    ###
    save: () ->
      @person_ids = _.compact(_.map(@people, (present, person_id) ->
        person_id if present
      ))
      @resource_ids = _.compact(_.map(@resources, (present, resource_id) ->
        resource_id if present
      ))
      @service_ids = _.compact(_.map(@services, (present, service_id) ->
        service_id if present
      ))
      @$put('self', {}, @).then (clinic) =>
        @updateModel(clinic)
        @setTimes()
        @setResourcesAndPeople()

    $update: (data) ->
      data ||= @
      @$put('self', {}, data).then (res) =>
        @constructor(res)

    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminClinic
    * @description
    * Static function that loads an array of clinics from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (params) ->
      AdminClinicService.query(params)

    ###**
    * @ngdoc method
    * @name create
    * @methodOf BB.Models:AdminClinic
    * @description
    * Static function that create an array of clinics from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$create: (prms, clinic) ->
      AdminClinicService.create(prms, clinic)

    ###**
    * @ngdoc method
    * @name update
    * @methodOf BB.Models:AdminClinic
    * @description
    * Static function that updates an array of clinics from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$update: (clinic) ->
      AdminClinicService.update(clinic)
