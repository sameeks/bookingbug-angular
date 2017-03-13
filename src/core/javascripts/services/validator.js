/***
 * @ngdoc service
 * @name BB.Services:Validator
 *
 * @description
 * Representation of an Validator Object
 *
 * @property {string} alpha Alpha pattern that accepts letters, hypens and spaces
 * @property {string} us_phone_number US phone number regex
 *
 */


angular.module('BB.Services').factory('ValidatorService', function ($rootScope, AlertService, CompanyStoreService, BBModel, $q, $bbug) {

    // Use http://regex101.com/ to test patterns

    // UK postcode regex (strict)
    // http://regexlib.com/REDetails.aspx?regexp_id=260
    // uk_postcode_regex = /^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$/i
    // let uk_postcode_regex = /^(((([A-PR-UWYZ][0-9][0-9A-HJKS-UW]?)|([A-PR-UWYZ][A-HK-Y][0-9][0-9ABEHMNPRV-Y]?))\s{0,1}[0-9]([ABD-HJLNP-UW-Z]{2}))|(GIR\s{0,2}0AA))$/i;

    // US postcode regex used for getMailingPattern
    let us_postcode_regex = /^\d{5}(?:[-\s]\d{4})?$/;

    // UK postcode regex (lenient) - this checks for a postcode like string
    // https://gist.github.com/simonwhitaker/5748487
    let uk_postcode_regex_lenient = /^[A-Z]{1,2}[0-9][0-9A-Z]?\s*[0-9][A-Z]{2}$/i;

    // number only regex
    let number_only_regex = /^\d+$/;

    // UK mobile number regex (strict)
    // ----------------------------------------------------------------------------------------------------------------------------------------
    // +44 or 0 followed by 7 followed by [45789] followed by \d{2} or 624 followed by \d{6} and can contain any number of spaces in between
    // ----------------------------------------------------------------------------------------------------------------------------------------
    let uk_mobile_regex_strict = /^((\+44|0)\s*7\s*([45789](\s*\d){2}|6\s*2\s*4)(\s*\d){6})$/;

    // mobile number regex (lenient)
    let mobile_regex_lenient = /^(0|\+)([\d \(\)]{9,19})$/;

    // UK landline regex (strict)
    // ----------------------------------------------------------------------------------------------------------------
    // Will accept numbers like: 0208 695 1232, 020 8695 1232, +44 208 695 1232, +44 1623 431 091
    // ----------------------------------------------------------------------------------------------------------------
    let uk_landline_regex_strict = /^(\+44|0)\s*[1-9]\s*\d{1,4}\s*\d{3,4}\s*\d{2,4}$/;


    // UK landline regex (lenient)
    let uk_landline_regex_lenient = /^(0|\+)([\d \(\)]{9,19})$/;

    // international number
    let international_number = /^(\+)([\d \(\)]{9,19})$/;

    let email_regex = /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i;

    // password requires minimum of 7 characters and 1 number
    let standard_password = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

    // alphanumeric
    let alphanumeric = /^[a-zA-Z0-9]*$/;

    let geocode_result = null;

    // letters, hyphens and spaces
    return {
        alpha: /^[a-zA-Z\s-]*$/,

        // https://www.safaribooksonline.com/library/view/regular-expressions-cookbook/9781449327453/ch04s02.html
        us_phone_number: /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,


        /***
         * @ngdoc method
         * @name getEmailPattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching email addresses
         *
         * @returns {string} Email regex
         */
        getEmailPattern() {
            return email_regex;
        },


        /***
         * @ngdoc method
         * @name getStandardPassword
         * @methodOf BB.Services:Validator
         * @description
         * Returns a password pattern enforcing at least 7 characters and 1 number
         *
         * @returns {string} Password regex
         */
        getStandardPassword() {
            return standard_password;
        },


        /***
         * @ngdoc method
         * @name getUKPostcodePattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching UK postcodes
         *
         * @returns {string} UK Postcode regex
         */
        getUKPostcodePattern() {
            return uk_postcode_regex_lenient;
        },


        /***
         * @ngdoc method
         * @name getUKPostcodePattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching local mailing codes based on current companies country
         *
         * @returns {string} Mailing code regex
         */
        // We use the country code in favour of the locale given that it's more likley that a user will reside in the same place as the business
        getMailingPattern() {
            let cc = CompanyStoreService.country_code;
            switch (cc) {
                case "us":
                    return us_postcode_regex;
                case "gb":
                    return uk_postcode_regex_lenient;
                default:
                    return null;
            }
        },

        /***
         * @ngdoc method
         * @name getNumberOnlyPattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching numbers only
         *
         * @returns {string} Number only regex
         */
        getNumberOnlyPattern() {
            return number_only_regex;
        },


        /***
         * @ngdoc method
         * @name getAlphaNumbericPattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching alpha numeric strings
         *
         * @returns {string} The returned the alphanumeric regex
         */
        getAlphaNumbericPattern() {
            return alphanumeric;
        },


        /***
         * @ngdoc method
         * @name getUKMobilePattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for mathing number like strings between 9 and 19 characters.  If the strict flag is used, the pattern matches UK mobile numbers
         *
         * @param {boolean} strict Use strict validation. Defaults to false.
         * @returns {string} The returned the UK mobile regixt strict if this is strict else return mobile_regex_lenient
         */
        getUKMobilePattern(strict) {
            if (strict == null) {
                strict = false;
            }
            if (strict) {
                return uk_mobile_regex_strict;
            }
            return mobile_regex_lenient;
        },


        /***
         * @ngdoc method
         * @name getMobilePattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching number like strings between 9 and 19 characters
         *
         * @returns {string} Mobile regex
         */
        getMobilePattern() {
            return mobile_regex_lenient;
        },


        /***
         * @ngdoc method
         * @name getUKLandlinePattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching number like strinsg between 9 and 19 characters.  If the strict flag is used, the pattern matches UK landline numbers
         *
         * @param {boolean} strict Use strict validation. Defaults to false.
         * @returns {string} UK landline regex
         */
        getUKLandlinePattern(strict) {
            if (strict == null) {
                strict = false;
            }
            if (strict) {
                return uk_landline_regex_strict;
            }
            return uk_landline_regex_lenient;
        },


        /***
         * @ngdoc method
         * @name getIntPhonePattern
         * @methodOf BB.Services:Validator
         * @description
         * Returns a pattern for matching number like strings between 9 and 19 characters
         *
         * @returns {string} International number regex
         */
        getIntPhonePattern() {
            return international_number;
        },


        /***
         * @ngdoc method
         * @name getGeocodeResult
         * @methodOf BB.Services:Validator
         * @description
         * Get the geocode result
         *
         * @returns {object} Geocoder result
         */
        getGeocodeResult() {
            if (geocode_result) {
                return geocode_result;
            }
        },


        /***
         * @ngdoc method
         * @name validatePostcode
         * @methodOf BB.Services:Validator
         * @description
         * Validates a postcode using the Google Maps API
         *
         * @returns {promise|boolean} A promise that resolves to indicate the postcodes valdiity after it has been verified using the Google Maps API or a boolean indicating if the postcode is missing or invalid
         */
        validatePostcode(form, prms) {

            AlertService.clear();

            if (!form || !form.postcode) {
                return false;
            }

            if (form.$error.required) {

                AlertService.raise('MISSING_POSTCODE');
                return false;

            } else if (form.$error.pattern) {

                AlertService.raise('POSTCODE_INVALID');
                return false;

            } else {

                let deferred = $q.defer();

                let postcode = form.postcode.$viewValue;

                let req = {address: postcode};
                if (prms.region) {
                    req.region = prms.region;
                }
                req.componentRestrictions = {'postalCode': req.address};

                if (prms.bounds) {
                    let sw = new google.maps.LatLng(prms.bounds.sw.x, prms.bounds.sw.y);
                    let ne = new google.maps.LatLng(prms.bounds.ne.x, prms.bounds.ne.y);
                    req.bounds = new google.maps.LatLngBounds(sw, ne);
                }

                let geocoder = new google.maps.Geocoder();
                geocoder.geocode(req, function (results, status) {

                    if ((results.length === 1) && (status === 'OK')) {

                        geocode_result = results[0];
                        return deferred.resolve(true);

                    } else {

                        AlertService.raise('POSTCODE_INVALID');
                        $rootScope.$apply();
                        return deferred.reject(false);
                    }
                });

                return deferred.promise;
            }
        },


        /***
         * @ngdoc method
         * @name validateForm
         * @methodOf BB.Services:Validator
         * @description
         * Validate a form
         *
         * @returns {boolean} Validity of form
         */
        validateForm(form) {

            if (!form) {
                return false;
            }

            form.submitted = true;
            $rootScope.$broadcast("form:validated", form);

            if (form.$invalid && form.raise_alerts && form.alert) {

                AlertService.danger(form.alert);
                return false;

            } else if (form.$invalid && form.raise_alerts) {

                AlertService.danger(ErrorService.getError('FORM_INVALID'));
                return false;

            } else if (form.$invalid) {

                return false;

            } else {

                return true;
            }
        },


        /***
         * @ngdoc method
         * @name resetForm
         * @methodOf BB.Services:Validator
         * @description
         * Set pristine state on a form
         *
         * @param {form} A single instance of a form controller
         */
        resetForm(form) {

            if (form) {
                form.submitted = false;
                return form.$setPristine();
            }
        },


        /***
         * @ngdoc method
         * @name resetForms
         * @methodOf BB.Services:Validator
         * @description
         * Set pristine state on given array of forms
         *
         * @param {array} Array of form controllers
         */
        resetForms(forms) {
            if (forms && $bbug.isArray(forms)) {
                return Array.from(forms).map((form) =>
                    (form.submitted = false,
                        form.$setPristine()));
            }
        }
    };
});

