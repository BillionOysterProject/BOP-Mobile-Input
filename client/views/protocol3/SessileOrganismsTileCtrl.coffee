angular.module('app.example').controller 'SessileOrganismsTileCtrl', [
	'$scope'
	'$rootScope'
	'$controller'
	'$q'
	'$stateParams'
	'$ionicListDelegate'
	'$ionicModal'
	'$ionicHistory'
	'sessileOrganismsHelper'
	'bopOfflineImageHelper'
	($scope, $rootScope, $controller, $q, $stateParams, $ionicListDelegate, $ionicModal, $ionicHistory, sessileOrganismsHelper, bopOfflineImageHelper) ->
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

		$scope.showTileStats = ->
			if sessileOrganismsHelper.tileIsComplete($scope.section, $scope.tileIndex)
				statsScope = $rootScope.$new()
				statsScope.stats = sessileOrganismsHelper.getStatsForTile($scope.section, $scope.tileIndex)

				$ionicModal.fromTemplateUrl("client/views/protocol3/sessileOrganismsTileStats.ng.html",
					scope: statsScope
					animation: 'slide-in-up')
				.then (modal) ->
					statsScope.tileStatsModal = modal
					statsScope.tileStatsModal.show()
			else
				$scope.alert("I can't show stats until you complete the tile", "Sorry")

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