angular.module('app.example').controller 'ExpeditionOverviewCtrl', [
	'$scope'
	'$stateParams'
	'$q'
	'$ionicHistory'
	'$timeout'
	'$meteor'
	'bopLocationHelper'
	'$ionicPlatform'
	($scope, $stateParams, $q, $ionicHistory, $timeout, $meteor, bopLocationHelper, $ionicPlatform) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		$scope.cameFromExpeditions = ->
			return $ionicHistory.backView()?.stateId is 'app.expeditions'

		if $stateParams.expeditionID
			$scope.expeditionEditing = $meteor.object(Expeditions, $stateParams.expeditionID, false);
		else
			$scope.expeditionEditing = {}

		isNew = !$scope.expeditionEditing.hasOwnProperty('_id')

		$scope.setLocationUsingGPS = ->
			console.log 'setLocationUsingGPS'
			$ionicPlatform.ready =>
				bopLocationHelper.getGPSPosition()
				.then (position)->
#					console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
					$scope.expeditionEditing.location = "#{position.coords.latitude},#{position.coords.longitude}"
				.catch (error)->
					console.error 'error: ' + JSON.stringify(error)
					$scope.alert JSON.stringify(error), 'error'

		$scope.onTapSave = (form) ->
			if form.$valid
				if isNew
					#create protocol section documents ------ start
					cageLocationID = null
					depthConditionID = null
					oysterGrowthID = null

					ProtocolSection.insert
						owner: Meteor.userId()
						machineName:'cageLocation'
					, (err, id)->
						console.log 'cageLocation section inserted'
						cageLocationID = id

					ProtocolSection.insert
						owner: Meteor.userId()
						machineName:'depthCondition'
					, (err, id)->
						console.log 'depthConditionID section inserted'
						depthConditionID = id

					ProtocolSection.insert
						owner: Meteor.userId()
						machineName:'oysterGrowth'
					, (err, id)->
						console.log 'oysterGrowthID section inserted'
						oysterGrowthID = id

						#create protocol section documents ------ end

						#create expedition
						$scope.expeditionEditing.owner = Meteor.userId()
						$scope.expeditionEditing.date = new Date()
						$scope.expeditionEditing.sections = {cageLocationID, depthConditionID, oysterGrowthID}

						Expeditions.insert $scope.expeditionEditing, (err, id)->
							$scope.changeExpedition(id)
				else
					$scope.expeditionEditing.save().then ->
						$ionicHistory.goBack()
			else
				console.log 'do nothing, overviewForm invalid'

		#TODO move into Mongo?
		wb = 0
		$scope.waterBodies = [
			{_id:wb++, label:'Lower East Side Ecology Center'}
			{_id:wb++, label:'The River Project/Pier 40/Hudson River Park'}
			{_id:wb++, label:'La Marina Restaurant'}
			{_id:wb++, label:'Concrete Plant Park'}
			{_id:wb++, label:'Randall\'s Island Park'}
			{_id:wb++, label:'East River State Park/Human Impact Institute'}
			{_id:wb++, label:'Hunter\'s Point South Park'}
			{_id:wb++, label:'Anable Basin Sailing Bar & Grill'}
			{_id:wb++, label:'WNYC Transmitter Park'}
			{_id:wb++, label:'Jefferson Park'}
			{_id:wb++, label:'Harlem River Park'}
			{_id:wb++, label:'Mill Pond Park'}
			{_id:wb++, label:'Swindler Cove'}
			{_id:wb++, label:'Roberto Clemente State Park'}
			{_id:wb++, label:'West Harlem Piers Park'}
			{_id:wb++, label:'Riverside Clay Tennis Association'}
			{_id:wb++, label:'Hudson River Park'}
			{_id:wb++, label:'The Battery Conservancy'}
			{_id:wb++, label:'Sebago Canoe Club'}
			{_id:wb++, label:'Erie Basin Park/IKEA'}
			{_id:wb++, label:'Brooklyn Bridge Park - Pier 6'}
			{_id:wb++, label:'Conference House Park'}
			{_id:wb++, label:'Bay Ridge Eco-Dock'}
			{_id:wb++, label:'Worlds Fair Marina'}
			{_id:wb++, label:'Richmond County Yacht Club'}
			{_id:wb++, label:'SolarOne/Stuy Cove'}
			{_id:wb++, label:'79th Street Boat Basin'}
			{_id:wb++, label:'Miller\'s Launch'}
			{_id:wb++, label:'Marina 59'}
			{_id:wb++, label:'Princess Bay Marina/Lemon Creek'}
			{_id:wb++, label:'Hudson River Community Sailing'}
			{_id:wb++, label:'Bush Terminal Park'}
			{_id:wb++, label:'Rainey Park'}
			{_id:wb++, label:'Faber Pool and Park'}
			{_id:wb++, label:'Sherman Creek'}
		]

		$scope.changeExpedition = (id)->
			$scope.setCurrentExpeditionByID(id)
			$scope.navigateHome()

	]