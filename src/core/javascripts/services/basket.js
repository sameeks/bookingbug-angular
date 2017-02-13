// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("BasketService", ($q, $rootScope, BBModel, MutexService) =>

  ({
    addItem(company, params) {
      let deferred = $q.defer();
      let lnk = params.item.book_link;
      let data = params.item.getPostData();
      if (!lnk) {
        deferred.reject("rel book not found for event");
      } else {
        MutexService.getLock().then(mutex =>
          lnk.$post('book', params, data).then(function(basket) {
            MutexService.unlock(mutex);
            company.$flush('basket');
            let mbasket = new BBModel.Basket(basket, params.bb);
            return basket.$get('items').then(function(items) {
              let promises = [];
              for (let i of Array.from(items)) {
                let item = new BBModel.BasketItem(i, params.bb);
                mbasket.addItem(item);
                // keep an eye on if this item needs any promises resolved to be valid
                promises = promises.concat(item.promises);
              }
              if (promises.length > 0) {
                return $q.all(promises).then(() => deferred.resolve(mbasket));
              } else {
                return deferred.resolve(mbasket);
              }
            }
            , err => deferred.reject(err));
          }
          , function(err) {
            MutexService.unlock(mutex);
            return deferred.reject(err);
          })
        );
      }
      return deferred.promise;
    },

    applyCoupon(company, params) {
      let deferred = $q.defer();

      MutexService.getLock().then(mutex =>
        company.$post('coupon', {}, {coupon: params.coupon}).then(function(basket) {
          MutexService.unlock(mutex);
          company.$flush('basket');
          let mbasket = new BBModel.Basket(basket, params.bb);
          return basket.$get('items').then(function(items) {
            let promises = [];
            for (let i of Array.from(items)) {
              let item = new BBModel.BasketItem(i, params.bb);
              mbasket.addItem(item);
              // keep an eye on if this item needs any promises resolved to be valid
              promises = promises.concat(item.promises);
            }
            if (promises.length > 0) {
              return $q.all(promises).then(() => deferred.resolve(mbasket));
            } else {
              return deferred.resolve(mbasket);
            }
          }
          , err => deferred.reject(err));
        }
        , function(err) {
          MutexService.unlock(mutex);
          return deferred.reject(err);
        })
      );
      return deferred.promise;
    },

    // add several items at onece - params should have an array of items:
    updateBasket(company, params) {
      let lnk;
      let deferred = $q.defer();

      let data = {entire_basket: true, items:[]};

      for (var item of Array.from(params.items)) {
        if (item.book_link) { lnk = item.book_link; }
        let xdata = item.getPostData();
        // force the date into utc
  //      d = item.date.date._a
  //      date = new Date(Date.UTC(d[0], d[1], d[2]))
  //      xdata.date = date
        data.items.push(xdata);
      }

      if (!lnk) {
        deferred.reject("rel book not found for event");
        return deferred.promise;
      }
      MutexService.getLock().then(mutex =>
        lnk.$post('book', params, data).then(function(basket) {
          MutexService.unlock(mutex);
          company.$flush('basket');
          let mbasket = new BBModel.Basket(basket, params.bb);
          return basket.$get('items').then(function(items) {
            let promises = [];
            for (let i of Array.from(items)) {
              item = new BBModel.BasketItem(i, params.bb);
              mbasket.addItem(item);
              // keep an eye on if this item needs any promises resolved to be valid
              promises = promises.concat(item.promises);
            }
            if (promises.length > 0) {
              return $q.all(promises).then(function() {
                $rootScope.$broadcast("basket:updated", mbasket);
                return deferred.resolve(mbasket);
              });
            } else {
              $rootScope.$broadcast("basket:updated", mbasket);
              return deferred.resolve(mbasket);
            }
          }
          , err => deferred.reject(err));
        }
        , function(err) {
          MutexService.unlock(mutex);
          return deferred.reject(err);
        })
      );

      return deferred.promise;
    },

    checkPrePaid(item, pre_paid_bookings) {
      let valid_pre_paid = null;
      for (let booking of Array.from(pre_paid_bookings)) {
        if (booking.checkValidity(item)) {
          valid_pre_paid = booking;
          break;
        }
      }
      return valid_pre_paid;
    },

    query(company, params) {
      let deferred = $q.defer();
      if (!company.$has('basket')) {
        deferred.reject("rel basket not found for company");
      } else {
        company.$get('basket').then(function(basket) {
          basket = new BBModel.Basket(basket, params.bb);
          if (basket.$has('items')) {
            basket.$get('items').then(items => Array.from(items).map((item) => basket.addItem(new BBModel.BasketItem(item, params.bb))));
          }
          return deferred.resolve(basket);
        }
        , err => deferred.reject(err));
      }
      return deferred.promise;
    },

    deleteItem(item, company, params) {
      if (!params) { params = {}; }
      if (params.basket) { params.basket.clearItem(item); }
      let deferred = $q.defer();
      if (!item.$has('self')) {
        deferred.reject("rel self not found for item");
      } else {
        MutexService.getLock().then(mutex =>
          item.$del('self', params).then(function(basket) {
            MutexService.unlock(mutex);
            company.$flush('basket');
            basket = new BBModel.Basket(basket, params.bb);
            if (basket.$has('items')) {
              basket.$get('items').then(items =>
                (() => {
                  let result = [];
                  for (item of Array.from(items)) {                     result.push(basket.addItem(new BBModel.BasketItem(item, params.bb)));
                  }
                  return result;
                })()
              );
            }
            return deferred.resolve(basket);
          }
          , err => deferred.reject(err))
        
        , function(err) {
          MutexService.unlock(mutex);
          return deferred.reject(err);
        });
      }

      return deferred.promise;
    },

    checkout(company, basket, params) {
      let deferred = $q.defer();
      if (!basket.$has('checkout')) {
        deferred.reject("rel checkout not found for basket");
      } else {
        let data = basket.getPostData();
        if (params.bb.qudini_booking_id) { data.qudini_booking_id = params.bb.qudini_booking_id; }
        if (params.bb.booking_settings) { data.booking_settings = params.bb.booking_settings; }
        if (params.bb.no_notifications) { data.no_notifications = params.bb.no_notifications; }
        data.affiliate_id = $rootScope.affiliate_id || params.affiliate_id;
        basket.waiting_for_checkout = true;
        MutexService.getLock().then(mutex =>
          basket.$post('checkout', params, data).then(function(total) {
            MutexService.unlock(mutex);
            $rootScope.$broadcast('updateBookings');
            let tot = new BBModel.Purchase.Total(total);
            $rootScope.$broadcast('newCheckout', tot);
            basket.clear();
            basket.waiting_for_checkout = false;
            return deferred.resolve(tot);
          }
          , function(err) {
            basket.waiting_for_checkout = false;
            return deferred.reject(err);
          })
        
        , function(err) {
          basket.waiting_for_checkout = false;
          MutexService.unlock(mutex);
          return deferred.reject(err);
        });
      }
      return deferred.promise;
    },

    empty(bb) {
      let deferred = $q.defer();
      MutexService.getLock().then(mutex =>
        bb.company.$del('basket').then(function(basket) {
          MutexService.unlock(mutex);
          bb.company.$flush('basket');
          return deferred.resolve(new BBModel.Basket(basket, bb));
        }
        , err => deferred.reject(err))
      
      , function(err) {
        MutexService.unlock(mutex);
        return deferred.reject(err);
      });
      return deferred.promise;
    },

    memberCheckout(basket, params) {
      let deferred = $q.defer();
      if (!basket.$has('checkout')) {
        deferred.reject("rel checkout not found for basket");
      } else if ($rootScope.member === null) {
        deferred.reject("member not set");
      } else {
        basket._data.setOption('auth_token', $rootScope.member._data.getOption('auth_token'));
        let data = {items: (Array.from(basket.items).map((item) => item._data))};
        basket.$post('checkout', params, data).then(function(total) {
          if (total.$has('member')) {
            total.$get('member').then(function(member) {
              $rootScope.member.flushBookings();
              return $rootScope.member = new BBModel.Member.Member(member);
            });
          }
          return deferred.resolve(total);
        }
        , err => deferred.reject(err));
      }
      return deferred.promise;
    },

    applyDeal(company, params) {
      let deferred = $q.defer();

      MutexService.getLock().then(mutex =>
        params.bb.basket.$post('deal', {}, {deal_code: params.deal_code}).then(function(basket) {
          MutexService.unlock(mutex);
          company.$flush('basket');
          let mbasket = new BBModel.Basket(basket, params.bb);
          return basket.$get('items').then(function(items) {
            let promises = [];
            for (let i of Array.from(items)) {
              let item = new BBModel.BasketItem(i, params.bb);
              mbasket.addItem(item);
              // keep an eye on if this item needs any promises resolved to be valid
              promises = promises.concat(item.promises);
            }
            if (promises.length > 0) {
              return $q.all(promises).then(() => deferred.resolve(mbasket));
            } else {
              return deferred.resolve(mbasket);
            }
          }
          , err => deferred.reject(err));
        }
        , function(err) {
          MutexService.unlock(mutex);
          return deferred.reject(err);
        })
      );
      return deferred.promise;
    },

    removeDeal(company, params) {
      if (!params) { params = {}; }
      let deferred = $q.defer();
      if (!params.bb.basket.$has('deal')) {
        return deferred.reject("No Remove Deal link found");
      } else {
        MutexService.getLock().then(mutex =>
          params.bb.basket.$put('deal', {}, {deal_code_id: params.deal_code_id.toString()}).then(function(basket) {
            MutexService.unlock(mutex);
            company.$flush('basket');
            basket = new BBModel.Basket(basket, params.bb);
            if (basket.$has('items')) {
              return basket.$get('items').then(function(items) {
                for (let item of Array.from(items)) { basket.addItem(new BBModel.BasketItem(item, params.bb)); }
                return deferred.resolve(basket);
              }
              , err => deferred.reject(err));
            }
          }
          , function(err) {
            MutexService.unlock(mutex);
            return deferred.reject(err);
          })
        );
        return deferred.promise;
      }
    }
  })
);

