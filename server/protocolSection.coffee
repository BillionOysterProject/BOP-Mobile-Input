Meteor.publish 'ProtocolSection', ->
	ProtocolSection.find(
		$and: [
			{owner: {$exists: true}}
			{owner: this.userId}
		]
	)

ProtocolSection.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true