angular.module('app.example').controller 'TideCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	'bopStaticData'
	($scope, $controller, $ionicPlatform, bopStaticData) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.tideLevels = [
			'dead low'
			'med/low'
			'mid'
			'med/high'
			'high'
		]

		$scope.castTideEstimateToNum = ->
			$scope.section.tideEstimate = Number($scope.section.tideEstimate)

		$scope.section.tideEstimate ?= 0
		$scope.section.tideDirection ?= 'slack'


		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.save().then ->
					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'
	]