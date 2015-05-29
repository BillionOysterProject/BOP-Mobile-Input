angular.module('app.example').controller 'ExpeditionsCtrl', ($scope,
                                                             $state,
                                                             $meteor,
                                                             $timeout
													) ->
	if !Meteor.userId()
		location.href = '/'
		return

	$scope.expeditions = $meteor.collection(Expeditions).subscribe('Expeditions')

	$scope.createExpedition = ->
		#create protocol section documents ------ start

		cageLocationID = ProtocolSection.insert
			owner: Meteor.userId()
			machineName:'cageLocation'

		depthConditionID = ProtocolSection.insert
			owner: Meteor.userId()
			machineName:'depthCondition'

		oysterGrowthID = ProtocolSection.insert
			owner: Meteor.userId()
			machineName:'oysterGrowth'

		#create protocol section documents ------ end

		#create expedition
		expedition =
			owner: Meteor.userId()
			date: new Date()
			sections:[
				cageLocationID
				depthConditionID
				oysterGrowthID
			]

		$scope.expeditions.save(expedition)

	$scope.deleteExpedition = (expedition)->
		$scope.expeditions.remove expedition

	#ephemeral. Just used to support highlighting in UI on creation
	$scope.isNew = (expedition)->
		new Date().getTime() - expedition.date.getTime() < 1000

#	$scope.onTapExpedition = (expedition)->
#		$scope.prepareForRootViewNavigation()
#		$state.go('app.expeditionOverview', {expeditionID:expedition._id})
#		$ionicHistory.clearHistory()
