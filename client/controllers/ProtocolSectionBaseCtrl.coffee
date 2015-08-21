angular.module('app.example').controller 'ProtocolSectionBaseCtrl', [
	'$scope'
	'$stateParams'
	'$meteor'
	'$ionicHistory'
	($scope, $stateParams, $meteor, $ionicHistory) ->
		$scope.protocolMetadata = $scope.protocolsMetadataMap[$stateParams.protocolNum]

		for sectionMeta, index in $scope.protocolMetadata.sections
			if sectionMeta.machineName is $stateParams.sectionMachineName
				sectionNum = index + 1
				$scope.sectionMeta = sectionMeta
				break

		$scope.back = (steps = -1)->
			$ionicHistory.goBack(steps)

		# @param Array. Fields to pass to update function (other fields like _id, owner will be omitted)
		$scope.saveSection = (updateFields)->
			ProtocolSection.update $scope.section._id,
				$set:_.pick($scope.section.getRawObject(), updateFields)


		#intercepting back button ------- start

		#   This is a hack that lets controller have access to the form so we can check if it's dirty before letting user go back (prevent losing unsaved changes)
		#   http://stackoverflow.com/a/22965461/756177
		#
		#   Note, relies on this being first child of form element in template:
		#       <div ng-init="setFormScope(sectionForm)"></div>
		#
		# @see AppCtrl#myGoBack

		$scope.setFormScope = (sectionForm)->
			console.log 'setFormScope'
			$scope.sectionFormRef = sectionForm

		# userTappedBack is broadcast from AppCtrl
		$scope.$on 'bop.userTappedBack', ->
			# Check if section form exists to ensure we're going back from a section that
			# has a sectionForm form otherwise ignore. Avoids this functionality running
			# on sections like Oyster Measurement (aka oysterGrowth) where there's an index screen and
			# the form is actually one level deeper (but they share this controller)
			if $scope.sectionFormRef?
				$scope.setSectionFormState($scope.sectionFormRef.$dirty, $scope.sectionFormRef.$invalid, $scope.sectionFormRef.$submitted)

		#user taps save in back button prompt so we submit the form
		$scope.$on 'bop.userChoseSaveAndGoBack', ->
#			if $scope.sectionFormRef?
			$scope.sectionFormRef.submitProgrammatically()
		#intercepting back button ------- end

		$scope.sectionFormRef = null

		$scope.title = "Protocol #{$scope.protocolMetadata.num}.#{sectionNum}"

		sectionMachineName = $scope.sectionMeta.machineName
		sectionID = $scope.expedition.sections[sectionMachineName]
		$scope.section = $meteor.object(ProtocolSection, sectionID, false)

	]