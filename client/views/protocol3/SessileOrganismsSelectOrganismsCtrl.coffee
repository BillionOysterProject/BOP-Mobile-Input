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
			stateParams =
				protocolNum:$scope.protocolMetadata.num
				sectionMachineName:$scope.section.machineName
				tileIndex:$scope.tileIndex
				cellIndex:$scope.cellIndex

			switch dominance
				when 'dominant'
					if $scope.cell.dominantOrgID is 'none'
						$scope.cell.coDominantOrgID = 'none'
						$state.go('app.sessileOrganismsNotes', stateParams)

					else
						$state.go('app.sessileOrganismsSelectCoDominant', stateParams)

				when 'co-dominant'
					$state.go('app.sessileOrganismsNotes', stateParams)

				when 'notes'
					#back two steps
					switch $ionicHistory.backView().stateName
						when 'app.sessileOrganismsSelectDominant'
							numStepsBack = 2

						when 'app.sessileOrganismsSelectCoDominant'
							numStepsBack = 3

					$scope.back(-numStepsBack)

			$scope.saveSection ['settlementTiles']
			$scope.showSaveDone()
			return

		$scope.saveAndGoBackOneStep = ->
			$scope.saveSection ['settlementTiles']
			$scope.showSaveDone()
			$scope.back()

		initOrgName = ->
			switch $ionicHistory.currentView().stateName
				when 'app.sessileOrganismsSelectDominant'
					$scope.setSelectedOrg('dominant', $scope.cell.dominantOrgID)

				when 'app.sessileOrganismsSelectCoDominant'
					$scope.setSelectedOrg('co-dominant', $scope.cell.coDominantOrgID)

		$scope.setSelectedOrg = (dominance, orgID)->
			#add id to the sessile organisms data
			switch dominance
				when 'dominant'
					$scope.cell.dominantOrgID = orgID

				when 'co-dominant'
					$scope.cell.coDominantOrgID = orgID

			#store the common name too for display purposes
			switch orgID
				when null, 'none', 'other'
					name = null

				else
					name = Organisms.findOne(orgID)?.common

			$scope.selectedOrgName = name

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
		initOrgName()
		$scope.sectionBeforeChanged = angular.toJson($scope.section)

	]