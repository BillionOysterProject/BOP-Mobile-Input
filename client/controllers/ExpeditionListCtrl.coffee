angular.module('app.example').controller 'ExpeditionListCtrl', [
	'$scope'
	'$state'
	'$meteor'
	'$timeout'
	($scope, $state, $meteor, $timeout) ->
		if !Meteor.userId()
			location.href = '/'
			return

		$scope.expeditions = $meteor.collection(Expeditions).subscribe('Expeditions')

		#Navigates user to the form for creating a new one
		$scope.createExpedition = ->
			$state.go('app.expeditionCreate', expeditionID:null)

		$scope.deleteExpedition = (expedition)->
			ProtocolSection.remove(sectionID) for sectionMachineName, sectionID of expedition.sections
			Expeditions.remove expedition._id
			$scope.setCurrentExpeditionToLatest()

		#ephemeral. Just used to support highlighting in UI on creation
		$scope.isNew = (expedition)->
			new Date().getTime() - expedition.date.getTime() < 1000

	#	$scope.onTapExpedition = (expedition)->
	#		$scope.prepareForRootViewNavigation()
	#		$state.go('app.expeditionSettings', {expeditionID:expedition._id})
	#		$ionicHistory.clearHistory()
	]
