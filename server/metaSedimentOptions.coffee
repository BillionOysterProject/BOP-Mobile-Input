Meteor.publish 'MetaSedimentOptions', ->
	MetaSedimentOptions.find({})

MetaSedimentOptions.allow
	insert: ->
		false
	update: ->
		false
	remove: ->
		false