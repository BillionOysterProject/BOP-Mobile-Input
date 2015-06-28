angular.module('app.example').controller 'AppCtrl', [
	'$scope'
	'$rootScope'
	'$state'
	'$ionicPlatform'
	'$timeout'
	'$ionicHistory'
	'$ionicNavBarDelegate'
	'$ionicSideMenuDelegate'
	'$meteor'
	'$ionicPopup'
	'$ionicModal'
	'$filter'
	'$cordovaAppVersion'
	'bopRoutesDynamic'
	($scope, $rootScope, $state, $ionicPlatform, $timeout, $ionicHistory, $ionicNavBarDelegate, $ionicSideMenuDelegate, $meteor, $ionicPopup, $ionicModal, $filter, $cordovaAppVersion, bopRoutesDynamic) ->

		#Version number display.
		$ionicPlatform.ready ->
			$scope.buildNumber =
				#Set native build number in mobile-config.js
				native: '#.#.#' #overridden below when running on a native platform. Shows as this string only when viewed in a browser without native shell.

				# Increment this manually each time a hot push is deployed.
				# Set to zero every time a native build is deployed.
				hotPush: 0;

			if window.cordova
				$cordovaAppVersion.getAppVersion().then (buildNum)->
					$scope.buildNumber.native = buildNum

		$scope.authenticated = ->
			Meteor.userId()

		$scope.alert = (message, title = 'Whoops!')->
			promise = $ionicPopup.alert
				title: title
				template: message
			return promise

		#tmp
		$scope.protocolProgress = [
			Math.random()
			Math.random()
			Math.random()
			Math.random()
			Math.random()
		]

		$scope.showHelp = (protocolNum, sectionMachineName)->
			helpScope = $rootScope.$new()
			for protocol in bopStaticData.protocolsMetadata
				if protocol.num is protocolNum
					for section in protocol.sections
						if section.machineName is sectionMachineName
							helpScope.sectionTitle = section.title
							break

			$ionicModal.fromTemplateUrl("client/views/help/protocol#{protocolNum}/#{sectionMachineName}Help.ng.html",
				scope: helpScope
				animation: 'slide-in-up')
			.then (modal) ->
				console.log 'modal made, showing...'
				helpScope.helpModal = modal
				helpScope.helpModal.show()

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

		$scope.setCurrentExpeditionToLatest = ->
			$scope.expedition = $filter('orderBy')($scope.expeditions, '-date', false)[0]

		$scope.showSaveDone = ->
			toastr.success("Saved")

		$scope.expeditions = $meteor.collection(Expeditions).subscribe('Expeditions')

		toastr.options =
			'closeButton': false
			'debug': false
			'newestOnTop': false
			'progressBar': false
			'positionClass': 'toast-bottom-center'
			'preventDuplicates': false
			'onclick': null
			'showDuration': '150'
			'hideDuration': '750'
			'timeOut': '1000'
			'extendedTimeOut': '1300'
			'showEasing': 'swing'
			'hideEasing': 'linear'
			'showMethod': 'fadeIn'
			'hideMethod': 'fadeOut'

		$meteor.subscribe('MobileOrganisms')
		$meteor.subscribe('ProtocolSection')
		.then $meteor.subscribe('Expeditions')
		.then ->
			console.log 'expeditions ready. Count: ' + $scope.expeditions.length

			$scope.startupComplete = true
			$scope.navigateOnAuthChange Meteor.userId()

		.catch (error)->
			console.error "startup failed. ", error
	]
