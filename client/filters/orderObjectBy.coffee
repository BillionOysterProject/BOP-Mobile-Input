#https://github.com/fmquaglia/ngOrderObjectBy/blob/master/src/ng-order-object-by.js
angular.module('app.example').filter 'orderObjectBy', ->
    (items, field, reverse) ->
      filtered = []

      index = (obj, i) ->
        obj[i]

      angular.forEach items, (item) ->
        filtered.push item
        return
      filtered.sort (a, b) ->
        comparator = undefined
        reducedA = field.split('.').reduce(index, a)
        reducedB = field.split('.').reduce(index, b)
        if reducedA == reducedB
          comparator = 0
        else
          comparator = if reducedA > reducedB then 1 else -1
        comparator
      if reverse
        filtered.reverse()
      filtered