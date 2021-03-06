angular.module('app.example').controller 'HomeCtrl', [
	'$scope'
	'$state'
	'bopSectionCompletenessHelper'
	($scope, $state, bopSectionCompletenessHelper) ->
#		$scope.navigateToOverview = ->
#			$state.go('app.expeditionSettings', {expeditionID:$scope.expedition._id})

		#gets aggregate completeness of sections
		$scope.getProtocolCompleteness = (protocol)->
			total = protocol.sections.length
			count = 0
			for section in protocol.sections
				id = $scope.expedition.sections[section.machineName]
				count += bopSectionCompletenessHelper.getSectionCompleteness(id, section.machineName)

			count / total
	]