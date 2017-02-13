/***
* @ngdoc service
* @name BB.Models:BasketItem
*
* @description
* Representation of an BasketItem Object
*
* @property {integer} company_id Company id that the basket item belongs to
* @property {integer} total_price Total price of the basket item
* @property {integer} total_due_price Total price of the basket item after applying discounts
* @property {array} items Arrays of items that are in the basket
* @property {integer} event_id The event id of the basket item
* @property {date} datetime Date and time of the event
* @property {integer} status Status of the items
*
*/


angular.module('BB.Models').factory("BasketItemModel", ($q, $window, BBModel, BookableItemModel, BaseModel, $bbug, DateTimeUtilitiesService, $translate) =>

  // A class that defines an item in a shopping basket
  // This could represent a time based service, a ticket for an event or class, or any other purchasable item

  class BasketItem extends BaseModel {

    constructor(data, bb) {

      super(data);

      this.ready = false;
      this.days_link =  null;
      this.book_link =  null;
      this.parts_links = {};
      if (!this.settings) { this.settings = {}; }
      this.has_questions = false;

      // give the basket item a unique reference so that we can track it
      if (!this.ref) { this.ref = Math.ceil(moment().unix() * Math.random()); }

      // if we were given an id then the item is ready - we need to fake a few items
      if (_.isNumber(this.time)) {
        this.time = new BBModel.TimeSlot({time: this.time, event_id: this.event_id, selected: true, avail: 1, price: this.price });
      }
      if (this.date) {
        this.date = new BBModel.Day({date: this.date, spaces: 1});
      }
      if (this.datetime) {
        this.date = new BBModel.Day({date: this.datetime.toISODate(), spaces: 1});

        let t =  (this.datetime.hour() * 60) +  this.datetime.minute();
        this.time = new BBModel.TimeSlot({time: t, event_id: this.event_id, selected: true, avail: 1, price: this.price });
      }

      if (this.id) {
        this.reserve_ready = true; // if it has an id - it must be held - so therefore it must already be 'reservable'
        // keep a note of a possibly held item - we might change this item - but we should know waht was possibly already selected
        this.held = {time: this.time, date: this.date, event_id: this.event_id, id: this.id};
      }



      this.promises = [];

      if (data) {

        let prom, serv;
        if (data.$has("answers")) {
          data.$get("answers").then(answers => {
            data.questions = [];
            return Array.from(answers).map((a) =>
              data.questions.push({id: a.question_id, answer: a.value}));
          }
          );
        }

        if (data.$has('company')) {
          let comp = data.$get('company');
          this.promises.push(comp);
          comp.then(comp => {
            let c = new BBModel.Company(comp);
            this.promises.push(c.getSettings());
            return this.setCompany(c);
          }
          );
        }

        if (data.$has('service')) {
          serv = data.$get('service');
          this.promises.push(serv);
          serv.then(serv => {
            if (serv.$has('category')) {
              prom = serv.$get('category');
              this.promises.push(prom);
              prom.then(cat => {
                return this.setCategory(new BBModel.Category(cat));
              }
              );
            }
            this.setService(new BBModel.Service(serv), data.questions);
            if (this.duration) { this.setDuration(this.duration); }
            this.checkReady();
            if (this.time) {
              return this.time.service = this.service;
            }
          }
          ); // the time slot sometimes wants to know thing about the service
        }

        if (data.$has('event_group')) {
          serv = data.$get('event_group');
          this.promises.push(serv);
          serv.then(serv => {
            if (serv.$has('category')) {
              prom = serv.$get('category');
              this.promises.push(prom);
              prom.then(cat => {
                return this.setCategory(new BBModel.Category(cat));
              }
              );
            }

            this.setEventGroup(new BBModel.EventGroup(serv));
            if (this.time) {
              return this.time.service = this.event_group;
            }
          }
          ); // the time slot sometimes wants to know thing about the service
        }

        if (data.$has('event_chain')) {
          let chain = data.$get('event_chain');
          this.promises.push(chain);
          if (!data.$has('event')) { // onlt set the event chain if we don't have the full event details - which will also set the event chain
            chain.then(serv => {
              return this.setEventChain(new BBModel.EventChain(serv), data.questions);
            }
            );
          }
        }


        if (data.$has('resource')) {
          let res = data.$get('resource');
          this.promises.push(res);
          res.then(res => {
            return this.setResource(new BBModel.Resource(res), false);
          }
          );
        }
        if (data.$has('person')) {
          let per = data.$get('person');
          this.promises.push(per);
          per.then(per => {
            return this.setPerson(new BBModel.Person(per), false);
          }
          );
        }
        if (data.$has('event')) {
          data.$get('event').then(event => {
            return this.setEvent(new BBModel.Event(event));
          }
          );
        }

        if (data.settings) {
          this.settings = $bbug.extend(true, {}, data.settings);
        }

        if (data.attachment_id) {
          this.attachment_id = data.attachment_id;
        }

        if (data.person_group_id) {
          this.setPersonGroupId(data.person_group_id);
        }

        if (data.$has('product')) {
          data.$get('product').then(product => {
            return this.setProduct(new BBModel.Product(product));
          }
          );
        }

        if (data.$has('package_item')) {
          data.$get('package_item').then(package_item => {
            return this.setPackageItem(new BBModel.PackageItem(package_item));
          }
          );
        }

        if (data.$has('bulk_purchase')) {
          data.$get('bulk_purchase').then(bulk_purchase => {
            return this.setBulkPurchase(new BBModel.BulkPurchase(bulk_purchase));
          }
          );
        }

        if (data.$has('deal')) {
          data.$get('deal').then(deal => {
            return this.setDeal(new BBModel.Deal(deal));
          }
          );
        }

        if (data.$has('pre_paid_booking')) {
          data.$get('pre_paid_booking').then(pre_paid_booking => {
            return this.setPrepaidBooking(new BBModel.PrePaidBooking(pre_paid_booking));
          }
          );
        }


        if (data.clinic_id) { this.clinic_id = data.clinic_id; }
      }
    }

    /***
    * @ngdoc method
    * @name setDefaults
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the default settings
    *
    * @returns {object} Default settings
    */
    setDefaults(defaults) {
      if (defaults.settings) {
        this.settings = defaults.settings;
      }
      if (defaults.company) {
        this.setCompany(defaults.company);
      }
      if (defaults.merge_resources) {
        this.setResource(null);
      }
      if (defaults.merge_people) {
        this.setPerson(null);
      }
      if (defaults.resource) {
        this.setResource(defaults.resource);
      }
      if (defaults.person) {
        this.setPerson(defaults.person);
      }
      if (defaults.service) {
        this.setService(defaults.service);
      }
      if (defaults.category) {
        this.setCategory(defaults.category);
      }
      if (defaults.date) {
        // NOTE: date is not set as it might not be available
        defaults.date = moment(defaults.date);
      }
      if (defaults.time) {
        // NOTE: time is not set as it might not be available
        let date = defaults.date ? defaults.date : moment();
        let time = defaults.time ? parseInt(defaults.time) : 0;
        defaults.datetime = DateTimeUtilitiesService.convertTimeToMoment(defaults.date, time);
      }
      if (defaults.service_ref) {
        this.service_ref = defaults.service_ref;
      }
      if (defaults.group) {
        this.group = defaults.group;
      }
      if (defaults.clinic) {
        this.clinic = defaults.clinic;
        this.clinic_id = defaults.clinic.id;
      }
      if (defaults.private_note) {
        this.private_note = defaults.private_note;
      }
      if (defaults.event_group) {
        this.setEventGroup(defaults.event_group);
      }
      if (defaults.event) {
        this.setEvent(defaults.event);
      }
      return this.defaults = defaults;
    }

    /***
    * @ngdoc method
    * @name storeDefaults
    * @methodOf BB.Models:BasketItem
    * @description
    * Store the default settings by attaching them to the current context
    *
    * @returns {array} defaults variable
    */
    storeDefaults(defaults) {
      return this.defaults = defaults;
    }



    /***
    * @ngdoc method
    * @name canLoadItem
    * @methodOf BB.Models:BasketItem
    * @description
    * See if this item is read to have a specific object type loads - i.e. services, resources, or people
    * @param {object} company a hash representing a company object
    *
    * @returns {boolean} if this item can be loaded
    */
    canLoadItem(item) {
      if (this.service && (this.item !== 'service')) {
        return true; // we have a service and we want something else
      } else if (this.resource && !this.anyResource() && (item !== 'resource')) {
        return true; // we have a resource and we want something else
      } else if (this.person && !this.anyPerson() && (item !== 'person')) {
        return true; // we have a person and we want something else
      } else {
        return false;
      }
    }

    /***
    * @ngdoc method
    * @name defaultService
    * @methodOf BB.Models:BasketItem
    * @description
    * Return the default service or event group
    *
    * @returns {Object} Default Service or EventGroup
    */
    defaultService() {
      if (this.defaults && this.defaults.service) {
        return this.defaults.service;
      } else if (this.defaults && this.defaults.event_group) {
        return this.defaults.event_group;
      } else {
       return null;
     }
    }



    /***
    * @ngdoc method
    * @name setSlot
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the current slot based on the passed parameter
    *
    * @param {object} slot A hash representing a slot object
    * @returns {array} The available slot
    */
    setSlot(slot) {

      this.date = new BBModel.Day({date: slot.datetime.toISODate(), spaces: 1});
      let t =  (slot.datetime.hour() * 60) +  slot.datetime.minute();
      this.time = new BBModel.TimeSlot({time: t, avail: 1, price: this.price });
      return this.available_slot = slot.id;
    }

    /***
    * @ngdoc method
    * @name setCompany
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the current company based on the passed parameter
    * @param {object} company a hash representing a company object
    */
    setCompany(company) {
      this.company = company;
      this.parts_links.company = this.company.$href('self');
      if (this.item_details) { return this.item_details.currency_code = this.company.currency_code; }
    }

    /***
    * @ngdoc method
    * @name clearExistingItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Clear existing item
    */
    clearExistingItem() {
      if (this.$has('self') &&  this.event_id) {
        let prom = this.$del('self');
        this.promises.push(prom);
        prom.then(function() {});
      }

      delete this.earliest_time;
      return delete this.event_id;  // when changing the service - we ahve to clear any pre-set event
    }

    /***
    * @ngdoc method
    * @name setItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the current item based on the item object passed as parameter
    */
    setItem(item) {
      if (!item) { return; }
      if (item.type === "person") {
        return this.setPerson(item);
      } else if (item.type === "service") {
        return this.setService(item);
      } else if (item.type === "resource") {
        return this.setResource(item);
      }
    }

    /***
    * @ngdoc method
    * @name setService
    * @methodOf BB.Models:BasketItem
    * @description
    * Set service in according of server parameter, if default_question is null
    *
    * @returns {array} The returned service set
    */
    setService(serv, default_questions) {
      // if there was previously a service - reset the item details - i.e. the asnwers to questions
      let prom;
      if (default_questions == null) { default_questions = null; }
      if (this.service) {
        if (this.service.self && serv.self && (this.service.self === serv.self)) { // return if it's the same service
          // make sure we reset the fact that we are using this service
          if (this.service.$has('book')) {
            this.book_link = this.service;
          }
          if (serv.$has('days')) {
            this.days_link = serv;
          }
          if (serv.$has('book')) {
            this.book_link = serv;
          }
          return;
        }
        // if it's a different service
        this.item_details = null;
        this.clearExistingItem();
      }

      if (this.service && serv && this.service.self && serv.self) {
        if ((this.service.self !== serv.self) && serv.durations && (serv.durations.length > 1)) {
          this.duration = null;
          this.listed_duration = null;
        }
      }

      this.service = serv;
      if (serv && (serv instanceof BookableItemModel)) {
        this.service = serv.item;
      }


      this.parts_links.service = this.service.$href('self');
      if (this.service.$has('book')) {
        this.book_link = this.service;
      }
      if (serv.$has('days')) {
        this.days_link = serv;
      }
      if (serv.$has('book')) {
        this.book_link = serv;
      }

      if (this.service.$has('questions')) {
        this.has_questions = true;

        // we have a questions link - but are there actaully any questions ?
        prom = this.service.$get('questions');
        this.promises.push(prom);
        prom.then(details => {
          if (this.company) { details.currency_code = this.company.currency_code; }
          this.item_details = new BBModel.ItemDetails(details);
          this.has_questions = this.item_details.hasQuestions;
          if (default_questions) {
            this.item_details.setAnswers(default_questions);
            return this.setAskedQuestions();
          }
        }  // make sure the item knows the questions were all answered
        , err => {
          return this.has_questions = false;
        }
        );

      } else {
        this.has_questions = false;
      }

      // select the first and only duration if this service only has one option

      if (this.service && this.service.durations && (this.service.durations.length === 1)) {
        this.setDuration(this.service.durations[0]);
        this.listed_duration = this.service.durations[0];
      }
      // check if the service has a listed duration (this is used for calculating the end time for display)
      if (this.service && this.service.listed_durations && (this.service.listed_durations.length === 1)) {
        this.listed_duration = this.service.listed_durations[0];
      }

      if (this.service.$has('category')) {
        // we have a category?
        prom = this.service.$getCategory();
        if (prom) {
          return this.promises.push(prom);
        }
      }
    }

    /***
    * @ngdoc method
    * @name setEventGroup
    * @methodOf BB.Models:BasketItem
    * @description
    * Set event group based on the event_group param
    *
    * @param {object} event_group a hash
    */
    setEventGroup(event_group) {
      if (this.event_group) {
        if (this.event_group.self && event_group.self && (this.event_group.self === event_group.self)) { // return if it's the same event_chain
          return;
        }
      }

      this.event_group = event_group;
      this.parts_links.event_group =  this.event_group.$href('self').replace('event_group','service');

      if (this.event_group.$has('category')) {
        // we have a category?
        let prom = this.event_group.$getCategory();
        if (prom) {
          return this.promises.push(prom);
        }
      }
    }

    /***
    * @ngdoc method
    * @name setEventChain
    * @methodOf BB.Models:BasketItem
    * @description
    * Set event chain in according of event_chain parameter, default_qustions is null
    *
    * @returns {array} The returned set event chaint
    */
    setEventChain(event_chain, default_questions) {

      if (default_questions == null) { default_questions = null; }
      if (this.event_chain) {

        if (this.event_chain.self && event_chain.self && (this.event_chain.self === event_chain.self)) { // return if it's the same event_chain
          return;
        }
      }
      
      this.event_chain = event_chain;
      this.base_price = parseFloat(event_chain.price);

      if ((this.price != null) && (this.price !== this.base_price)) {
        this.setPrice(this.price);
      } else {
        this.setPrice(this.base_price);
      }
      
      if (this.event_chain.isSingleBooking()) { // i.e. does not have tickets sets and max bookings is 1
        
        // if you can only book one ticket - just use that
        this.tickets = {
          name: $translate.instant('COMMON.TERMINOLOGY.ADMITTANCE'),
          max: 1,
          type: "normal",
          price: this.base_price
        };

        this.tickets.pre_paid_booking_id = this.pre_paid_booking_id;
        if (this.num_book) { this.tickets.qty = this.num_book; }
      }


      if (this.event_chain.$has('questions')) {

        this.has_questions = true;

        // we have a questions link - but are there actaully any questions ?
        let prom = this.event_chain.$get('questions');
        this.promises.push(prom);
        return prom.then(details => {
          this.item_details = new BBModel.ItemDetails(details);
          this.has_questions = this.item_details.hasQuestions;
          if (this.questions) {
            for (var q of Array.from(this.item_details.questions)) {
              let a=_.find(this.questions, c => c.id === q.id);
              if ((a && (q.answer === undefined)) || (a !== q.answer)) {
                q.answer = a.answer;
              }
            }
            this.setAskedQuestions();
          }
          if (default_questions) {
            this.item_details.setAnswers(default_questions);
            return this.setAskedQuestions();
          }
        }  // make sure the item knows the questions were all answered
        , err => {
          return this.has_questions = false;
        }
        );
      } else {
        return this.has_questions = false;
      }
    }

    /***
    * @ngdoc method
    * @name setEvent
    * @methodOf BB.Models:BasketItem
    * @description
    * Set event according to event parameter
    *
    * @param {object} event A hash representing an event object
    */
    setEvent(event, default_questions) {

      if (default_questions == null) { default_questions = null; }
      if (this.event) { this.event.unselect(); }
      this.event = event;
      this.event.select();
      this.event_chain_id = event.event_chain_id;
      this.setDate({date: event.date});
      this.setTime(event.time);
      this.setDuration(event.duration);
      if (event.$has('book')) { this.book_link = event; }
      if (event.qty) { this.num_book = event.qty; }
      let prom = this.event.getChain();
      this.promises.push(prom);
      prom.then(chain => {
        return this.setEventChain(chain, default_questions);
      }
      );
      prom = this.event.getGroup();
      this.promises.push(prom);
      prom.then(group => {
        return this.setEventGroup(group);
      }
      );
      if ((this.event.getSpacesLeft() <= 0) && !this.company.settings) {
        if (this.company.getSettings().has_waitlists) { return this.status = 8; }
      } else if ((this.event.getSpacesLeft() <= 0) && this.company.settings && this.company.settings.has_waitlists) {
        return this.status = 8;
      }
    }



    /***
    * @ngdoc method
    * @name setCategory
    * @methodOf BB.Models:BasketItem
    * @description
    * Set category according to cat parameter
    *
    * @param {object} cat A hash representing a category object
    */
    // if someone sets a category - we may then later restrict the service list by category
    setCategory(cat) {
      return this.category = cat;
    }

    /***
    * @ngdoc method
    * @name setPerson
    * @methodOf BB.Models:BasketItem
    * @description
    * Set person according to per parameter
    *
    * @param {object} per A hash representing a person object

    * @param {boolean} set_selected The returned set resource for basket item
    */
    setPerson(per, set_selected) {
      if (set_selected == null) { set_selected = true; }
      if (set_selected && this.earliest_time) {
        delete this.earliest_time;
      }

      if (!per) {
        this.person = true;
        if (set_selected) { this.settings.person = -1; }
        this.parts_links.person = null;
        if (this.service) { this.setService(this.service); }
        if (this.resource && !this.anyResource()) { this.setResource(this.resource, false); }
        if (this.event_id) {
          delete this.event_id;  // when changing the person - we ahve to clear any pre-set event
          if (this.resource && this.defaults && this.defaults.merge_resources) { return this.setResource(null); }  // if a resources has been automatically set - clear it
        }
      } else {
        this.person = per;
        if (set_selected) { this.settings.person = this.person.id; }
        this.parts_links.person = this.person.$href('self');
        if (per.$has('days')) {
          this.days_link = per;
        }
        if (per.$has('book')) {
          this.book_link = per;
        }
        if (this.event_id && this.$has('person') && (this.$href('person') !== this.person.self)) {
          delete this.event_id;  // when changing the person - we ahve to clear any pre-set event
          if (this.resource && this.defaults && this.defaults.merge_resources) { return this.setResource(null); }  // if a resources has been automatically set - clear it
        }
      }
    }

    /***
    * @ngdoc method
    * @name setStaffGroup
    * @methodOf BB.Models:BasketItem
    * @description Set the current staff group id
    */
    setPersonGroupId(id) {
      return this.person_group_id = id;
    }


    /***
    * @ngdoc method
    * @name setResource
    * @methodOf BB.Models:BasketItem
    * @description
    * Set resource in according of res parameter, if set_selected is true
    *
    * @returns {object} The returned set resource for basket item
    */
    setResource(res, set_selected) {
      if (set_selected == null) { set_selected = true; }
      if (set_selected && this.earliest_time) {
        delete this.earliest_time;
      }

      if (!res) {
        this.resource = true;
        if (set_selected) { this.settings.resource = -1; }
        this.parts_links.resource = null;
        if (this.service) { this.setService(this.service); }
        if (this.person && !this.anyPerson()) { this.setPerson(this.person, false); }
        if (this.event_id) {
          delete this.event_id;  // when changing the resource - we ahve to clear any pre-set event
          if (this.person && this.defaults && this.defaults.merge_people) { return this.setPerson(null); } // if a person has been automatically set - clear it
        }
      } else {
        this.resource = res;
        if (set_selected) { this.settings.resource = this.resource.id; }
        this.parts_links.resource = this.resource.$href('self');
        if (res.$has('days')) {
          this.days_link = res;
        }
        if (res.$has('book')) {
          this.book_link = res;
        }
        if (this.event_id && this.$has('resource') && (this.$href('resource') !== this.resource.self)) {
          delete this.event_id;  // when changing the resource - we ahve to clear any pre-set event
          if (this.person && this.defaults && this.defaults.merge_people) { return this.setPerson(null); } // if a person has been automatically set - clear it
        }
      }
    }

    /***
    * @ngdoc method
    * @name setDuration
    * @methodOf BB.Models:BasketItem
    * @description
    * Set duration in according of dur parameter
    *
    * @returns {integer} The returned set duration for basket item
    */
    setDuration(dur) {
      this.duration = dur;
      if (this.service) {
        this.base_price = this.service.getPriceByDuration(dur);
      } else if (this.time && this.time.price) {
        this.base_price = this.time.price;
      } else if (this.price) {
        this.base_price = this.price;
      }

      return this.setPrice(this.base_price);
    }

    /***
    * @ngdoc method
    * @name print_time
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print time
    *
    * @returns {date} The returned print time
    */
    print_time() {
      if (this.time) { return this.time.print_time(); }
    }

    /***
    * @ngdoc method
    * @name print_end_time
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print end time
    *
    * @returns {date} The returned print end time
    */
    print_end_time() {
      if (this.time) { return this.time.print_end_time(this.duration); }
    }

    /***
    * @ngdoc method
    * @name print_time12
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print time12 if show suffix is true
    *
    * @returns {date} The returned print time12
    */
    print_time12(show_suffix) {
      if (show_suffix == null) { show_suffix = true; }
      if (this.time) { return this.time.print_time12(show_suffix); }
    }

    /***
    * @ngdoc method
    * @name print_end_time12
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print end time12 if show_suffix is true
    *
    * @returns {date} The returned print end time12
    */
    print_end_time12(show_suffix) {
      if (show_suffix == null) { show_suffix = true; }
      if (this.time) { return this.time.print_end_time12(show_suffix, this.duration); }
    }

    /***
    * @ngdoc method
    * @name setTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Set time in according of time parameter
    *
    * @returns {date} The returned set time
    */
    setTime(time) {
      if (this.time) { this.time.unselect(); }
      this.time = time;
      if (this.time) {
        this.time.select();

        if (this.datetime) {
          this.datetime = DateTimeUtilitiesService.convertTimeToMoment(this.date.date, this.time.time);
        }

        if (this.price && this.time.price && (this.price !== this.time.price)) {
          this.setPrice(this.time.price);
        } else if (this.price && !this.time.price) {
         this.setPrice(this.price);
        } else if (this.time.price && !this.price) {
          this.setPrice(this.time.price);
        } else if (this.price && this.time.price) {
          this.setPrice(this.price);
        } else {
          this.setPrice(null);
        }
      }

      return this.checkReady();
    }

    /***
    * @ngdoc method
    * @name setDate
    * @methodOf BB.Models:BasketItem
    * @description
    * Set date in according of date parameter
    *
    * @returns {date} The returned set date
    */
    setDate(date) {
      this.date = date;
      if (this.date) {
        this.date.date = moment(this.date.date);
        if (this.datetime) {
          this.datetime.date(this.date.date.date());
          this.datetime.month(this.date.date.month());
          this.datetime.year(this.date.date.year());
        }
      }

      return this.checkReady();
    }

    /***
    * @ngdoc method
    * @name clearDateTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Clear date and time
    *
    * @returns {date} The returned clear date and time
    */
    clearDateTime() {
      delete this.date;
      delete this.time;
      delete this.datetime;
      this.ready = false;
      return this.reserve_ready = false;
    }

    /***
    * @ngdoc method
    * @name clearTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Clear time
    *
    * @returns {date} The returned clear time
    */
    clearTime() {
      delete this.time;
      this.ready = false;
      return this.reserve_ready = false;
    }

    /***
    * @ngdoc method
    * @name clearTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Set group in according of group parameter
    *
    * @returns {object} The returned set group
    */
    setGroup(group) {
      return this.group = group;
    }

    /***
    * @ngdoc method
    * @name setAskedQuestions
    * @methodOf BB.Models:BasketItem
    * @description
    * Set asked questions
    *
    * @returns {object} The returned set asked questions
    */
    setAskedQuestions() {
      this.asked_questions = true;
      return this.checkReady();
    }

    /***
    * @ngdoc method
    * @name checkReady
    * @methodOf BB.Models:BasketItem
    * @description
    * Check if an item is fully ready for checkout
    * @ready - means it's fully ready for checkout
    * @reserve_ready - means the question still need asking - but it can be reserved
    *
    * @returns {boolean} whether it's fully ready for checkout
    */
    checkReady() {
      this.ready = false;

      if (this.checkReserveReady() && (this.asked_questions || !this.has_questions)) {
        this.ready = true;
      }

      return this.ready;
    }

    /***
    * @ngdoc method
    * @name checkReserveReady
    * @methodOf BB.Models:BasketItem
    * @description
    * Check if an item can be reserved
    *
    * @returns {boolean} whether it's ready to be reserved
    */
    checkReserveReady() {
      this.reserve_ready = false;

      if ((this.date && this.time && this.service) || this.event || this.product || this.package_item || this.bulk_purchase || this.external_purchase || this.deal || this.is_coupon || (this.date && this.service && (this.service.duration_unit === 'day'))) {
        this.reserve_ready = true;
      }

      return this.reserve_ready;
    }

    /***
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:BasketItem
    * @description
    * Build an array with details for every basket item in items array
    *
    * @returns {array} Newly created details array
    */
    getPostData() {
      if (this.cloneAnswersItem) {
        for (let o_question of Array.from(this.cloneAnswersItem.item_details.questions)) {
          for (let m_question of Array.from(this.item_details.questions)) {
            if (m_question.id === o_question.id) {
              m_question.answer = o_question.answer;
              // mark questionds as asked if we're cloning
              this.setAskedQuestions();
            }
          }
        }
      }

      let data = {};
      if (this.date) {
        data.date = this.date.date.toISODate();
      }
      if (this.time) {
        data.time = this.time.time;
        if (this.time.event_id) {
          data.event_id = this.time.event_id;
        } else if (this.time.event_ids) { // what's this about?
          data.event_ids = this.time.event_ids;
        }
      } else if (this.date && this.date.event_id) {
        data.event_id = this.date.event_id;
      }
      data.price = this.price;
      data.paid = this.paid;
      if (this.book_link) {
        data.book = this.book_link.$href('book');
      }
      data.id = this.id;
      data.duration = this.duration;
      data.settings = this.settings;
      data.child_client_ids = this.child_client_ids;
      if (!data.settings) { data.settings = {}; }
      if (this.earliest_time) { data.settings.earliest_time = this.earliest_time; }
      if (this.item_details && this.asked_questions) { data.questions = this.item_details.getPostData(); }
      if (this.move_item_id) { data.move_item_id = this.move_item_id; }
      if (this.srcBooking) { data.move_item_id = this.srcBooking.id; }
      if (this.service) { data.service_id = this.service.id; }
      if (this.resource) { data.resource_id = this.resource.id; }
      if (this.person) { data.person_id = this.person.id; }
      if (this.person_group_id) { data.person_group_id = this.person_group_id; }
      data.length = this.length;
      if (this.event) {
        data.event_id = this.event.id;
        // when can events have a prepaid booking id?
        if (this.event.pre_paid_booking_id != null) {
          data.pre_paid_booking_id = this.event.pre_paid_booking_id;
        } else if (this.tickets && (this.tickets.pre_paid_booking_id != null)) {
          data.pre_paid_booking_id = this.tickets.pre_paid_booking_id;
        }
        data.tickets = this.tickets;
      }
      if (this.pre_paid_booking_id != null) { data.pre_paid_booking_id = this.pre_paid_booking_id; }
      data.event_chain_id = this.event_chain_id;
      data.event_group_id = this.event_group_id;
      data.qty = this.qty;
      if (this.status) { data.status = this.status; }
      if (this.num_resources != null) { data.num_resources = parseInt(this.num_resources); }
      if (this.package_item) { data.package_id = this.package_item.id; }
      if (this.bulk_purchase) { data.bulk_purchase_id = this.bulk_purchase.id; }
      data.external_purchase = this.external_purchase;
      if (this.deal) { data.deal = this.deal; }
      if (this.deal && this.recipient) { data.recipient = this.recipient; }
      if (this.deal && this.recipient && this.recipient_mail) { data.recipient_mail = this.recipient_mail; }
      data.coupon_id = this.coupon_id;
      data.is_coupon = this.is_coupon;
      if (this.attachment_id) { data.attachment_id = this.attachment_id; }
      if (this.deal_codes) { data.vouchers = this.deal_codes; }
      if (this.product) { data.product_id = this.product.id; }
      data.ref = this.ref;
      if (this.move_reason) { data.move_reason = this.move_reason; }

      if (this.email) { data.email = this.email; }
      if (this.first_name) { data.first_name = this.first_name; }
      if (this.last_name) { data.last_name = this.last_name; }

      if (this.email != null) {
        data.email = this.email;
      }
      if (this.email_admin != null) {
        data.email_admin = this.email_admin;
      }
      if (this.private_note) { data.private_note = this.private_note; }
      if (this.available_slot) {
        data.available_slot = this.available_slot;
      }
      if (this.clinic_id) { data.clinic_id = this.clinic_id; }
      return data;
    }

    /***
    * @ngdoc method
    * @name setPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Set price in according of nprice parameter
    *
    * @returns {integer} The returned set price
    */
    setPrice(nprice) {
      let printed_price;
      if (nprice != null) {
        this.price = parseFloat(nprice);
        printed_price = this.price / 100;
        this.printed_price = (printed_price % 1) === 0 ? `£${parseInt(printed_price)}` : $window.sprintf("£%.2f", printed_price);
        if (this.company && this.company.settings) { this.printed_vat_cal = this.company.settings.payment_tax; }
        if (this.printed_vat_cal) { this.printed_vat = (this.printed_vat_cal / 100) * printed_price; }
        if (this.printed_vat_cal) { return this.printed_vat_inc = ((this.printed_vat_cal / 100) * printed_price) + printed_price; }
      } else {
        this.price = null;
        this.printed_price = null;
        this.printed_vat_cal = null;
        this.printed_vat = null;
        return this.printed_vat_inc = null;
      }
    }

    /***
    * @ngdoc method
    * @name getStep
    * @methodOf BB.Models:BasketItem
    * @description
    * Build a temp object with current step variables
    *
    * @returns {object} Temp hash
    */
    getStep() {
      let temp = {};
      temp.service = this.service;
      temp.category = this.category;
      temp.person = this.person;
      temp.resource = this.resource;
      temp.duration = this.duration;
      temp.event = this.event;
      temp.event_group = this.event_group;
      temp.event_chain = this.event_chain;
      temp.time = this.time;
      temp.date = this.date;
      temp.days_link = this.days_link;
      temp.book_link = this.book_link;
      temp.ready = this.ready;
      temp.num_book = this.num_book;
      temp.tickets = this.tickets;
      return temp;
    }

    /***
    * @ngdoc method
    * @name loadStep
    * @methodOf BB.Models:BasketItem
    * @description
    * Build current step variables based on a hash object passed as parameter
    *
    * @param {object} step Hash object representing a step
    *
    * @returns {object} The returned load step
    */
    loadStep(step) {
      this.service = step.service;
      this.category = step.category;
      this.person = step.person;
      this.resource = step.resource;
      this.duration = step.duration;
      this.event = step.event;
      this.event_chain = step.event_chain;
      this.event_group = step.event_group;
      this.time = step.time;
      this.date = step.date;
      this.days_link = step.days_link;
      this.book_link = step.book_link;
      this.ready = step.ready;
      this.num_book = step.num_book;
      return this.tickets = step.tickets;
    }

    /***
    * @ngdoc method
    * @name describe
    * @methodOf BB.Models:BasketItem
    * @description
    * Get information about of the basket item
    *
    * @returns {object} The returned title
    */
    describe() {
      let title = "-";
      if (this.service) { title = this.service.name; }
      if (this.event_group && this.event && (title === "-")) {
        title = this.event_group.name + " - " + this.event.description;
      }
      if (this.product) { title = this.product.name; }
      if (this.external_purchase) { title = this.external_purchase.name; }
      if (this.deal) { title = this.deal.name; }
      if (this.package_item) { title = this.package_item.name; }
      if (this.bulk_purchase) { title = this.bulk_purchase.name; }
      return title;
    }

    /***
    * @ngdoc method
    * @name booking_date
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking date of the basket item, in according of format parameter
    *
    * @returns {date} The returned booking date
    */
    booking_date(format) {
      if (!this.date || !this.date.date) { return null; }
      return this.date.date.format(format);
    }

    /***
    * @ngdoc method
    * @name booking_time
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking time of the basket item in according with separator = '-'
    *
    * @returns {date} The returned booking time
    */
    booking_time(seperator) {
      if (seperator == null) { seperator = '-'; }
      if (!this.time) { return null; }
      let duration = this.listed_duration ? this.listed_duration : this.duration;
      return this.time.print_time() + " " + seperator + " " +  this.time.print_end_time(duration);
    }

    /***
    * @ngdoc method
    * @name duePrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Get due price for the basket item
    *
    * @returns {string} The returned price
    */
    duePrice() {
      if (this.isWaitlist()) {
        return 0;
      }
      return this.price;
    }


    /***
    * @ngdoc method
    * @name isWaitlist
    * @methodOf BB.Models:BasketItem
    * @description
    * Checks if this is a wait list
    *
    * @returns {boolean} If this is a wait list
    */
    isWaitlist() {
      return this.status && (this.status === 8); // 8 = waitlist
    }


    /***
    * @ngdoc method
    * @name start_datetime
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking start date and time
    *
    * @returns {date} The returned start date time
    */
    start_datetime() {
      if (!this.date || !this.time) { return null; }
      return DateTimeUtilitiesService.convertTimeToMoment(this.date.date, this.time.time);
    }


    startDatetime() {
      return this.start_datetime();
    }


    /***
    * @ngdoc method
    * @name end_datetime
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking end date and time
    *
    * @returns {date} The returned end date time
    */
    end_datetime() {
      if (!this.date || !this.time || (!this.listed_duration && !this.duration)) { return null; }
      let duration = this.listed_duration ? this.listed_duration : this.duration;
      let time = this.time.time + duration;
      return DateTimeUtilitiesService.convertTimeToMoment(this.date.date, time);
    }


    endDatetime() {
      return this.end_datetime();
    }


    /***
    * @ngdoc method
    * @name setSrcBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Set a booking are to be a move if according of booking parameter
    *
    * @returns {object} The returned end date time
    */
    // set a booking are to be a move (or a copy?) from a previous booking
    setSrcBooking(booking) {
      this.srcBooking = booking;
      // convert duration from seconds to minutes
      return this.duration = booking.duration;
    }


    /***
    * @ngdoc method
    * @name anyPerson
    * @methodOf BB.Models:BasketItem
    * @description
    * Verify type of any person
    *
    * @returns {boolean} The returned any person
    */
    anyPerson() {
      return this.person && (typeof this.person === 'boolean');
    }

    /***
    * @ngdoc method
    * @name anyResource
    * @methodOf BB.Models:BasketItem
    * @description
    * Verify type of any resorce
    *
    * @returns {boolean} The returned any resource
    */
    anyResource() {
      return this.resource && (typeof this.resource === 'boolean');
    }


    /***
    * @ngdoc method
    * @name isMovingBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Verify if booking has been moved
    *
    * @returns {boolean} The returned moving booking
    */
    isMovingBooking() {
      return (this.srcBooking || this.move_item_id);
    }


    /***
    * @ngdoc method
    * @name setCloneAnswers
    * @methodOf BB.Models:BasketItem
    * @description
    * Set clone answers in according of other item parameter
    *
    * @returns {object} The returned clone answers
    */
    setCloneAnswers(otherItem) {
      return this.cloneAnswersItem = otherItem;
    }


    /***
    * @ngdoc method
    * @name questionPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Question price for the basket item
    *
    * @returns {integer} The returned question price
    */
    questionPrice() {

      if (!this.item_details) { return 0; }
      return this.item_details.questionPrice(this.getQty());
    }


    /***
    * @ngdoc method
    * @name getQty
    * @methodOf BB.Models:BasketItem
    * @description
    * Get quantity of tickets
    *
    * @returns {integer} The returned quatity of tickets
    */
    getQty() {
      if (this.qty) { return this.qty; }
      if (this.tickets) { return this.tickets.qty; }
      return 1;
    }


    /***
    * @ngdoc method
    * @name totalPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Total price of the basket item (price including discounts)
    *
    * @returns {integer} The returned total price
    */
    totalPrice() {
      if (this.tickets && this.tickets.pre_paid_booking_id) {
        return 0;
      }
      if (this.pre_paid_booking_id) {
        return 0;
      }
      if (this.discount_price != null) {
        return this.discount_price + this.questionPrice();
      }
      let pr = this.total_price;
      if (!angular.isNumber(pr)) { pr = this.price; }
      if (!angular.isNumber(pr)) { pr = 0; }
      return pr + this.questionPrice();
    }


    /***
    * @ngdoc method
    * @name fullPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Full price for the basket item (price not including discounts)
    *
    * @returns {integer} The returned full price
    */
    fullPrice() {
      let pr = this.base_price;
      if (!pr) { pr = this.total_price; }
      if (!pr) { pr = this.price; }
      if (!pr) { pr = 0; }
      return pr + this.questionPrice();
    }


    /***
    * @ngdoc method
    * @name setProduct
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a product to the BasketItem
    *
    */
    setProduct(product) {
      this.product = product;
      if (this.product.$has('book')) { this.book_link = this.product; }
      if (product.price) { return this.setPrice(product.price); }
    }


    /***
    * @ngdoc method
    * @name setPackageItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a package to the BasketItem
    *
    */
    setPackageItem(package_item) {
      this.package_item = package_item;
      if (this.package_item.$has('book')) { this.book_link = this.package_item; }
      if (package_item.price) { return this.setPrice(package_item.price); }
    }


    /***
    * @ngdoc method
    * @name setBulkPurchase
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a bulk purchase to the BasketItem
    *
    */
    setBulkPurchase(bulk_purchase) {
      this.bulk_purchase = bulk_purchase;
      if (this.bulk_purchase.$has('book')) { this.book_link = this.bulk_purchase; }
      if (bulk_purchase.price) { return this.setPrice(bulk_purchase.price); }
    }

    /***
    * @ngdoc method
    * @name setExternalPurchase
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply an external purchase to the BasketItem
    *
    */
    setExternalPurchase(external_purchase) {
      this.external_purchase = external_purchase;
      this.book_link = this.company;
      if (external_purchase.price) { return this.setPrice(external_purchase.price); }
    }


    /***
    * @ngdoc method
    * @name setDeal
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a deal on to BasketItem
    *
    */
    setDeal(deal) {
      this.deal = deal;
      if (this.deal.$has('book')) { this.book_link = this.deal; }
      if (deal.price) { return this.setPrice(deal.price); }
    }


    /***
    * @ngdoc method
    * @name hasPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Checks if the BasketItem has a price
    *
    * @returns {boolean}
    */
    hasPrice() {
      return (this.price != null);
    }


    /***
    * @ngdoc method
    * @name getAttachment
    * @methodOf BB.Models:BasketItem
    * @description
    * Get attachment of the basket item
    *
    * @returns {object} The attachment
    */
    getAttachment() {
      if (this.attachment) { return this.attachment; }
      if (this.$has('attachment') && this.attachment_id) {
        return this._data.$get('attachment').then(att => {
          this.attachment = att;
          return this.attachment;
        }
        );
      }
    }

    /***
    * @ngdoc method
    * @name deleteAttachment
    * @methodOf BB.Models:BasketItem
    * @description
    * Delete attachment of the basket item
    *
    * @returns {object} The attachment
    */

    deleteAttachment() {
      if (this.attachment_id) {
        this._data.$del("del_attachment",{});
        return this.attachment_id = null;
      }
    }

    /***
    * @ngdoc method
    * @name setPrepaidBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a prepaid booking to BasketItem
    *
    */
    setPrepaidBooking(pre_paid_booking) {
      this.pre_paid_booking    = pre_paid_booking;
      return this.pre_paid_booking_id = pre_paid_booking.id;
    }


    /***
    * @ngdoc method
    * @name hasPrepaidBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Indicates if the basket item has a prepaid booking applied
    *
    * @returns {boolean} boolean indicating if the BasketItem has a prepaid booking
    */
    hasPrepaidBooking() {
      return (this.pre_paid_booking_id != null);
    }


    /***
    * @ngdoc method
    * @name getEventId
    * @methodOf BB.Models:BasketItem
    * @description
    * Get the event id for the BasketItem
    *
    * @returns {string} The Event ID
    */
    getEventId() {
      if (this.time && this.time.event_id) {
        return this.time.event_id;
      } else if (this.date && this.date.event_id) {
        return this.date.event_id;
      } else if (this.event) {
        return this.event.id;
      }
    }


    /***
    * @ngdoc method
    * @name isExternalPurchase
    * @methodOf BB.Models:BasketItem
    * @description
    * Indicates if the BasketItem is an external purchase
    *
    * @returns {boolean}
    */
    isExternalPurchase() {
      return (this.external_purchase != null);
    }


    /***
    * @ngdoc method
    * @name getName
    * @methodOf BB.Models:BasketItem
    * @description
    * Returns the basket item name
    *
    * @returns {String}
    */
    getName() {
      if (this.session_name) {
        return this.session_name;
      } else {
        return this.service_name;
      }
    }


    /***
    * @ngdoc method
    * @name getAttendeeName
    * @methodOf BB.Models:BasketItem
    * @description
    * Returns the attendee name
    *
    * @returns {String}
    */
    getAttendeeName(client) {
      if (this.first_name) {
        return `${this.first_name} ${this.last_name}`;
      } else if (client) {
        return client.getName();
      }
    }


    /***
    * @ngdoc method
    * @name isTimeItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Indicates if the BasketItem is a time item (i.e. either an event
    * or appointment booking)
    *
    * @returns {boolean}
    */
    isTimeItem() {
      return this.service || this.event;
    }
  }
);
