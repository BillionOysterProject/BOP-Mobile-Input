angular.module('app.example').controller 'HomeCtrl', ($scope,
                                                      $state,
                                                      $meteor,
                                                      $meteorCollection
													) ->
	if !Meteor.userId()
		location.href = '/'
		return

	if $scope.currentExpeditionID
		$scope.expedition = $meteor.object(Expeditions, $scope.currentExpeditionID);
	else
		$scope.expeditions = $meteorCollection(Expeditions).subscribe('Expeditions')
		$scope.expedition = $scope.expeditions[$scope.expeditions.length - 1]

	$scope.navigateToOverview = ->
		console.log 'navigateToOverview() ' + $scope.currentExpeditionID
		$state.go('app.expeditionOverview', {expeditionID:$scope.currentExpeditionID or $scope.expedition._id})