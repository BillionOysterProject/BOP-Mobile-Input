angular.module('app.example').directive 'sessileOrganismCard', [
	->
		def =
			name:'sessileOrganismCard'
			restrict:'E'

			templateUrl:'client/views/protocol4/directives/sessileOrganismCard.ng.html'
			scope:
				organism:'='
				selected:'='
				specialLabel:'='

#			link:($scope, element, attrs)->

		return def
	]

