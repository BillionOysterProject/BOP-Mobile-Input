angular.module('app.example').controller 'WaterQualityIndicatorCtrl', [
	'$scope'
	'$rootScope'
	'$controller'
	'$stateParams'
	'$ionicPopup'
	'$ionicListDelegate'
	'bopStaticData'
	($scope, $rootScope, $controller, $stateParams, $ionicPopup, $ionicListDelegate, bopStaticData) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.getSamples = ->
			$scope.formIntermediary.samples[$scope.formIntermediary.method.machineName]

		$scope.onClickAdd = ->
			$ionicListDelegate.closeOptionButtons()
			# An elaborate, custom popup
			myPopup = $ionicPopup.show(
				template: '<input type="number" ng-model="formIntermediary.popupData">'
				title: 'Enter value for sample'
				subTitle: $scope.formIntermediary.method.label
				scope: $scope
				buttons: [
					{text: 'Cancel'}
					{
						text: '<b>Save</b>'
						type: 'button-positive'
						onTap: (e) ->
							console.log isNaN($scope.formIntermediary.popupData)
							if isNaN($scope.formIntermediary.popupData)
								#don't allow the user to close unless he enters wifi password
								e.preventDefault()
							else
								return $scope.formIntermediary.popupData
							return

					}
				])
			myPopup.then (datum) ->
				if datum
					console.log 'Tapped!', datum
					$scope.getSamples().push datum
					$scope.formIntermediary.popupData = null
				return

		$scope.indicators = bopStaticData.waterQualitySectionIndicators

		for indicator in $scope.indicators
			if indicator.machineName is $stateParams.indicatorMachineName
				$scope.indicator = indicator
				break

#		#an object to bind certain things to that we don't want directly bound to the meteor model.
#		# We can take what we need from this right before save.
		$scope.formIntermediary =
			method:$scope.indicator.methods[0]
			singleMethod:$scope.indicator.methods.length is 1
			samples:{} #keys are method machineName, values are measurement datum


		$scope.section.indicators ?= {}
		#initialize
		$scope.section.indicators[$scope.indicator.machineName] ?=
			units:$scope.indicator.units
			samples:null

		#shorthand alias
		sectionIndicator = $scope.section.indicators[$scope.indicator.machineName]

		for method in $scope.indicator.methods
			$scope.formIntermediary.samples[method.machineName] = new Array(3)

		$scope.deleteSample = (index)->
			$ionicListDelegate.closeOptionButtons()
			$scope.getSamples().splice(index, 1)

		$scope.editSample = (index)->
			console.log 'edit index ' + index
			$ionicListDelegate.closeOptionButtons()
			$scope.formIntermediary.popupData = $scope.getSamples()[index]

			# An elaborate, custom popup
			myPopup = $ionicPopup.show(
				template: '<input type="number" ng-model="formIntermediary.popupData" autofocus>'
				title: 'Set value for sample'
				subTitle: $scope.formIntermediary.method.label
				scope: $scope
				buttons: [
					{text: 'Cancel'}
					{
						text: '<b>Save</b>'
						type: 'button-positive'
						onTap: (e) ->
							console.log isNaN($scope.formIntermediary.popupData)
							if isNaN($scope.formIntermediary.popupData)
								#don't allow the user to close unless he enters wifi password
								e.preventDefault()
							else
								return $scope.formIntermediary.popupData
							return

					}
				])
			myPopup.then (datum) ->
				if datum
					console.log 'Tapped!', datum
					$scope.getSamples()[index] = $scope.formIntermediary.popupData
					$scope.formIntermediary.popupData = null
				return

		$scope.onTapSave = (formIsValid)->
			$ionicListDelegate.closeOptionButtons()
			if formIsValid
				$scope.section.save().then ->
					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'
	]