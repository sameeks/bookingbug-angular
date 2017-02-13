// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue.Controllers').controller('QueuerPosition', function(
  QueuerService, $scope, $pusher, QueryStringService) {

	let params = {
		id: QueryStringService('id'),
		url: $scope.apiUrl
	};
	return QueuerService.query(params).then(function(queuer) {
		$scope.queuer = {
			name: queuer.first_name,
			position: queuer.position,
			dueTime: queuer.due.valueOf(),
			serviceName: queuer.service.name,
			spaceId: queuer.space_id,
			ticketNumber: queuer.ticket_number
		};
		let client = new Pusher("c8d8cea659cc46060608");
		let pusher = $pusher(client);
		let channel = pusher.subscribe(`mobile-queue-${$scope.queuer.spaceId}`);
		return channel.bind('notification', function(data) {
			$scope.queuer.dueTime = data.due.valueOf();
			$scope.queuer.ticketNumber = data.ticket_number;
			return $scope.queuer.position = data.position;
		});
	});
});

