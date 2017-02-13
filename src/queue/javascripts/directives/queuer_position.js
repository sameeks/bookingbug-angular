// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue.Directives').directive('bbQueuerPosition', () =>

	({
		restrict: 'AE',
		replace: true,
		controller: 'QueuerPosition',
		templateUrl: 'public/queuer_position.html',
		scope: {
			id: '=',
			apiUrl: '@'
		}
	})
);

