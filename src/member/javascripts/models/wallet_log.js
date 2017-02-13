angular.module("BB.Models").factory("Member.WalletLogModel", ($q, BBModel,
  BaseModel) =>

  class Member_WalletLog extends BaseModel {
    constructor(data) {
      super(data);

      this.created_at = moment(this.created_at);

      // HACK - if payment amount is less than zero, API returns it as zero!
      this.payment_amount = parseFloat(this.amount) * 100;

      // HACK - new wallet amount should be returned as a integer
      this.new_wallet_amount = parseFloat(this.new_wallet_amount) * 100;
    }
  }
);
