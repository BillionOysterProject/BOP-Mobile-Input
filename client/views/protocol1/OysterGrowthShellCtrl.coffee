angular.module('app.example').controller 'OysterGrowthShellCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$ionicListDelegate'
	'$ionicModal'
	'$ionicScrollDelegate'
	'bopOfflineImageHelper'
	($scope, $controller, $stateParams, $ionicListDelegate, $ionicModal, $ionicScrollDelegate, bopOfflineImageHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		totalShells = 10
		$scope.shellIndex = $stateParams.shellIndex;
		$scope.maxOysters = 50

		$scope.maxSpatSizeMM = 99

		$scope.radioBoolValues =
			boolTrue:true
			boolFalse:false

		#Note: overrides title defined in ProtocolSectionBaseCtrl
		$scope.title = '<i class="icon icon-oyster-measurement"></i>Oyster growth'

		#init with some basic structure that will be populated via bindings in the template
		$scope.initSection = ->
			#set up initial shells array if empty
			if !$scope.section.substrateShells
				$scope.section.substrateShells = []
				i = totalShells
				while i--
					$scope.section.substrateShells[i] =
						totals:
							sizeMM:{}
						oysters:[]
						photoIDInside:null
						photoIDOutside:null

			$scope.section.totalsMM ?=
				min: null
				max: null
				avg: null

			$scope.section.totalsMortality ?=
				live: null
				dead: null

			initPhotoURLs()

		$scope.getOysters = ->
			$scope.section.substrateShells[$scope.shellIndex].oysters

		# gets the actual number.
		# @see getTotalLiveOystersArr
		$scope.getTotalLiveOysters = (shellIndex)->
			$scope.section.substrateShells[shellIndex]?.totals.live or 0

		$scope.shellHasLiveOysters = (shellIndex)->
			$scope.section.substrateShells[shellIndex].totals.live > 0

		$scope.addOyster = ->
			#enforce max with warning $scope.alert
			if $scope.getOysters().length is $scope.maxOysters
				$scope.alert("Measure only #{$scope.maxOysters} of the #{$scope.section.substrateShells[$scope.shellIndex].totals.live} at random")
			else
				shell = $scope.section.substrateShells[$scope.shellIndex]
				shell.oysters.push
					isAlive: null

				shell.totals.live ?= 0
				shell.totals.live++

				$scope.sectionFormRef.$setDirty()
				$ionicScrollDelegate.scrollBottom(true)

		$scope.deleteOyster = (oysterIndex)->
			shell = $scope.section.substrateShells[$scope.shellIndex]
			oyster = shell.oysters[oysterIndex]
			if oyster.isAlive
				shell.totals.live--
			else
				shell.totals.dead--

			$ionicListDelegate.closeOptionButtons()
			_.pull(shell.oysters, oyster)

			$scope.sectionFormRef.$setDirty()

		$scope.updateOysterStats = ->
			shell = $scope.section.substrateShells[$scope.shellIndex]

			console.log  'form is valid, update stats'
			min = null
			max = null
			avg = 0
			live = 0
			dead = 0
			for oyster in shell.oysters
				if oyster.isAlive
					live++
					avg += oyster.sizeMM
					min = if min then Math.min(min, oyster.sizeMM) else oyster.sizeMM
					max = if max then Math.max(max, oyster.sizeMM) else oyster.sizeMM
				else
					dead++
					delete oyster.sizeMM

			if shell.totals.live > 1
				avg = avg / live

			shell.totals.sizeMM = {min, max, avg}
			shell.totals.live = live
			shell.totals.dead = dead

		$scope.updateMainTotals = ->
			live = 0
			dead = 0
			min = null
			max = null
			avg = 0

			#we'll skip over oysters that don't have a measurement (could happen if an oyster measurement field is invalid). We'll count the valid ones
			shellsNotIgnoredCount = 0

			for shell in $scope.section.substrateShells
				if shell.totals.live? and shell.totals.sizeMM.min?
					shellsNotIgnoredCount++
					avg += shell.totals.sizeMM.avg
					min = if min then Math.min(min, shell.totals.sizeMM.min) else shell.totals.sizeMM.min
					max = if max then Math.max(max, shell.totals.sizeMM.max) else shell.totals.sizeMM.max

					live += shell.totals.live

				if shell.totals.dead?
					dead += shell.totals.dead

			avg = avg / shellsNotIgnoredCount

			$scope.section.totalsMM = {min, max, avg}
			$scope.section.totalsMortality = {live, dead}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				for oyster in $scope.getOysters()
					delete oyster.sizeMM if !oyster.isAlive

				$scope.updateStats()
				$scope.saveSection ['substrateShells', 'totalsMM', 'totalsMortality']
				$scope.showSaveDone()
				$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'

		$scope.showShellStats = ->
			if $scope.sectionFormRef.$invalid
				$scope.sectionFormRef.submitProgrammatically()
				$scope.alert('Check living status and measurements then try again')
			else
				$scope.updateStats()

				$ionicModal.fromTemplateUrl("client/views/protocol1/oysterGrowthShellStats.ng.html",
					scope: $scope
					animation: 'slide-in-up')
				.then (modal) ->
					$scope.shellStatsModal = modal
					$scope.shellStatsModal.show()

		$scope.updateStats = ->
			$scope.updateOysterStats()
			$scope.updateMainTotals()

		$scope.showPhotos = ->
			$scope.updateStats()

			$ionicModal.fromTemplateUrl("client/views/protocol1/oysterGrowthPhotos.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				$scope.photosModal = modal
				$scope.photosModal.show()

		$scope.toggleSide = ->
			if $scope.side is 'inside'
				$scope.side = 'outside'
			else
				$scope.side = 'inside'

		getPhotoIDForSide = (side)->
			photoID = null
			shell = $scope.section.substrateShells[$scope.shellIndex]
			switch side
				when 'inside'
					photoID = shell.photoIDInside

				when 'outside'
					photoID = shell.photoIDOutside

			photoID

		initPhotoURLs = ->
			insideID = getPhotoIDForSide('inside')
			outsideID = getPhotoIDForSide('outside')

			$scope.photoURLs ?= {}

			if insideID?
				bopOfflineImageHelper.getURLForID(insideID)
				.then (uri)->
					$scope.photoURLs.inside = uri

			if outsideID?
				bopOfflineImageHelper.getURLForID(outsideID)
				.then (uri)->
					$scope.photoURLs.outside = uri

		$scope.takePhoto = (side)->
			shell = $scope.section.substrateShells[$scope.shellIndex]

			bopOfflineImageHelper.takePic()
			.then (photoMeta) ->
				#photoMeta obj object contains _id and uri

				switch side
					when 'inside'
						oldURL = shell.photoIDInside
						shell.photoIDInside = photoMeta._id

					when 'outside'
						oldURL = shell.photoIDOutside
						shell.photoIDOutside = photoMeta._id

				initPhotoURLs()

				if oldURL
					bopOfflineImageHelper.removePic(oldURL)

		#dirty if section data has changed – emulates ngForm.dirty
		$scope.isDirty = ->
			angular.toJson($scope.section) != $scope.sectionBeforeChanged

		#intercepting back button ------- start

		# userTappedBack is broadcast from AppCtrl
		$scope.$on 'bop.userTappedBack', ->
			$scope.setSectionFormState($scope.isDirty(), false, false)

		#user taps save in back button prompt so we submit the form
		$scope.$on 'bop.userChoseSaveAndGoBack', ->
			$scope.onTapSave()

		#intercepting back button ------- end

		$scope.Math = Math

		#for photo taking modal – the side of the oyster shell to show and take a picture of (inside/outside)
		$scope.side = 'inside'

		$scope.initSection()

		$scope.sectionBeforeChanged = angular.toJson($scope.section)
	]