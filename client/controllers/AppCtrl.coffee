angular.module('app.example').controller 'AppCtrl', [
	'$scope'
	'$state'
	'$timeout'
	'$ionicHistory'
	'$ionicNavBarDelegate'
	'$ionicSideMenuDelegate'
	'$meteor'
	'$ionicPopup'
	'$ionicModal'
	'bopStaticData'
	($scope, $state, $timeout, $ionicHistory, $ionicNavBarDelegate, $ionicSideMenuDelegate, $meteor, $ionicPopup, $ionicModal, bopStaticData) ->

		$scope.authenticated = ->
			Meteor.userId()

		$scope.alert = (message, title = 'Whoops!')->
			promise = $ionicPopup.alert
				title: title
				template: message
			return promise

		$scope.showHelp = (protocolNum, sectionMachineName)->
			$ionicModal.fromTemplateUrl("client/views/help/protocol#{protocolNum}/#{sectionMachineName}Help.ng.html",
				scope: $scope
				animation: 'slide-in-up')
			.then (modal) ->
				console.log 'modal made, showing...'
				$scope.helpModal = modal
				$scope.helpModal.show()

		$scope.getProtocolsMetadata = ->
			bopStaticData.protocolsMetadata

		$scope.protocolsMetadataMap = {}
		($scope.protocolsMetadataMap[protocol.num] = protocol) for protocol in $scope.getProtocolsMetadata()

		$scope.hasExpeditions = ->
			Meteor.userId() and Expeditions.find().count() > 0

		$scope.$watch ->
			Meteor.userId()
		, (newValue, oldValue) ->
			if newValue != oldValue
				console.log 'auth watcher, newValue: ' + newValue
				$scope.navigateOnAuthChange(newValue)
			return

		$scope.prepareForRootViewNavigation = ->
			$ionicHistory.nextViewOptions
				disableBack: true #The next view should forget its back view, and set it to null.
				historyRoot: true #The next view should become the root view in its history stack.
				disableAnimate:true

		$scope.navigateOnAuthChange = (isAuthenticated)->
			$scope.prepareForRootViewNavigation()

			$ionicSideMenuDelegate.toggleLeft(false)

			if isAuthenticated
				if $scope.expeditions.length > 0
					if !$scope.expedition
						$scope.setCurrentExpeditionByID $scope.expeditions[$scope.expeditions.length - 1]._id
					$state.go('app.home')
				else
					$state.go('app.expeditions')
				$ionicHistory.clearHistory()
			else
				$state.go('app.auth')
				$ionicHistory.clearHistory()

		$scope.navigateHome = ->
			$scope.prepareForRootViewNavigation()
			$ionicSideMenuDelegate.toggleLeft(false)
			$state.go('app.home')
			$ionicHistory.clearHistory()

		$scope.setCurrentExpeditionByID = (id)->
			$scope.expedition = $meteor.object(Expeditions, id, false);

		$scope.expeditions = $meteor.collection(Expeditions).subscribe('Expeditions')

		$meteor.subscribe('ProtocolSection')
		.then $meteor.subscribe('Expeditions')
		.then ->
			console.log 'expeditions ready. Count: ' + $scope.expeditions.length

			$scope.startupComplete = true
			$scope.navigateOnAuthChange Meteor.userId()
	]
