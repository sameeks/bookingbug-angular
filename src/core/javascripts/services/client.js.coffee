angular.module('BB.Services').factory "ClientService", ($q, BBModel, MutexService) ->


  setDefaultCompanyId = (company, client) ->
    # set the default_company_id on the client so that we can filter search results by child company if AdminBookingOptions.use_default_company_id is set
    client.default_company_id = company.id
    return


  create: (company, client) ->
    deferred = $q.defer()
    
    if !company.$has('client')
      deferred.reject("Cannot create new people for this company")
    else
      MutexService.getLock().then (mutex) ->
        setDefaultCompanyId(company, client)
        company.$post('client', {}, client.getPostData()).then (cl) =>
          deferred.resolve(new BBModel.Client(cl))
          MutexService.unlock(mutex)
        , (err) =>
          deferred.reject(err)
          MutexService.unlock(mutex)

    deferred.promise


  update: (company, client) ->
    deferred = $q.defer()

    MutexService.getLock().then (mutex) ->
      setDefaultCompanyId(company, client)
      client.$put('self', {}, client.getPostData()).then (cl) =>
        deferred.resolve(new BBModel.Client(cl))
        MutexService.unlock(mutex)
      , (err) =>
        deferred.reject(err)
        MutexService.unlock(mutex)

    deferred.promise

  create_or_update: (company, client) ->
    if client.$has('self')
      @update(company, client)
    else
      @create(company, client)

  query_by_email: (company, email) ->
    deferred = $q.defer()
    if company? && email?
      company.$get("client_by_email", {email: email}).then (client) =>
        if client?
          deferred.resolve(new BBModel.Client(client))
        else
          deferred.resolve({})
      , (err) ->
        deferred.reject(err)
    else
      deferred.reject("No company or email defined")
    deferred.promise