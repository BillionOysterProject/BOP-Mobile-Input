angular.module('app.example').controller 'DepthConditionCtrl', [
	'$scope'
	'$controller'
	'bopLocationHelper'
	($scope, $controller, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.section.bioaccumulation ?= 0

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				ProtocolSection.update $scope.section._id,
					$set:_.pick($scope.section.getRawObject(), 'submergedDepth', 'bioaccumulation')
				$scope.showSaveDone()
				$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]