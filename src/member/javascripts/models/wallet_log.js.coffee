angular.module("BB.Models").factory "Member.WalletLogModel", ($q, BBModel, BaseModel) ->
  
  class Member_WalletLog extends BaseModel
    constructor: (data) ->
      super(data)

      @created_at = moment(@created_at)

      # HACK - if payment amount is less than zero, API returns it as zero!
      @payment_amount = parseFloat(@amount) * 100

      # HACK - new wallet amount should be returned as a integer
      @new_wallet_amount = parseFloat(@new_wallet_amount) * 100
