'use strict'

angular.module('BB.Models').factory "Admin.BookingModel", ($q, BBModel, BaseModel, BookingCollections) ->

  class Admin_Booking extends BaseModel

    constructor: (data) ->
      super
      @datetime = moment(@datetime)
      @start = @datetime
      @end = @datetime.clone().add(@duration, 'minutes')
      @title = @full_describe
      @time = @start.hour()* 60 + @start.minute()
      @allDay = false
      if @status == 3
        @className = "status_blocked"
      else if @status == 4
        @className = "status_booked"
 

    useFullTime: () ->
      @using_full_time = true
      @start = @datetime.clone().subtract(@pre_time, 'minutes') if @pre_time
      @end = @datetime.clone().add(@duration + @post_time, 'minutes') if @post_time

    getPostData: () ->
      @datetime = @start.clone()
      if (@using_full_time)
        # we need to make sure if @start has changed - that we're adjusting for a possible pre-time
        @datetime.add(@pre_time, 'minutes')
      data = {}
      data.date = @datetime.format("YYYY-MM-DD")
      data.time = @datetime.hour() * 60 + @datetime.minute()
      data.duration = @duration
      data.id = @id
      data.pre_time = @pre_time
      data.post_time = @post_time
      data.person_id = @person_id
      if @questions
        data.questions = (q.getPostData() for q in @questions)
      data
      
    hasStatus: (status) ->
      @multi_status[status]?

    statusTime: (status) ->
      if @multi_status[status]
        moment(@multi_status[status])
      else
        null

    sinceStatus: (status) ->
      s = @statusTime(status)
      return 0 if !s
      return Math.floor((moment().unix() - s.unix()) / 60)

    sinceStart: (options) ->
      start = @datetime.unix()
      if !options
        return Math.floor((moment().unix() - start) / 60)
      if options.later
        s = @statusTime(options.later).unix()
        if s > start
          return Math.floor((moment().unix() - s) / 60)
      if options.earlier
        s = @statusTime(options.earlier).unix()
        if s < start
          return Math.floor((moment().unix() - s) / 60)
      return Math.floor((moment().unix() - start) / 60)

    answer: (q) ->
      if @answers_summary
        for a in @answers_summary
          if a.name == q
            return a.answer
      return null
 

    $update: (data) ->
      data ||= @getPostData()
      @$put('self', {}, data).then (res) =>
        @constructor(res) 
        if @using_full_time
          @useFullTime()
        BookingCollections.checkItems(@)

    $refetch: () ->
      @$flush('self')
      @$get('self').then (res) =>
        @constructor(res)
        if @using_full_time
          @useFullTime()
        BookingCollections.checkItems(@)

