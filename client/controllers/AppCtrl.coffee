angular.module('app.example').controller 'AppCtrl', [
	'$scope'
	'$rootScope'
	'$state'
	'$q'
	'$ionicPlatform'
	'$ionicHistory'
	'$ionicNavBarDelegate'
	'$ionicSideMenuDelegate'
	'$meteor'
	'$ionicPopup'
	'$ionicModal'
	'$filter'
	'$interval'
	'$cordovaAppVersion'
	'bopRoutesDynamic'
	($scope, $rootScope, $state, $q, $ionicPlatform, $ionicHistory, $ionicNavBarDelegate, $ionicSideMenuDelegate, $meteor, $ionicPopup, $ionicModal, $filter, $interval, $cordovaAppVersion, bopRoutesDynamic) ->
		#Version number display.
		$ionicPlatform.ready ->
			$scope.buildNumber =
				#Set native build number in mobile-config.js
				native: '#.#.#' #overridden below when running on a native platform. Shows as this string only when viewed in a browser without native shell.

				# Increment this manually each time a hot push is deployed.
				# Set to zero every time a native build is deployed.
				hotPush: 2;

			if window.cordova
				$cordovaAppVersion.getAppVersion().then (buildNum)->
					$scope.buildNumber.native = buildNum

		$scope.authenticated = ->
			Meteor.userId()

		$scope.setPromptToSave = (prompt)->
			$scope.promptToSave = prompt

		$scope.promptToSave = false

		$scope.myGoBack = ->
			$scope.$broadcast 'bop.userTappedBack'

			if $scope.promptToSave
				$scope.promptToSave = false
				console.log 'about to show popup'
				confirmPopup = $ionicPopup.confirm(
					title: 'Abandon Changes?'
					template: 'Are you sure you want to abandon your unsaved changes?'
					cancelText: 'Keep'
					cancelType: 'button-stable'
					okText: 'Abandon'
					okType: 'button-calm'
				)

				confirmPopup.then (res) ->
					if res
						$ionicHistory.goBack()
					else
						console.log 'Back aborted.'
					return
				return
			else
				$ionicHistory.goBack()

		$scope.alert = (message, title = 'Whoops!')->
			promise = $ionicPopup.alert
				title: title
				template: message
			return promise

		$scope.showHelp = (protocolNum, sectionMachineName)->
			helpScope = $rootScope.$new()
			for protocol in $scope.metaProtocols
				if protocol.num is protocolNum
					for section in protocol.sections
						if section.machineName is sectionMachineName
							helpScope.sectionTitle = section.title
							break

			$ionicModal.fromTemplateUrl("client/views/help/protocol#{protocolNum}/#{sectionMachineName}Help.ng.html",
				scope: helpScope
				animation: 'slide-in-up')
			.then (modal) ->
				helpScope.helpModal = modal
				helpScope.helpModal.show()

		$scope.hasExpeditions = ->
			Meteor.userId() and Expeditions.find().count() > 0

		$scope.prepareForRootViewNavigation = ->
			$ionicHistory.nextViewOptions
				disableBack: true #The next view should forget its back view, and set it to null.
				historyRoot: true #The next view should become the root view in its history stack.
				disableAnimate:true

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

		$scope.getMessage = (tplKey)->
			Messages.findOne({tplKey:tplKey}).tpl

		#gets generated title of expedition (user can also customize an alias of this)
		$scope.getExpeditionTitle = (exp)->
			return '' if !Meteor.user()

			titleParts = []
			titleParts.push "#{Meteor.user().profile.name.first} #{Meteor.user().profile.name.last}"

			if $scope.userHasRole('teacher')
				#TODO replace with actual class name which will be from a (yet to be created) Class.find(id).name where id is $scope.expedition.class
				titleParts.push "Biology 101"

			if exp?
				titleParts.push $filter('date')(exp.date, 'MMM d, yyyy')
				titleParts.push Sites.findOne(exp.site).label

			titleParts.join(" | ")

		$scope.getUserEmail = ->
			Meteor.user()?.emails[0].address

		$scope.getTotalExpeditions = ->
			Expeditions.find().count()

		$scope.userHasRole = (role)->
			Meteor.user().profile.roles.indexOf(role) isnt -1

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

		getUserExpeditions = ->
			$q (resolve, reject)->
#					# using Meteor syntax here because resolved promise for $meteor.subscribe doesn't guarantee that client has actually loaded the records
				Meteor.subscribe 'Expeditions',
					onReady: ->
						resolve()
					onStop: (err)->
						reject(err)

		getOrganisms = ->
			$q (resolve, reject)->
				Meteor.subscribe 'Organisms',
					onReady: ->
						resolve()
					onStop: (err)->
						reject(err)

		getMessages = ->
			$q (resolve, reject)->
				Meteor.subscribe 'Messages',
					onReady: ->
						resolve()
					onStop: (err)->
						reject(err)

		#prepares the organism data for UI. Also supports preloading MobileOrganisms images
		initOrganisms = ->
			$scope.organisms = $meteor.collection( ->
				Organisms.find({mobile:true})
			)
			$scope.organismCategories = _.unique((org.category for org in $scope.organisms), true)

			#TODO might want to move this into the db
			$scope.organismCategoriesFileMap =
				Crustaceans:"filter-crustaceans.svg"
				Fish:"filter-fish.svg"
				Molluscs:"filter-molluscs.svg"
				Sponges:"filter-sponges.svg"
				Tunicates:"filter-tunicates.svg"
				Worms:"filter-worms.svg"

		#startup sequence for authenticated user
		startup = ->
			$meteor.subscribe('MetaProtocols')
			.then getOrganisms
			.then initOrganisms
			.then $meteor.subscribe('Sites')
			.then $meteor.subscribe('ProtocolSection')
			.then getUserExpeditions
			.then ->
				$scope.metaProtocols = $meteor.collection(MetaProtocols)
				$scope.protocolsMetadataMap = {}
				($scope.protocolsMetadataMap[protocol.num] = protocol) for protocol in $scope.metaProtocols

				if !$scope.dynamicRoutesDefined
					$scope.dynamicRoutesDefined = true
					bopRoutesDynamic.init()

				#user's expeditions
				$scope.expeditions = $meteor.collection(Expeditions)
				$scope.setCurrentExpeditionToLatest()

				$scope.startupComplete = true
#				$scope.navigateOnAuthChange Meteor.userId()

				$scope.prepareForRootViewNavigation()
				$ionicSideMenuDelegate.toggleLeft(false)

				if $scope.expeditions.length > 0
					if !$scope.expedition
						$scope.setCurrentExpeditionByID $scope.expeditions[$scope.expeditions.length - 1]._id
					$state.go('app.home')
				else
					$state.go('app.expeditions')

				$ionicHistory.clearHistory()

			.catch (error)->
				console.error "startup failed. ", error

		Accounts.onLogin ->
			$meteor.waitForUser()
			.then (currentUser)->
				startup()

		#Lobby is the branded view that has the buttons for sign in and create account
		navigateToLobby = ->
			$scope.prepareForRootViewNavigation()
			$ionicSideMenuDelegate.toggleLeft(false)
			$state.go('app.lobby')
			$ionicHistory.clearHistory()

		$scope.logout = ->
			Meteor.logout ->
				navigateToLobby()

		$scope.dynamicRoutesDefined = false

		#support for samsungMax and samsungMin directives. I created those to work around the bug where the Samsung keyboard has no decimal point: https://code.google.com/p/chromium/issues/detail?id=151738#c17
		regex = ///(SAMSUNG[- ])?(GT|SM|SGH)-[IGNPST]\d\d\d///
		$scope.isSamsung = regex.test(navigator.userAgent);

		getMessages()
		.then $meteor.waitForUser
		.then (currentUser)->
			$scope.startupStarted = true
			if currentUser
				startup()
			else
				navigateToLobby()

	]

