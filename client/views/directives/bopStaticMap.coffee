angular.module('app.example').directive 'bopStaticMap', [
	->
		def =
			name:'bopStaticMap'
			restrict:'E'

			templateUrl:'client/views/directives/bopStaticMap.ng.html'
			scope:
				location:'='
#				mode:'='

			link:($scope, element, attrs)->
				element.addClass('bop-static-map')

#				attrs.$observe "backImg", (value) ->
#					element.css
#						"background-image": "url(" + value + ")"
#						"background-size": "cover"
#
#					return

		return def
	]

