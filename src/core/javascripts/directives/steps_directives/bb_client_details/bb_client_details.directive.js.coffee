'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbClientDetails
* @restrict AE
* @scope true
*
* @description
* Loads a list of client details for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} questions Questions of the client
* @property {integer} company_id The company id of the client company
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://uk.bookingbug.com'>
*   <div  bb-widget='{company_id:21}'>
*     <div bb-client-details>
*        <p>company_id: {{client_details.company_id}}</p>
*        <p>offer_login: {{client_details.offer_login}}</p>
*        <p>ask_address: {{client_details.ask_address}}</p>
*        <p>no_phone: {{client_details.no_phone}}</p>
*      </div>
*     </div>
*     </div>
*   </file>
*  </example>
*
####


angular.module('BB.Directives').directive 'bbClientDetails', ($q, $templateCache, $compile) ->
  restrict: 'AE'
  replace: true
  scope : true
  transclude: true 
  controller : 'ClientDetails'
  link: (scope, element, attrs, controller, transclude) ->

    transclude scope, (clone) =>
      # if there's content compile that or grab the client_details template
      has_content = clone.length > 1 || (clone.length == 1 && (!clone[0].wholeText || /\S/.test(clone[0].wholeText)))
      if has_content
        element.html(clone).show()
      else
        $q.when($templateCache.get('_client_details.html')).then (template) ->
          element.html(template).show()
          $compile(element.contents())(scope)
