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
				$scope.section.save().then ->
					console.log 'saved section form to db'
					$scope.showSaveDone()
					$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]