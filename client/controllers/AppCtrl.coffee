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
	'localStorageService'
	($scope, $rootScope, $state, $q, $ionicPlatform, $ionicHistory, $ionicNavBarDelegate, $ionicSideMenuDelegate, $meteor, $ionicPopup, $ionicModal, $filter, $interval, $cordovaAppVersion, bopRoutesDynamic, localStorageService) ->
		$scope.$on '$ionicView.beforeEnter', -> #doesn't work without wrapping in beforeEnter handler
			#disable swipe (content fg) to reveal main menu. Disables for all future views (unless they call this again with true)
			$ionicSideMenuDelegate.canDragContent(false)

		$ionicPlatform.ready ->
			#Version number display.
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

		$scope.setSectionFormState = (dirty, invalid, submitted)->
			$scope.sectionFormState = {dirty, invalid, submitted}

		$scope.myGoBack = ->
			$scope.$broadcast 'bop.userTappedBack'

			formState = $scope.sectionFormState

			if formState?.dirty
				if formState.invalid
					$scope.alert('Please check your measurements and try again')
					.then (res) ->
						$scope.$broadcast 'bop.userChoseSaveAndGoBack'
						return
				else
					confirmPopup = $ionicPopup.confirm(
						title: 'Save Changes?'
						template: 'Are you sure you want to abandon your unsaved changes?'
						cancelText: 'Don\'t Save'
						cancelType: 'button-stable'
						okText: 'Save'
						okType: 'button-calm'
					)

					confirmPopup.then (res) ->
						if res
							$scope.$broadcast 'bop.userChoseSaveAndGoBack'

						else
							$ionicHistory.goBack()
						return
			else
				$ionicHistory.goBack()

			$scope.sectionFormState = null

		$scope.alert = (message, title = 'Whoops!')->
			promise = $ionicPopup.alert
				title: title
				template: message
				okType: 'button-calm'
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

		$scope.back = (steps = -1)->
			$ionicHistory.goBack(steps)

		$scope.navigateHome = ->
			if $ionicHistory.currentStateName() isnt 'app.home'
				$scope.prepareForRootViewNavigation()
				$ionicSideMenuDelegate.toggleLeft(false)

				if Expeditions.find().count() > 0
					$state.go('app.home')
				else
					$state.go('app.expeditions')

				$ionicHistory.clearHistory()

		$scope.isLocalDev = ->
			Meteor.absoluteUrl().indexOf(':3000') isnt -1

		$scope.setCurrentExpeditionByID = (id)->
			$scope.expedition = $scope.$meteorObject(Expeditions, id, false);

		$scope.setCurrentExpeditionToLatest = ->
			$scope.expedition = $filter('orderBy')($scope.expeditions, '-date', false)[0]

		$scope.showSaveDone = ->
			toastr.success 'Saved'

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
				titleParts.push Sites.findOne(exp.site)?.label #added ? in case Sites collection not populated yet.
