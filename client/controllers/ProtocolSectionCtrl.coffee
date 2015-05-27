angular.module('app.example').controller 'ProtocolSectionCtrl', [
	'$scope'
	'$stateParams'
	'$q'
	'$timeout'
	'$meteor'
	'bopLocationHelper'
	'$cordovaGeolocation'
	($scope, $stateParams, $q, $timeout, $meteor, bopLocationHelper, $cordovaGeolocation) ->
		if !$scope.startupComplete
			location.href = '/'
			return

		console.log 'ProtocolSectionCtrl stateParams: ' + JSON.stringify($stateParams)
		$scope.protocolNum = $stateParams.protocolNum2

		for section, index in $scope.protocolsMap[$scope.protocolNum].sections
			if section.machineName is $stateParams.sectionMachineName
				$scope.sectionNum = index + 1
				$scope.section = section
				break

#		console.log 'stateParams.protocolNum: ' + $stateParams.protocolNum
#		console.log 'stateParams.sectionIndex: ' + $stateParams.sectionIndex

#		$scope.expedition = $meteor.object(Expeditions, $stateParams.expeditionID, false);
#		$cordovaGeolocation.getCurrentPosition().then (result)->

		$scope.onTapSave = (form) ->
			console.log(form)
			if form.$valid
				console.log('onTapSave for form')
#				$scope.expedition.save()
			else
				console.log 'do nothing, form invalid'

	]