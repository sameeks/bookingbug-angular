// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:ScheduleRules
*
* @description
* Representation of an Schedule Rules Object
*
* @property {object} rules The schedule rules
*///

angular.module('BB.Models').factory("ScheduleRules", () =>

  class ScheduleRules {

    constructor(rules) {
      this.addRangeToDate = this.addRangeToDate.bind(this);
      this.removeRangeFromDate = this.removeRangeFromDate.bind(this);
      if (rules == null) { rules = {}; }
      this.rules = rules;
    }

    /***
    * @ngdoc method
    * @name addRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Add date range in according of the start and end parameters
    *
    * @returns {date} Returns the added date
    */
    addRange(start, end) {
      return this.applyFunctionToDateRange(start, end, 'YYYY-MM-DD', this.addRangeToDate);
    }

    /***
    * @ngdoc method
    * @name removeRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Remove date range in according of the start and end parameters
    *
    * @returns {date} Returns the removed date
    */
    removeRange(start, end) {
      return this.applyFunctionToDateRange(start, end, 'YYYY-MM-DD', this.removeRangeFromDate);
    }

    /***
    * @ngdoc method
    * @name addWeekdayRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Add week day range in according of the start and end parameters
    *
    * @returns {date} Returns the week day
    */
    addWeekdayRange(start, end) {
      return this.applyFunctionToDateRange(start, end, 'd', this.addRangeToDate);
    }

    /***
    * @ngdoc method
    * @name removeWeekdayRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Remove week day range in according of the start and end parameters
    *
    * @returns {date} Returns removed week day
    */
    removeWeekdayRange(start, end) {
      return this.applyFunctionToDateRange(start, end, 'd', this.removeRangeFromDate);
    }

    /***
    * @ngdoc method
    * @name addRangeToDate
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} date The date
    * @param {array=} range The range of the date
    * @description
    * Add range to date in according of the date and range parameters
    *
    * @returns {date} Returns the added range of date
    */
    addRangeToDate(date, range) {
      let ranges = this.rules[date] ? this.rules[date] : [];
      return this.rules[date] = this.joinRanges(this.insertRange(ranges, range));
    }

    /***
    * @ngdoc method
    * @name removeRangeFromDate
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} date The date
    * @param {array=} range The range of the date
    * @description
    * Remove range to date in according of the date and range parameters
    *
    * @returns {date} Returns the removed range of date
    */
    removeRangeFromDate(date, range) {
      let ranges = this.rules[date] ? this.rules[date] : [];
      this.rules[date] = this.joinRanges(this.subtractRange(ranges, range));
      if (this.rules[date] === '') { return delete this.rules[date]; }
    }

    /***
    * @ngdoc method
    * @name applyFunctionToDateRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date
    * @param {date=} end The end date
    * @param {date=} format The format of the range date
    * @param {object} func The func of the date and range
    * @description
    * Apply date range in according of the start, end, format and func parameters
    *
    * @returns {array} Returns the rules
    */
    applyFunctionToDateRange(start, end, format, func) {
      let date;
      let days = this.diffInDays(start, end);
      if (days === 0) {
        date = start.format(format);
        let range = [start.format('HHmm'), end.format('HHmm')].join('-');
        func(date, range);
      } else {
        let end_time = moment(start).endOf('day');
        this.applyFunctionToDateRange(start, end_time, format, func);
        _.each(__range__(1, days, true), i => {
          let start_time;
          date = moment(start).add(i, 'days');
          if (i === days) {
            if ((end.hour() !== 0) || (end.minute() !== 0)) {
              start_time = moment(end).startOf('day');
              return this.applyFunctionToDateRange(start_time, end, format, func);
            }
          } else {
            start_time = moment(date).startOf('day');
            end_time = moment(date).endOf('day');
            return this.applyFunctionToDateRange(start_time, end_time, format, func);
          }
        }
        );
      }
      return this.rules;
    }

    /***
    * @ngdoc method
    * @name diffInDays
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date
    * @param {date=} end The end date
    * @description
    * Difference in days in according of the start and end parameters
    *
    * @returns {array} Returns the difference in days
    */
    diffInDays(start, end) {
      return moment.duration(end.diff(start)).days();
    }

    /***
    * @ngdoc method
    * @name insertRange
    * @methodOf BB.Models:ScheduleRules
    * @param {object} ranges The ranges
    * @param {object} range The range
    * @description
    * Insert range in according of the ranges and range parameters
    *
    * @returns {array} Returns the ranges
    */
    insertRange(ranges, range) {
      ranges.splice(_.sortedIndex(ranges, range), 0, range);
      return ranges;
    }

    /***
    * @ngdoc method
    * @name subtractRange
    * @methodOf BB.Models:ScheduleRules
    * @param {object} ranges The ranges
    * @param {object} range The range
    * @description
    * Substract the range in according of the ranges and range parameters
    *
    * @returns {array} Returns the range decreasing
    */
    subtractRange(ranges, range) {
      if (_.indexOf(ranges, range, true) > -1) {
        return _.without(ranges, range);
      } else {
        return _.flatten(_.map(ranges, function(r) {
          if ((range.slice(0, 4) >= r.slice(0, 4)) && (range.slice(5, 9) <= r.slice(5, 9))) {
            if (range.slice(0, 4) === r.slice(0, 4)) {
              return [range.slice(5, 9), r.slice(5, 9)].join('-');
            } else if (range.slice(5, 9) === r.slice(5, 9)) {
              return [r.slice(0, 4), range.slice(0, 4)].join('-');
            } else {
              return [[r.slice(0, 4), range.slice(0, 4)].join('-'),
               [range.slice(5, 9), r.slice(5, 9)].join('-')];
            }
          } else {
            return r;
          }
        }));
      }
    }

    /***
    * @ngdoc method
    * @name joinRanges
    * @methodOf BB.Models:ScheduleRules
    * @param {object} ranges The ranges
    * @description
    * Join ranges
    *
    * @returns {array} Returns the range
    */
    joinRanges(ranges) {
      return _.reduce(ranges, function(m, range) {
        if (m === '') {
          return range;
        } else if (range.slice(0, 4) <= m.slice(m.length - 4, m.length)) {
          if (range.slice(5, 9) >= m.slice(m.length - 4, m.length)) {
            return m.slice(0, m.length - 4) + range.slice(5, 9);
          } else {
            return m;
          }
        } else {
          return [m,range].join();
        }
      }
      , "").split(',');
    }

    /***
    * @ngdoc method
    * @name filterRulesByDates
    * @methodOf BB.Models:ScheduleRules
    * @description
    * Filter rules by dates
    *
    * @returns {array} Returns the filtered rules by dates
    */
    filterRulesByDates() {
      return _.pick(this.rules, (value, key) => key.match(/^\d{4}-\d{2}-\d{2}$/) && (value !== "None"));
    }

    /***
    * @ngdoc method
    * @name filterRulesByWeekdays
    * @methodOf BB.Models:ScheduleRules
    * @description
    * Filter rules by week day
    *
    * @returns {array} Returns the filtered rules by week day
    */
    filterRulesByWeekdays() {
      return _.pick(this.rules, (value, key) => key.match(/^\d$/));
    }

    /***
    * @ngdoc method
    * @name formatTime
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} time The time
    * @description
    * Format the time in according of the time parameter
    *
    * @returns {date} Returns the formated time
    */
    formatTime(time) {
      return [time.slice(0, 2),time.slice(2, 4)].join(':');
    }

    /***
    * @ngdoc method
    * @name toEvents
    * @methodOf BB.Models:ScheduleRules
    * @param {array} d The day of events
    * @description
    * Go to events day
    *
    * @returns {array} Returns fullcalendar compatible events
    */
    toEvents(d) {
      if (d && (this.rules[d] !== "None")) {
        return _.map(this.rules[d], range => {
          return {
            start: [d, this.formatTime(range.split('-')[0])].join('T'),
            end: [d, this.formatTime(range.split('-')[1])].join('T')
          };
        }
        );
      } else {
        return _.reduce(this.filterRulesByDates(), (memo, ranges, date) => {
          return memo.concat(_.map(ranges, range => {
            return {
              start: [date, this.formatTime(range.split('-')[0])].join('T'),
              end: [date, this.formatTime(range.split('-')[1])].join('T')
            };
          }
          ));
        }
        ,[]);
      }
    }

    /***
    * @ngdoc method
    * @name toWeekdayEvents
    * @methodOf BB.Models:ScheduleRules
    * @description
    * Go to events week day
    *
    * @returns {array} Returns fullcalendar compatible events
    */
    toWeekdayEvents() {
      return _.reduce(this.filterRulesByWeekdays(), (memo, ranges, day) => {
        let date = moment().set('day', day).format('YYYY-MM-DD');
        return memo.concat(_.map(ranges, range => {
          return {
            start: [date, this.formatTime(range.split('-')[0])].join('T'),
            end: [date, this.formatTime(range.split('-')[1])].join('T')
          };
        }
        ));
      }
      ,[]);
    }
  }
);


function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}