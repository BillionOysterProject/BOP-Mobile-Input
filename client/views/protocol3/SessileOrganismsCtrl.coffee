angular.module('app.example').controller 'SessileOrganismsCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$ionicModal'
	($scope, $controller, $stateParams, $ionicModal) ->
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

		cellIsComplete = (cellIndex)->
			cell = $scope.getCurrentTile().cells[cellIndex]
			cell.dominantOrgID and cell.coDominantOrgID

		$scope.tileIsComplete = (tileIndex)->
			tile = $scope.section.settlementTiles[tileIndex]
			totalCells = tile.cells.length
			completedCells = 0

			for cell in tile.cells
				completedCells++ if cell.dominantOrgID and cell.coDominantOrgID

			completedCells == totalCells

		$scope.showOverallStats = ->
			$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismsOverallStats.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.overallStatsModal = modal
				$scope.overallStatsModal.show()

		initSection()
	]