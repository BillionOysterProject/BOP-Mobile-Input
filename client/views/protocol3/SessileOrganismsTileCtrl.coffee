angular.module('app.example').controller 'SessileOrganismsTileCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$ionicListDelegate'
	'$ionicModal'
	'$ionicScrollDelegate'
	($scope, $controller, $stateParams, $ionicListDelegate, $ionicModal, $ionicScrollDelegate) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		totalShells = 10
		$scope.tileIndex = $stateParams.tileIndex;

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
				i = totalShells
				while i--
					$scope.section.settlementTiles[i] =
						totals:
							sizeMM:{}
						oysters:[]

			$scope.section.totalsMM ?=
				min: null
				max: null
				avg: null

			$scope.section.totalsMortality ?=
				live: null
				dead: null

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

		$scope.onTapSave = (formIsValid)->
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

		#creates 2D array representing grids and columns. No contents.
		initGrid = ->
			rows = 5
			cols = 5
			tile = 0
			$scope.grid = new Array(rows)

			r = 0
			while r < rows
				c = 0
				$scope.grid[r] = []
				while c < cols
					$scope.grid[r][c++] = tile++
				r++

				initSection

		initSection()
		initGrid()
	]