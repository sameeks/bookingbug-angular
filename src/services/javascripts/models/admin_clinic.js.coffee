'use strict'

angular.module('BB.Models').factory "Admin.ClinicModel", ($q, BBModel, BaseModel, ClinicModel) ->

  class Admin_Clinic extends ClinicModel

    
    getPostData: () ->
      data = {}
      data.name = @name
      data.start_time = @start_time
      data.end_time = @end_time
      data.resource_ids = []
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
      data

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

