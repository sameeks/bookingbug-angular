/***
* @ngdoc directive
* @name BB.Directives:bbCompanies
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of companies for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {integer} id The company id
* @property {string} name The company name
* @property {integer} address_id Company address id
* @property {string} country_code Company country code
* @property {string} currency_code The company currency code
* @property {string} timezone The company time zone
* @property {integer} numeric_widget_id The numeric widget id of the company
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://uk.bookingbug.com'>
*   <div  bb-widget='{company_id:21}'>
*     <div bb-company>
*       <p>id: {{company.id}}</p>
*        <p>name: {{company.name}}</p>
*        <p>address_id: {{company.address_id}}</p>
*        <p>country_code: {{company.country_code}}</p>
*        <p>currency_code: {{company.country_code}}</p>
*        <p>timezone: {{company.timezone}}</p>
*        <p>numeric_widget_id: {{company.numeric_widget_id}}</p>
*      </div>
*     </div>
*     </div>
*   </file>
*  </example>
*///

angular.module('BB.Directives').directive('bbCompanies', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'CompanyList'
  })
);
