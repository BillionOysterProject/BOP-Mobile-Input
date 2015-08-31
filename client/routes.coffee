#
# For routes that are known before startup time
#
# @see bopRoutesDynamic.coffee for additional routes which are dependent on some metadata being loaded from DB
#
angular.module('app.example').config [
	'$urlRouterProvider'
	'$stateProvider'
	($urlRouterProvider, $stateProvider) ->
		# if none of the below states are matched, use this as the fallback
		$urlRouterProvider.otherwise '/'

		$stateProvider.state 'auth',
			url:'^'
			abstract: true
			views:
				'default':
					templateUrl: 'client/views/menu.ng.html'
					controller: 'AuthCtrl'

		.state 'app.uploadTest',
			cache:false
			url: '/uploadTest'
			views:
				'menuContent':
					templateUrl: 'client/views/uploadTest.ng.html'
					controller: 'UploadTestCtrl'

		.state 'auth.lobby',
#			cache:false
			url: '/'
			data:
				loginRequired:false

			views:
				'menuContent':
					templateUrl: 'client/views/auth/lobby.ng.html'

			resolve:
				authorize: ["$meteor", "$state", "$ionicHistory", "$ionicSideMenuDelegate", "$timeout", ($meteor, $state, $ionicHistory, $ionicSideMenuDelegate, $timeout)->
					$timeout(1) #without this, when offline '$meteor.waitForUser()' doesn't resolve
					.then $meteor.waitForUser()
					.then ->
#						console.log 'Meteor.user(): ' + Meteor.user()
#						console.log 'Meteor.userId(): ' + Meteor.userId()
						if Meteor.userId()
							if Expeditions.find().count() > 0
#								$state.go('app.home')
								$state.go('app.uploadTest')
							else
								$state.go('app.expeditions')

							$ionicHistory.clearHistory()

				]

		.state 'auth.login',
			data:
				loginRequired:false

			views:
				'menuContent':
					templateUrl: 'client/views/auth/login.ng.html'

		.state 'auth.createAccount',
			data:
				loginRequired:false

			views:
				'menuContent':
					templateUrl: 'client/views/auth/createAccount.ng.html'

		$stateProvider.state 'app',
			url:'^'
			abstract: true
			views:
				'default':
					templateUrl: 'client/views/menu.ng.html'
					controller: 'AppCtrl'

		.state 'app.expeditions',
#			cache:false
			views:
				'menuContent':
					templateUrl: 'client/views/expeditionList.ng.html'
					controller: 'ExpeditionListCtrl'

		.state 'app.expeditionSettings',
			cache:false

			#shorthand default values
			params:
				expeditionID: undefined

			views:
				'menuContent':
					templateUrl: 'client/views/expeditionSettings.ng.html'
					controller: 'ExpeditionCtrl'

		.state 'app.expeditionCreate',
			cache:false

			#shorthand default values
			params:
				expeditionID: undefined

			views:
				'menuContent':
					templateUrl: 'client/views/expeditionCreate.ng.html'
					controller: 'ExpeditionCtrl'

		.state 'app.home',
			cache:false
			views:
				'menuContent':
					templateUrl: 'client/views/home.ng.html'
					controller: 'HomeCtrl'

		.state 'app.protocol',
			cache:false

			#shorthand default values
			params:
		        protocolNum: 1

			views:
				'menuContent':
					templateUrl: 'client/views/protocol.ng.html'
					controller: 'ProtocolCtrl'

		#subsection for oyster growth (an individual substrate shell) (note, app.oysterGrowth is defined in bopRoutesDynamic.coffee and is a list of the 10 substrate shells)
		.state 'app.oysterGrowthShell',
			cache: false

			#shorthand default values
			params:
				protocolNum: undefined
				sectionMachineName: undefined
				shellIndex: undefined

			views:
				'menuContent':
					templateUrl: "client/views/protocol1/oysterGrowthShell.ng.html"
					controller: 'OysterGrowthShellCtrl'

		#subsection for protocol 5's waterQuality indicator
		.state 'app.waterQualityIndicator',
			cache: false

			#shorthand default values
			params:
				protocolNum: undefined
				sectionMachineName: undefined
				indicatorMachineName: undefined

			views:
				'menuContent':
					templateUrl: "client/views/protocol5/waterQualityIndicator.ng.html"
					controller: 'WaterQualityIndicatorCtrl'

		#see bopRoutesDynamic.coffee for additional routes which are dependent on some metadata being loaded from DB
		return
]

angular.module('app.example').run [
	'$rootScope'
	($rootScope) ->

#		$rootScope.$on '$stateChangeStart', (event, to, toParams, from, fromParams) ->
#			console.log ''
#			console.log '~~~~~~~~~~~~~'
#			console.log '~~~~~~$stateChangeStart %s -> %s', from.name, to.name

]