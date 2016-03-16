'use strict';

###**
* @ngdoc service
* @name BB.Models:Company
*
* @description
* Representation of an Company Object.<br/>
* Here are some helpful functions about a company.
*
* @constructor
* @param {HALobject=} data A HAL object to initialise the company from
*
* @property {string} name Company name
* @property {string} description Company description
* @property {string} country_code Country code for this company
* @property {string} currency_code A CCY for this company
* @property {string} reference A custom external reference for the company
* @property {number} id Company ID
* @property {boolean} live If this company is set live
* @property {array} companies An array of child companies if this company is a parent
* @property {string} timezone Business timezone
####

# helpful functions about a company
angular.module('BB.Models').factory "CompanyModel", ($q, BBModel, BaseModel, halClient, AppConfig, $sessionStorage, CompanyService) ->

  class Company extends BaseModel

    constructor: (data) ->
      super(data)
      # instantiate each child company as a hal resource
      # we'll set the @companies array to all companies - including grandchildren
      # and we'll have an array called child_companies that contains only direct ancesstors
      if @companies
        all_companies = []
        @child_companies = []
        for comp in @companies
          c = new BBModel.Company(halClient.$parse(comp))
          @child_companies.push(c)
          if c.companies
            # if that company has it's own child companies
            for child in c.companies
              all_companies.push(child)
          else
            all_companies.push(c)
        @companies = all_companies

    ###**
    * @ngdoc method
    * @name getCompanyByRef
    * @methodOf BB.Models:Company
    * @param {string} ref Ref
    * @description
    * Finds a child company by reference.
    *
    * @param {string} ref ref parameter
    *
    * @returns {promise} A promise that on success will return a company object.
    ###
    getCompanyByRef: (ref) ->
      defer = $q.defer()
      @$get('companies').then (companies) ->
        company = _.find(companies, (c) -> c.reference == ref)
        if company
          defer.resolve(company)
        else
          defer.reject('No company for ref '+ref)
      , (err) ->
        console .log 'err ', err
        defer.reject(err)
      defer.promise

    ###**
    * @ngdoc method
    * @name findChildCompany
    * @methodOf BB.Models:Company
    * @param {string} id Company id
    * @description
    * Finds a child company by id.<br/>
    * If company cannot be find by id it will be searched by name.
    *
    * @param {string} id Company id
    *
    * @returns {object} The child company
    ###
    findChildCompany: (id) ->
      return null if !@companies
      for c in @companies
        if c.id == parseInt(id)
          return c
        if c.ref && c.ref == String(id)
          return c
      # failed to find by id - maybe by name ?
      if typeof id == "string"
        name = id.replace(/[\s\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '').toLowerCase()
        for c in @companies
          cname = c.name.replace(/[\s\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '').toLowerCase()
          if name == cname
            return c
      return null

    ###**
    * @ngdoc method
    * @name getSettings
    * @methodOf BB.Models:Company
    * @description
    * Gets company settings.
    *
    * @returns {promise} A promise that on success will return the company settings
    ###
    getSettings: () ->
      def = $q.defer()
      if @settings
        def.resolve(@settings)
      else
        if @$has('settings')
          @$get('settings').then (set) =>
            @settings = new BBModel.CompanySettings(set)
            def.resolve(@settings)
        else
          def.reject("Company has no settings")
      return def.promise

    ###**
    * @ngdoc method
    * @name pusherSubscribe
    * @methodOf BB.Models:Company
    * @description
    * A callback function will be called whenever a booking, cancellation or updating event is triggered.
    *
    * @param {function} callback A function to be called whenever the event is triggered.
    * @param {object} options If options parameter is null it will be set to an empty object.
    *
    ###
    pusherSubscribe: (callback, options = {}) =>
      if Pusher? && !@pusher?
        @pusher = new Pusher 'c8d8cea659cc46060608',
          encrypted: if options.hasOwnProperty('encrypted') then options.encrypted else true
          authEndpoint: @$link('pusher').href
          auth:
            headers:
              'App-Id' : AppConfig.appId
              'App-Key' : AppConfig.appKey
              'Auth-Token' : $sessionStorage.getItem('auth_token')
        channelName = "private-c#{@id}-w#{@numeric_widget_id}"
        unless @pusher.channel(channelName)?
          @pusher_channel = @pusher.subscribe(channelName)
          @pusher_channel.bind 'booking', callback
          @pusher_channel.bind 'cancellation', callback
          @pusher_channel.bind 'updating', callback

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Company
    * @description
    * Static function that loads an array of companies from a company object.
    *
    * @returns {promise} A returned promise.
    ###
    @$query: (company_id, options) ->
      CompanyService.query(company_id, options)
