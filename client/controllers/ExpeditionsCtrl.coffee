angular.module('app.example').controller 'ExpeditionsCtrl', ($scope,
                                                             $state,
                                                             $meteorCollection
													) ->
	if !Meteor.userId()
		location.href = '/'
		return
	$scope.expeditions = $meteorCollection(Expeditions).subscribe('Expeditions')

	$scope.createExpedition = ->
		expedition =
			owner: Meteor.userId()
			date: new Date()
			title: 'Untitled expedition'

		$scope.expeditions.save expedition

	$scope.deleteExpedition = (expedition)->
		$scope.expeditions.remove expedition

#	$scope.onTapExpedition = (expedition)->
#		$scope.prepareForRootViewNavigation()
#		$state.go('app.expeditionOverview', {expeditionID:expedition._id})
#		$ionicHistory.clearHistory()
