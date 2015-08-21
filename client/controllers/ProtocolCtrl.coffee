angular.module('app.example').controller 'ProtocolCtrl', [
	'$scope'
	'$stateParams'
	'bopSectionCompletenessHelper'
	($scope, $stateParams, bopSectionCompletenessHelper) ->
		$scope.protocol = $scope.protocolsMetadataMap[$stateParams.protocolNum]

		$scope.getCompleteness = (machineName)->
			id = $scope.expedition.sections[machineName]
			bopSectionCompletenessHelper.getSectionCompleteness(id, machineName)
	]