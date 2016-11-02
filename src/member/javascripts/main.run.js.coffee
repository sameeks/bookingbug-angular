'use strict'

angular.module('BBMember').run ($q, $injector, BBModel) ->
  'ngInject'

  TrNgGrid.defaultColumnOptions.enableFiltering = false

  models = ['Member', 'Booking', 'Wallet', 'WalletLog', 'Purchase', 'PurchaseItem', 'WalletPurchaseBand', 'PaymentItem']
  mfuncs = {}
  for model in models
    mfuncs[model] = $injector.get("Member." + model + "Model")
  BBModel['Member'] = mfuncs

  return