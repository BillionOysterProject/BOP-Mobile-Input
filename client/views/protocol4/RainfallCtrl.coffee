angular.module('app.example').controller 'RainfallCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	($scope, $controller, $ionicPlatform) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				#default these to false if undefined (helps support measuring of section completeness)
				$scope.section.recentRain72h ?= false
				$scope.section.recentRain7d ?= false

				$scope.saveSection ['recentRain72h', 'recentRain7d']
				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]