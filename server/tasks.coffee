Meteor.publish 'Tasks', ->
	Tasks.find {}

Tasks.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true