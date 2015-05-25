Meteor.publish 'Images', ->
	Images.find {}

Images.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true