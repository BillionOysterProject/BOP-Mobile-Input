angular.module('app.example').controller 'WaterQualityCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$meteor'
	($scope, $controller, $stateParams, $meteor) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]
		$scope.indicators = $meteor.collection(MetaWaterQualityIndicators).subscribe('MetaWaterQualityIndicators')
	]
