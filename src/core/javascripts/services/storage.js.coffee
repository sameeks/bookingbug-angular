###**
* @ngdoc service
* @name BB.Services:Storage
*
* @description
* The StorageService provides
*
####

angular.module('BB.Services').factory 'StorageService', ($sessionStorage, $localStorage, SettingsService) ->

  storage = $sessionStorage


  switchStorage = (old_storage, new_storage) ->
    return true

  useLocalStorage = () ->
    storage = $localStorage
    return true

  useSessionStorage =  () ->
    storage = $sessionStorage
    return true


  # TODO decoorate storage object with extra classes

  # if SettingsService.isPersistenceEnabled()
  #   return $sessionStorage
  # else
  #   return $localStorage
  

