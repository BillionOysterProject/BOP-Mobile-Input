angular.module('app.example').directive 'bopSamsungNumberInput', [
	'$timeout'
	($timeout)->
		def =
			name:'bopSamsungNumberInput'
			restrict:'E'
			require:'ngModel'

			templateUrl:"client/views/directives/bopSamsungNumberInput.ng.html"
#
			scope:
				name:'='
				myValue:'=ngModel'
				min:'='
				max:'='
				isSamsung:'='

			link: ($scope, element, attrs, ngModelCtrl)->
				element.addClass('bop-samsung-number-input')
				$scope.opts = attrs

				#I don't know why I had to do this, I expected that myValue would two-way bind back up to the original model passed in.
				$scope.propagateModel = (value)->
					nestedVal = Number($('input').val())
					ngModelCtrl.$setViewValue(nestedVal)

		return def
	]

