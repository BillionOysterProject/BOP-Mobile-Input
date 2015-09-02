angular.module('app.example').controller 'WeatherCtrl', [
	'$scope'
	'$controller'
	'$meteor'
	'$q'
	($scope, $controller, $meteor, $q) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.windDirections = [
			{deg:0, label:"N"}
			{deg:45, label:"NE"}
			{deg:90, label:"E"}
			{deg:135, label:"SE"}
			{deg:180, label:"S"}
			{deg:225, label:"SW"}
			{deg:270, label:"W"}
			{deg:315, label:"NW"}
		]

		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		$scope.weatherConditions = $meteor.collection(MetaWeatherConditions)

		if $scope.section.weatherCondition?
			for condition in $scope.weatherConditions
				if $scope.section.weatherCondition is condition.machineName
					$scope.formIntermediary.weatherCondition = condition
					break

		if $scope.section.windDirection?
			for item in $scope.windDirections
				if $scope.section.windDirection is item.label
					$scope.formIntermediary.windDirection = item

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				if $scope.formIntermediary.weatherCondition?
					$scope.section.weatherCondition = $scope.formIntermediary.weatherCondition.machineName

				if $scope.formIntermediary.windDirection?
					$scope.section.windDirection = $scope.formIntermediary.windDirection.label

				$scope.saveSection(['humidityPct','machineName','temperatureF','weatherCondition','windDirection','windSpeed'])
				$scope.showSaveDone()
				$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]