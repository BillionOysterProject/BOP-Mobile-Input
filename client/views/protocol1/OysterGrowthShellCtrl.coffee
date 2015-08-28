angular.module('app.example').controller 'OysterGrowthShellCtrl', [
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
		$scope.shellIndex = $stateParams.shellIndex;
		$scope.maxOysters = 12

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

			$scope.section.totalsMM ?=
				min: null
				max: null
				avg: null

			$scope.section.totalsMortality ?=
				live: null
				dead: null

#		$scope.onChangeTotalLive = (shellIndex, formIsValid)->
#			if formIsValid
#				$scope.pruneModel shellIndex
#				$scope.updateMainTotals(formIsValid)

		# truncate the model's liveSizesMM array in case it used ot be longer.
		# ng-repeat will keep up with the right amount of fields but won't prune
		# the model if total live oysters is reduced by user.
#		$scope.pruneModel = (shellIndex)->
#			shell = $scope.section.substrateShells[shellIndex]
#			totalLive = $scope.getTotalLiveOysters(shellIndex)
#			shell.oysters = shell.liveSizesMM[0...totalLive]

		# Dummy array to enable ng-repeat for n times (maxed at 12). Array does not get populated.
		# @see getTotalLiveOysters
#		$scope.getTotalLiveOystersArr = (shellIndex)->
#			new Array(Math.min($scope.getTotalLiveOysters(shellIndex), $scope.maxLiveOysterMeasurements))

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
				$scope.alert("Measure only #{$scope.maxOysters} of the #{$scope.section.substrateShells[shellIndex].totals.live} at random")
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

#		$scope.onChangeIsAlive = (oysterIndex)->
#			shell = $scope.section.substrateShells[$scope.shellIndex]
#			oyster = shell.oysters[oysterIndex]
#
#			#increment or decrement depending on living status
##			shell.totals.live += if oyster.isAlive then -1 else 1
#			$scope.updateOysterTotals(oysterIndex)

#		$scope.updateOysterTotals = (oysterIndex)->
#			shell = $scope.section.substrateShells[$scope.shellIndex]
#			live = 0
#			dead = 0
#			for oyster in $scope.getOysters()
#				if oyster.isAlive then live++ else dead++
#
#			shell.totals.live = live
#			shell.totals.dead = dead

		$scope.updateOysterStats = ->
			console.log 'updateOysterStats'
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
				avg = Math.round(avg / shell.totals.live)

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
					dead += shell.totals.dead

			avg = Math.round(avg / shellsNotIgnoredCount)

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

		$scope.Math = Math

		$scope.initSection()
	]