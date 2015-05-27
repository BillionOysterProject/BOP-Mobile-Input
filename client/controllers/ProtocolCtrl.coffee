angular.module('app.example').controller 'ProtocolCtrl', ($scope,
                                                      $state,
                                                      $stateParams,
													) ->
	if !$scope.startupComplete
		location.href = '/'
		return

	console.log 'protocolctrl stateParams: ' + JSON.stringify($stateParams)

	$scope.protocol = $scope.protocolsMap[$stateParams.protocolNum]