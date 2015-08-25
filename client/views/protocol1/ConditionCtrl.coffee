angular.module('app.example').controller 'ConditionCtrl', [
	'$scope'
	'$controller'
	'bopLocationHelper'
	($scope, $controller, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.section.bioaccumulation ?= 0

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.saveSection ['bioaccumulation']
				$scope.showSaveDone()
				$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]