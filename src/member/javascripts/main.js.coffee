'use strict'

angular.module('BBMember', [
  'BB',
  'BBMember.Directives',
  'BBMember.Services',
  'BBMember.Filters',
  'BBMember.Controllers',
  'BBMember.Models',
  'trNgGrid',
  'pascalprecht.translate'
])

angular.module('BBMember').config ($logProvider) ->
  $logProvider.debugEnabled(true)

angular.module('BBMember').run () ->
  TrNgGrid.defaultColumnOptions.enableFiltering = false

angular.module('BBMember.Directives', [])

angular.module('BBMember.Filters', [])

angular.module('BBMember.Models', [])

angular.module('BBMember.Services', [
  'ngResource',
  'ngSanitize'
])

angular.module('BBMember.Controllers', [
  'ngSanitize'
])


angular.module('BBMember').run ($q, $injector, BBModel) ->
  models = ['Member', 'Booking', 'Wallet', 'WalletLog', 'Purchase', 'PurchaseItem', 'WalletPurchaseBand', 'PaymentItem']
  mfuncs = {}
  for model in models
    mfuncs[model] = $injector.get("Member." + model + "Model")
  BBModel['Member'] = mfuncs

angular.module('BBMemberMockE2E', ['BBMember', 'BBAdminMockE2E'])
