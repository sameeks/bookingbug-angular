'use strict'

angular.module('BB.Services').factory 'AppService', ($uibModalStack) ->

	isModalOpen: ->
		!!$uibModalStack.getTop()
