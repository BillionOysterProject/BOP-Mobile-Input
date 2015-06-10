angular.module('app.example').controller 'ProtocolSectionBaseCtrl', [
	'$scope'
	'$stateParams'
	'$meteor'
	($scope, $stateParams, $meteor) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		$scope.protocolMetadata = $scope.protocolsMetadataMap[$stateParams.protocolNum]

		for sectionMeta, index in $scope.protocolMetadata.sections
			if sectionMeta.machineName is $stateParams.sectionMachineName
				sectionNum = index + 1
				$scope.sectionMeta = sectionMeta
				break

		$scope.title = "Protocol #{$scope.protocolMetadata.num}.#{sectionNum}"

		sectionMachineName = $scope.sectionMeta.machineName
		sectionID = $scope.expedition.sections[sectionMachineName]
		$scope.section = $meteor.object(ProtocolSection, sectionID, false)
#		$scope.section.subscribe(ProtocolSection)
	]