// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("Member.MemberModel", ($q, MemberService,
  BBModel, BaseModel, ClientModel) =>

  class Member_Member extends ClientModel {

    static $refresh(member) {
      return MemberService.refresh(member);
    }

    static $current() {
      return MemberService.current();
    }

    static $updateMember(member, params) {
      return MemberService.updateMember(member, params);
    }

    static $sendWelcomeEmail(member, params) {
      return MemberService.sendWelcomeEmail(member, params);
    }

    getBookings(params) {
      return BBModel.Member.Booking.$query(this, params);
    }
  }
);

