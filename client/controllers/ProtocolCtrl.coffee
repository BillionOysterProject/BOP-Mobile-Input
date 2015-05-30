angular.module('app.example').controller 'ProtocolCtrl', ($scope,
                                                      $state,
                                                      $stateParams,
													) ->
	if !$scope.startupComplete
		location.href = '/'
		return

	$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]