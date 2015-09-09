angular.module('app.example').controller 'SessileOrganismsSelectOrganismsCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$meteor'
	($scope, $controller, $stateParams, $meteor) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#prepares the organism data for UI.
		$scope.organisms = $meteor.collection ->
			Organisms.find({mobile:true})

		$scope.tileIndex = $stateParams.tileIndex;
		$scope.cellIndex = $stateParams.cellIndex;
		$scope.cell = $scope.section.settlementTiles[$scope.tileIndex].cells[$scope.cellIndex]
	]