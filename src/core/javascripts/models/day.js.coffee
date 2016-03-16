
'use strict';

###**
* @ngdoc service
* @name BB.Models:Day
*
* @description
* Representation of an Day Object
*
* @property {string} string_date Date as string
* @property {date} date  Formatted date
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
    * Gets the day date.
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
    * (!!check)Get off by month.
    *
    * @param {date} month month parameter
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
    * Gets the  class using the month parameter.
    *
    * @param {date} month month parameter
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

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Day
    * @description
    * Static function that loads an array of days from a company object.
    *
    * @returns {promise} A returned promise
    ###
    @$query: (prms) ->
      DayService.query(prms)
