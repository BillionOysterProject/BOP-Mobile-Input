# @author Andrew Blair
angular.module('app.example').directive 'samsungFix', [
	'$timeout'
	($timeout)->
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

				if attrs.hasOwnProperty('autofocus')
					console.log 'adding autofocus to input'

					$timeout ->
						console.log "element.find('input'): ", element.find('input')
#						element.find('input').attr('autofocus')
						element.find('input')[0].focus()

				#I don't know why I had to do this, I expected that myValue would two-way bind back up to the original model passed in.
				$scope.propagateModel = (value)->
					nestedVal = Number($('input').val())
					ngModelCtrl.$setViewValue(nestedVal)

		return def
	]

