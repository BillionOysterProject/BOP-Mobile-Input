angular.module('app.example').controller 'StartupCtrl', [
	'$scope'
	'$timeout'
	'$ionicNavBarDelegate'
	'$ionicSideMenuDelegate'
	($scope, $timeout, $ionicNavBarDelegate, $ionicSideMenuDelegate) ->
		$timeout ->
			$ionicNavBarDelegate.showBar(false)

		#disable swipe (content fg) to reveal main menu. Disables for all future views (unless they call this again with true)
		$ionicSideMenuDelegate.canDragContent(false)
	]