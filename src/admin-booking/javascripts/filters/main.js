// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.

angular.module('BB.Filters').filter('in_the_future', () =>

  function(slots) {

    let tim = moment();
    let now_tod = tim.minutes() + (tim.hours()*60);
    return _.filter(slots, x => x.time > now_tod);
  }
);


angular.module('BB.Filters').filter('tod_from_now', () =>

  function(tod, options) {

    let str;
    let tim = moment();
    let now_tod = tim.minutes() + (tim.hours()*60);

    let v = tod - now_tod;

    let hour_string = options && options.abbr_units ? "hr"  : "hour";
    let min_string  = options && options.abbr_units ? "min" : "minute";
    let seperator   = options && angular.isString(options.seperator) ? options.seperator : "and";

    let val = parseInt(v);
    if (val < 60) {
      return `${val} ${min_string}s`;
    }
    let hours = parseInt(val / 60);
    let mins = val % 60;
    if (mins === 0) {
      if (hours === 1) {
        return `1 ${hour_string}`;
      } else {
       return `${hours} ${hour_string}s`;
     }
    } else {
      str = `${hours} ${hour_string}`;
      if (hours > 1) { str += "s"; }
      if (mins === 0) { return str; }
      if (seperator.length > 0) { str += ` ${seperator}`; }
      str += ` ${mins} ${min_string}s`;
    }

    return str;
  }
);

