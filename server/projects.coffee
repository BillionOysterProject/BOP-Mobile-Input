Meteor.publish 'Projects', ->
	Projects.find {}

Projects.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true