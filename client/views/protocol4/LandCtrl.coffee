angular.module('app.example').controller 'LandCtrl', [
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

		#TODO move all these objects to the DB
		$scope.shorelineTypes = [
			{id: 'bulkheadWall', label:'Bulkhead / Wall'}
			{id: 'fixedPier', label:'Fixed Pier'}
			{id: 'floatingDock', label:'Floating Dock'}
			{id: 'riprap', label:'Riprap'}
			{id: 'rockyShoreline', label:'Rocky Shoreline'}
			{id: 'natural', label:'Natural'}
			{id: 'other', label:'Other'}
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

		$scope.settotalLandSurfaceAreas = ->
			$scope.formIntermediary.totalLandSurfaceAreas = $scope.section.imperviousSurfacePct + $scope.section.perviousSurfacePct + $scope.section.vegetatedSurfacePct
			return

		$scope.settotalLandSurfaceAreas()

		$scope.formIntermediary.landGarbage = $scope.section.landGarbage

#		$scope.shorelineTypeMap = {}
#		for type in $scope.shorelineTypes
#			$scope.shorelineTypeMap[type.id] = type

#		$scope.setDrainLocationUsingGPS = ->
#			$ionicPlatform.ready =>
#				bopLocationHelper.getGPSPosition()
#				.then (position)->
##					console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
#					$scope.section.sewerDrainLocations[0] ?= {}
#					$scope.section.sewerDrainLocations[0].location = "#{position.coords.latitude},#{position.coords.longitude}"
#				.catch (error)->
#					console.error 'error: ' + JSON.stringify(error)
#					$scope.alert JSON.stringify(error), 'error'

		$scope.formIntermediary.shorelineTypes = {}

		$scope.section.shorelineTypes ?= []
		for type in $scope.section.shorelineTypes
			$scope.formIntermediary.shorelineTypes[type] = true

		#set initial option to "none" rather than the default blank - saves the user having to select if there is none of this type
		angular.forEach $scope.garbageTypes, (value, key) ->
			$scope.section[value.name] = if $scope.section[value.name] then $scope.section[value.name] else $scope.garbageQuantities[0]
			return

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.landGarbage = $scope.formIntermediary.landGarbage
				shorelineTypes = []
				for shorelineID, isChecked of $scope.formIntermediary.shorelineTypes
					shorelineTypes.push(shorelineID) if isChecked
				$scope.section.shorelineTypes = shorelineTypes
				if !$scope.formIntermediary.shorelineTypes.other
					$scope.section.shorelineDescOther = null

				sectionsToSave = ['imperviousSurfacePct', 'perviousSurfacePct', 'vegetatedSurfacePct', 'landGarbage', 'shorelineTypes', 'shorelineDescOther']

				angular.forEach $scope.garbageTypes, (value, key) ->
					#if landGarbage "No" then reset quantity for each type
					$scope.section[value.name] = null if !$scope.formIntermediary.landGarbage
					#add all the garbage types to save
					sectionsToSave.push value.name
					return

				$scope.saveSection sectionsToSave

				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]