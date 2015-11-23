angular.module('ngStorage', [])
.factory('$fakeStorage', [
  '$cookies',
  function($cookies){
    function FakeStorage() {};
    FakeStorage.prototype.setItem = function (key, value) {
      $cookies[key] = value;
    };
    FakeStorage.prototype.getFakeItem = function (key) {
      return typeof $cookies[key] == 'undefined' ? null : $cookies[key];
    }
    FakeStorage.prototype.removeItem = function (key) {
      $cookies[key] = undefined;
    };
    FakeStorage.prototype.clear = function(){
      for (var key in $cookies) {
        if( $cookies.hasOwnProperty(key) )
        {
          $cookies.removeItem(key);
        }
      }
    };
    FakeStorage.prototype.key = function(index){
      return Object.keys($cookies)[index];
    };
    return new FakeStorage();
  }
])
.factory('$localStorage', [
  '$window', '$fakeStorage',
  function($window, $fakeStorage) {
    function isStorageSupported(storageName) 
    {
      var testKey = 'test',
        storage = $window[storageName];
      try
      {
        storage.setItem(testKey, '1');
        storage.removeItem(testKey);
        return true;
      } 
      catch (error) 
      {
        return false;
      }
    }
    var storage = isStorageSupported('localStorage') ? window.localStorage : $fakeStorage;
    return {
      setItem: function(key, value) {
        storage.setItem(key, value);
      },
      getItem: function(key, defaultValue) {
        return storage.getItem(key) || defaultValue;
      },
      setObject: function(key, value) {
        storage.setItem(key, JSON.stringify(value));
      },
      getObject: function(key) {
        return JSON.parse(storage.getItem(key) || '{}');
      },
      removeItem: function(key){
        storage.removeItem(key);
      },
      clear: function() {
        storage.clear();
      },
      key: function(index){
        storage.key(index);
      }
    }
  }
])
.factory('$sessionStorage', [
  '$window', '$fakeStorage',
  function($window, $fakeStorage) {
    function isStorageSupported(storageName) 
    {
      var testKey = 'test',
        storage = $window[storageName];
      try
      {
        storage.setItem(testKey, '1');
        storage.removeItem(testKey);
        return true;
      } 
      catch (error) 
      {
        return false;
      }
    }
    var storage = isStorageSupported('sessionStorage') ? $fakeStorage : $fakeStorage;
    return {
      setItem: function(key, value) {
        storage.setItem(key, value);
      },
      getItem: function(key, defaultValue) {
        return storage.getFakeItem(key) || defaultValue;
      },
      setObject: function(key, value) {
        storage.setItem(key, JSON.stringify(value));
      },
      getObject: function(key) {
        return JSON.parse(storage.getItem(key) || '{}');
      },
      removeItem: function(key){
        storage.removeItem(key);
      },
      clear: function() {
        storage.clear();
      },
      key: function(index){
        storage.key(index);
      }
    }
  }
]);