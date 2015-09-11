angular.module('app.example').controller 'SessileOrganismsCtrl', [
	'$scope'
	'$rootScope'
	'$controller'
	'$stateParams'
	'$ionicModal'
	'sessileOrganismsHelper'
	($scope, $rootScope, $controller, $stateParams, $ionicModal, sessileOrganismsHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#init with some basic structure that will be populated via bindings in the template
		initSection = ->
			#set up initial shells array if empty
			if !$scope.section.settlementTiles
				$scope.section.settlementTiles = []
				totalTiles = 4
				totalCells = 25
				t = totalTiles
				while t--
					c = totalCells
					$scope.section.settlementTiles[t] =
						photoID:null
						cells: []

					while c--
						$scope.section.settlementTiles[t].cells[c] =
							dominantOrgID:null
							coDominantOrgID:null
							notes:null

				#save the emtpy object structure so that the 'select dominant/co-dominant organism' screens have access to it.
				$scope.saveSection ['settlementTiles']

		$scope.tileIsComplete = (tileIndex)->
			sessileOrganismsHelper.tileIsComplete($scope.section, tileIndex)

		$scope.showOverallStats = ->
			if sessileOrganismsHelper.allTilesAreComplete($scope.section)
				statsScope = $rootScope.$new()
				statsScope.stats = sessileOrganismsHelper.getOverallStats($scope.section)

				$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismsOverallStats.ng.html",
					scope: statsScope
					animation: 'slide-in-up')
				.then (modal) ->
					statsScope.overallStatsModal = modal
					statsScope.overallStatsModal.show()

			else
				$scope.alert("I can't show overall stats until you complete all the tiles", "Sorry")

		initSection()
	]