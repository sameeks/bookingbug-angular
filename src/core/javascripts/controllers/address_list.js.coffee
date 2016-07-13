## Address List

###**
* @ngdoc directive
* @name BB.Directives:bbAddresses
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of addresses for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {boolean} manual_postcode_entry The manual postcode entry of the address
* @property {string} address1 The first address of the client
* @property {string} address2 The second address of the client
* @property {string} address3 The third address of the client
* @property {string} address4 The fourth address of the client
* @property {string} address5 The fifth address of the client
* @property {boolean} show_complete_address Display complete address of the client
* @property {boolean} postcode_submitted Postcode of the client has been submitted
* @property {string} findByPostcode Find address by postcode
* @property {string} setLoaded Set loaded address list
* @property {string} notLoaded Address list not loaded
####

angular.module('BB.Directives').directive 'bbAddresses', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'AddressList'


angular.module('BB.Controllers').controller 'AddressList',
($scope, $rootScope, $filter, $sniffer, FormDataStoreService, LoadingService, BBModel) ->

  $scope.controller = "public.controllers.AddressList"
  $scope.manual_postcode_entry = false
  loader = LoadingService.$loader($scope)

  FormDataStoreService.init 'AddressList', $scope, [
    'show_complete_address'
  ]

  $rootScope.connection_started.then =>
    if $scope.client.postcode && !$scope.bb.postcode
      $scope.bb.postcode = $scope.client.postcode

    # if client postcode is set and matches postcode entered by the user (and address isn't already set), copy the address from the client
    if $scope.client.postcode && $scope.bb.postcode && $scope.client.postcode == $scope.bb.postcode && !$scope.bb.address1
      $scope.bb.address1 = $scope.client.address1
      $scope.bb.address2 = $scope.client.address2
      $scope.bb.address3 = $scope.client.address3
      $scope.bb.address4 = $scope.client.address4
      $scope.bb.address5 = $scope.client.address5

    $scope.manual_postcode_entry = if !$scope.bb.postcode then true else false
    $scope.show_complete_address = if $scope.bb.address1 then true else false
    if !$scope.postcode_submitted
      $scope.findByPostcode()
      $scope.postcode_submitted = false
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')


  ###**
  * @ngdoc method
  * @name findByPostcode
  * @methodOf BB.Directives:bbAddresses
  * @description
  * Make a request for a list of addresses. They come as seperate list of objects containing addresses and monikers, which are converted into a single list of objects containing both properties.
  ###
  # make a request for a list of addresses. They come as seperate list of
  # objects containing addresses and monikers, which are converted into a single
  # list of objects containing both properties.
  $scope.findByPostcode = () ->
    $scope.postcode_submitted = true
    return if !$scope.bb.postcode

    loader.notLoaded()
    BBModel.Address.$query(
      company: $scope.bb.company
      post_code: $scope.bb.postcode
    )
    .then (response) ->
      # create an array of addresses
      if angular.isArray(response)
        addressArr = _.map response, (item, i) ->
          address : item.partialAddress
          moniker : item.moniker
      else
        addressArr = [{
          address : response.partialAddress
          moniker : response.moniker
        }]

      #  there is a bug in IE where it can't display a single option if the
      #  select menu is set to display more than one i.e. <select size="3">, so
      #  we add a blank
      if addressArr.length is 1 and $sniffer.msie
        newaddr = []
        newaddr.push(addressArr[0])
        newaddr.push({address : '' })
        addressArr = newaddr

      $scope.addresses = addressArr
      # set address as as first item to prevent angular adding an empty item to
      # the select control this is bound to
      $scope.bb.address = addressArr[0]
      $scope.client.address = addressArr[0]
      loader.setLoaded()
      return
    ,(err) ->
      $scope.show_complete_address = true
      $scope.postcode_submitted = true
      loader.setLoaded()

  ###**
  * @ngdoc method
  * @name showCompleteAddress
  * @methodOf BB.Directives:bbAddresses
  * @description
  * Show complete address
  ###
  $scope.showCompleteAddress = () ->
      $scope.show_complete_address = true
      $scope.postcode_submitted = false

      if $scope.bb.address && $scope.bb.address.moniker
        loader.notLoaded()
        BBModel.Address.$getAddress(
          company : $scope.bb.company,
          id : $scope.bb.address.moniker
        )
        .then (response) ->
          address = response
          house_number = ''
          if typeof address.buildingNumber is 'string'
            house_number = address.buildingNumber
          else if !address.buildingNumber?
            house_number = address.buildingName

          if typeof address.streetName is 'string'
            streetName = if address.streetName then address.streetName else ''
            $scope.bb.address1 = house_number + ' ' + streetName
          else
            addressLine2 = if address.addressLine2 then address.addressLine2 else ''
            $scope.bb.address1 = house_number + ' ' + addressLine2

          if address.buildingName and !address.buildingNumber?
            $scope.bb.address1 = house_number
            $scope.bb.address2 = address.streetName
            $scope.bb.address4 = address.county if address.county?

          if typeof address.buildingNumber is 'string' && typeof address.buildingName is 'string' && typeof address.streetName is 'string'
            streetName = if address.streetName then address.streetName else ''
            $scope.bb.address1 = address.buildingName
            $scope.bb.address2 = address.buildingNumber + " " + streetName

          if address.buildingName? and address.buildingName.match(/(^[^0-9]+$)/)
            building_number = if address.buildingNumber then address.buildingNumber else ''
            $scope.bb.address1 = address.buildingName + " " + building_number
            $scope.bb.address2 = address.streetName

          if !address.buildingNumber? and !address.streetName?
            $scope.bb.address1 = address.buildingName
            $scope.bb.address2 = address.addressLine3
            $scope.bb.address4 = address.town


          #The below conditional logic is VERY specific to different company address layouts
          if address.companyName?
            $scope.bb.address1 = address.companyName

            if !address.buildingNumber? and !address.streetName?
              $scope.bb.address2 = address.addressLine3
            else if !address.buildingNumber?
              address2 = if address.buildingName then address.buildingName + ', ' + address.streetName else address.streetName
              $scope.bb.address2 = address2
            else if !address.buildingName? and !address.addressLine2?
              $scope.bb.address2 = address.buildingNumber + ", " + address.streetName
            else
              $scope.bb.address2 = address.buildingName
            $scope.bb.address3 = address.buildingName

            if address.addressLine3 && address.buildingNumber?
              address3 = address.addressLine3
            else if !address.addressLine2? and address.buildingNumber?
              address3 = address.buildingNumber + " " + address.streetName
            else if !address.addressLine2? and !address.buildingNumber? and address.buildingName?
              address3 = address.addressLine3
            else
              address3 = ''
            $scope.bb.address3 = address3
            $scope.bb.address4 = address.town
            $scope.bb.address5 = ""
            $scope.bb.postcode = address.postCode

          if !address.buildingName? and !address.companyName? and !address.county?
            if !address.addressLine2? and !address.companyName?
              address2 = address.addressLine3
            else
              address2 = address.addressLine2
            $scope.bb.address2 = address2
          else if !address.buildingName? and !address.companyName?
            $scope.bb.address2 = address.addressLine3

          if address.buildingName? and address.streetName? and !address.companyName? and address.addressLine3?
            if !address.addressLine3?
              $scope.bb.address3 = address.buildingName
            else
              $scope.bb.address3 = address.addressLine3
          else if !address.buildingName? and !address.companyName? and address.addressLine2?
            $scope.bb.address3 = address.addressLine3
          else if !address.buildingName? and address.streetName? and !address.addressLine3?
            $scope.bb.address3 = address.addressLine3
          $scope.bb.address4 = address.town
          $scope.bb.address5 = address.county if address.county?
          loader.setLoaded()
          return
        ,(err) ->
            $scope.show_complete_address = true
            $scope.postcode_submitted = false
            loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name setManualPostcodeEntry
  * @methodOf BB.Directives:bbAddresses
  * @description
  * Set manual postcode entry
  *
  * @param {string} value The value of postcode
  ###
  $scope.setManualPostcodeEntry = (value) ->
    $scope.manual_postcode_entry = value


  $scope.$on "client_details:reset_search", (event) ->
    $scope.bb.address1 = null
    $scope.bb.address2 = null
    $scope.bb.address3 = null
    $scope.bb.address4 = null
    $scope.bb.address5 = null
    $scope.show_complete_address = false
    $scope.postcode_submitted = false
    $scope.bb.address = $scope.addresses[0]

