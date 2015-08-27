angular.module('app.example').controller 'CageLocationCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	'bopLocationHelper'
	($scope, $controller, $ionicPlatform, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.setLocationUsingGPS = ->
			console.log 'setLocationUsingGPS'
			$scope.sectionFormRef.$setDirty()
			$ionicPlatform.ready =>
				bopLocationHelper.getGPSPosition()
				.then (position)->
#					console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
					$scope.section.location = "#{position.coords.latitude},#{position.coords.longitude}"
				.catch (error)->
					console.error 'error: ' + JSON.stringify(error)
					$scope.alert JSON.stringify(error), 'error'

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.save().then ->
					console.log 'saved section form to db'
					$scope.showSaveDone()
					$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]