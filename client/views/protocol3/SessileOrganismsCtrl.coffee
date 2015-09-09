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

###


section.settlementTiles = [
	photoID:'b1dH36' # photo _id value
	cells:[
		main:'ab12345' # aka 'dominant'. organism _id value
		sub:'za24' # aka 'co-dominant'. 3 possible value types: 1. organism _id value, 2. 'none' or 3. 'other'
		desc:"Also saw a puffer fish"
		#... 25
	]
,
	cells:[

		#... 25
	]
,
	cells:[

		#... 25
	]
,
	cells:[

		#... 25
	]
]
###
