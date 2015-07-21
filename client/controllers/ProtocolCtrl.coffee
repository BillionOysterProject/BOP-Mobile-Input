angular.module('app.example').controller 'ProtocolCtrl', [
	'$scope'
	'$stateParams'
	'bopSectionCompletenessHelper'
	($scope, $stateParams, bopSectionCompletenessHelper) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]

		$scope.getCompleteness = (machineName)->
			id = $scope.expedition.sections[machineName]
			bopSectionCompletenessHelper.getSectionCompleteness(id, machineName)
	]