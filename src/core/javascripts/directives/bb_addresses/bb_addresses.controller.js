// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('AddressList', function(
  $scope, $rootScope, $filter, $sniffer, FormDataStoreService, LoadingService,
  BBModel) {

  $scope.manual_postcode_entry = false;
  let loader = LoadingService.$loader($scope);

  FormDataStoreService.init('AddressList', $scope, [
    'show_complete_address'
  ]);

  $rootScope.connection_started.then(() => {
    if ($scope.client.postcode && !$scope.bb.postcode) {
      $scope.bb.postcode = $scope.client.postcode;
    }

    // if client postcode is set and matches postcode entered by the user (and address isn't already set), copy the address from the client
    if ($scope.client.postcode && $scope.bb.postcode && ($scope.client.postcode === $scope.bb.postcode) && !$scope.bb.address1) {
      $scope.bb.address1 = $scope.client.address1;
      $scope.bb.address2 = $scope.client.address2;
      $scope.bb.address3 = $scope.client.address3;
      $scope.bb.address4 = $scope.client.address4;
      $scope.bb.address5 = $scope.client.address5;
    }

    $scope.manual_postcode_entry = !$scope.bb.postcode ? true : false;
    $scope.show_complete_address = $scope.bb.address1 ? true : false;
    if (!$scope.postcode_submitted) {
      $scope.findByPostcode();
      return $scope.postcode_submitted = false;
    }
  }
  , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));


  /***
  * @ngdoc method
  * @name findByPostcode
  * @methodOf BB.Directives:bbAddresses
  * @description
  * Make a request for a list of addresses. They come as seperate list of objects containing addresses and monikers, which are converted into a single list of objects containing both properties.
  */
  // make a request for a list of addresses. They come as seperate list of
  // objects containing addresses and monikers, which are converted into a single
  // list of objects containing both properties.
  $scope.findByPostcode = function() {
    $scope.postcode_submitted = true;
    if (!$scope.bb.postcode) { return; }

    loader.notLoaded();
    return BBModel.Address.$query({
      company: $scope.bb.company,
      post_code: $scope.bb.postcode
    })
    .then(function(response) {
      // create an array of addresses
      let addressArr;
      if (angular.isArray(response)) {
        addressArr = _.map(response, (item, i) =>
          ({
            address : item.partialAddress,
            moniker : item.moniker
          })
        );
      } else {
        addressArr = [{
          address : response.partialAddress,
          moniker : response.moniker
        }];
      }

      //  there is a bug in IE where it can't display a single option if the
      //  select menu is set to display more than one i.e. <select size="3">, so
      //  we add a blank
      if ((addressArr.length === 1) && $sniffer.msie) {
        let newaddr = [];
        newaddr.push(addressArr[0]);
        newaddr.push({address : '' });
        addressArr = newaddr;
      }

      $scope.addresses = addressArr;
      // set address as as first item to prevent angular adding an empty item to
      // the select control this is bound to
      $scope.bb.address = addressArr[0];
      $scope.client.address = addressArr[0];
      loader.setLoaded();
    }
    ,function(err) {
      $scope.show_complete_address = true;
      $scope.postcode_submitted = true;
      return loader.setLoaded();
    });
  };

  /***
  * @ngdoc method
  * @name showCompleteAddress
  * @methodOf BB.Directives:bbAddresses
  * @description
  * Show complete address
  */
  $scope.showCompleteAddress = function() {
      $scope.show_complete_address = true;
      $scope.postcode_submitted = false;

      if ($scope.bb.address && $scope.bb.address.moniker) {
        loader.notLoaded();
        return BBModel.Address.$getAddress({
          company : $scope.bb.company,
          id : $scope.bb.address.moniker
        })
        .then(function(response) {
          let address2, address3, addressLine2, streetName;
          let address = response;
          let house_number = '';
          if (typeof address.buildingNumber === 'string') {
            house_number = address.buildingNumber;
          } else if (address.buildingNumber == null) {
            house_number = address.buildingName;
          }

          if (typeof address.streetName === 'string') {
            streetName = address.streetName ? address.streetName : '';
            $scope.bb.address1 = house_number + ' ' + streetName;
          } else {
            addressLine2 = address.addressLine2 ? address.addressLine2 : '';
            $scope.bb.address1 = house_number + ' ' + addressLine2;
          }

          if (address.buildingName && (address.buildingNumber == null)) {
            $scope.bb.address1 = house_number;
            $scope.bb.address2 = address.streetName;
            if (address.county != null) { $scope.bb.address4 = address.county; }
          }

          if ((typeof address.buildingNumber === 'string') && (typeof address.buildingName === 'string') && (typeof address.streetName === 'string')) {
            streetName = address.streetName ? address.streetName : '';
            $scope.bb.address1 = address.buildingName;
            $scope.bb.address2 = address.buildingNumber + " " + streetName;
          }

          if ((address.buildingName != null) && address.buildingName.match(/(^[^0-9]+$)/)) {
            let building_number = address.buildingNumber ? address.buildingNumber : '';
            $scope.bb.address1 = address.buildingName + " " + building_number;
            $scope.bb.address2 = address.streetName;
          }

          if ((address.buildingNumber == null) && (address.streetName == null)) {
            $scope.bb.address1 = address.buildingName;
            $scope.bb.address2 = address.addressLine3;
            $scope.bb.address4 = address.town;
          }


          //The below conditional logic is VERY specific to different company address layouts
          if (address.companyName != null) {
            $scope.bb.address1 = address.companyName;

            if ((address.buildingNumber == null) && (address.streetName == null)) {
              $scope.bb.address2 = address.addressLine3;
            } else if (address.buildingNumber == null) {
              address2 = address.buildingName ? address.buildingName + ', ' + address.streetName : address.streetName;
              $scope.bb.address2 = address2;
            } else if ((address.buildingName == null) && (address.addressLine2 == null)) {
              $scope.bb.address2 = address.buildingNumber + ", " + address.streetName;
            } else {
              $scope.bb.address2 = address.buildingName;
            }
            $scope.bb.address3 = address.buildingName;

            if (address.addressLine3 && (address.buildingNumber != null)) {
              address3 = address.addressLine3;
            } else if ((address.addressLine2 == null) && (address.buildingNumber != null)) {
              address3 = address.buildingNumber + " " + address.streetName;
            } else if ((address.addressLine2 == null) && (address.buildingNumber == null) && (address.buildingName != null)) {
              address3 = address.addressLine3;
            } else {
              address3 = '';
            }
            $scope.bb.address3 = address3;
            $scope.bb.address4 = address.town;
            $scope.bb.address5 = "";
            $scope.bb.postcode = address.postCode;
          }

          if ((address.buildingName == null) && (address.companyName == null) && (address.county == null)) {
            if ((address.addressLine2 == null) && (address.companyName == null)) {
              address2 = address.addressLine3;
            } else {
              address2 = address.addressLine2;
            }
            $scope.bb.address2 = address2;
          } else if ((address.buildingName == null) && (address.companyName == null)) {
            $scope.bb.address2 = address.addressLine3;
          }

          if ((address.buildingName != null) && (address.streetName != null) && (address.companyName == null) && (address.addressLine3 != null)) {
            if (address.addressLine3 == null) {
              $scope.bb.address3 = address.buildingName;
            } else {
              $scope.bb.address3 = address.addressLine3;
            }
          } else if ((address.buildingName == null) && (address.companyName == null) && (address.addressLine2 != null)) {
            $scope.bb.address3 = address.addressLine3;
          } else if ((address.buildingName == null) && (address.streetName != null) && (address.addressLine3 == null)) {
            $scope.bb.address3 = address.addressLine3;
          }
          $scope.bb.address4 = address.town;
          if (address.county != null) { $scope.bb.address5 = address.county; }
          loader.setLoaded();
        }
        ,function(err) {
            $scope.show_complete_address = true;
            $scope.postcode_submitted = false;
            return loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
        });
      }
    };

  /***
  * @ngdoc method
  * @name setManualPostcodeEntry
  * @methodOf BB.Directives:bbAddresses
  * @description
  * Set manual postcode entry
  *
  * @param {string} value The value of postcode
  */
  $scope.setManualPostcodeEntry = value => $scope.manual_postcode_entry = value;


  return $scope.$on("client_details:reset_search", function(event) {
    $scope.bb.address1 = null;
    $scope.bb.address2 = null;
    $scope.bb.address3 = null;
    $scope.bb.address4 = null;
    $scope.bb.address5 = null;
    $scope.show_complete_address = false;
    $scope.postcode_submitted = false;
    return $scope.bb.address = $scope.addresses[0];});});
