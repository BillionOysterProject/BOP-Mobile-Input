angular.module('app.example').controller 'SedimentCtrl', [
	'$scope'
	'$controller'
	($scope, $controller) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.save().then ->
					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'
	]