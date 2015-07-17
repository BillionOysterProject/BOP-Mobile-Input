# @author Andrew Blair
angular.module('app.example').directive 'samsungFix', [
	->
		def =
			name:'samsungFix'
			restrict:'A'
			require:'ngModel'
			replace:true

			templateUrl:"client/views/directives/samsungFix.ng.html"
#
			scope:
				name:'='
				myValue:'=ngModel'
				min:'='
				max:'='
				isSamsung:'='

			link: ($scope, element, attrs, ngModelCtrl)->
				$scope.opts = attrs

				#I don't know why I had to do this, I expected that myValue would two-way bind back up to the original model passed in.
				$scope.propagateModel = (value)->
					nestedVal = Number($('input').val())
					ngModelCtrl.$setViewValue(nestedVal)

		return def
	]

