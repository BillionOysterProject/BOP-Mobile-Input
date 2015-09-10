angular.module('app.example').controller 'SessileOrganismsCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$ionicModal'
	($scope, $controller, $stateParams, $ionicModal) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.tileIsComplete = (index)->
			#TODO
#			$scope.section.settlementTiles?[index].grid.length > 0

		$scope.showOverallStats = ->
			$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismsOverallStats.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.overallStatsModal = modal
				$scope.overallStatsModal.show()
	]