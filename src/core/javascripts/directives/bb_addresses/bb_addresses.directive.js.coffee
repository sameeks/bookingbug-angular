'use strict'

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
