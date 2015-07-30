angular.module('app.example').controller 'OysterGrowthCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$ionicModal'
	'$rootScope'
	($scope, $controller, $stateParams, $ionicModal, $rootScope) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		# Dummy array to enable ng-repeat for n times. Array does not get populated.
		$scope.totalShells = new Array(10)
		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]

		$scope.shellIsComplete = (index)->
			$scope.section.substrateShells?[index].totals.live? || $scope.section.substrateShells?[index].totals.dead?

		$scope.showOverallStats = ->
			$ionicModal.fromTemplateUrl("client/views/protocol1/oysterGrowthOverallStats.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.overallStatsModal = modal
				$scope.overallStatsModal.show()
	]