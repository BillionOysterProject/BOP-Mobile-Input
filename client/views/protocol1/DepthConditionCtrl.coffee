angular.module('app.example').controller 'DepthConditionCtrl', [
	'$scope'
	'$controller'
	'bopLocationHelper'
	($scope, $controller, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.section.bioaccumulation ?= 0

		console.log 'DepthConditionCtrl isSamsung: ' + $scope.isSamsung

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.saveSection ['submergedDepth', 'bioaccumulation']
				$scope.showSaveDone()
				$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]