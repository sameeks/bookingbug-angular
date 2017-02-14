// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc service
 * @name BB.Models:AdminAddress
 *
 * @description
 * Representation of an Address Object
 *
 * @property {string} address1 First line of the address
 * @property {string} address2 Second line of the address
 * @property {string} address3 Third line of the address
 * @property {string} address4 Fourth line of the address
 * @property {string} address5 Fifth line of the address
 * @property {string} postcode The Postcode/Zipcode
 * @property {string} country The country
 *///

angular.module('BB.Models').factory("AdminAddressModel", ($q, BBModel, BaseModel, AddressModel) =>

    /***
     * @ngdoc method
     * @name distanceFrom
     * @methodOf BB.Models:AdminAddress
     * @param {string=} address The admin address
     * @param {array} options The options of admin address
     * @description
     * Calculate the address distance in according of the address and options parameters
     *
     * @returns {array} Returns an array of address
     */
    class Admin_Address extends AddressModel {

        distanceFrom(address, options) {

            if (!this.dists) {
                this.dists = [];
            }
            if (!this.dists[address]) {
                this.dists[address] = Math.round(Math.random() * 50, 0);
            }
            return this.dists[address];
        }
    });

