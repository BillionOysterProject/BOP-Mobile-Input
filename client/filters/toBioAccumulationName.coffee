angular.module('app.example').filter 'toBioAccumulationName', ->
	(num) ->
		levels = ['None', 'Light', 'Medium', 'Heavy']
		levels[num]