angular.module('app.example').directive 'bopProgressBar', [
	->
		def =
			name:'bopProgressBar'
			restrict:'E'

			template:"""
					<div class="outer">
						<div class="inner"></div>
					</div>
					"""
			scope:
				p:'='

			link:($scope, element, attrs)->
				updateWidth = ->
					element.find('.inner').css('width', Math.floor($scope.p * 100) + '%')

				$scope.$watch 'p', ->
					updateWidth()

				element.addClass('bop-progress-bar')
				updateWidth()

		return def
	]

