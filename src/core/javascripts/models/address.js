// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:Address
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


angular.module('BB.Models').factory("AddressModel", ($q, BBModel, BaseModel, AddressListService) =>

  class Address extends BaseModel {

    constructor(data) {
      super(data);
      // Assign value to map_url if the value is an empty String
      // Note: This is not ideal as it will not show a map marker. But the map_url prop should already be set, so this is just a fallback
      if (!this.map_url || (this.map_url === "")) {
        if (this.lat && this.long) { this.map_url = `https://www.google.com/maps/@${this.lat},${this.long},17z`; }
      }
    }

    /***
    * @ngdoc method
    * @name addressSingleLine
    * @methodOf BB.Models:Address
    * @description
    * Get a the address as a single comma sepeated line
    *
    * @returns {string} The returned address
    */
    addressSingleLine() {
      let str = "";
      if (this.address1) { str += this.address1; }
      if (this.address2 && (str.length > 0)) { str += ", "; }
      if (this.address2) { str += this.address2; }
      if (this.address3 && (str.length > 0)) { str += ", "; }
      if (this.address3) { str += this.address3; }
      if (this.address4 && (str.length > 0)) { str += ", "; }
      if (this.address4) { str += this.address4; }
      if (this.address5 && (str.length > 0)) { str += ", "; }
      if (this.address5) { str += this.address5; }
      if (this.postcode && (str.length > 0)) { str += ", "; }
      if (this.postcode) { str += this.postcode; }
      return str;
    }

    /***
    * @ngdoc method
    * @name hasAddress
    * @methodOf BB.Models:Address
    * @description
    * Checks if this is considered a valid address
    *
    * @returns {boolean} If this is a valid address
    */
    hasAddress() {
      return this.address1 || this.address2 || this.postcode;
    }

    /***
    * @ngdoc method
    * @name addressCsvLine
    * @methodOf BB.Models:Address
    * @description
    * Get all address fields as a single comma sepeated line - suitable for csv export
    *
    * @returns {string} The returned address
    */
    addressCsvLine() {
      let str = "";
      if (this.address1) { str += this.address1; }
      str += ", ";
      if (this.address2) { str += this.address2; }
      str += ", ";
      if (this.address3) { str += this.address3; }
      str += ", ";
      if (this.address4) { str += this.address4; }
      str += ", ";
      if (this.address5) { str += this.address5; }
      str += ", ";
      if (this.postcode) { str += this.postcode; }
      str += ", ";
      if (this.country) { str += this.country; }
      return str;
    }

    /***
    * @ngdoc method
    * @name addressMultiLine
    * @methodOf BB.Models:Address
    * @description
    * Get a the address as multiple lines with line feeds
    *
    * @returns {string} The returned address
    */
    addressMultiLine() {
      let str = "";
      if (this.address1) { str += this.address1; }
      if (this.address2 && (str.length > 0)) { str += "<br/>"; }
      if (this.address2) { str += this.address2; }
      if (this.address3 && (str.length > 0)) { str += "<br/>"; }
      if (this.address3) { str += this.address3; }
      if (this.address4 && (str.length > 0)) { str += "<br/>"; }
      if (this.address4) { str += this.address4; }
      if (this.address5 && (str.length > 0)) { str += "<br/>"; }
      if (this.address5) { str += this.address5; }
      if (this.postcode && (str.length > 0)) { str += "<br/>"; }
      if (this.postcode) { str += this.postcode; }
      return str;
    }

    static $query(prms) {
      return AddressListService.query(prms);
    }

    static $getAddress(prms) {
      return AddressListService.getAddress(prms);
    }
  }
);

