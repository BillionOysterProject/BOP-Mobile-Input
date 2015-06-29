Meteor.publish 'Messages', ->
	Messages.find({})

Messages.allow
	insert: ->
		false
	update: ->
		false
	remove: ->
		false