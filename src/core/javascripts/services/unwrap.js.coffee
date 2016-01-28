

angular.module('BB.Services').factory "BB.Service.address", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Address(resource)


angular.module('BB.Services').factory "BB.Service.person", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Person(resource)


angular.module('BB.Services').factory "BB.Service.people", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('people').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.Person(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.resource", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Resource(resource)


angular.module('BB.Services').factory "BB.Service.resources", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('resources').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.Resource(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.service", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Service(resource)


angular.module('BB.Services').factory "BB.Service.services", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->

    deferred = $q.defer()

     # if the resource is embedded, return the array of models
    if angular.isArray(resource)

      models = (new BBModel.Service(service) for service in resource)
      deferred.resolve(models)

    else
    
      resource.$get('services').then (items) =>
        models = []
        for i in items
          models.push(new BBModel.Service(i))
        deferred.resolve(models)
      , (err) =>
        deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.package_item", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.PackageItem(resource)


angular.module('BB.Services').factory "BB.Service.package_items", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('package_items').then (package_items) =>
      models = []
      for i in package_items
        models.push(new BBModel.PackageItem(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.bulk_purchase", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.BulkPurchase(resource)


angular.module('BB.Services').factory "BB.Service.bulk_purchases", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->

    deferred = $q.defer()

    # if the resource is embedded, return the array of models
    if angular.isArray(resource)

      models = (new BBModel.BulkPurchase(bulk_purchase) for bulk_purchase in resource)
      deferred.resolve(models)

    else
    
      resource.$get('bulk_purchases').then (bulk_purchases) =>
        models = []
        for i in bulk_purchases
          models.push(new BBModel.BulkPurchase(i))
        deferred.resolve(models)
      , (err) =>
        deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.event_group", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.EventGroup(resource)


angular.module('BB.Services').factory "BB.Service.event_groups", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('event_groups').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.EventGroup(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.event_chain", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.EventChain(resource)


angular.module('BB.Services').factory "BB.Service.event_chains", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.EventChain(resource)


angular.module('BB.Services').factory "BB.Service.category", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Category(resource)


angular.module('BB.Services').factory "BB.Service.categories", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('categories').then (items) =>
      models = []
      for i in items
        cat = new BBModel.Category(i)
        cat.order ||= _i
        models.push(cat)
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.client", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Client(resource)


angular.module('BB.Services').factory "BB.Service.child_clients", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('clients').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.Client(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.clients", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('clients').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.Client(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.questions", ($q, BBModel) ->
  unwrap: (resource) ->
    if resource.questions
      (new BBModel.Question(i) for i in resource.questions)
    else if resource.$has('questions')
      defer = $q.defer()
      resource.$get('questions').then (items) ->
        defer.resolve((new BBModel.Question(i) for i in items))
      , (err) ->
        defer.reject(err)
      defer.promise
    else
      (new BBModel.Question(i) for i in resource)


angular.module('BB.Services').factory "BB.Service.question", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Question(resource)


angular.module('BB.Services').factory "BB.Service.answers", ($q, BBModel) ->
  promise: false
  unwrap: (items) ->
    models = []
    for i in items
      models.push(new BBModel.Answer(i))
    answers =
      answers: models

      getAnswer: (question) ->
        for a in @answers
          return a.value if a.question_text is question or a.question_id is question

    return answers


angular.module('BB.Services').factory "BB.Service.administrators", ($q, BBModel) ->
  unwrap: (items) ->
    new BBModel.Admin.User(i) for i in items


angular.module('BB.Services').factory "BB.Service.company", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Company(resource)


angular.module('BB.Services').factory "BB.Service.parent", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Company(resource)
    
    
angular.module('BB.Services').factory "BB.Service.company_questions", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('company_questions').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.BusinessQuestion(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.company_question", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.BusinessQuestion(resource)


angular.module('BB.Services').factory "BB.Service.images", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('images').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.Image(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.bookings", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('bookings').then (items) =>
      models = []
      for i in items
        models.push(new BBModel.Member.Booking(i))
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.wallet", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Member.Wallet(resource)


angular.module('BB.Services').factory "BB.Service.product", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.Product(resource)


angular.module('BB.Services').factory "BB.Service.products", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->
    deferred = $q.defer()
    resource.$get('products').then (items) =>
      models = []
      for i in items
        cat = new BBModel.Product(i)
        cat.order ||= _i
        models.push(cat)
      deferred.resolve(models)
    , (err) =>
      deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.pre_paid_booking", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.PrePaidBooking(resource)


angular.module('BB.Services').factory "BB.Service.pre_paid_bookings", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->

    deferred = $q.defer()

    if angular.isArray(resource)

      models = (new BBModel.PrePaidBooking(pre_paid_booking) for pre_paid_booking in resource)
      deferred.resolve(models)

    else
    
      resource.$get('pre_paid_bookings').then (items) =>
        models = []
        for i in items
          models.push(new BBModel.PrePaidBooking(i))
        deferred.resolve(models)
      , (err) =>
        deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.external_purchase", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.ExternalPurchase(resource)


angular.module('BB.Services').factory "BB.Service.external_purchases", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->

    deferred = $q.defer()

    # if the resource is embedded, return the array of models
    if angular.isArray(resource)

      models = (new BBModel.ExternalPurchase(external_purchase) for external_purchase in resource)
      deferred.resolve(models)

    else
    
      resource.$get('external_purchases').then (items) =>
        models = []
        for i in items
          models.push(new BBModel.ExternalPurchase(i))
        deferred.resolve(models)
      , (err) =>
        deferred.reject(err)

    deferred.promise


angular.module('BB.Services').factory "BB.Service.purchase_item", ($q, BBModel) ->
  unwrap: (resource) ->
    return new BBModel.PurchaseItem(resource)


angular.module('BB.Services').factory "BB.Service.purchase_items", ($q, BBModel) ->
  promise: true
  unwrap: (resource) ->

    deferred = $q.defer()

     # if the resource is embedded, return the array of models
    if angular.isArray(resource)

      models = (new BBModel.PurchaseItem(purchase_item) for purchase_item in resource)
      deferred.resolve(models)

    else
    
      resource.$get('purchase_items').then (items) =>
        models = []
        for i in items
          models.push(new BBModel.PurchaseItem(i))
        deferred.resolve(models)
      , (err) =>
        deferred.reject(err)

    deferred.promise
