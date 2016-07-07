# Change Log
All notable changes to this project will be documented in this file.

## [1.3.1] - 2016-07-07
### Changed
- BREAKING: Fixed issue where form controller shared scope with login model. Templates where bbMemberLogin is invoked need to be updated to set the login object:

    <input type="password" name="password" id="password" required ng-model="login.password" class="form-control" />

## [1.3.0] - 2016-07-07
### Added
- Introduced `use_local_timezone` option which instructs the widget to display times in users local time zone using `moment.tz.guess()`
- Introduced bbTimeZone for displaying time zone information
- Added `show_time_zone` option to the `datetime` filter to show the time zone abbreviation 

### Changed 
- Updated `datetime` filter to use display time zone to format time
- Updated accordion range group to respect display mode (local time zone vs default company time zone
* Updated time list directive and tiem range directive to use time slot datetime if available

### Removed
- Removed duplicate code from bbTimeRanges that sets the loc and "coffied" all the operators for consistency