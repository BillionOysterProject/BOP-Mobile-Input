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
				$scope.section.recentRain7d ?= null
				$scope.section.recentRain72h ?= null
				$scope.section.recentRain24h ?= null

				#reset 72h and 24h if the time period above (longer) is set to "No"
				$scope.section.recentRain72h = null if $scope.section.recentRain7d == ""
				$scope.section.recentRain24h = null if $scope.section.recentRain7d == "" or $scope.section.recentRain72h == ""

				$scope.saveSection ['recentRain7d', 'recentRain72h', 'recentRain24h']
				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]