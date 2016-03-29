'use strict';

###**
* @ngdoc service
* @name BB.Models:Client
*
* @description
* Representation of an Client Object
*
* @property {string} first_name Client first name
* @property {string} last_name Client last name
* @property {string} email Client email address
* @property {string} address1 Address 1
* @property {string} address2 Address 2
* @property {string} address3 Address 3
* @property {string} address4 Address 4
* @property {string} address4 Address 5
* @property {string} postcode Client postcode
* @property {string} country Client country
* @property {string} phone Client phone number
* @property {string} mobile Client mobile phone
* @property {number} id Client id
* @property {array} answers Client answers
* @property {boolean} deleted Verifies if the client account is deleted or not
####


angular.module('BB.Models').factory "ClientModel", ($q, BBModel, BaseModel, ClientService, LocaleService) ->

  class Client extends BaseModel

    constructor: (data) ->
      super
      @name = @getName()
      if data
        if data.answers && data.$has('questions')
          @waitingQuestions = $q.defer()
          @gotQuestions = @waitingQuestions.promise
          data.$get('questions').then (details) =>
            @client_details = new BBModel.ClientDetails(details)
            @client_details.setAnswers(data.answers)
            @questions = @client_details.questions
            @setAskedQuestions()  # make sure the item knows the questions were all answered
            @waitingQuestions.resolve()
        @raw_mobile = @mobile
        @mobile = "0" + @mobile if @mobile && @mobile[0] != "0"
        @phone  = "0" + @phone if @phone && @phone[0] != "0"


    ###**
    * @ngdoc method
    * @name setClientDetails
    * @methodOf BB.Models:Client
    * @description
    * Sets the client details using the details parameter.
    *
    * @param {object} details Client Details
    *
    * @returns {array} Client question answers
    ###
    setClientDetails: (details) ->
      @client_details = details
      @questions = @client_details.questions

    ###**
    * @ngdoc method
    * @name setDefaults
    * @methodOf BB.Models:Client
    * @description
    * Sets the default values for client object.
    *
    * @param {object} Client default values
    *
    * @returns {array} Default client answers
    ###
    setDefaults: (values) ->
      @name = values.name if values.name
      @first_name = values.first_name if values.first_name
      @last_name = values.last_name if values.last_name
      @phone = values.phone if values.phone
      @mobile = values.mobile if values.mobile
      @email = values.email if values.email
      @id = values.id if values.id
      @comp_ref = values.ref if values.ref
      @comp_ref = values.comp_ref if values.comp_ref
      @address1 = values.address1 if values.address1
      @address2 = values.address2 if values.address2
      @address3 = values.address3 if values.address3
      @address4 = values.address4 if values.address4
      @address5 = values.address5 if values.address5
      @postcode = values.postcode if values.postcode
      @country = values.country if values.country
      @default_answers = values.answers if values.answers

    ###**
    * @ngdoc method
    * @name pre_fill_answers
    * @methodOf BB.Models:Client
    * @description
    * Prefills the client answers from client details.
    *
    * @param {object} details Client details
    *
    * @returns {array} Default client answers
    ###
    pre_fill_answers: (details) ->
      return if !@default_answers
      for q in details.questions
        if @default_answers[q.name]
          q.answer = @default_answers[q.name]

    ###**
    * @ngdoc method
    * @name getName
    * @methodOf BB.Models:Client
    * @description
    * Gets the client first and last name.
    *
    * @returns {string} Client full name
    ###
    getName:  ->
      str = ""
      str += @first_name if @first_name
      str += " " if str.length > 0 && @last_name
      str += @last_name if @last_name
      str

    ###**
    * @ngdoc method
    * @name addressSingleLine
    * @methodOf BB.Models:Client
    * @description
    * Creates the full address from all the address fields as a single line and comma separated string.
    *
    * @returns {string} Full adress
    ###
    addressSingleLine: ->
      str = ""
      str += @address1 if @address1
      str += ", " if @address2 && str.length > 0
      str += @address2 if @address2
      str += ", " if @address3 && str.length > 0
      str += @address3 if @address3
      str += ", " if @address4 && str.length > 0
      str += @address4 if @address4
      str += ", " if @address5 && str.length > 0
      str += @address5 if @address5
      str += ", " if @postcode && str.length > 0
      str += @postcode if @postcode
      str

    ###**
    * @ngdoc method
    * @name hasAddress
    * @methodOf BB.Models:Client
    * @description
    * Returns the first or second address or the postcode if at least one of these exists.
    *
    * @returns {string} One of these: address1, address2 or postcode
    ###
    hasAddress: ->
      return @address1 || @address2 || @postcode

    ###**
    * @ngdoc method
    * @name addressCsvLine
    * @methodOf BB.Models:Client
    * @description
    * Creates the full address from all the address fields as a single line and comma separated string wich is suitable for csv export.
    *
    * @returns {string} Full address
    ###
    addressCsvLine: ->
      str = ""
      str += @address1 if @address1
      str += ", "
      str += @address2 if @address2
      str += ", "
      str += @address3 if @address3
      str += ", "
      str += @address4 if @address4
      str += ", "
      str += @address5 if @address5
      str += ", "
      str += @postcode if @postcode
      str += ", "
      str += @country if @country
      return str

    ###**
    * @ngdoc method
    * @name addressMultiLine
    * @methodOf BB.Models:Client
    * @description
    * Creates the full address from all the address fields as a multiple lines string.
    *
    * @returns {string} Multiple lines full address
    ###
    addressMultiLine: ->
      str = ""
      str += @address1 if @address1
      str += "<br/>" if @address2 && str.length > 0
      str += @address2 if @address2
      str += "<br/>" if @address3 && str.length > 0
      str += @address3 if @address3
      str += "<br/>" if @address4 && str.length > 0
      str += @address4 if @address4
      str += "<br/>" if @address5 && str.length > 0
      str += @address5 if @address5
      str += "<br/>" if @postcode && str.length > 0
      str += @postcode if @postcode
      str

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:Client
    * @description
    * Creates an object with client details.
    *
    * @returns {object} Newly created object with client details
    ###
    getPostData: ->
      x = {}
      x.first_name = @first_name
      x.last_name = @last_name
      if @house_number
        x.address1 = @house_number + " " + @address1
      else
        x.address1 = @address1
      x.address2 = @address2
      x.address3 = @address3
      x.address4 = @address4
      x.address5 = @address5
      x.postcode = @postcode
      x.country = @country
      x.email = @email
      x.id = @id
      x.comp_ref = @comp_ref
      x.parent_client_id = @parent_client_id
      x.password = @password
      x.notifications = @notifications
      x.member_level_id = @member_level_id if @member_level_id
      x.send_welcome_email = @send_welcome_email if @send_welcome_email
      x.default_company_id = @default_company_id if @default_company_id

      if @phone
        x.phone = @phone
        x.phone_prefix = @phone_prefix if @phone_prefix

      if @mobile
        @remove_prefix()
        x.mobile = @mobile
        x.mobile_prefix = @mobile_prefix


      if @questions
        x.questions = []
        for q in @questions
          x.questions.push(q.getPostData())
      x

    ###**
    * @ngdoc method
    * @name valid
    * @methodOf BB.Models:Client
    * @description
    * Verifies if an email is valid.
    *
    * @returns {boolean} True or false depending on email validity
    ###
    valid: ->
      return @isValid if @isValid
      if @email || @hasServerId()
        return true
      else
        return false

    ###**
    * @ngdoc method
    * @name setValid
    * @methodOf BB.Models:Client
    * @description
    * Sets the client validity.
    *
    * @param {boolean} val val parameter
    *
    * @returns {boolean} True or false depending on val parameter
    ###
    setValid: (val) ->
      @isValid = val

    ###**
    * @ngdoc method
    * @name hasServerId
    * @methodOf BB.Models:Client
    * @description
    * Checks if the client has an id and then returns it.
    *
    * @returns {string} Client id
    ###
    hasServerId: ->
      return @id

    ###**
    * @ngdoc method
    * @name setAskedQuestions
    * @methodOf BB.Models:Client
    * @description
    * Sets the asked_questions flag to true.
    *
    * @returns {boolean} True
    ###
    setAskedQuestions: ->
      @asked_questions = true

    ###**
    * @ngdoc method
    * @name fullMobile
    * @methodOf BB.Models:Client
    * @description
    * Shows the mobile phone number of the client.
    *
    * @returns {string} Mobile phone number
    ###
    fullMobile: ->
      return if !@mobile
      return @mobile if !@mobile_prefix
      return "+" + @mobile_prefix + @mobile

    ###**
    * @ngdoc method
    * @name remove_prefix
    * @methodOf BB.Models:Client
    * @description
    * Removes the prefix from mobile phone number of the client.
    *
    * @returns {string} Mobile phone number without the prefix
    ###
    remove_prefix: ->
      pref_arr = @mobile.match(/^(\+|00)(999|998|997|996|995|994|993|992|991|990|979|978|977|976|975|974|973|972|971|970|969|968|967|966|965|964|963|962|961|960|899|898|897|896|895|894|893|892|891|890|889|888|887|886|885|884|883|882|881|880|879|878|877|876|875|874|873|872|871|870|859|858|857|856|855|854|853|852|851|850|839|838|837|836|835|834|833|832|831|830|809|808|807|806|805|804|803|802|801|800|699|698|697|696|695|694|693|692|691|690|689|688|687|686|685|684|683|682|681|680|679|678|677|676|675|674|673|672|671|670|599|598|597|596|595|594|593|592|591|590|509|508|507|506|505|504|503|502|501|500|429|428|427|426|425|424|423|422|421|420|389|388|387|386|385|384|383|382|381|380|379|378|377|376|375|374|373|372|371|370|359|358|357|356|355|354|353|352|351|350|299|298|297|296|295|294|293|292|291|290|289|288|287|286|285|284|283|282|281|280|269|268|267|266|265|264|263|262|261|260|259|258|257|256|255|254|253|252|251|250|249|248|247|246|245|244|243|242|241|240|239|238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|219|218|217|216|215|214|213|212|211|210|98|95|94|93|92|91|90|86|84|82|81|66|65|64|63|62|61|60|58|57|56|55|54|53|52|51|49|48|47|46|45|44|43|41|40|39|36|34|33|32|31|30|27|20|7|1)/)
      if pref_arr
        @mobile.replace pref_arr[0], ""
        @mobile_prefix = pref_arr[0]

    ###**
    * @ngdoc method
    * @name $getPrePaidBookings
    * @methodOf BB.Models:Address
    * @description
    * Gets the  prepaid bookingss of a client.
    *
    * @returns {promise} A promise that on success will return the client prepaid bookings
    ###
    $getPrePaidBookings: (params) ->
      defer = $q.defer()
      if @$has('pre_paid_bookings')
        @$get('pre_paid_bookings', params).then (collection) ->
          collection.$get('pre_paid_bookings').then (prepaids) ->
            defer.resolve((new BBModel.PrePaidBooking(prepaid) for prepaid in prepaids))
          , (err) ->
            defer.reject(err)
        , (err) ->
          defer.reject(err)
      # return empty array if there are no prepaid bookings
      else
        defer.resolve([])
        #defer.reject('missing pre_paid_bookings link')
      defer.promise

    ###**
    * @ngdoc method
    * @name query_by_email
    * @methodOf BB.Models:Client
    * @description
    * Static function that will search for a client by email in a given company.
    *
    * @param {object} company Company object
    * @param {string} email Client email
    *
    * @returns {promise} A promise that on success will return a client
    ###
    @$query_by_email: (company, email) ->
      ClientService.query_by_email(company, email)

    ###**
    * @ngdoc method
    * @name $create_or_update
    * @methodOf BB.Models:Client
    * @description
    * Static function that updates a client from a company object.
    *
    * @param {object} company Company object
    * @param {object} client Client object
    *
    * @returns {promise} A promise that on success will create or update an existing client
    ###
    @$create_or_update: (company, client) ->
      ClientService.create_or_update(company, client)
