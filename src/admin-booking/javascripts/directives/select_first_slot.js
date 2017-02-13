angular.module('BB.Directives').directive 'selectFirstSlot', ->
  link: (scope, el, attrs) ->
    scope.$on 'slotsUpdated', (e, basket_item, slots) ->
      # -------------------------------------
      # Only show TimeSlots in the future!
      # -------------------------------------
      slots = _.filter slots, (slot) ->
        return slot.time_moment.isAfter(moment())
      # --------------------------------------
      # Select the first available TimeSlot
      # --------------------------------------
      if slots[0]
        scope.bb.selected_slot = slots[0]
        scope.bb.selected_date = scope.selected_date
        hours = slots[0].time_24.split(":")[0]
        minutes = slots[0].time_24.split(":")[1]
        scope.bb.selected_date.hour(hours).minutes(minutes).seconds(0)
        scope.highlightSlot(slots[0], scope.selected_day)
      for slot in slots when !slot.selected
        slot.hidden = true
