provider = ($logProvider) ->
  'ngInject'

  greeting = 'Hello'

  @setGreeting = (newGreeting) ->
    greeting = newGreeting
    return

  @$get = ($log) ->
    'ngInject'

    class Greeter
      constructor: () ->
        return

      greet: (employeeName) ->
        return greeting + ' ' + employeeName + '!'

    return Greeter

  return

angular
.module('bbTe.blogArticle')
.provider('Greeter', provider)
