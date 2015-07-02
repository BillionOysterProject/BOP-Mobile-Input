Meteor.publish 'Sites', ->
	Sites.find({}, {$orderBy: {label:1}})

Sites.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true