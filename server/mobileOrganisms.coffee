Meteor.publish 'MobileOrganisms', ->
	MobileOrganisms.find({})

#MobileOrganisms.allow
#	insert: ->
#		true
#	update: ->
#		true
#	remove: ->
#		true