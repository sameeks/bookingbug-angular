'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbMoveBooking
* @restrict AE
*
* @description
*
* Loads calendar template optionally in a modal and updates purchase with any updated bookings
*
####

angular.module('BB.Directives').directive 'bbMoveBooking', () ->
	restrict: 'AE'
	controller: 'MoveBooking'
