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

		.state 'app.auth',
#			cache:false
			url: '/auth'
			views:
				'menuContent':
					templateUrl: 'client/views/auth.ng.html'
					controller: 'AuthCtrl'

		.state 'app.expeditions',
#			cache:false
			url: '/expeditions'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditions.ng.html'
					controller: 'ExpeditionsCtrl'

		.state 'app.expeditionOverview',
			cache:false
			url: '/expeditionOverview/:expeditionID'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditionOverview.ng.html'
					controller: 'ExpeditionOverviewCtrl'

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
		.state 'app.todos',
			url: '/todos'
			views:
				'menuContent':
					templateUrl: 'client/views/todos.ng.html'
					controller: 'TodoCtrl'

		return
]


