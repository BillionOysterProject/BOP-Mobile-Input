angular.module('app.example').controller 'HomeCtrl', ($scope,
                                                      $state,
													) ->
	if !$scope.startupComplete
		location.href = '/'
		return

	$scope.navigateToOverview = ->
		$state.go('app.expeditionOverview', {expeditionID:$scope.expedition._id})