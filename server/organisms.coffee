Meteor.publish 'Organisms', ->
	Organisms.find({}, {$orderBy:{common:1}})

Organisms.allow
	insert: ->
		false
	update: ->
		false
	remove: ->
		false