angular.module('app.example').controller 'WaterCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	'bopLocationHelper'
	($scope, $controller, $ionicPlatform, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		#TODO move to DB? Need official list, I made this up --abcd
		$scope.waterColours = [
			{label:'Clear'}
			{label:'Pea green'}
			{label:'Dark Green'}
			{label:'Greeny Brown'}
			{label:'Dark Brown'}
			{label:'Dark Blue'}
			{label:'Light Blue'}
			{label:'Rusty Red'}
			{label:'Orange'}
			{label:'Yellow'}
		]

		#TODO I've set this up for multiple locations but for V1 we'll just work with the first array item and in the UI there's only one drain we can record location for. This structure allows us to add multiple in UI.
		$scope.section.sewerDrainLocations ?= []
		$scope.section.pollutionDrainLocations ?= []

		$scope.formIntermediary.sewerDrainsNear = $scope.section.sewerDrainLocations.length > 0
		$scope.formIntermediary.pollutionDrainsNear = $scope.section.pollutionDrainLocations.length > 0

		$scope.setDrainLocationUsingGPS = ->
			$ionicPlatform.ready =>
				bopLocationHelper.getGPSPosition()
				.then (position)->
#					console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
					$scope.section.sewerDrainLocations[0] ?= {}
					$scope.section.sewerDrainLocations[0].location = "#{position.coords.latitude},#{position.coords.longitude}"
				.catch (error)->
					console.error 'error: ' + JSON.stringify(error)
					$scope.alert JSON.stringify(error), 'error'

		$scope.setPollutionDrainLocationUsingGPS = ->
			$ionicPlatform.ready =>
				bopLocationHelper.getGPSPosition()
				.then (position)->
#					console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
					$scope.section.pollutionDrainLocations[0] ?= {}
					$scope.section.pollutionDrainLocations[0].location = "#{position.coords.latitude},#{position.coords.longitude}"
				.catch (error)->
					console.error 'error: ' + JSON.stringify(error)
					$scope.alert JSON.stringify(error), 'error'

		$scope.garbageDescPlaceholder = 'Many small plastic particles of different colours ranging from .25" to 1" in size'

		if $scope.section.waterColour?
			for item in $scope.waterColours
				if $scope.section.waterColour is item.label
					$scope.formIntermediary.waterColour = item
					break

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.waterColour = $scope.formIntermediary.waterColour.label
				$scope.section.sewerDrainLocations = [] if !$scope.formIntermediary.sewerDrainsNear
				$scope.section.pollutionDrainLocations = [] if !$scope.formIntermediary.pollutionDrainsNear

				$scope.saveSection ['waterColour', 'garbageDescription', 'oilSheen', 'pollutionDrainLocations', 'sewerDrainLocations']
				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]