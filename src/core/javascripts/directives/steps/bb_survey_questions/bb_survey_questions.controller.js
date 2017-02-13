angular.module('BB.Controllers').controller('SurveyQuestions', function($scope, $rootScope,
  $location, BBModel, ValidatorService, $sessionStorage) {

  let auth_token, getBookingAndSurvey, params;
  $scope.completed = false;
  $scope.login = {email: "", password: ""};
  $scope.login_error = false;
  $scope.booking_ref = "";

  let loader = LoadingService.$loader($scope).notLoaded();

  $rootScope.connection_started.then(() => init()
  , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));


  var init = () => {
    if ($scope.company) {
      if ($scope.company.settings.requires_login) {
        $scope.checkIfLoggedIn();
        if ($rootScope.member) {
          return getBookingAndSurvey();
        } else {
          return;
        }
      } else {
        return getBookingAndSurvey();
      }
    }
  };

  /***
  * @ngdoc method
  * @name checkIfLoggedIn
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Check if logged in
  */
  $scope.checkIfLoggedIn = () => {
    return BBModel.Login.$checkLogin();
  };

  /***
  * @ngdoc method
  * @name loadSurvey
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Load Survey in according of purchase parameter
  *
  * @param {array} purchase The purchase
  */
  $scope.loadSurvey = purchase => {
    if (!$scope.company) {
      $scope.purchase.$get('company').then(company => {
        return setPurchaseCompany(company);
      }
      );
    }

    if ($scope.purchase.$has('client')) {
      $scope.purchase.$get('client').then(client => {
        return $scope.setClient(new BBModel.Client(client));
      }
      );
    }

    return $scope.purchase.$getBookings().then(bookings => {
      params = {};
      $scope.bookings = bookings;
      return (() => {
        let result = [];
        for (var booking of Array.from($scope.bookings)) {
          if (booking.datetime) {
            booking.pretty_date = moment(booking.datetime).format("dddd, MMMM Do YYYY");
          }
          if (booking.address) {
            let address = new BBModel.Address(booking.address);
            let pretty_address = address.addressSingleLine();
            booking.pretty_address = pretty_address;
          }
          if ($rootScope.user) {
            params.admin_only = true;
          }
          result.push(booking.$get("survey_questions", params).then(details => {
            let item_details = new BBModel.ItemDetails(details);
            booking.survey_questions = item_details.survey_questions;
            return booking.$getSurveyAnswers().then(answers => {
              booking.survey_answers = answers;
              for (let question of Array.from(booking.survey_questions)) {
                if (booking.survey_answers) {
                  for (let answer of Array.from(booking.survey_answers)) {
                    if (((answer.question_text) === question.name) && answer.value) {
                      question.answer = answer.value;
                    }
                  }
                }
              }
              return loader.setLoaded();
            }
            );
          }
          ));
        }
        return result;
      })();
    }
    , function(err) {
      loader.setLoaded();
      return failMsg();
    });
  };

  /***
  * @ngdoc method
  * @name submitSurveyLogin
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Submit survey login in according of form parameter else display an error message
  *
  * @param {object} form The survey login form
  */
  $scope.submitSurveyLogin = form => {
    if (!ValidatorService.validateForm(form)) { return; }
    params = {
      email: $scope.login.email,
      password: $scope.login.password,
      id: $scope.company_id
    };
    return BBModel.Login.$companyLogin($scope.company, {}, params).then(member => {
      BBModel.Login.$setLogin(member);
      return getBookingAndSurvey();
    }
    , function(err) {
      showLoginError();
      return loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
    });
  };

  /***
  * @ngdoc method
  * @name loadSurveyFromPurchaseID
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Load survey from purchase id in according of id parameter else display an error message
  *
  * @param {object} id The id of purchase
  */
  $scope.loadSurveyFromPurchaseID = id => {
    params = {purchase_id: id, url_root: $scope.bb.api_url};
    auth_token = $sessionStorage.getItem('auth_token');
    if (auth_token) { params.auth_token = auth_token; }
    return BBModel.Purchase.Total.$query(params).then(purchase => {
      $scope.purchase = purchase;
      $scope.total = $scope.purchase;
      return $scope.loadSurvey($scope.purchase);
    }
    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
  };

  /***
  * @ngdoc method
  * @name loadSurveyFromBookingRef
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Load survey from booking ref in according of id else display an error message
  *
  * @param {object} id The id of booking
  */
  $scope.loadSurveyFromBookingRef = id => {
    params = {booking_ref: id, url_root: $scope.bb.api_url, raw: true};
    auth_token = $sessionStorage.getItem('auth_token');
    if (auth_token) { params.auth_token = auth_token; }
    return BBModel.Purchase.Total.$bookingRefQuery(params).then(purchase => {
      $scope.purchase = purchase;
      $scope.total = $scope.purchase;
      return $scope.loadSurvey($scope.purchase);
    }
    , function(err) {
      showLoginError();
      return loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
    });
  };

  /***
  * @ngdoc method
  * @name submitSurvey
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Submit survey in according of form parameter
  *
  * @param {object} form The survey form
  */
  $scope.submitSurvey = form => {
    if (!ValidatorService.validateForm(form)) { return; }
    return Array.from($scope.bookings).map((booking) =>
      (booking.checkReady(),
      booking.ready ?
        (loader.notLoaded(),
        booking.client_id = $scope.client.id,
        params = (booking),
        BBModel.Purchase.Booking.$addSurveyAnswersToBooking(params).then(function(booking) {
          loader.setLoaded();
          return $scope.completed = true;
        }
        , err => loader.setLoaded()))
      :
        $scope.decideNextPage(route)));
  };

  /***
  * @ngdoc method
  * @name submitBookingRef
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Submit booking in according of form parameter
  *
  * @param {object} form The submit booking form
  */
  $scope.submitBookingRef = form => {
    if (!ValidatorService.validateForm(form)) { return; }
    loader.notLoaded();
    params = {booking_ref: $scope.booking_ref, url_root: $scope.bb.api_url, raw: true};
    auth_token = $sessionStorage.getItem('auth_token');
    if (auth_token) { params.auth_token = auth_token; }
    return BBModel.Purchase.Total.$bookingRefQuery(params).then(purchase => {
      $scope.purchase = purchase;
      $scope.total = $scope.purchase;
      return $scope.loadSurvey($scope.purchase);
    }
    , function(err) {
      showLoginError();
      return loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
    });
  };

  /***
  * @ngdoc method
  * @name storeBookingCookie
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Store booking cookie
  */
  $scope.storeBookingCookie = () => document.cookie = `bookingrefsc=${$scope.booking_ref}`;

  /***
  * @ngdoc method
  * @name showLoginError
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Show login error
  */
  var showLoginError = () => {
    return $scope.login_error = true;
  };

  /***
  * @ngdoc method
  * @name getMember
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get member
  */
  let getMember = () => {
    params = {member_id: $scope.member_id, company_id: $scope.company_id};
    return BBModel.Login.$memberQuery(params).then(member => {
      return $scope.member = member;
    }
    );
  };

  /***
  * @ngdoc method
  * @name setPurchaseCompany
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Set purchase company in according of company parameter
  *
  * @param {object} company The company
  */
  var setPurchaseCompany = function(company) {
    $scope.bb.company_id = company.id;
    $scope.bb.company = new BBModel.Company(company);
    $scope.company = $scope.bb.company;
    $scope.bb.item_defaults.company = $scope.bb.company;
    if (company.settings) {
      if (company.settings.merge_resources) { $scope.bb.item_defaults.merge_resources = true; }
      if (company.settings.merge_people) { return $scope.bb.item_defaults.merge_people    = true; }
    }
  };

  /***
  * @ngdoc method
  * @name getBookingRef
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get booking references
  */
  let getBookingRef = function() {
    let booking_ref;
    let matches = /^.*(?:\?|&)booking_ref=(.*?)(?:&|$)/.exec($location.absUrl());
    if (matches) { booking_ref = matches[1]; }
    return booking_ref;
  };

  /***
  * @ngdoc method
  * @name getPurchaseID
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get purchase Id
  */
  let getPurchaseID = function() {
    let purchase_id;
    let matches = /^.*(?:\?|&)id=(.*?)(?:&|$)/.exec($location.absUrl());
    if (matches) { purchase_id = matches[1]; }
    return purchase_id;
  };

  /***
  * @ngdoc method
  * @name getBookingAndSurvey
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get booking and survey
  */
  return getBookingAndSurvey = function() {
    let id = getBookingRef();
    if (id) {
      return $scope.loadSurveyFromBookingRef(id);
    } else {
      id = getPurchaseID();
      if (id) {
        return $scope.loadSurveyFromPurchaseID(id);
      } else {
        if ($scope.bb.total) {
          return $scope.loadSurveyFromPurchaseID($scope.bb.total.long_id);
        } else {
          return;
        }
      }
    }
  };
});
