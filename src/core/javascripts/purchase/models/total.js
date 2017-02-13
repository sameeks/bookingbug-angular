angular.module('BB.Models').factory("Purchase.TotalModel", ($q, $window, BBModel, BaseModel, $sce) =>

  class Purchase_Total extends BaseModel {
    constructor(data) {
      super(data);
      this.getItems().then(items => {
        return this.items = items;
      }
      );
      this.getClient().then(client => {
        return this.client = client;
      }
      );
      this.getMember().then(member => {
        return this.member = member;
      }
      );
    }

    id() {
      return this.get('id');
    }

    icalLink() {
      return this._data.$href('ical');
    }

    webcalLink() {
      return this._data.$href('ical');
    }

    gcalLink() {
      return this._data.$href('gcal');
    }

    getItems() {
      let defer = $q.defer();
      if (this.items) { defer.resolve(this.items); }
      $q.all([
        this.$getBookings(),
        this.$getCourseBookings(),
        this.getPackages(),
        this.getProducts(),
        this.getDeals()
      ]).then(function(result) {
        let items = _.flatten(result);
        return defer.resolve(items);
      });
      return defer.promise;
    }

    $getBookings() {
      let defer = $q.defer();
      if (this.bookings) { defer.resolve(this.bookings); }
      if (this._data.$has('bookings')) {
        this._data.$get('bookings').then(bookings => {
          this.bookings = ((() => {
            let result = [];
            for (let b of Array.from(bookings)) {               result.push(new BBModel.Purchase.Booking(b));
            }
            return result;
          })());
          this.bookings.sort((a, b) => a.datetime.unix() - b.datetime.unix());
          return defer.resolve(this.bookings);
        }
        );
      } else {
        defer.resolve([]);
      }
      return defer.promise;
    }

    $getCourseBookings() {
      let defer = $q.defer();
      if (this.course_bookings) { defer.resolve(this.course_bookings); }
      if (this._data.$has('course_bookings')) {
        this._data.$get('course_bookings').then(bookings => {
          this.course_bookings = ((() => {
            let result = [];
            for (let b of Array.from(bookings)) {               result.push(new BBModel.Purchase.CourseBooking(b));
            }
            return result;
          })());
          return $q.all(_.map(this.course_bookings, b => b.getBookings())).then(() => {
            return defer.resolve(this.course_bookings);
          }
          );
        }
        );
      } else {
        defer.resolve([]);
      }
      return defer.promise;
    }

    getPackages() {
      let defer = $q.defer();
      if (this.packages) { defer.resolve(this.packages); }
      if (this._data.$has('packages')) {
        this._data.$get('packages').then(packages => {
          this.packages = packages;
          return defer.resolve(this.packages);
        }
        );
      } else {
        defer.resolve([]);
      }
      return defer.promise;
    }

    getProducts() {
      let defer = $q.defer();
      if (this.products) { defer.resolve(this.products); }
      if (this._data.$has('products')) {
        this._data.$get('products').then(products => {
          this.products = products;
          return defer.resolve(this.products);
        }
        );
      } else {
        defer.resolve([]);
      }
      return defer.promise;
    }

    getDeals() {
      let defer = $q.defer();
      if (this.deals) { defer.resolve(this.deals); }
      if (this._data.$has('deals')) {
        this._data.$get('deals').then(deals => {
          this.deals = deals;
          return defer.resolve(this.deals);
        }
        );
      } else {
        defer.resolve([]);
      }
      return defer.promise;
    }

    getMessages(booking_texts, msg_type) {
      let defer = $q.defer();
      booking_texts = (Array.from(booking_texts).filter((bt) => bt.message_type === msg_type).map((bt) => bt));
      if (booking_texts.length === 0) {
        defer.resolve([]);
      } else {
        this.getItems().then(function(items) {
          let msgs = [];
          for (let booking_text of Array.from(booking_texts)) {
            for (let item of Array.from(items)) {
              for (let type of ['company','person','resource','service']) {
                if (item.$has(type) && (item.$href(type) === booking_text.$href('item'))) {
                  if (msgs.indexOf(booking_text.message) === -1) {
                    msgs.push(booking_text.message);
                  }
                }
              }
            }
          }
          return defer.resolve(msgs);
        });
      }
      return defer.promise;
    }

    getClient() {
      let defer = $q.defer();
      if (this._data.$has('client')) {
        this._data.$get('client').then(client => {
          this.client = new BBModel.Client(client);
          return defer.resolve(this.client);
        }
        );
      } else {
        defer.reject('No client');
      }
      return defer.promise;
    }

    getMember() {
      let defer = $q.defer();
      if (this._data.$has('member')) {
        this._data.$get('member').then(member => {
          this.member = new BBModel.Client(member);
          return defer.resolve(this.member);
        }
        );
      } else {
        defer.reject('No member');
      }
      return defer.promise;
    }

    getConfirmMessages() {
      let defer = $q.defer();
      if (this._data.$has('confirm_messages')) {
        this._data.$get('confirm_messages').then(msgs => {
          return this.getMessages(msgs, 'Confirm').then(filtered_msgs => {
            return defer.resolve(filtered_msgs);
          }
          );
        }
        );
      } else {
        defer.reject('no messages');
      }
      return defer.promise;
    }

    printed_total_price() {
      if ((parseFloat(this.total_price) % 1) === 0) { return `£${parseInt(this.total_price)}`; }
      return $window.sprintf("£%.2f", parseFloat(this.total_price));
    }

    newPaymentUrl() {
      if (this._data.$has('new_payment')) {
        return $sce.trustAsResourceUrl(this._data.$href('new_payment'));
      }
    }

    totalDuration() {
      let duration = 0;
      for (let item of Array.from(this.items)) {
        if (item.duration) { duration += item.duration; }
      }
      return duration;
    }

    containsWaitlistItems() {
      let waitlist = [];
      for (let item of Array.from(this.items)) {
        if (item.on_waitlist === true) {
          waitlist.push(item);
        }
      }
      return waitlist.length > 0 ? true : false;
    }
  }
);

