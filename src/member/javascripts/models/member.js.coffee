###**
* @ngdoc service
* @name BB.Models:Member
*
* @description
* Representation of an Member Object
####

angular.module('BB.Models').factory "Member.MemberModel",
($q, MemberService, BBModel, BaseModel, ClientModel) ->

  class Member_Member extends ClientModel

    ###**
    * @ngdoc method
    * @name $refresh
    * @methodOf BB.Models:Member
    * @description
    * Static function that refreshes the member object.
    *
    * @param {object} member member parameter
    *
    * @returns {Promise} A promise that on success will return a member object
    ###
    @$refresh: (member) ->
      MemberService.refresh(member)

    ###**
    * @ngdoc method
    * @name $current
    * @methodOf BB.Models:Member
    * @description
    * Static function that gets the currently in scope member.
    *
    * @param {object} member member parameter
    * @param {object} booking booking parameter
    *
    * @returns {Promise} A returned promise
    ###
    @$current: () ->
      MemberService.current()

    ###**
    * @ngdoc method
    * @name $updateMember
    * @methodOf BB.Models:Member
    * @description
    * Static function that updates the member oobject.
    *
    * @param {object} member member parameter
    * @param {object} params params parameter
    *
    * @returns {Promise} A promise that on success will return a member object
    ###
    @$updateMember: (member, params) ->
      MemberService.updateMember(member, params)

    ###**
    * @ngdoc method
    * @name $sendWelcomeEmail
    * @methodOf BB.Models:Member
    * @description
    * Sends an welcome email to a particular member.
    *
    * @param {object} member member parameter
    * @param {object} params params parameter
    *
    * @returns {Promise} A promise that on success will return a member object
    ###
    @$sendWelcomeEmail: (member, params) ->
      MemberService.sendWelcomeEmail(member, params)
