angular.module('app.example').controller 'ExpeditionListCtrl', [
	'$scope'
	'$state'
	'$meteor'
	'$timeout'
	($scope, $state, $meteor, $timeout) ->
#		$scope.expeditions = $meteor.collection(Expeditions).subscribe('Expeditions')
		$scope.expeditions = $meteor.collection(Expeditions)

		#navigation correction in case expeditions were slow to load after login. Note, can't use onReady with Meteor.subscribe because that doesn't work with GroundDB for offline so this is a workaround.
		stopWatching = $scope.$watch 'expeditions.length', (newValue)->
			if newValue > 0
				console.log 'finished loading expedition'
				if !$scope.expedition
					$scope.setCurrentExpeditionByID $scope.expeditions[$scope.expeditions.length - 1]._id
				$scope.navigateHome()
				stopWatching()

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
