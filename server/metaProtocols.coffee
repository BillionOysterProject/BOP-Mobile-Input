Meteor.publish 'MetaProtocols', ->
	MetaProtocols.find({}, {$orderBy: {num:1}})

MetaProtocols.allow
	insert: ->
		false
	update: ->
		false
	remove: ->
		false