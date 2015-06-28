Meteor.publish 'MetaWaterQualityIndicators', ->
	MetaWaterQualityIndicators.find({})

MetaWaterQualityIndicators.allow
	insert: ->
		false
	update: ->
		false
	remove: ->
		false