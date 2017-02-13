angular.module('BB.Controllers').controller('PackagePicker',
function($scope,  $rootScope, $q, TimeService, LoadingService, BBModel) {

  let item, latest, slot, time;
  $scope.sel_date = moment().add(1, 'days');
  $scope.selected_date = $scope.sel_date.toDate();
  $scope.picked_time = false;
  let loader = LoadingService.$loader($scope);

  $scope.$watch('selected_date', (newv, oldv) => {
    $scope.sel_date = moment(newv);
    return $scope.loadDay();
  }
  );

  /***
  * @ngdoc method
  * @name loadDay
  * @methodOf BB.Directives:bbPackagePicker
  * @description
  * Load day
  */
  $scope.loadDay = () => {
    $scope.timeSlots = [];
    loader.notLoaded();

    let pslots = [];
    for (item of Array.from($scope.stackedItems)) {
      pslots.push(TimeService.query({company: $scope.bb.company, cItem: item, date: $scope.sel_date, client: $scope.client }));
    }

    return $q.all(pslots).then(res => {
      loader.setLoaded();
      $scope.data_valid = true;
      $scope.timeSlots = [];
      for (let _i = 0; _i < $scope.stackedItems.length; _i++) {
        item = $scope.stackedItems[_i];
        item.slots = res[_i];
        if (!item.slots || (item.slots.length === 0)) { $scope.data_valid = false; }
        item.order = _i;
      }

      // only show times if all of the severs have availability
      if ($scope.data_valid) {

        $scope.timeSlots = res;
        // go through the items forward - to disable any start times that can't be booked for later services
        let earliest = null;
        for (item of Array.from($scope.stackedItems)) {
          let next_earliest = null;
          for (slot of Array.from(item.slots)) {
            if (earliest && (slot.time < earliest)) {
              slot.disable();
            } else if (!next_earliest) {
              next_earliest = slot.time + item.service.duration;
            }
          }
          earliest = next_earliest;
        }

        // go through the items backwards - to disable any start times that can't be booked for earlier services
        latest = null;
        return (() => {
          let result = [];
          for (item of Array.from($scope.bb.stacked_items.slice(0).reverse())) {
            let next_latest = null;
            for (slot of Array.from(item.slots)) {
              if (latest && (slot.time > latest)) {
                slot.disable();
              } else {
                next_latest = slot.time - item.service.duration;
              }
            }
            result.push(latest = next_latest);
          }
          return result;
        })();
      }
    }
    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
  };

  /***
  * @ngdoc method
  * @name selectSlot
  * @methodOf BB.Directives:bbPackagePicker
  * @description
  * Select slot in according of sel_item and slot parameters
  *
  * @param {array} sel_item The sel item
  * @param {object} slot The slot
  */
  $scope.selectSlot = (sel_item, slot) => {

    for (let count = 0; count < $scope.stackedItems.length; count++) {
      var next;
      item = $scope.stackedItems[count];
      if (count === sel_item.order) {
        item.setDate(new BBModel.Day({date: $scope.sel_date.format(), spaces: 1}));
        item.setTime(slot);
        next = slot.time + item.service.duration;
        ({ time } = slot);
        slot = null;
        // if this wasnt the first item - we might need to go backwards through the previous package items - but only if they haven't already had a time picked - or it the time picked wasn't valid
        if (count > 0) {
          let current = count - 1;
          while (current >= 0) {
            item = $scope.bb.stacked_items[current];
            latest = time - item.service.duration;  // the last time this service can be based on the next time (we're not accounting for gaps yet) - and the previous service duration
            if (!item.time || (item.time.time > latest)) {  // if the item doesn't already have a time - or has one, but it's no longer valid for the picked new time
              // pick a new time - select the last possible time
              item.setDate(new BBModel.Day({date: $scope.sel_date.format(), spaces: 1}));
              item.setTime(null);
              for (slot of Array.from(item.slots)) {
                if (slot.time < latest) { item.setTime(slot); }
              }
            }
            ({ time } = item.time);
            current -= 1;
          }
        }
      } else if (count > sel_item.order) {
        // for the last items - resort them
        let { slots } = item;
        item.setDate(new BBModel.Day({date: $scope.sel_date.format(), spaces: 1}));
        if (slots) {
          item.setTime(null);
          for (slot of Array.from(slots)) {
            if ((slot.time >= next) && !item.time) {
              item.setTime(slot);
              next = slot.time + item.service.duration;
            }
          }
        }
      }
    }
    return $scope.picked_time = true;
  };

  /***
  * @ngdoc method
  * @name hasAvailability
  * @methodOf BB.Directives:bbPackagePicker
  * @description
  * Checks if picker have the start time and the end time available
  *
  * @param {object} slots The slots of the package picker
  * @param {date} start_time The start time of the picker
  * @param {date} end_time The end time of the picker
  */
  // helper function to determine if there's availability between given times,
  // returns true immediately if a time a slot is found with availability
  $scope.hasAvailability = (slots, start_time, end_time) => {

    if (!slots) { return false; }

    if (start_time && end_time) {
      // it's a time range query
      for (slot of Array.from(slots)) {
        if ((slot.time >= start_time) && (slot.time < end_time) && (slot.availability() > 0)) { return true; }
      }

    } else if (end_time) {
      // it's a 'less than' query
      for (slot of Array.from(slots)) {
        if ((slot.time < end_time) && (slot.availability() > 0)) { return true; }
      }

    } else if (start_time) {
      // it's a 'greater than' query
      for (slot of Array.from(slots)) {
        if ((slot.time >= start_time) && (slot.availability() > 0)) { return true; }
      }

    } else {
      // check if there's availability across all slots
      for (slot of Array.from(slots)) {
        if (slot.availability() > 0) { return true; }
      }
    }
  };



  return $scope.confirm = () => {};
});
