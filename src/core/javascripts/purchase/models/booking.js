angular.module('BB.Models').factory("Purchase.BookingModel", ($q, $window, BBModel, BaseModel, $bbug) =>


    class Purchase_Booking extends BaseModel {
        constructor(data) {
            super(data);
            this.ready = false;

            this.datetime = moment.parseZone(this.datetime);
            if (this.time_zone) {
                this.datetime.tz(this.time_zone);
            }

            this.original_datetime = moment(this.datetime);

            this.end_datetime = moment.parseZone(this.end_datetime);
            if (this.time_zone) {
                this.end_datetime.tz(this.time_zone);
            }

            this.min_cancellation_time = moment(this.min_cancellation_time);
            this.min_cancellation_hours = this.datetime.diff(this.min_cancellation_time, 'hours');
        }

        getGroup() {
            if (this.group) {
                return this.group;
            }
            if (this._data.$has('event_groups')) {
                return this._data.$get('event_groups').then(group => {
                        this.group = group;
                        return this.group;
                    }
                );
            }
        }


        getColour() {
            if (this.getGroup()) {
                return this.getGroup().colour;
            } else {
                return "#FFFFFF";
            }
        }


        getCompany() {
            if (this.company) {
                return this.company;
            }
            if (this.$has('company')) {
                return this._data.$get('company').then(company => {
                        this.company = new BBModel.Company(company);
                        return this.company;
                    }
                );
            }
        }


        $getAnswers() {
            let defer = $q.defer();
            if (this.answers != null) {
                defer.resolve(this.answers);
            } else {
                this.answers = [];
                if (this._data.$has('answers')) {
                    this._data.$get('answers').then(answers => {
                            this.answers = (Array.from(answers).map((a) => new BBModel.Answer(a)));
                            return defer.resolve(this.answers);
                        }
                    );
                } else {
                    defer.resolve([]);
                }
            }
            return defer.promise;
        }

        $getSurveyAnswers() {
            let defer = $q.defer();
            if (this.survey_answers) {
                defer.resolve(this.survey_answers);
            }
            if (this._data.$has('survey_answers')) {
                this._data.$get('survey_answers').then(survey_answers => {
                        this.survey_answers = (Array.from(survey_answers).map((a) => new BBModel.Answer(a)));
                        return defer.resolve(this.survey_answers);
                    }
                );
            } else {
                defer.resolve([]);
            }
            return defer.promise;
        }


        answer(q) {
            if (this.answers != null) {
                for (let a of Array.from(this.answers)) {
                    if (a.name && (a.name === q)) {
                        return a.answer;
                    }
                    if (a.question_text && (a.question_text === q)) {
                        return a.value;
                    }
                }
            } else {
                this.$getAnswers();
            }
            return null;
        }


        getPostData() {
            let data = {};

            data.attended = this.attended;
            data.client_id = this.client_id;
            data.company_id = this.company_id;
            data.time = (this.datetime.hour() * 60) + this.datetime.minute();
            data.date = this.datetime.toISODate();
            data.deleted = this.deleted;
            data.describe = this.describe;
            data.duration = this.duration;
            data.end_datetime = this.end_datetime;

            // is the booking being moved (i.e. new time/new event) or are we just updating
            // the existing booking
            if (this.time && this.time.event_id && !this.isEvent()) {
                data.event_id = this.time.event_id;
            } else if (this.event) {
                data.event_id = this.event.id;
            } else {
                data.event_id = this.slot_id;
            }

            data.full_describe = this.full_describe;
            data.id = this.id;
            data.min_cancellation_time = this.min_cancellation_time;
            data.on_waitlist = this.on_waitlist;
            data.paid = this.paid;
            data.person_name = this.person_name;
            data.price = this.price;
            data.purchase_id = this.purchase_id;
            data.purchase_ref = this.purchase_ref;
            data.quantity = this.quantity;
            data.self = this.self;
            if (this.move_item_id) {
                data.move_item_id = this.move_item_id;
            }
            if (this.srcBooking) {
                data.move_item_id = this.srcBooking.id;
            }
            if (this.person) {
                data.person_id = this.person.id;
            }
            if (this.service) {
                data.service_id = this.service.id;
            }
            if (this.resource) {
                data.resource_id = this.resource.id;
            }
            if (this.item_details) {
                data.questions = this.item_details.getPostData();
            }
            if (this.move_reason) {
                data.move_reason = this.move_reason;
            }
            data.service_name = this.service_name;
            data.settings = this.settings;
            if (this.status) {
                data.status = this.status;
            }
            if (this.email != null) {
                data.email = this.email;
            }
            if (this.email_admin != null) {
                data.email_admin = this.email_admin;
            }
            if (this.first_name) {
                data.first_name = this.first_name;
            }
            if (this.last_name) {
                data.last_name = this.last_name;
            }

            let formatted_survey_answers = [];
            if (this.survey_questions) {
                data.survey_questions = this.survey_questions;
                for (let q of Array.from(this.survey_questions)) {
                    formatted_survey_answers.push({
                        value: q.answer,
                        outcome: q.outcome,
                        detail_type_id: q.id,
                        price: q.price
                    });
                }
                data.survey_answers = formatted_survey_answers;
            }

            return data;
        }

        checkReady() {
            if (this.datetime && this.id && this.purchase_ref) {
                return this.ready = true;
            }
        }


        printed_price() {
            if ((parseFloat(this.price) % 1) === 0) {
                return `£${parseInt(this.price)}`;
            }
            return $window.sprintf("£%.2f", parseFloat(this.price));
        }


        getDateString() {
            return this.datetime.toISODate();
        }


        // return the time of day in total minutes
        getTimeInMins() {
            return (this.datetime.hour() * 60) + this.datetime.minute();
        }


        getAttachments() {
            if (this.attachments) {
                return this.attachments;
            }
            if (this.$has('attachments')) {
                return this._data.$get('attachments').then(atts => {
                        this.attachments = atts.attachments;
                        return this.attachments;
                    }
                );
            }
        }


        canCancel() {
            return moment(this.min_cancellation_time).isAfter(moment());
        }


        canMove() {
            return this.canCancel();
        }


        getAttendeeName() {
            return `${this.first_name} ${this.last_name}`;
        }


        isEvent() {
            return (this.event_chain != null);
        }

        static $addSurveyAnswersToBooking(booking) {
            return PurchaseBookingService.addSurveyAnswersToBooking(booking);
        }
    }
);

