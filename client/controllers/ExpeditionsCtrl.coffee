angular.module('app.example').controller 'ExpeditionsCtrl', [
	'$scope'
	'$state'
	'$meteor'
	'$timeout'
	($scope, $state, $meteor, $timeout) ->
		if !Meteor.userId()
			location.href = '/'
			return

		$scope.expeditions = $meteor.collection(Expeditions).subscribe('Expeditions')

		$scope.createExpedition = ->
			$state.go('app.expeditionOverview', expeditionID:null)

		$scope.deleteExpedition = (expedition)->
			ProtocolSection.remove({_id: sectionID}) for sectionMachineName, sectionID of expedition.sections

			$scope.expeditions.remove expedition
			$scope.setCurrentExpeditionToLatest()

		#ephemeral. Just used to support highlighting in UI on creation
		$scope.isNew = (expedition)->
			new Date().getTime() - expedition.date.getTime() < 1000

	#	$scope.onTapExpedition = (expedition)->
	#		$scope.prepareForRootViewNavigation()
	#		$state.go('app.expeditionOverview', {expeditionID:expedition._id})
	#		$ionicHistory.clearHistory()
	]
