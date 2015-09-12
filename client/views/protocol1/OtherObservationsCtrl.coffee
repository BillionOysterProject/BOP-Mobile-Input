angular.module('app.example').controller 'OtherObservationsCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	($scope, $controller, $ionicPlatform) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.section.otherObservations ?= null

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.saveSection ['otherObservations']
				$scope.showSaveDone()
				$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]