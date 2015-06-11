angular.module('app.example').controller 'SedimentCtrl', [
	'$scope'
	'$controller'
	'$filter'
	($scope, $controller, $filter) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.updateVolumeRate = (form)->
			if form.volume.$valid and form.daysCollected.$valid
				$scope.section.volumeRate = $scope.section.volume / $scope.section.daysCollected
				$scope.volumeRateDisplay = $filter('number')($scope.section.volumeRate, 2)

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.save().then ->
					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'
	]