#				site = Sites.findOne(exp.site)
#				try
#					titleParts.push site?.label
#				catch err
#					console.warn 'exp.site: ' + exp.site
#					console.warn 'Sites count(): ' + Sites.find().count()
#					console.warn 'site ', angular.toJson(site)
#					console.error err

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
			'showDuration': 150
			'hideDuration': 750
			'timeOut': 1000
			'extendedTimeOut': 1300
			'showEasing': 'swing'
			'hideEasing': 'linear'
			'showMethod': 'fadeIn'
			'hideMethod': 'fadeOut'

		getUserExpeditions = ->
			$q (resolve, reject)->
				Meteor.subscribe 'Expeditions'

				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				stop = $interval ->
					if Expeditions.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		getMessages = ->
			$q (resolve, reject)->
				Meteor.subscribe 'Messages'

				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				stop = $interval ->
					if Messages.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		getMetaProtocols = ->
			#promise here doesn't guarantee collection is populated just helps kick off the promise chain
			$q (resolve, reject)->
				Meteor.subscribe('MetaProtocols')
				resolve()

		getSites = ->
			$q (resolve, reject)->
				Meteor.subscribe 'Sites'
				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				stop = $interval ->
					if Sites.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		getTideTimes = ->
			$q (resolve, reject)->
				#Get tide tables for the current week
				today = moment()
				endOfWeek = moment().add(6, 'days')
				startDate = today.format("YYYYMMDD")
				endDate = endOfWeek.format("YYYYMMDD")

				#this is the nicer API as it returns JSON, but I could only get it to return tide heights
				#at 6 minute intervals throughout the day, when we really just want each of the high and low tides of each day
				#http://tidesandcurrents.noaa.gov/api/datagetter?begin_date='+startDate+'&end_date='+endDate+'&station=8518750&product=water_level&datum=mllw&units=metric&time_zone=lst&application=web_services&format=json

				#this service returns xml,text, or html but not json so we convert to json using xml2json package
				#https://atmospherejs.com/sergeyt/jquery-xml2json
				Meteor.call "dataFromApi", "http://opendap.co-ops.nos.noaa.gov/axis/webservices/highlowtidepred/response.jsp?stationId=8518750&beginDate="+startDate+"&endDate="+endDate+"&datum=MLLW&unit=1&timeZone=0&format=xml&Submit=Submit", (err, data)->
					if err
						console.error err
						#reject(err)
						localStorageService.set('tides', 'notAvailable')
						console.log 'failed tide lookup'
						resolve()
					else
						jsonTides = $.xml2json(data['content'])
						#console.log jsonTides
						localStorageService.set 'tides', jsonTides['soapenv:Envelope']['soapenv:Body']['HighLowAndMetadata']['HighLowValues']['item']
						resolve(data)

		getProtocolSections = ->
			$q (resolve, reject)->
				Meteor.subscribe 'ProtocolSection'

				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				stop = $interval ->
					if ProtocolSection.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		getMetaWaterQualityIndicators = ->
			$q (resolve, reject)->
				Meteor.subscribe 'MetaWaterQualityIndicators'

				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				stop = $interval ->
					if MetaWaterQualityIndicators.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		getMetaWeatherConditions = ->
			$q (resolve, reject)->
				Meteor.subscribe('MetaWeatherConditions')

				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				stop = $interval ->
					if MetaWeatherConditions.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		getMetaSedimentOptions = ->
			$q (resolve, reject)->
				Meteor.subscribe('MetaSedimentOptions')

				stop = $interval ->
					if MetaSedimentOptions.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		getOrganisms = ->
			$q (resolve, reject)->
				Meteor.subscribe 'Organisms'

				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				stop = $interval ->
					if Organisms.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		#startup sequence for authenticated user
		$scope.startup = ->
			$scope.startupStarted = true

			getMetaProtocols()
			.then getOrganisms
#			.then initOrganisms
			.then getMetaWaterQualityIndicators
			.then getMetaWeatherConditions
			.then getMetaSedimentOptions
			.then getSites
			.then getProtocolSections
			.then getUserExpeditions
			.then getTideTimes
			.then ->
				$scope.metaProtocols = $scope.$meteorCollection(MetaProtocols)
				$scope.protocolsMetadataMap = {}
				($scope.protocolsMetadataMap[protocol.num] = protocol) for protocol in $scope.metaProtocols

				if !$scope.dynamicRoutesDefined
					$scope.dynamicRoutesDefined = true
					bopRoutesDynamic.init()

				#user's expeditions
				$scope.expeditions = $scope.$meteorCollection(Expeditions)
				$scope.setCurrentExpeditionToLatest()

				$scope.startupComplete = true

				if $scope.expeditions.length > 0
					if !$scope.expedition
						$scope.setCurrentExpeditionByID $scope.expeditions[$scope.expeditions.length - 1]._id

			.catch (error)->
				console.error "startup failed. ", error

		#Lobby is the branded view that has the buttons for sign in and create account
		navigateToLobby = ->
			if $ionicHistory.currentStateName() isnt 'auth.lobby'
				$scope.prepareForRootViewNavigation()
				$ionicSideMenuDelegate.toggleLeft(false)
				$state.go('auth.lobby')
				$ionicHistory.clearHistory()

		$scope.logout = ->
			Meteor.logout ->
				navigateToLobby()

		$scope.useTabletLayout = ->
			window.innerWidth >= 768

		#only for logins that occur after user goes through the login view (not for when user is logged in automatically based on cached credentials – i.e. not for when user logs in then reloads page and is still logged in)
		$scope.$on 'bop.onLogin', ->
			$scope.startup()

		$scope.dynamicRoutesDefined = false

		#support for samsungMax and samsungMin directives. I created those to work around the bug where the Samsung keyboard has no decimal point: https://code.google.com/p/chromium/issues/detail?id=151738#c17
		regex = ///(SAMSUNG[- ])?(GT|SM|SGH)-[IGNPST]\d\d\d///
		$scope.isSamsung = regex.test(navigator.userAgent);

		getMessages()
		.then ->
			if Meteor.userId()
				$scope.startup()
	]

