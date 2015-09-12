angular.module('app.example').filter 'organismFilename', ->
	(organism) ->
		(organism.category + '-' + organism.common).replace(/\s+/g, '-').toLowerCase() + '.jpg'