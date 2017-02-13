angular.module('BBMember').directive('memberBookingsTable', function($uibModal, $log, ModalForm, BBModel) {

  let controller = function($scope, $uibModal, $document) {

    $scope.loading = true;

    if (!$scope.fields) { $scope.fields = ['date_order', 'details']; }

    $scope.$watch('member', function(member) {
      if (member != null) { return getBookings($scope, member); }
    });

    $scope.edit = function(id) {
      let booking = _.find($scope.booking_models, b => b.id === id);
      return booking.$getAnswers().then(function(answers) {
        for (let answer of Array.from(answers.answers)) {
          booking[`question${answer.question_id}`] = answer.value;
        }
        return ModalForm.edit({
          model: booking,
          title: 'Booking Details',
          templateUrl: 'edit_booking_modal_form.html',
          success(b) {
            b = new BBModel.Member.Booking(b);
            let i =_.indexOf($scope.booking_models, b => b.id === id);
            $scope.booking_models[i] = b;
            return $scope.setRows();
          }
        });
      });
    };

    $scope.cancel = function(id) {
      let booking = _.find($scope.booking_models, b => b.id === id);

      let modalInstance = $uibModal.open({
        templateUrl: 'member_bookings_table_cancel_booking.html',
        controller($scope, $uibModalInstance, booking) {
          $scope.booking = booking;
          $scope.booking.notify = true;
          $scope.ok = () => $uibModalInstance.close($scope.booking);
          return $scope.close = () => $uibModalInstance.dismiss();
        },
        scope: $scope,
        resolve: {
          booking() { return booking; }
        }
      });

      return modalInstance.result.then(function(booking) {
        $scope.loading = true;
        let params =
          {notify: booking.notify};
        return booking.$post('cancel', params).then(function() {
          let i =_.findIndex($scope.booking_models, b => b.id === booking.id);
          $scope.booking_models.splice(i, 1);
          $scope.setRows();
          return $scope.loading = false;
        });
      });
    };

    $scope.setRows = () =>
      $scope.bookings = _.map($scope.booking_models, booking =>
        ({
          id: booking.id,
          date: moment(booking.datetime).format('YYYY-MM-DD'),
          date_order: moment(booking.datetime).format('x'),
          datetime: moment(booking.datetime),
          details: booking.full_describe
        })
      )
    ;

    var getBookings = function($scope, member) {
      let params = {
        src     : member,
        start_date : $scope.startDate.format('YYYY-MM-DD'),
        start_time : $scope.startTime ? $scope.startTime.format('HH:mm') : undefined,
        end_date   : $scope.endDate ? $scope.endDate.format('YYYY-MM-DD') : undefined,
        end_time   : $scope.endTime ? $scope.endTime.format('HH:mm') : undefined
      };
      return BBModel.Member.Booking.$query(member, params).then(function(bookings) {
        let now = moment.unix();
        if ($scope.period && ($scope.period === "past")) {
          $scope.booking_models = _.filter(bookings.items, x => x.datetime.unix() < now); 
        }
        if ($scope.period && ($scope.period === "future")) {
          $scope.booking_models = _.filter(bookings.items, x => x.datetime.unix() > now); 
        } else {
          $scope.booking_models = bookings.items;
        }

        $scope.setRows();
        return $scope.loading = false;
      }
      , function(err) {
        $log.error(err.data);
        return $scope.loading = false;
      });
    };

    if (!$scope.startDate) { $scope.startDate = moment(); }

    $scope.orderBy = $scope.defaultOrder;
    if ($scope.orderBy == null) {
      $scope.orderBy = 'date_order';
    }
 
    $scope.now = moment();

    if ($scope.member) { return getBookings($scope, $scope.member); }
  };

  return {
    controller,
    templateUrl: 'member_bookings_table.html',
    scope: {
      apiUrl:       '@',
      fields:       '=?',
      member:       '=',
      startDate:    '=?',
      startTime:    '=?',
      endDate:      '=?',
      endTime:      '=?',
      defaultOrder: '=?',
      period:       '=?'
    }
  };});
