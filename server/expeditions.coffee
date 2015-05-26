Meteor.publish 'Expeditions', ->
	Expeditions.find(
		$and: [
			{owner: {$exists: true}},
			{owner: this.userId}
		]
	, {$orderBy: {date:1}})

Expeditions.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true