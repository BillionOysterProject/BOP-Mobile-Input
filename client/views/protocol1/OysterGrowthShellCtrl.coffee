angular.module('app.example').controller 'OysterGrowthShellCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	($scope, $controller, $stateParams) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		totalShells = 10
		$scope.shellIndex = $stateParams.shellIndex;
		$scope.maxLiveOysterMeasurements = 12

		$scope.maxSpatSizeMM = 200

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

		$scope.onChangeTotalLive = (shellIndex, formIsValid)->
			if formIsValid
				$scope.pruneModel shellIndex
#				$scope.updateMainTotals(formIsValid)

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
			new Array(Math.min($scope.getTotalLiveOysters(shellIndex), $scope.maxLiveOysterMeasurements))

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
					avg = Math.round(avg / shell.totals.live)

			else
				console.log  'form is INVALID, ignoring'
				min = max = avg = null

			shell.totals.sizeMM = {min, max, avg}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				i = totalShells
				while i--
					$scope.pruneModel(i)

#				$scope.updateMainTotals(true)
				$scope.saveSection ['shells', 'totalsMM', 'totalsMortality']
				$scope.showSaveDone()
				$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'

		$scope.Math = Math

		$scope.initSection()
	]