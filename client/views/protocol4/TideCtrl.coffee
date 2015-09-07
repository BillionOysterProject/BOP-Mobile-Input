angular.module('app.example').controller 'TideCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	($scope, $controller, $ionicPlatform) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

#		$scope.tideLevels = [
#			'dead low'
#			'med/low'
#			'mid'
#			'med/high'
#			'high'
#		]

#		$scope.castTideEstimateToNum = ->
#			$scope.section.estimate = Number($scope.section.estimate)

#		$scope.castTideSpeedToNum = ->
#			$scope.section.speed = Number($scope.section.speed)

		$scope.section.tideLevel ?= null
		$scope.section.pmHighTideHeight ?= null
		$scope.section.pmHighTideTime ?= null
		$scope.section.currentDistance ?= null
		$scope.section.currentTime ?= null
		$scope.section.direction ?= null


		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.saveSection ['tideLevel', 'pmHighTideHeight', 'pmHighTideTime', 'currentDistance', 'currentTime', 'direction']
				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]