angular.module('app.example').controller 'ProtocolSectionBaseCtrl', [
	'$scope'
	'$stateParams'
	'$meteor'
	'$ionicHistory'
	($scope, $stateParams, $meteor, $ionicHistory) ->
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

		$scope.back = (steps = -1)->
			$ionicHistory.goBack(steps)

		sectionMachineName = $scope.sectionMeta.machineName
		sectionID = $scope.expedition.sections[sectionMachineName]
		$scope.section = $meteor.object(ProtocolSection, sectionID, false)

		# @param Array. Fields to pass to update function (other fields like _id, owner will be omitted)
		$scope.saveSection = (updateFields)->
			ProtocolSection.update $scope.section._id,
				$set:_.pick($scope.section.getRawObject(), updateFields)
	]