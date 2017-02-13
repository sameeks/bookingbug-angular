// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc service
* @name BBAdminDashboard.calendar.services.service:TitleAssembler
*
* @description
* Assembles a string based on a pattern and an object provided according to the following rules
* ex: '{service_name} - {client_name} - {created_at|date:shortTime}'
* everything outside  {} will remain as is, inside the {} the first param (required) is the property name
* second after the '|' (optional) is the filter and third after the ':' (optional) are the options for filter
* if the requested property is not part of the given object it will be skipped
*/
angular.module('BBAdminDashboard.calendar.services').factory('TitleAssembler', [
  function() {
    let expression = new RegExp("\\{([a-zA-z_-]+)\\|?([a-zA-z_-]+)?:?([a-zA-z0-9{}_-]+)?\\}", "g");

    return {
      getTitle(object, pattern){
        // Return null if either the object or the pattern hasnt been passed in
        if ((object == null) || (pattern == null)) {
          return null;
        }

        let patternMatches = pattern.match(expression);
        // No pattern matches means there is nothing to replace in the pattern
        // hence simply return the pattern
        if ((patternMatches == null) || (patternMatches.length === 0)) {
          return pattern;
        }

        let label = pattern;

        for (let index = 0; index < patternMatches.length; index++) {
          let match = patternMatches[index];
          let parts = match.split(expression);
          // Remove unnecessary empty properties of the array (first/last)
          parts.splice(0,1);
          parts.pop();

          // If requested property exists replace the placeholder with value otherwise with ''
          if (object.hasOwnProperty(parts[0])) {
            let replaceWith = object[parts[0]];
            // if a filter is requested as part of the expression and filter exists
            if ((parts[1] != null) && ($filter(parts[1]) != null)) {
              // If filter has options as part of the expression use them
              if (parts[2] != null) {
                replaceWith = $filter(parts[1])(replaceWith, $scope.$eval(parts[2]));
              } else {
                replaceWith = $filter(parts[1])(replaceWith);
              }
            }

            label = label.replace(match, replaceWith);
          } else {
            label = label.replace(match, '');
          }
        }

        return label;
      }
    };
  }
]);
