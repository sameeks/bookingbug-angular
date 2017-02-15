/***
 * @ngdoc service
 * @name BB.Models:Client
 *
 * @description
 * Representation of an Client Object
 *
 * @property {string} first_name Client first name
 * @property {string} last_name Client last name
 * @property {string} email Client email address
 * @property {string} address1 The first line of client address
 * @property {string} address2 The second line of client address
 * @property {string} address3 The third line of client address
 * @property {string} address4 The fourth line of client address
 * @property {string} address4 The fifth line of client address
 * @property {string} postcode Postcode of the client
 * @property {string} country Country of the client
 * @property {integer} phone The phone number of the client
 * @property {integer} mobile The mobile phone number of the client
 * @property {integer} id Id of the client
 * @property {array} answers Answers of the client
 * @property {boolean} deleted Verify if the client account is deleted or not
 *///


angular.module('BB.Models').factory("ClientModel", ($q, BBModel, BaseModel, ClientService) =>

    class Client extends BaseModel {

        constructor(data) {
            super(...arguments);
            this.name = this.getName();
            if (data) {
                if (data.answers && data.$has('questions')) {
                    this.waitingQuestions = $q.defer();
                    this.gotQuestions = this.waitingQuestions.promise;
                    data.$get('questions').then(details => {
                            this.client_details = new BBModel.ClientDetails(details);
                            this.client_details.setAnswers(data.answers);
                            this.questions = this.client_details.questions;
                            this.setAskedQuestions();  // make sure the item knows the questions were all answered
                            return this.waitingQuestions.resolve();
                        }
                    );
                }
            }
        }


        /***
         * @ngdoc method
         * @name setClientDetails
         * @methodOf BB.Models:Client
         * @description
         * Set client details in according to details parameter
         *
         * @returns {object} The returned client details
         */
        setClientDetails(details) {
            this.client_details = details;
            return this.questions = this.client_details.questions;
        }


        /**
         * @ngdoc method
         * @name setTimeZone
         * @methodOf BB.Models:Client
         * @description
         * Set client time zone in according to time_zone parameter
         * @param {string} time_zone
         */
        setTimeZone(time_zone) {
            if (time_zone != null) {
                this.time_zone = time_zone;
            }
        }


        /***
         * @ngdoc method
         * @name setDefaults
         * @methodOf BB.Models:Client
         * @description
         * Set client defaults in according of values parameter
         *
         * @returns {object} The returned client defaults
         */
        setDefaults(values) {
            if (values.name) {
                this.name = values.name;
            }
            if (values.first_name) {
                this.first_name = values.first_name;
            }
            if (values.last_name) {
                this.last_name = values.last_name;
            }
            if (values.phone) {
                this.phone = values.phone;
            }
            if (values.mobile) {
                this.mobile = values.mobile;
            }
            if (values.email) {
                this.email = values.email;
            }
            if (values.id) {
                this.id = values.id;
            }
            if (values.ref) {
                this.comp_ref = values.ref;
            }
            if (values.comp_ref) {
                this.comp_ref = values.comp_ref;
            }
            if (values.address1) {
                this.address1 = values.address1;
            }
            if (values.address2) {
                this.address2 = values.address2;
            }
            if (values.address3) {
                this.address3 = values.address3;
            }
            if (values.address4) {
                this.address4 = values.address4;
            }
            if (values.address5) {
                this.address5 = values.address5;
            }
            if (values.postcode) {
                this.postcode = values.postcode;
            }
            if (values.country) {
                this.country = values.country;
            }
            if (values.answers) {
                this.default_answers = values.answers;
            }
            if (values.time_zone) {
                return this.time_zone = values.time_zone;
            }
        }

        /***
         * @ngdoc method
         * @name pre_fill_answers
         * @methodOf BB.Models:Client
         * @description
         * Pre fill client answers according of details
         *
         * @returns {object} The returned pre fill answers
         */
        pre_fill_answers(details) {
            if (!this.default_answers) {
                return;
            }
            return (() => {
                let result = [];
                for (let q of Array.from(details.questions)) {
                    let item;
                    if (this.default_answers[q.name]) {
                        item = q.answer = this.default_answers[q.name];
                    }
                    result.push(item);
                }
                return result;
            })();
        }

        /***
         * @ngdoc method
         * @name getName
         * @methodOf BB.Models:Client
         * @description
         * Get client first name and last name
         *
         * @returns {string} The returned client name
         */
        getName() {
            let str = "";
            if (this.first_name) {
                str += this.first_name;
            }
            if ((str.length > 0) && this.last_name) {
                str += " ";
            }
            if (this.last_name) {
                str += this.last_name;
            }
            return str;
        }

        /***
         * @ngdoc method
         * @name addressSingleLine
         * @methodOf BB.Models:Address
         * @description
         * Get the address and postcode of the client
         *
         * @returns {string} The returned address
         */
        addressSingleLine() {
            let str = "";
            if (this.address1) {
                str += this.address1;
            }
            if (this.address2 && (str.length > 0)) {
                str += ", ";
            }
            if (this.address2) {
                str += this.address2;
            }
            if (this.address3 && (str.length > 0)) {
                str += ", ";
            }
            if (this.address3) {
                str += this.address3;
            }
            if (this.address4 && (str.length > 0)) {
                str += ", ";
            }
            if (this.address4) {
                str += this.address4;
            }
            if (this.address5 && (str.length > 0)) {
                str += ", ";
            }
            if (this.address5) {
                str += this.address5;
            }
            if (this.postcode && (str.length > 0)) {
                str += ", ";
            }
            if (this.postcode) {
                str += this.postcode;
            }
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
         * Get all address fields, postcode and country for CSV file
         *
         * @returns {string} The returned address
         */
        addressCsvLine() {
            let str = "";
            if (this.address1) {
                str += this.address1;
            }
            str += ", ";
            if (this.address2) {
                str += this.address2;
            }
            str += ", ";
            if (this.address3) {
                str += this.address3;
            }
            str += ", ";
            if (this.address4) {
                str += this.address4;
            }
            str += ", ";
            if (this.address5) {
                str += this.address5;
            }
            str += ", ";
            if (this.postcode) {
                str += this.postcode;
            }
            str += ", ";
            if (this.country) {
                str += this.country;
            }
            return str;
        }

        /***
         * @ngdoc method
         * @name addressMultiLine
         * @methodOf BB.Models:Address
         * @description
         * Get address several lines separated by line breaks
         *
         * @returns {string} The returned address
         */
        addressMultiLine() {
            let str = "";
            if (this.address1) {
                str += this.address1;
            }
            if (this.address2 && (str.length > 0)) {
                str += "<br/>";
            }
            if (this.address2) {
                str += this.address2;
            }
            if (this.address3 && (str.length > 0)) {
                str += "<br/>";
            }
            if (this.address3) {
                str += this.address3;
            }
            if (this.address4 && (str.length > 0)) {
                str += "<br/>";
            }
            if (this.address4) {
                str += this.address4;
            }
            if (this.address5 && (str.length > 0)) {
                str += "<br/>";
            }
            if (this.address5) {
                str += this.address5;
            }
            if (this.postcode && (str.length > 0)) {
                str += "<br/>";
            }
            if (this.postcode) {
                str += this.postcode;
            }
            return str;
        }

        /***
         * @ngdoc method
         * @name getPostData
         * @methodOf BB.Models:Address
         * @description
         * Build an array with details of the client
         *
         * @returns {array} newly created details array
         */
        getPostData() {
            let x = {};
            x.first_name = this.first_name;
            x.last_name = this.last_name;
            if (this.house_number) {
                x.address1 = this.house_number + " " + this.address1;
            } else {
                x.address1 = this.address1;
            }
            x.address2 = this.address2;
            x.address3 = this.address3;
            x.address4 = this.address4;
            x.address5 = this.address5;
            x.postcode = this.postcode;
            x.country = this.country;
            x.email = this.email;
            x.id = this.id;
            x.comp_ref = this.comp_ref;
            x.parent_client_id = this.parent_client_id;
            x.password = this.password;
            x.notifications = this.notifications;
            if (this.member_level_id) {
                x.member_level_id = this.member_level_id;
            }
            if (this.send_welcome_email) {
                x.send_welcome_email = this.send_welcome_email;
            }
            if (this.default_company_id) {
                x.default_company_id = this.default_company_id;
            }
            if (this.time_zone) {
                x.time_zone = this.time_zone;
            }

            if (this.phone) {
                x.phone = this.phone;
                if (this.phone_prefix) {
                    x.phone_prefix = this.phone_prefix;
                }
            }

            if (this.mobile) {
                this.remove_prefix();
                x.mobile = this.mobile;
                x.mobile_prefix = this.mobile_prefix;
            }


            if (this.questions) {
                x.questions = [];
                for (let q of Array.from(this.questions)) {
                    x.questions.push(q.getPostData());
                }
            }
            return x;
        }

        /***
         * @ngdoc method
         * @name valid
         * @methodOf BB.Models:Address
         * @description
         * Checks if this is considered a valid email
         *
         * @returns {boolean} If this is a valid email
         */
        valid() {
            if (this.isValid) {
                return this.isValid;
            }
            if (this.email || this.hasServerId()) {
                return true;
            } else {
                return false;
            }
        }

        /***
         * @ngdoc method
         * @name setValid
         * @methodOf BB.Models:Address
         * @description
         * Set valid client, according of val
         *
         * @returns {object} The returned valid client
         */
        setValid(val) {
            return this.isValid = val;
        }

        /***
         * @ngdoc method
         * @name hasServerId
         * @methodOf BB.Models:Address
         * @description
         * Checks if this has a id
         *
         * @returns {boolean} If this has a id
         */
        hasServerId() {
            return this.id;
        }

        /***
         * @ngdoc method
         * @name setAskedQuestions
         * @methodOf BB.Models:Address
         * @description
         * Set asked questions of the client
         *
         * @returns {boolean} If this is set
         */
        setAskedQuestions() {
            return this.asked_questions = true;
        }

        /***
         * @ngdoc method
         * @name fullMobile
         * @methodOf BB.Models:Address
         * @description
         * Full mobile phone number of the client
         *
         * @returns {object} The returned full mobile number
         */
        fullMobile() {
            if (!this.mobile) {
                return;
            }
            if (!this.mobile_prefix) {
                return this.mobile;
            }
            return `+${this.mobile_prefix}${this.mobile.substr(0, 1) === '0' ? this.mobile.substr(1) : this.mobile}`;
        }

        /***
         * @ngdoc method
         * @name remove_prefix
         * @methodOf BB.Models:Address
         * @description
         * Remove prefix from mobile number of the client
         *
         * @returns {array} The returned full mobile number without prefix
         */
        remove_prefix() {
            let pref_arr = this.mobile.match(/^(\+|00)(999|998|997|996|995|994|993|992|991|990|979|978|977|976|975|974|973|972|971|970|969|968|967|966|965|964|963|962|961|960|899|898|897|896|895|894|893|892|891|890|889|888|887|886|885|884|883|882|881|880|879|878|877|876|875|874|873|872|871|870|859|858|857|856|855|854|853|852|851|850|839|838|837|836|835|834|833|832|831|830|809|808|807|806|805|804|803|802|801|800|699|698|697|696|695|694|693|692|691|690|689|688|687|686|685|684|683|682|681|680|679|678|677|676|675|674|673|672|671|670|599|598|597|596|595|594|593|592|591|590|509|508|507|506|505|504|503|502|501|500|429|428|427|426|425|424|423|422|421|420|389|388|387|386|385|384|383|382|381|380|379|378|377|376|375|374|373|372|371|370|359|358|357|356|355|354|353|352|351|350|299|298|297|296|295|294|293|292|291|290|289|288|287|286|285|284|283|282|281|280|269|268|267|266|265|264|263|262|261|260|259|258|257|256|255|254|253|252|251|250|249|248|247|246|245|244|243|242|241|240|239|238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|219|218|217|216|215|214|213|212|211|210|98|95|94|93|92|91|90|86|84|82|81|66|65|64|63|62|61|60|58|57|56|55|54|53|52|51|49|48|47|46|45|44|43|41|40|39|36|34|33|32|31|30|27|20|7|1)/);
            if (pref_arr) {
                this.mobile.replace(pref_arr[0], "");
                return this.mobile_prefix = pref_arr[0];
            }
        }


        /***
         * @ngdoc method
         * @name $getPrePaidBookings
         * @methodOf BB.Models:Address
         * @description
         * Get pre paid bookings promise of the client
         *
         * @returns {promise} A promise for client pre paid bookings
         */
        $getPrePaidBookings(params) {
            let defer = $q.defer();
            if (this.$has('pre_paid_bookings')) {
                this.$get('pre_paid_bookings', params).then(collection =>
                        collection.$get('pre_paid_bookings').then(prepaids => defer.resolve((Array.from(prepaids).map((prepaid) => new BBModel.PrePaidBooking(prepaid))))
                            , err => defer.reject(err))

                    , err =>
                        // =====================================================================================================
                        // TO FIX IN API:
                        // When a default Client is generated by SSO, @get('pre_paid_bookings') returns 401
                        // which in turn throws an error in the Widget
                        // I am going to fail this error silently so that the Widget will not display the error for CHORLEY
                        // =====================================================================================================
                        defer.resolve([])
                );
                // defer.reject(err)
                // return empty array if there are no prepaid bookings
            } else {
                defer.resolve([]);
            }
            return defer.promise;
        }

        static $create_or_update(company, client) {
            return ClientService.create_or_update(company, client);
        }

        static $query_by_email(company, email) {
            return ClientService.query_by_email(company, email);
        }
    }
);

