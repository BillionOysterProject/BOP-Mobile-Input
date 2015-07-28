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

		$stateProvider.state 'app',
#			url: '/app'
			abstract: true
			templateUrl: 'client/views/menu.ng.html'
			controller: 'AppCtrl'

		.state 'app.startup',
			url: '/'
			views:
				'menuContent':
					templateUrl: 'client/views/startup.ng.html'
					controller: 'StartupCtrl'

		.state 'app.login',
#			cache:false
			url: '/login'
			views:
				'menuContent':
					templateUrl: 'client/views/auth/login.ng.html'
					controller: 'AuthCtrl'

		.state 'app.lobby',
#			cache:false
			url: '/lobby'
			views:
				'menuContent':
					templateUrl: 'client/views/auth/lobby.ng.html'
#					controller: 'AuthCtrl'

		.state 'app.createAccount',
#			cache:false
			url: '/createAccount'
			views:
				'menuContent':
					templateUrl: 'client/views/auth/createAccount.ng.html'
					controller: 'AuthCtrl'

		.state 'app.expeditions',
#			cache:false
			url: '/expeditions'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditionList.ng.html'
					controller: 'ExpeditionListCtrl'

		.state 'app.expeditionSettings',
			cache:false
			url: '/expeditionSettings/:expeditionID'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditionSettings.ng.html'
					controller: 'ExpeditionCtrl'

		.state 'app.expeditionCreate',
			cache:false
			url: '/expeditionCreate'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditionCreate.ng.html'
					controller: 'ExpeditionCtrl'

		.state 'app.home',
			cache:false
			url: '/home'
			views:
				'menuContent':
					templateUrl: 'client/views/home.ng.html'
					controller: 'HomeCtrl'

		.state 'app.protocol',
			cache:false
#			url: '/protocol/:protocolNum'
			#shorthand default values
			params:
		        protocolNum: 1
#		        param2: "param2Default"
			views:
				'menuContent':
					templateUrl: 'client/views/protocol.ng.html'
					controller: 'ProtocolCtrl'

		#TODO deprecated, was part of getting started
#		.state 'app.todos',
#			url: '/todos'
#			views:
#				'menuContent':
#					templateUrl: 'client/views/todos.ng.html'
#					controller: 'TodoCtrl'

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


