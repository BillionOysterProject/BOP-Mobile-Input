angular.module('app.example').controller 'ProtocolCtrl', [
	'$scope'
	'$stateParams'
	($scope, $stateParams) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]
	]