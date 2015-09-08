angular.module('app.example').controller 'SessileOrganismsCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$ionicModal'
	'$rootScope'
	($scope, $controller, $stateParams, $ionicModal, $rootScope) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		# Dummy array to enable ng-repeat for n times. Array does not get populated.
		$scope.totalTiles = new Array(4)
		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]

		$scope.tileIsComplete = (index)->
			$scope.section.settlementTiles?[index].grid.length > 0

		$scope.showOverallStats = ->
			$ionicModal.fromTemplateUrl("client/views/protocol1/SessileOrganismsOverallStats.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.overallStatsModal = modal
				$scope.overallStatsModal.show()
	]