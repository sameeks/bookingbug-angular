# String::includes polyfill
if !String::includes

  String::includes = (search, start) ->
    if typeof start != 'number'
      start = 0
    if start + search.length > @length
      false
    else
      @indexOf(search, start) != -1

# Extend String with parameterise method
String::parameterise = (seperator = '-') ->
  @trim().replace(/\s/g,seperator).toLowerCase()

