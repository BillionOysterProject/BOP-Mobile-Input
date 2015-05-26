Meteor.publish 'Expeditions', ->
	Expeditions.find
		$and: [
			{owner: {$exists: true}},
			{owner: this.userId}
		]

Expeditions.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true