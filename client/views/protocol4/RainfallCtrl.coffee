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
				#default these to null if undefined (helps support measuring of section completeness)
				$scope.section.recentRain24h ?= null
				$scope.section.recentRain72h ?= null
				$scope.section.recentRain7d ?= null

				$scope.saveSection ['recentRain24h', 'recentRain72h', 'recentRain7d']
				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]