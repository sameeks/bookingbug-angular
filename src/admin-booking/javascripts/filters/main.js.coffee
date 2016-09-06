
angular.module('BB.Filters').filter 'in_the_future', ->

  (slots) ->

    tim = moment()
    now_tod = tim.minutes() + tim.hours()*60
    _.filter slots, (x) -> x.time > now_tod


angular.module('BB.Filters').filter 'tod_from_now', ->

  (tod, options) ->

    tim = moment()
    now_tod = tim.minutes() + tim.hours()*60

    v = tod - now_tod

    hour_string = if options && options.abbr_units then "hr"  else "hour"
    min_string  = if options && options.abbr_units then "min" else "minute"
    seperator   = if options && angular.isString(options.seperator) then options.seperator else "and"

    val = parseInt(v)
    if val < 60
      return "#{val} #{min_string}s"
    hours = parseInt(val / 60)
    mins = val % 60
    if mins == 0
      if hours == 1
        return "1 #{hour_string}"
      else
       return "#{hours} #{hour_string}s"
    else
      str = "#{hours} #{hour_string}"
      str += "s" if hours > 1
      return str if mins == 0
      str += " #{seperator}" if seperator.length > 0
      str += " #{mins} #{min_string}s"

    return str

