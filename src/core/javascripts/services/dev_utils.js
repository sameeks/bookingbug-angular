angular.module('BB').config(($logProvider, $injector) => $logProvider.debugEnabled(true));

angular.module('BB.Services').factory("DebugUtilsService",
function($rootScope, $location, $window, $log, BBModel, $bbug) {
  // logs a scopes key names and values
  let logObjectKeys = function(obj, showValue) {
    for (let key in obj) {
      // dont show angular scope methods
      let value = obj[key];
      if (obj.hasOwnProperty(key) && !_.isFunction(value) && !(/^\$\$/.test(key))) {
        console.log(key);
        if (showValue) {
          console.log('\t', value, '\n');
        }
      }
    }
  };


  let showScopeChain = function() {
    let $root = $('[ng-app]');
    let data = $root.data();

    if (data && data.$scope) {
      var f = function(scope) {
        console.log(scope.$id);
        console.log(scope);

        if (scope.$$nextSibling) {
          return f(scope.$$nextSibling);
        } else {
          if (scope.$$childHead) {
            return f(scope.$$childHead);
          }
        }
      };

      f(data.$scope);
    }
  };


  (function() {
    if ((($location.host() === 'localhost') || ($location.host() === '127.0.0.1')) && ($location.port() === 3000)) {
      return window.setTimeout(function() {
        let scope = $rootScope;
        // look for BBCtrl scope object and store it in memory
        while (scope) {
          if (scope.cid === 'BBCtrl') {
            break;
          }
          scope  = scope.$$childHead;
        }


        // display the element, scope and controller for the selected element
        $bbug($window).on('dblclick', function(e){
          let controllerName;
          scope = angular.element(e.target).scope();
          let controller = scope.hasOwnProperty('controller');
          let pscope = scope;

          if (controller) {
            controllerName = scope.controller;
          }

          while (!controller) {
            pscope = pscope.$parent;
            controllerName = pscope.controller;
            controller = pscope.hasOwnProperty('controller');
          }

          $window.bbScope = scope;
          $log.log(e.target);
          $log.log($window.bbScope);
          return $log.log('Controller ->', controllerName);
        });



        // displays the key names on the BBCtrl scope. handy to see what's been
        // stuck on the scope. if 'prop' is true it will also display properties
        $window.bbBBCtrlScopeKeyNames = prop => logObjectKeys(scope, prop);

        // displays the BBCtrl scope object
        $window.bbBBCtrlScope = () => scope;

        $window.bbCurrentItem = () => scope.bb.current_item;

        // displays the currentItem Object
        return $window.bbShowScopeChain = showScopeChain;
      }

      ,10);
    }
  })();

  return {
    logObjectKeys
  };});

