angular.module('app.example').controller 'SessileOrganismsTileCtrl', [
	'$scope'
	'$controller'
	'$q'
	'$stateParams'
	'$ionicListDelegate'
	'$ionicModal'
	'$ionicHistory'
	'sessileOrganismsHelper'
	'bopOfflineImageHelper'
	($scope, $controller, $q, $stateParams, $ionicListDelegate, $ionicModal, $ionicHistory, sessileOrganismsHelper, bopOfflineImageHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.cellIsComplete = (cellIndex)->
			sessileOrganismsHelper.cellIsComplete($scope.section, $scope.tileIndex, cellIndex)

		$scope.showPhoto = ->
			$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismTilePhoto.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.photosModal = modal
				$scope.photosModal.show()

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

		$scope.showTileStats = ->
			$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismsTileStats.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.shellStatsModal = modal
				$scope.shellStatsModal.show()

		$scope.getCurrentTile = ->
			$scope.section.settlementTiles[$scope.tileIndex]

		initPhotoURL = ->
			$q (resolve, reject)->
				photoID = $scope.getCurrentTile().photoID
				if photoID?
					bopOfflineImageHelper.getURLForID(photoID)
					.then (uri)->
						$scope.photoURL = uri
						resolve()
				else
					resolve()

		$scope.takePhoto = ()->
			bopOfflineImageHelper.takePic()
			.then (photoMeta) ->
				#photoMeta obj object contains _id and uri
				console.log 'photoMeta: ', photoMeta

				oldURL = $scope.getCurrentTile().photoID
				$scope.getCurrentTile().photoID = photoMeta._id

				initPhotoURL()

				if oldURL
					bopOfflineImageHelper.removePic(oldURL)

		$scope.saveAndGoBackOneStep = ->
			$scope.saveSection ['settlementTiles']
			$scope.showSaveDone()
			$scope.back()

		#dirty if section data has changed – emulates ngForm.dirty
		$scope.isDirty = ->
			angular.toJson($scope.section) != $scope.sectionBeforeChanged

		#intercepting back button ------- start

		# userTappedBack is broadcast from AppCtrl
		$scope.$on 'bop.userTappedBack', ->
			$scope.setSectionFormState($scope.isDirty(), false, false)

		#user taps save in back button prompt so we submit the form
		$scope.$on 'bop.userChoseSaveAndGoBack', ->
			$scope.saveAndGoBackOneStep()

		#intercepting back button ------- end

		$scope.tileIndex = $stateParams.tileIndex;

		initGrid()
		initPhotoURL()
		$scope.sectionBeforeChanged = angular.toJson($scope.section)

		#show the photo if we don't have one yet and we've arrived here by navigating forward (not coming back to this view from somewhere deeper in the stack)
		$scope.showPhoto() if !$scope.getCurrentTile().photoID? and $ionicHistory.forwardView() is null
	]