angular.module('app.example').controller 'OysterGrowthCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	($scope, $controller, $stateParams) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		# Dummy array to enable ng-repeat for n times. Array does not get populated.
		$scope.totalShells = new Array(10)
		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]

		$scope.shellIsComplete = (index)->
			$scope.section.shells?[index].totals.live? || $scope.section.shells?[index].totals.dead?

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
	]