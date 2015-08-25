angular.module('app.example').controller 'WaterQualityIndicatorCtrl', [
	'$scope'
	'$rootScope'
	'$controller'
	'$ionicPlatform'
	'$stateParams'
	'$ionicPopup'
	'$ionicListDelegate'
	'$meteor'
	($scope, $rootScope, $controller, $ionicPlatform, $stateParams, $ionicPopup, $ionicListDelegate, $meteor) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#scope for the add/edit data-sample popup
		$scope.datumPopupScope = $rootScope.$new()

		$scope.datumPopupScope.onCancel = ->
			$ionicPlatform.ready ->
				cordova?.plugins.Keyboard.close()

			$scope.datumPopupScope.popup.close()

		$scope.datumPopupScope.onSubmit = (formValid)->
			if formValid
				switch $scope.datumPopupScope.action
					when 'add'
						$scope.getSamples().push $scope.datumPopupScope.data.popupData
					when 'edit'
						$scope.getSamples()[$scope.datumPopupScope.index] = $scope.datumPopupScope.data.popupData

				$scope.datumPopupScope.data.popupData = null
				delete $scope.datumPopupScope.action
				delete $scope.datumPopupScope.index

				$ionicPlatform.ready ->
					cordova?.plugins.Keyboard.close()
					
				$scope.datumPopupScope.popup.close()

		#popup containing an input field for the data to create/edit
		$scope.createDatumPopup = (action)->
			$scope.datumPopupScope.action = action
			$scope.datumPopupScope.units = $scope.getUnitsForMethod($scope.formIntermediary.method.machineName)

			$scope.datumPopupScope.getMessage = (tplKey)->
				$scope.getMessage(tplKey)

			$scope.datumPopupScope.popup = $ionicPopup.show(
				templateUrl: 'client/views/protocol5/indicatorDatumPopup.ng.html'
				title: 'Enter value for sample'
				subTitle: $scope.formIntermediary.method.label
				scope: $scope.datumPopupScope
				cssClass: 'bopDatumPopup'
			)

			$ionicPlatform.ready ->
				cordova?.plugins.Keyboard.show()

			$scope.datumPopupScope.popup

		$scope.getSamples = ->
			methodKey = $scope.formIntermediary.method.machineName
			$scope.sectionIndicator.methods[methodKey].samples

		$scope.onClickAdd = ->
			$ionicListDelegate.closeOptionButtons()
			$scope.datumPopupScope.data =
				popupData: null
			$scope.createDatumPopup('add')

		$scope.deleteSample = (index)->
			$ionicListDelegate.closeOptionButtons()
			$scope.getSamples().splice(index, 1)

		$scope.editSample = (index)->
			$ionicListDelegate.closeOptionButtons()
			$scope.datumPopupScope.index = index
			$scope.datumPopupScope.data =
				popupData: $scope.getSamples()[index]

			$scope.createDatumPopup('edit')

		$scope.onTapSave = ->
			$ionicListDelegate.closeOptionButtons()

			$scope.sectionIndicator.totalSamples = 0
			for method in $scope.indicator.methods
				sectionIndicatorMethod = $scope.sectionIndicator.methods[method.machineName]

				#remove invalid sample values (NaN) before save
				pruneIndices = []
				for sample, index in sectionIndicatorMethod.samples
					pruneIndices.push(index) if isNaN(sample)
				_.pullAt(sectionIndicatorMethod.samples, pruneIndices)

				$scope.sectionIndicator.totalSamples += sectionIndicatorMethod.samples.length

			$scope.saveSection ['indicators']
			$scope.showSaveDone()
			$scope.back()


		#get reference to current indicator (i.e. Temperature (which has a couple different methods like 'thermometer' and 'Atlas probe')
		$scope.indicator = $meteor.object(MetaWaterQualityIndicators, machineName:$stateParams.indicatorMachineName);

#		#an object to bind certain things to that we don't want directly bound to the meteor model.
#		# We can take what we need from this right before save.
		$scope.formIntermediary =
			method:$scope.indicator.methods[0]
			singleMethod:$scope.indicator.methods.length is 1

		#initialize ------------------------   start
		$scope.section.indicators ?= {}
		$scope.section.indicators[$scope.indicator.machineName] ?=
			methods:null

		#shorthand alias to current indicator data
		$scope.sectionIndicator = $scope.section.indicators[$scope.indicator.machineName]

		$scope.getUnitsForMethod = (methodMachineName)->
			for method in $scope.indicator.methods
				if method.machineName is methodMachineName
					return method.units

		for method in $scope.indicator.methods
			$scope.sectionIndicator.methods ?= {}
			$scope.sectionIndicator.methods[method.machineName] ?=
				samples:[]

			sectionIndicatorMethod = $scope.sectionIndicator.methods[method.machineName]

			if sectionIndicatorMethod.samples.length is 0
				#start user with three blank slots for samples (blank ones will get pruned on save)
				sectionIndicatorMethod.samples = new Array(3)

		#initialize ------------------------   end



]