angular.module('BB.Services').factory('AppService', $uibModalStack =>

	({
		isModalOpen() {
			return !!$uibModalStack.getTop();
		}
	})
);
