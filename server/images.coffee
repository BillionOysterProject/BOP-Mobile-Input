Meteor.publish 'Images', ->
	Images.find
		$and: [
			{owner: {$exists: true}},
			{owner: this.userId}
		]

Images.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true