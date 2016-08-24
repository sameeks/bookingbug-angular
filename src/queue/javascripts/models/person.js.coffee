angular.module('BB.Models').factory "AdminQueuerPersonModel", ($q,
  AdminPersonService, BBModel, BaseModel, PersonModel) ->

  class Admin_Person extends PersonModel

    constructor: (data) ->
      super(data)
      unless @queuing_disabled
        @setCurrentCustomer()


    ###**
    * @ngdoc method
    * @name setCurrentCustomer
    * @methodOf BB.Models:AdminPerson
    * @description
    * Set current customer
    *
    * @returns {Promise} Returns a promise that rezolve the current customer
    ###
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

