angular.module('app.example').controller 'AppCtrl', (
													$scope,
													$state,
													$timeout,
													$ionicHistory,
													$ionicNavBarDelegate,
													$ionicSideMenuDelegate,
													$meteor,
													$meteorCollection,
													$ionicPopup,
													) ->

	$scope.authenticated = ->
		Meteor.userId()

	$scope.alert = (message, title = 'Whoops!')->
		promise = $ionicPopup.alert
			title: title
			template: message
		return promise

	$scope.protocols = [
		num:1
		title:'Oyster Measurements'
		sections:[
			{machineName: 'cageLocation', title:'Location of oyster cage'}
			{machineName: 'depthCondition', title:'Depth and condition of the oyster cage'}
			{machineName: 'measuring', title:'Measuring oyster growth'}
		]
	,
		num:2
		title:'Mobile Organisms'
		sections:[
			{machineName: 'mobileOrganisms', title:'Mobile organisms observed'}
		]
	,
		num:3
		title:'Sessile Organisms/Settlement plates'
		sections:[
			{machineName: 'sessileObserved', title:'Sessile organisms observed'}
		]
	,
		num:4
		title:'Site conditions'
		sections:[
			{machineName: 'weather', title: 'Meteorological conditions'}
			{machineName: 'rainfall', title: 'Recent rainfall'}
			{machineName: 'tide', title: 'Tide conditions'}
			{machineName: 'water', title: 'Water conditions'}
			{machineName: 'sea', title: 'State of the sea (degree)'}
			{machineName: 'land', title: 'Land conditions'}
		]
	,
		num:5
		title:'Water Quality'
		sections:[
			{machineName: 'waterQuality', title:'Water quality measurements'}
			{machineName: 'sediment', title:'Sedimentation'}
		]
	]

	$scope.protocolsMap = {}
	($scope.protocolsMap[protocol.num] = protocol) for protocol in $scope.protocols

	$scope.hasExpeditions = ->
		Meteor.userId() and Expeditions.find().count() > 0

	$scope.$watch ->
		Meteor.userId()
	, (newValue, oldValue) ->
		if newValue != oldValue
			console.log 'auth watcher, newValue: ' + newValue
			$scope.navigateOnAuthChange(newValue)
		return

	$scope.prepareForRootViewNavigation = ->
		$ionicHistory.nextViewOptions
			disableBack: true #The next view should forget its back view, and set it to null.
			historyRoot: true #The next view should become the root view in its history stack.
			disableAnimate:true

	$scope.navigateOnAuthChange = (isAuthenticated)->
		$scope.prepareForRootViewNavigation()

		$ionicSideMenuDelegate.toggleLeft(false)

		if isAuthenticated
			if $scope.expeditions.length > 0
				$state.go('app.home')
			else
				$state.go('app.expeditions')
			$ionicHistory.clearHistory()
		else
			$state.go('app.auth')
			$ionicHistory.clearHistory()

	$scope.navigateHome = ->
		$scope.prepareForRootViewNavigation()
		$ionicSideMenuDelegate.toggleLeft(false)
		$state.go('app.home')
		$ionicHistory.clearHistory()

	$scope.setCurrentExpeditionID = (id)->
		$scope.currentExpeditionID = id

	$scope.expeditions = $meteorCollection(Expeditions).subscribe('Expeditions')

	$meteor.subscribe('Expeditions').then ->
		console.log 'expeditions ready. Count: ' + $scope.expeditions.length

		$scope.startupComplete = true
		$scope.navigateOnAuthChange Meteor.userId()

