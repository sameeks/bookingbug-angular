
'use strict';

###**
* @ngdoc service
* @name BB.Models:Day
*
* @description
* Representation of an Day Object
*
* @property {string} string_date The string date
* @property {date} date Second The date
####

angular.module('BB.Models').factory "DayModel", ($q, BBModel, BaseModel, DayService) ->

  class Day extends BaseModel

    constructor: (data) ->
      super
      @string_date = @date
      @date = moment(@date)

    ###**
    * @ngdoc method
    * @name day
    * @methodOf BB.Models:Day
    * @description
    * Get day date
    *
    * @returns {date} The returned day
    ###
    day: ->
      @date.date()

    ###**
    * @ngdoc method
    * @name off
    * @methodOf BB.Models:Day
    * @description
    * Get off by month
    *
    * @returns {date} The returned off
    ###
    off: (month) ->
      @date.month() != month

    ###**
    * @ngdoc method
    * @name class
    * @methodOf BB.Models:Day
    * @description
    * Get class in according of month
    *
    * @returns {string} The returned class
    ###
    class: (month) ->
      str = ""
      if @date.month() < month
        str += "off off-prev"
      if @date.month() > month
        str += "off off-next"
      if @spaces == 0
        str += " not-avail"
      str

    @$query: (prms) ->
      DayService.query(prms)
