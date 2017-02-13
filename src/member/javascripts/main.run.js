angular.module('BBMember').run(function($q, $injector, BBModel) {
  'ngInject';

  TrNgGrid.defaultColumnOptions.enableFiltering = false;

  let models = ['Member', 'Booking', 'Wallet', 'WalletLog', 'Purchase', 'PurchaseItem', 'WalletPurchaseBand', 'PaymentItem'];
  let mfuncs = {};
  for (let model of Array.from(models)) {
    mfuncs[model] = $injector.get(`Member.${model}Model`);
  }
  BBModel['Member'] = mfuncs;

});