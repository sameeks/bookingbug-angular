# Change Log
All notable changes to this project will be documented in this file using [CHANGELOG](http://keepachangelog.com/en/0.3.0/) convention.

## [Unreleased] 
* GeneralOptions.calendar_min_time, calOptions.min_time replaced with AdminCalendarOptions.minTime
* GeneralOptions.calendar_max_time, calOptions.max_time replaced with AdminCalendarOptions.maxTime
* PageControllerService removed

## [2.1.0] - 2017-01-12
### Added
* [i18n](https://github.com/BookingBug/bookingbug-angular/wiki/1.1-i18n) support using [angular-translate](https://angular-translate.github.io/)
* `endDateTime` helper method to the core TimeSlot model which returns the end time as a Moment object
* Added bbWalletRemainder directive for calculating remaining wallet balance after basket checkout
* Added `distance` filter which uses locale to determine the measurement unit to use
* New CompanyStoreService has been created to share company data, e.g country_code and currency_code

### Changed
* All templates have been updated to use translation keys
* All controllers/models have been updated use the $translate service
* Localized moment format tokens are now used throughout the SDK to support i10n
* bbDayList has been enhanced so that it supports localisation.  The directive shows the next 5 weeks of availability rather than a traditional month view so that past days aren't displayed
* The original bbDayList component is now named `bbMonthCalendar`
* haversine function has been moved from bbMap to the GeolocationService
* BREAKING: Replaced SettingsService with (new) CompanyStoreService and (the existing) GeneralOptions provider.
  The following initilisation options from bbWiget have been moved to be configurable options in GeneralOptions:
    - scroll_offset
    - update_document_title
    - set_time_zone_automatically - if set to true display_time_zone will be set using moment.guess()
    - use_i18n
  Use your projects config block to set them:

```
    angular.module('demo').config (GeneralOptionsProvider) ->
      GeneralOptionsProvider.setOption('set_time_zone_automatically', true)
```

### Removed
* use_i18n from GeneralOptionsProvider as i18n is now enabled by default
* `print_time`, `print_end_time`, `print_time12`, and `print_end_time12` methods and `time_12` and `time_24` properties have been removed from the core TimeSlot model in favour of `datetime()` and `endDateTime()`.

## [2.0.26] - 2016-09-26
### Changed
- SDK has been refactored so bbLocale is the only one place to change moment.locale across whole codebase
- SDK build process does not flatten template files anymore in order to avoid naming conflicts.
  Bespoke projects that refer|override any of the following templates should be updated so they have proper directory structure.  
  ADMIN
  templates/login/admin_login.html
  templates/login/admin_pick_company.html  
  EVENT
  templates/event-chain-table/event_chain_table_main.html
  templates/event-chain-table/event_group_table_main.html  
  QUEUE
  templates/public/queuer_position.html  
  SETTINGS
  templates/admin-table/admin_form.html
  templates/admin-table/admin_table_main.html

  Before change $templateCache would register 'login/admin_login.html' template as 'admin_login.html'.
  After change $templateCache registers 'login/admin_login.html' template as 'login/admin_login.html'.
- Month picker now works with angular carousel (removed angular slick from month picker)

<a name="2.0.0-alpha"></a>
# 2.0.0-alpha (2015-11-21)
### Changed
- **Resource:** Change resource form being wait_for_service by default, you now need to add a wait-for-service=true to the directive
- **Models** Moved Member and Admin injector to their specific bower deps and changed them all to inject directly at run time
- **Models** Removed functions from being copied from BaseResource objects - which helps simplify all Models
- **Models ** change getxxxPromise to just $getxxx as the promise version

## [1.4.10] - 2016-07-19
###Added
- Added helper methods to bbBasketList for displaying total price and tickety qty for grouped BasketItem objects that have events assoicated to them
- Added capability to edit BasketItem objects with events assoicated to them

### Changed
- Fixed issue where `current_item` was incorrectly set as the first item in the basket item rather than the most recently added one when updating the basket
- Fixed issue where selecting more tickets for the same event would make already entered ticket details available for edit again
- BREAKING: Updated `EventTicket` model with improved `getRange` method that takes account of tickets the user has selected when determing the valid number of tickets. Templates will need to be updated to pass the event to `getRange` method:

```
    <select ng-if="!selected_tickets" ng-model="ticket.qty" ng-options="n as n for n in ticket.getRange(event)">
      <option value="">-</option>
    </select>
```

## [1.4.0] - 2016-07-11
###Added
- New `Summary/Confirmation` step introduced in the default booking routing between the old 'summary' now 'booking questions' step and 'checkout' step
- Introduced capability to accept waitlist bookings in bbMemberUpcomingBookings

### Changed
- BREAKING: `src/core/javascripts/models/basket_item.js.coffee` renamed `getName` method to `getAttendeeName`. `getName` now returns the name of the service/event name associated with the basket_iten
- Updated `src/core/javascripts/models/basket.js.coffee` `readyToCheckout` method to check whether each individual basket item is ready
- bbMemberUpcomingBookings and bbMemberPastBookings now expect notLoaded and setLoaded to be passed in:

```
    <div bb-member-past-bookings member="client" not-loaded="notLoaded" set-loaded="setLoaded"></div>
```

- bbMemberUpcomingBookings and bbMemberPastBookings now use bbMemberBooking to render booking details and assoicated actions
- BREAKING: Scoped methods `edit`, and `cancel` in bbMemberUpcomingBookings and bbMemberPastBookings are now exposed by the controller which bbMemberBooking requires. These actions can now be called via the scoped `actions` variable. See `_member_booking.html` for an example.

## [1.3.1] - 2016-07-07
### Changed
- BREAKING: Fixed issue in bbMemberLogin where form controller shared scope with login model. Templates where bbMemberLogin is invoked need to be updated to use the login object:

```
    <input type="password" name="password" id="password" required ng-model="login.password" class="form-control" />
```

## [1.3.0] - 2016-07-07
### Added
- Introduced `use_local_timezone` option which instructs the widget to display times in users local time zone using `moment.tz.guess()`
- Introduced bbTimeZone for displaying time zone information
- Added `show_time_zone` option to the `datetime` filter to show the time zone abbreviation

### Changed
- Updated `datetime` filter to use display time zone to format time
- Updated accordion range group to respect display mode (local time zone vs default company time zone
* Updated bbTimes directive and bbTimeRanges directive to use time slot datetime if available

### Removed
- Removed duplicate code from bbTimeRanges that sets the loc and "coffied" all the operators for consistency
