angular.module('app.example').controller 'SessileOrganismsSelectOrganismsCtrl', [
	'$scope'
	'$controller'
	'$stateParams'
	'$state'
	'$meteor'
	'$ionicHistory'
	($scope, $controller, $stateParams, $state, $meteor, $ionicHistory) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#prepares the organism data for UI.
		$scope.organisms = $meteor.collection ->
			Organisms.find({mobile:true})

		$scope.setDone = (dominance)->
			$scope.saveSection ['settlementTiles']
			$scope.showSaveDone()
			switch dominance
				when 'dominant'
					stateParams =
						protocolNum:$scope.protocolMetadata.num
						sectionMachineName:$scope.section.machineName
						tileIndex:$scope.tileIndex
						cellIndex:$scope.cellIndex

					$state.go('app.sessileOrganismsSelectCoDominant', stateParams)

				when 'co-dominant'
					#back two steps
					$scope.back(-2)

		$scope.saveAndGoBackOneStep = ->
			$scope.saveSection ['settlementTiles']
			$scope.showSaveDone()
			$scope.back()

		#dirty if section data has changed – emulates ngForm.dirty
		$scope.isDirty = ->
			angular.toJson($scope.section) != $scope.sectionBeforeChanged

		#intercepting back button ------- start

		# userTappedBack is broadcast from AppCtrl
		$scope.$on 'bop.userTappedBack', ->
			$scope.setSectionFormState($scope.isDirty(), false, false)

		#user taps save in back button prompt so we submit the form
		$scope.$on 'bop.userChoseSaveAndGoBack', ->
			$scope.saveAndGoBackOneStep()

		#intercepting back button ------- end

		$scope.tileIndex = $stateParams.tileIndex;
		$scope.cellIndex = $stateParams.cellIndex;
		$scope.cell = $scope.section.settlementTiles[$scope.tileIndex].cells[$scope.cellIndex]
		$scope.sectionBeforeChanged = angular.toJson($scope.section)
	]