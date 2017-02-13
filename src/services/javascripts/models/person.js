/***
* @ngdoc service
* @name BB.Models:AdminPerson
*
* @description
* Representation of an Person Object
*
* @property {integer} id Person id
* @property {string} name Person name
* @property {boolean} deleted Verify if person is deleted or not
* @property {boolean} disabled Verify if person is disabled or not
* @property {integer} order The person order
*///

angular.module('BB.Models').factory("AdminPersonModel", ($q,
  AdminPersonService, BBModel, BaseModel, PersonModel) =>

  class Admin_Person extends PersonModel {

    constructor(data) {
      super(data);
    }

    /***
    * @ngdoc method
    * @name setAttendance
    * @methodOf BB.Models:AdminPerson
    * @param {string} status The status of attendance
    * @param {string} duration The estimated duration
    * @description
    * Set attendance in according of the status parameter
    *
    * @returns {Promise} Returns a promise that rezolve the attendance
    */
    setAttendance(status, duration) {
      let defer = $q.defer();
      this.$put('attendance', {}, {status, estimated_duration: duration}).then(p => {
        this.updateModel(p);
        return defer.resolve(this);
      }
      , err => {
        return defer.reject(err);
      }
      );
      return defer.promise;
    }

    /***
    * @ngdoc method
    * @name finishServing
    * @methodOf BB.Models:AdminPerson
    * @description
    * Finish serving
    *
    * @returns {Promise} Returns a promise that rezolve the finish serving
    */
    finishServing() {
      let defer = $q.defer();
      if (this.$has('finish_serving')) {
        this.$flush('self');
        this.$post('finish_serving').then(q => {
          this.$get('self').then(p => this.updateModel(p));
          this.serving = null;
          return defer.resolve(q);
        }
        , err => {
          return defer.reject(err);
        }
        );
      } else {
        defer.reject('finish_serving link not available');
      }
      return defer.promise;
    }

    /***
    * @ngdoc method
    * @name isAvailable
    * @methodOf BB.Models:AdminPerson
    * @param {date=} start The start date format of the availability schedule
    * @param {date=} end The end date format of the availability schedule
    * @description
    * Look up a schedule for a time range to see if this available.
    *
    * @returns {string} Returns yes if schedule is available or not.
    */
    // look up a schedule for a time range to see if this available
    // currently just checks the date - but chould really check the time too
    isAvailable(start, end) {
      let str = start.format("YYYY-MM-DD") + "-" + end.format("YYYY-MM-DD");
      if (!this.availability) { this.availability = {}; }

      if (this.availability[str]) { return this.availability[str] === "Yes"; }
      this.availability[str] = "-";

      if (this.$has('schedule')) {
        this.$get('schedule', {start_date: start.format("YYYY-MM-DD"), end_date: end.format("YYYY-MM-DD")}).then(sched => {
          this.availability[str] = "No";
          if (sched && sched.dates && sched.dates[start.format("YYYY-MM-DD")] && (sched.dates[start.format("YYYY-MM-DD")] !== "None")) {
            return this.availability[str] = "Yes";
          }
        }
        );
      } else {
        this.availability[str] = "Yes";
      }

      return this.availability[str] === "Yes";
    }

    /***
    * @ngdoc method
    * @name startServing
    * @methodOf BB.Models:AdminPerson
    * @param {string=} queuer The queuer of the company.
    * @description
    * Start serving in according of the queuer parameter
    *
    * @returns {Promise} Returns a promise that rezolve the start serving link
    */
    startServing(queuer) {
      let defer = $q.defer();
      if (this.$has('start_serving')) {
        this.$flush('self');
        let params =
          {queuer_id: queuer ? queuer.id : null};
        this.$post('start_serving', params).then(q => {
          this.$get('self').then(p => this.updateModel(p));
          this.serving = q;
          return defer.resolve(q);
        }
        , err => {
          return defer.reject(err);
        }
        );
      } else {
        defer.reject('start_serving link not available');
      }
      return defer.promise;
    }

    /***
    * @ngdoc method
    * @name getQueuers
    * @methodOf BB.Models:AdminPerson
    * @description
    * Get the queuers
    *
    * @returns {Promise} Returns a promise that rezolve the queuer links
    */
    getQueuers() {
      let defer = $q.defer();
      if (this.$has('queuers')) {
        this.$flush('queuers');
        this.$get('queuers').then(collection => {
          return collection.$get('queuers').then(queuers => {
            let models = (Array.from(queuers).map((q) => new BBModel.Admin.Queuer(q)));
            this.queuers = models;
            return defer.resolve(models);
          }
          , err => {
            return defer.reject(err);
          }
          );
        }
        , err => {
          return defer.reject(err);
        }
        );
      } else {
        defer.reject('queuers link not available');
      }
      return defer.promise;
    }

    /***
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:AdminPerson
    * @description
    * Get post data
    *
    * @returns {array} Returns data
    */
    getPostData() {
      let data = {};
      data.id = this.id;
      data.name = this.name;
      data.extra = this.extra;
      data.description = this.description;
      return data;
    }

    /***
    * @ngdoc method
    * @name update
    * @methodOf BB.Models:AdminPerson
    * @param {object} data The company data
    * @description
    * Update the data in according of the data parameter
    *
    * @returns {array} Returns the updated array
    */
    $update(data) {
      if (!data) { data = this.getPostData(); }
      return this.$put('self', {}, data).then(res => {
        return this.constructor(res);
      }
      );
    }

    static $query(params) {
      return AdminPersonService.query(params);
    }

    static $block(company, person, data) {
      return AdminPersonService.block(company, person, data);
    }

    static $signup(user, data) {
      return AdminPersonService.signup(user, data);
    }

    $refetch() {
      let defer = $q.defer();
      this.$flush('self');
      this.$get('self').then(res => {
        this.constructor(res);
        return defer.resolve(this);
      }
      , err => defer.reject(err));
      return defer.promise;
    }
  }
);