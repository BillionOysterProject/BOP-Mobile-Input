angular.module('app.example').controller 'WaterQualityCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'bopStaticData'
	($scope, $controller, $stateParams, bopStaticData) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]
		$scope.indicators = bopStaticData.waterQualitySectionIndicators
	]