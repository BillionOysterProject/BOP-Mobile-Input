Meteor.publish 'MetaWeatherConditions', ->
	MetaWeatherConditions.find({})

MetaWeatherConditions.allow
	insert: ->
		false
	update: ->
		false
	remove: ->
		false