angular.module('app.example').filter 'organismFilename', ->
	(organism) ->
		if organism
			(organism.category + '-' + organism.common).replace(/\s+/g, '-').toLowerCase() + '.jpg'
		else
			'other.jpg'