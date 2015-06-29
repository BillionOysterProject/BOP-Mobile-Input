angular.module('app.example').filter 'tokenValues', ->
	(text, values) ->
		console.log 'tokenValues'
		console.log values
		for value, i in values
			text = text.split('{' + i + '}').join(value)

		text