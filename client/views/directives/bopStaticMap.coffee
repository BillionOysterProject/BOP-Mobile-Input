angular.module('app.example').directive 'bopStaticMap', [
	->
		def =
			name:'bopStaticMap'
			restrict:'E'

			template:'<img ng-src="https://maps.googleapis.com/maps/api/staticmap?center={{location}}&markers=color:red%7C{{location}}&zoom=14&size=320x200&maptype=roadmap">'

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

