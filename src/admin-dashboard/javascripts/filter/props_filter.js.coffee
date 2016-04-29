###
* @ngdoc filter
* @name BB.Filters.filter:propsFilter
* @description
* Does an OR operation
###
angular.module('BB.Filters').filter 'propsFilter', ->
  (items, props) ->
    out = []
    if angular.isArray(items)
      keys = Object.keys(props)
      items.forEach (item) ->
        itemMatches = false
        i = 0
        while i < keys.length
          prop = keys[i]
          text = props[prop].toLowerCase()
          if item[prop].toString().toLowerCase().indexOf(text) != -1
            itemMatches = true
            break
          i++
        if itemMatches
          out.push item
        return
    else
      # Let the output be the input untouched
      out = items
    out