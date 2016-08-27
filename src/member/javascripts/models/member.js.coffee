angular.module('BB.Models').factory "Member.MemberModel", ($q, MemberService,
  BBModel, BaseModel, ClientModel) ->

  class Member_Member extends ClientModel

    @$refresh: (member) ->
      MemberService.refresh(member)

    @$current: () ->
      MemberService.current()

    @$updateMember: (member, params) ->
      MemberService.updateMember(member, params)

    @$sendWelcomeEmail: (member, params) ->
      MemberService.sendWelcomeEmail(member, params)

    getBookings: (params) ->
      BBModel.Member.Booking.$query(@, params)

