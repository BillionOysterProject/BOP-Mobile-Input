#dynamically rotates by given degrees. Designed for inline icons, sets display to inline-block
angular.module('app.example').directive 'rotate', [
	->
		def =
			name:'rotate'
			restrict:'A'

			link:($scope, element, attrs)->
				attrs.$observe "rotate", (value) ->
					cssVal = "rotate(" + value + "deg)"
					element.css
						"display": 'inline-block'
						"-ms-transform": cssVal         # IE 9
						"-webkit-transform": cssVal     # Safari
						"transform": cssVal

					return

		return def
	]