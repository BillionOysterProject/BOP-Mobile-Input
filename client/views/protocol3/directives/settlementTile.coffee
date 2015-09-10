angular.module('app.example').directive 'settlementTile', [
	->
		def =
			name:'settlementTile'
			restrict:'E'
			replace:true

			templateUrl:'client/views/protocol3/directives/settlementTile.ng.html'
			scope:
				tileIndex:'='
				completed:'='

#			link:($scope, element, attrs)->

		return def
	]

