angular.module('app.example').controller 'AppCtrl', (
													$scope,
													$state,
													$timeout,
													$ionicHistory,
													$ionicNavBarDelegate,
													$ionicSideMenuDelegate,
													) ->

	$scope.authenticated = ->
		Meteor.userId()

	$scope.playlists = [
		{
			title: 'Reggae'
			id: 1
		}
		{
			title: 'Chill'
			id: 2
		}
		{
			title: 'Dubstep'
			id: 3
		}
		{
			title: 'Indie'
			id: 4
		}
		{
			title: 'Rap'
			id: 5
		}
		{
			title: 'Cowbell'
			id: 6
		}
	]

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
		if isAuthenticated
			$state.go('app.home')
			$ionicHistory.clearHistory()
			$timeout ->
				$ionicNavBarDelegate.showBar(true)
		else
			$ionicSideMenuDelegate.toggleLeft(false)
			$state.go('app.auth')
			$ionicHistory.clearHistory()
			$timeout ->
				$ionicNavBarDelegate.showBar(false)

	$scope.navigateOnAuthChange Meteor.userId()

