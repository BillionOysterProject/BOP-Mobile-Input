angular.module('app.example').controller 'ProtocolSectionBaseCtrl', [
	'$scope'
	'$stateParams'
	'$q'
	'$timeout'
	'$meteor'
	'bopLocationHelper'
	($scope, $stateParams, $q, $timeout, $meteor, bopLocationHelper) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		$scope.protocol = $scope.protocolsMap[$stateParams.protocolNum]

		for section, index in $scope.protocol.sections
			if section.machineName is $stateParams.sectionMachineName
				console.log 'parsed'
				sectionNum = index + 1
				$scope.section = section
				break

		$scope.title = "Protocol #{$scope.protocol.num}.#{sectionNum}"
	]