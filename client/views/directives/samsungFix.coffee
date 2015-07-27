# An attempt to fix the Samsung bug where on earlier versions of Android < ~5.0.0 on Samsung devices where they have
# their own keyboard, they're missing the decimal point when input type=number.
# This fix doesn't facilitate things like adding ng-change or any other directives and the scope just gets too crazy. I haven't figure out how to get the html autofocus directive to work when adding it dynamically which is important for the Water Quality section data-input pop-up
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

