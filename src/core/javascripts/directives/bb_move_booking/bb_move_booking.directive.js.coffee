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

	'ngInject'
	
	return {
		controller  : 'MoveBookingCtrl'
		controllerAs: 'vm'
		restrict    : 'AE'
		scope       : true
	} 
