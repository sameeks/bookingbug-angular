'use strict';

###**
* @ngdoc service
* @name BB.Models:AdminPerson
*
* @description
* Representation of an Person Object
*
* @property {integer} id Person id
* @property {string} name Person name
* @property {boolean} deleted Verify if person is deleted or not
* @property {boolean} disabled Verify if person is disabled or not
* @property {integer} order The person order
####

angular.module('BB.Models').factory "Admin.PersonModel", ($q, BBModel, BaseModel, PersonModel, AdminPersonService) ->

  class Admin_Person extends PersonModel

    constructor: (data) ->
      super(data)
      unless @queuing_disabled
        @setCurrentCustomer()

    setCurrentCustomer: () ->
      defer = $q.defer()
      if @$has('queuer')
        @$get('queuer').then (queuer) =>
          @serving = new BBModel.Admin.Queuer(queuer)
          defer.resolve(@serving)
        , (err) ->
          defer.reject(err)
      else
        defer.resolve()
      defer.promise

    setAttendance: (status) ->
      defer = $q.defer()
      @$put('attendance', {}, {status: status}).then  (p) =>
        @updateModel(p)
        defer.resolve(@)
      , (err) =>
        defer.reject(err)
      defer.promise

    finishServing: () ->
      defer = $q.defer()
      if @$has('finish_serving')
        @$flush('self')
        @$post('finish_serving').then (q) =>
          @$get('self').then (p) => @updateModel(p)
          @serving = null
          defer.resolve(q)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('finish_serving link not available')
      defer.promise

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

    startServing: (queuer) ->
      defer = $q.defer()
      if @$has('start_serving')
        @$flush('self')
        params =
          queuer_id: if queuer then queuer.id else null
        @$post('start_serving', params).then (q) =>
          @$get('self').then (p) => @updateModel(p)
          @serving = q
          defer.resolve(q)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('start_serving link not available')
      defer.promise

    getQueuers: () ->
      defer = $q.defer()
      if @$has('queuers')
        @$flush('queuers')
        @$get('queuers').then (collection) =>
          collection.$get('queuers').then (queuers) =>
            models = (new BBModel.Admin.Queuer(q) for q in queuers)
            @queuers = models
            defer.resolve(models)
          , (err) =>
            defer.reject(err)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('queuers link not available')
      defer.promise

    getPostData: () ->
      data = {}
      data.id = @id
      data.name = @name
      data.extra = @extra
      data.description = @description
      data

 
    $update: (data) -> 
      data ||= @getPostData()
      @$put('self', {}, data).then (res) =>
        @constructor(res) 


    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @param {string=} filter_by_fields Comma separated list of field, value pairs to filter results by.
    * @param {string=} order_by Specifies field to order results by.
    * @param {boolean=} order_by_reverse Reverses the ordered results if true.
    * @methodOf BB.Models:AdminPerson
    * @description
    * Gets a filtered collection of people.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of people.
    ###
    @query: (company, page, per_page, filter_by_fields, order_by, order_by_reverse) ->
      AdminPersonService.query
        company: company
        page: page
        per_page: per_page
        filter_by_fields: filter_by_fields
        order_by: order_by
        order_by_reverse: order_by_reverse


angular.module('BB.Models').factory 'AdminPerson', ($injector) ->
  $injector.get('Admin.PersonModel')

