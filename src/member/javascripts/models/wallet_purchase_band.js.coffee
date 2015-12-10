angular.module("BB.Models").factory 'Member.WalletPurchaseBandModel', (BBModel, BaseModel) ->

	class Member_WalletPurchaseBand extends BaseModel
		constructor: (data) ->
			super(data)
