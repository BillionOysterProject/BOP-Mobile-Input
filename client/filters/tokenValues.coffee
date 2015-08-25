angular.module('app.example').filter 'tokenValues', ->
	(text, values) ->
		for value, i in values
			text = text.split('{' + i + '}').join(value)

		text