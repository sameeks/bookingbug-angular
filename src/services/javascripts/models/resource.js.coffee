'use strict';


###**
* @ngdoc service
* @name BB.Models:AdminResource
*
* @description
* Representation of an Resource Object
*
* @property {integer} total_entries The total entries
* @property {array} resources An array with resources elements
* @property {integer} id The resources id
* @property {string} name Name of resources
* @propertu {string} type Type of resources
* @property {boolean} deleted Verify if resources is deleted or not
* @property {boolean} disabled Verify if resources is disabled or not
####


angular.module('BB.Models').factory "Admin.ResourceModel", ($q, BBModel, BaseModel, ResourceModel, AdminResourceService) ->

  class Admin_Resource extends ResourceModel

    ###**
    * @ngdoc method
    * @name isAvailable
    * @methodOf BB.Models:AdminResource
    * @param {date=} start The start date of the availability of the resource
    * @param {date=} end The end date of the availability of the resource
    * @description
    * Look up a schedule for a time range to see if this available
    *
    * @returns {string} Returns yes if availability of resource is valid
    ###
    # look up a schedule for a time range to see if this available
    # currently just checks the date - but chould really check the time too
    isAvailable: (start, end) ->
      str = start.format("YYYY-MM-DD") + "-" + end.format("YYYY-MM-DD")
      @availability ||= {}
      
      return @availability[str] == "Yes" if @availability[str]
      @availability[str] = "-"

      if @$has('schedule')
        @$get('schedule', {start_date: start.format("YYYY-MM-DD"), end_date: end.format("YYYY-MM-DD")}).then (sched) =>
          @availability[str] = "No"
          if sched && sched.dates && sched.dates[start.format("YYYY-MM-DD")] && sched.dates[start.format("YYYY-MM-DD")] != "None"
            @availability[str] = "Yes"
      else
        @availability[str] = "Yes"

      return @availability[str] == "Yes" 

    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminResource
    * @description
    * Static function that loads an array of admin resource from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (params) ->
      AdminResourceService.query(params)

angular.module('BB.Models').factory 'AdminResource', ($injector) ->
  $injector.get('Admin.ResourceModel')

