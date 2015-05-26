angular.module('app.example').controller 'ExpeditionsCtrl', ($scope,
                                                             $state,
                                                             $meteorCollection,
                                                             $ionicHistory
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
		$scope.latest = expedition

	$scope.deleteExpedition = (expedition)->
		$scope.expeditions.remove expedition

	$scope.isNew = (expedition)->
		new Date().getTime() - expedition.date.getTime() < 1000

#	$scope.onTapExpedition = (expedition)->
#		$scope.prepareForRootViewNavigation()
#		$state.go('app.expeditionOverview', {expeditionID:expedition._id})
#		$ionicHistory.clearHistory()
