angular.module('app.example').directive 'sessileOrganismCard', [
	->
		def =
			name:'sessileOrganismCard'
			restrict:'E'

			templateUrl:'client/views/protocol3/directives/sessileOrganismCard.ng.html'
			scope:
				organism:'='
				selected:'='
				specialLabel:'='

			link:($scope, element, attrs)->
#				updateWidth = ->
#					element.find('.inner').css('width', Math.floor($scope.p * 100) + '%')
#
#				$scope.$watch 'p', ->
#					updateWidth()
#
#				element.addClass('bop-progress-bar')
#				updateWidth()

		return def
	]

