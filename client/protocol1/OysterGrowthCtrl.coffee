angular.module('app.example').controller 'OysterGrowthCtrl', [
	'$scope'
	'$controller'
	'bopLocationHelper'
	($scope, $controller, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		totalShells = 10

		#init with some basic structure that will be populated via bindings in the template
		$scope.initSection = ->
			#set up initial shells array if empty
			if !$scope.section.shells
				$scope.section.shells = []
				i = totalShells
				while i--
					$scope.section.shells[i] =
						totals:{}
						liveSizesMM:[]

			$scope.section.totalsMM ?=
				min: null
				max: null
				avg: null

			$scope.section.totalsMortality ?=
				live: null
				dead: null

		$scope.maxSpatSizeMM = 50

		$scope.onChangeTotalLive = (shellIndex, formIsValid)->
			if formIsValid
				$scope.pruneModel shellIndex
				$scope.updateMainTotals(formIsValid)

		# truncate the model's liveSizesMM array in case it used ot be longer.
		# ng-repeat will keep up with the right amount of fields but won't prune
		# the model if total live oysters is reduced by user.
		$scope.pruneModel = (shellIndex)->
			shell = $scope.section.shells[shellIndex]
			totalLive = $scope.getTotalLiveOysters(shellIndex)
			shell.liveSizesMM = shell.liveSizesMM[0...totalLive]

		# Dummy array to enable ng-repeat for n times (maxed at 12). Array does not get populated.
		# @see getTotalLiveOysters
		$scope.getTotalLiveOystersArr = (shellIndex)->
			new Array(Math.min($scope.getTotalLiveOysters(shellIndex), 12))

		# gets the actual number.
		# @see getTotalLiveOystersArr
		$scope.getTotalLiveOysters = (shellIndex)->
			$scope.section.shells[shellIndex]?.totals.live or 0

		$scope.shellHasLiveOysters = (shellIndex)->
			$scope.section.shells[shellIndex].totals.live > 0

		$scope.updateLiveOysterStats = (formIsValid, shellIndex)->
			console.log 'updateLiveOysterStats'
			shell = $scope.section.shells[shellIndex]

			if formIsValid
				console.log  'form is valid, update stats'
				min = null
				max = null
				avg = 0
				for sizeMM in shell.liveSizesMM
					avg += sizeMM
					min = if min then Math.min(min, sizeMM) else sizeMM
					max = if max then Math.max(max, sizeMM) else sizeMM

				if shell.totals.live > 1
					avg = Math.round(avg / 3)

			else
				console.log  'form is INVALID, ignoring'
				min = max = avg = null

			shell.totals.sizeMM = {min, max, avg}

		$scope.updateMainTotals = (formIsValid)->
			console.log 'updateMainTotals'
			if formIsValid
				live = 0
				dead = 0
				min = null
				max = null
				avg = 0
				for shell in $scope.section.shells
					avg += shell.totals.sizeMM.avg
					min = if min then Math.min(min, shell.totals.sizeMM.min) else shell.totals.sizeMM.min
					max = if max then Math.max(max, shell.totals.sizeMM.max) else shell.totals.sizeMM.max
					live += shell.totals.live
					dead += shell.totals.dead

				avg = Math.round(avg / totalShells)
			else
				live = dead = min = max = avg = null

			$scope.section.totalsMM = {min, max, avg}
			$scope.section.totalsMortality = {live, dead}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				console.log 'TODO save sectionForm'

				i = totalShells
				while i--
					$scope.pruneModel(i)

				$scope.updateMainTotals(true)
				$scope.section.save().then ->
					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'

		$scope.initSection()
	]