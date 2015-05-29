angular.module('app.example').controller 'ProtocolSectionBaseCtrl', [
	'$scope'
	'$stateParams'
	'$meteor'
	'$q'
	'$timeout'
	'bopLocationHelper'
	($scope, $stateParams, $meteor, $q, $timeout, bopLocationHelper) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		$scope.protocol = $scope.protocolsMap[$stateParams.protocolNum]

		for sectionMeta, index in $scope.protocol.sections
			if sectionMeta.machineName is $stateParams.sectionMachineName
				sectionNum = index + 1
				$scope.sectionMeta = sectionMeta
				break

		$scope.title = "Protocol #{$scope.protocol.num}.#{sectionNum}"
		$scope.section = $meteor.object(ProtocolSection, {machineName:$scope.sectionMeta.machineName}, false)
	]