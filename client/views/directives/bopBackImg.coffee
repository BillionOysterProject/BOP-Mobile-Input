
#dynamically adds a CSS background image
angular.module('app.example').directive 'bopBackImg', [
	->
		def =
			name:'bopBackImg'
			restrict:'A'

			link:($scope, element, attrs)->
				attrs.$observe "bopBackImg", (value) ->
					element.css
						"background-image": "url(" + value + ")"
						"background-repeat": "no-repeat"

					return

		return def
	]