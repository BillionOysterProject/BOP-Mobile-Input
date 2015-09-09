angular.module('app.example').controller 'SessileOrganismsTileCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$ionicListDelegate'
	'$ionicModal'
	'$ionicHistory'
	($scope, $controller, $stateParams, $ionicListDelegate, $ionicModal, $ionicHistory) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.cellIsComplete = (index)->
			#TODO
#			$scope.section.settlementTiles?[index].grid.length > 0

		$scope.showPhoto = ->
			$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismTilePhoto.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.photosModal = modal
				$scope.photosModal.show()

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
							desc:null

				#save the emtpy object structure so that the 'select dominant/co-dominant organism' screens have access to it.
				$scope.saveSection ['settlementTiles']

		#creates 2D array representing grids and columns. No contents.
		initGrid = ->
			rows = 5
			cols = 5
			tile = rows * cols - 1
			$scope.grid = new Array(rows)

			r = rows
			while r--
				c = cols
				$scope.grid[r] = []

				while c--
					$scope.grid[r][c] = tile--

				initSection

		# Enforces completion before closing
		#
		# @see closePhotosModal
#		$scope.requestClosePhotosModal = ->
#			shell = $scope.section.substrateShells[$scope.shellIndex]
#			if !shell.photoIDInside? or !shell.photoIDOutside?
#				$scope.alert("You must take two photos first – the outside and the inside")
#			else
#				$scope.closePhotosModal()

		# @see requestClosePhotosModal
		$scope.closePhotosModal = ->
			$scope.photosModal.remove()

		$scope.getTileStats = ->
			#TODO

#			shell = $scope.section.settlementTiles[$scope.shellIndex]
#
#			console.log  'form is valid, update stats'
#			min = null
#			max = null
#			avg = 0
#			live = 0
#			dead = 0
#			for oyster in shell.oysters
#				if oyster.isAlive
#					live++
#					avg += oyster.sizeMM
#					min = if min then Math.min(min, oyster.sizeMM) else oyster.sizeMM
#					max = if max then Math.max(max, oyster.sizeMM) else oyster.sizeMM
#				else
#					dead++
#					delete oyster.sizeMM
#
#			if shell.totals.live > 1
#				avg = avg / live
#
#			shell.totals.sizeMM = {min, max, avg}
#			shell.totals.live = live
#			shell.totals.dead = dead

		$scope.updateMainTotals = ->
			#TODO

#			live = 0
#			dead = 0
#			min = null
#			max = null
#			avg = 0
#
#			#we'll skip over oysters that don't have a measurement (could happen if an oyster measurement field is invalid). We'll count the valid ones
#			shellsNotIgnoredCount = 0
#
#			for shell in $scope.section.settlementTiles
#				if shell.totals.live? and shell.totals.sizeMM.min?
#					shellsNotIgnoredCount++
#					avg += shell.totals.sizeMM.avg
#					min = if min then Math.min(min, shell.totals.sizeMM.min) else shell.totals.sizeMM.min
#					max = if max then Math.max(max, shell.totals.sizeMM.max) else shell.totals.sizeMM.max
#
#					live += shell.totals.live
#
#				if shell.totals.dead?
#					dead += shell.totals.dead
#
#			avg = avg / shellsNotIgnoredCount
#
#			$scope.section.totalsMM = {min, max, avg}
#			$scope.section.totalsMortality = {live, dead}

		$scope.onTapSave = ->
			#TODO

#			if formIsValid
#				for oyster in $scope.getOysters()
#					delete oyster.sizeMM if !oyster.isAlive
#
#				$scope.updateStats()
#				$scope.saveSection ['settlementTiles', 'totalsMM', 'totalsMortality']
#				$scope.showSaveDone()
#				$scope.back()
#			else
#				console.log 'do nothing, sectionForm invalid'

		$scope.showTileStats = ->
			$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismsTileStats.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.shellStatsModal = modal
				$scope.shellStatsModal.show()

		$scope.getCurrentTile = ->
			$scope.section.settlementTiles[$scope.tileIndex]

		$scope.tileIndex = $stateParams.tileIndex;

		initSection()
		initGrid()

		#show the photo if we don't have one yet and we've arrived here by navigating forward (not coming back to this view from somewhere deeper in the stack)
		$scope.showPhoto() if !$scope.getCurrentTile().photoID? and $ionicHistory.forwardView() is null
	]