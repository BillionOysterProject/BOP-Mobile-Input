angular.module('app.example').controller 'LandCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	'bopLocationHelper'
	($scope, $controller, $ionicPlatform, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.shorelineTypes = [
			{id: 'bulkheadWall', label:'Bulkhead / Wall'}
			{id: 'fixedPier', label:'Fixed Pier'}
			{id: 'floatingDock', label:'Floating Dock'}
			{id: 'riprap', label:'Riprap'}
			{id: 'rockyShoreline', label:'Rocky Shoreline'}
			{id: 'natural', label:'Natural'}
			{id: 'other', label:'Other'}
		]
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

		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary =
			shorelineTypes:{}

		$scope.section.shorelineTypes ?= []
		for type in $scope.section.shorelineTypes
			$scope.formIntermediary.shorelineTypes[type] = true

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				shorelineTypes = []
				for shorelineID, isChecked of $scope.formIntermediary.shorelineTypes
					shorelineTypes.push(shorelineID) if isChecked
				$scope.section.shorelineTypes = shorelineTypes
				if !$scope.formIntermediary.shorelineTypes.other
					$scope.section.shorelineDescOther = null

				$scope.section.save().then ->
					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'
	]