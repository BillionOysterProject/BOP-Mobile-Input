# Puts cursor in input (focuses it) conditionally
#
# Usage:
#	<div class="row" ng-form="myForm" ng-repeat="form in forms track by $index">
#	  <input type="text" name="location" ng-model="form.query" focused-on="$first" />
#	</div>
#
# ref: http://stackoverflow.com/a/20820673/756177
angular.module('app.example').directive 'bopFocusedOn', [
	'$timeout'
	($timeout) ->
		($scope, $element, $attrs) ->
			focus = ->
				$timeout (->
					$element.focus()
				), 20

			if _($attrs.focusedOn).isEmpty()
				return focus()

			$scope.$watch $attrs.focusedOn, (newVal) ->
				focus() if newVal

]