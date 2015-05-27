angular.module('app.example').controller 'ExpeditionOverviewCtrl', [
	'$scope'
	'$stateParams'
	'$q'
	'$ionicHistory'
	'$timeout'
	'$meteor'
	'bopLocationHelper'
	'$cordovaGeolocation'
	($scope, $stateParams, $q, $ionicHistory, $timeout, $meteor, bopLocationHelper, $cordovaGeolocation) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		$scope.cameFromExpeditions = ->
			return $ionicHistory.backView()?.stateId is 'app.expeditions'

		$scope.expedition = $meteor.object(Expeditions, $stateParams.expeditionID, false);
#		$cordovaGeolocation.getCurrentPosition().then (result)->

		$scope.setLocationUsingGPS = ->
			console.log 'setLocationUsingGPS'
			bopLocationHelper.getGPSPosition()
			.then (position)->
				console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
				$scope.expedition.location = "#{position.coords.latitude},#{position.coords.longitude}"

		$scope.onTapSave = (form) ->
			console.log(form)
			if form.$valid
				console.log('onTapSave for overviewForm', $scope.user.username)
				$scope.expedition.save()
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

		$scope.changeExpedition = ->
			$scope.setCurrentExpeditionID $scope.expedition._id
			$scope.navigateHome()

	]