angular.module('app.example').controller 'WaterCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	($scope, $controller, $ionicPlatform) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		#TODO move all these objects to the DB
		$scope.waterColors = [
			{label:'Light Blue'}
			{label:'Dark Blue'}
			{label:'Light Green'}
			{label:'Dark Green'}
			{label:'Light Brown'}
			{label:'Dark Brown'}
		]

		$scope.garbageTypes = [
			{name:'hardPlastic', label:'Hard Plastic'}
			{name:'softPlastic', label:'Soft Plastic'}
			{name:'metal', label:'Metal'}
			{name:'paper', label:'Paper'}
			{name:'glass', label:'Glass'}
			{name:'organic', label:'Organic'}
		]

		$scope.garbageQuantities = [
			{value:0, label:'None'}
			{value:1, label:'Sporadic'}
			{value:2, label:'Common'}
			{value:3, label:'Extensive'}
		]

		$scope.pipeFlowAmounts = [
			{value:1,label:'Trickle'}
			{value:2,label:'Light Stream'}
			{value:3,label:'Steady Stream'}
			{value:4,label:'Full Flow'}
		]

		#TODO I've set this up for multiple locations but for V1 we'll just work with the first array item and in the UI there's only one drain we can record location for. This structure allows us to add multiple in UI.
		#We've ditched the locations for the sewer pipes
		#$scope.section.sewerDrainLocations ?= []
		#$scope.formIntermediary.sewerDrainsNear = $scope.section.sewerDrainLocations.length > 0

		$scope.formIntermediary.waterGarbage = $scope.section.waterGarbage
		$scope.formIntermediary.sewerDrainsNear = $scope.section.sewerDrainsNear
		$scope.formIntermediary.pipeFlow = $scope.section.pipeFlow

		if $scope.section.waterColor?
			for item in $scope.waterColors
				if $scope.section.waterColor is item.label
					$scope.formIntermediary.waterColor = item
					break

		#set initial option to "none" rather than the default blank - saves the user having to select if there is none of this type
		angular.forEach $scope.garbageTypes, (value, key) ->
			$scope.section[value.name] = if $scope.section[value.name] then $scope.section[value.name] else $scope.garbageQuantities[0]
			return

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.waterColor = $scope.formIntermediary.waterColor?.label
				$scope.section.oilSheen = $scope.formIntermediary.oilSheen
				$scope.section.waterGarbage = $scope.formIntermediary.waterGarbage
				$scope.section.sewerDrainsNear = $scope.formIntermediary.sewerDrainsNear
				$scope.section.pipeFlow = $scope.formIntermediary.pipeFlow

				sectionsToSave = ['waterColor', 'waterGarbage', 'oilSheen', 'sewerDrainsNear', 'pipeDiameter', 'pipeFlow', 'pipeFlowAmount']

				angular.forEach $scope.garbageTypes, (value, key) ->
					#if waterGarbage "No" then reset quantity for each type
					$scope.section[value.name] = null if !$scope.formIntermediary.waterGarbage
					#add all the garbage types to save
					sectionsToSave.push value.name
					return

				#various resets if parent question is not set or "No"
				$scope.section.pipeDiameter = null if !$scope.formIntermediary.sewerDrainsNear
				$scope.section.pipeFlow = null if !$scope.formIntermediary.sewerDrainsNear
				$scope.section.pipeFlowAmount = null if !$scope.formIntermediary.pipeFlow or !$scope.formIntermediary.sewerDrainsNear

				$scope.saveSection sectionsToSave

				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]