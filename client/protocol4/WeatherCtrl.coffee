angular.module('app.example').controller 'WeatherCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	'bopStaticData'
	($scope, $controller, $ionicPlatform, bopStaticData) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.windDirections = [
			{label:"N"}
			{label:"NW"}
			{label:"W"}
			{label:"SW"}
			{label:"S"}
			{label:"SE"}
			{label:"E"}
			{label:"NE"}
		]

		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		$scope.weatherConditions = bopStaticData.weatherConditions
		if $scope.section.weatherCondition?
			for item in $scope.weatherConditions
				if $scope.section.weatherCondition is item.id
					$scope.formIntermediary.weatherCondition = item
					break

		if $scope.section.windDirection?
			for item in $scope.windDirections
				if $scope.section.windDirection is item.label
					$scope.formIntermediary.windDirection = item

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.weatherCondition = $scope.formIntermediary.weatherCondition.id
				$scope.section.windDirection = $scope.formIntermediary.windDirection.label
				$scope.section.save().then ->
					console.log 'saved section form to db'
					$scope.showSaveDone()
					$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]