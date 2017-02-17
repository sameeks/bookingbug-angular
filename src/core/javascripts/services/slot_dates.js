/*
 * @ngdoc service
 * @name BB.Services.service:SlotDates
 *
 * @description
 * checks for the first date with available spaces
 */
angular.module('BB.Services').factory('SlotDates', function ($q, DayService) {
    let cached = {
        firstSlotDate: null,
        timesQueried: 0
    };

    var getFirstDayWithSlots = function (cItem, selected_day) {
        let deferred = $q.defer();

        if (cached.firstSlotDate != null) {
            deferred.resolve(cached.firstSlotDate);
            return deferred.promise;
        }

        let endDate = selected_day.clone().add(3, 'month');

        DayService.query({
            cItem,
            date: selected_day.format('YYYY-MM-DD'),
            edate: endDate.format('YYYY-MM-DD')
        }).then(function (days) {
                cached.timesQueried++;

                let firstAvailableSlots = _.find(days, day => day.spaces > 0);
                if (firstAvailableSlots) {
                    cached.firstSlotDate = firstAvailableSlots.date;
                    return deferred.resolve(cached.firstSlotDate);
                } else {
                    if (cached.timesQueried <= 4) {
                        return getFirstDayWithSlots(cItem, endDate).then(day => deferred.resolve(cached.firstSlotDate)
                            , err => deferred.reject(err));
                    } else {
                        return deferred.reject(new Error('ERROR.NO_SLOT_AVAILABLE'));
                    }
                }
            }
            , err => deferred.reject(new Error('ERROR.COULDNT_GET_AVAILABLE_DATES')));

        return deferred.promise;
    };

    return {getFirstDayWithSlots};
});
