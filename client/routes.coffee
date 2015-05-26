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
			url: '/auth'
			views:
				'menuContent':
					templateUrl: 'client/views/auth.ng.html'
					controller: 'AuthCtrl'

		.state 'app.expeditions',
			url: '/expeditions'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditions.ng.html'
					controller: 'ExpeditionsCtrl'

		.state 'app.expeditionOverview',
			url: '/expeditionOverview/:expeditionID'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditionOverview.ng.html'
					controller: 'ExpeditionOverviewCtrl'

		.state 'app.home',
			url: '/home'
			views:
				'menuContent':
					templateUrl: 'client/views/home.ng.html'
					controller: 'HomeCtrl'

		.state 'app.todos',
			url: '/todos'
			views:
				'menuContent':
					templateUrl: 'client/views/todos.ng.html'
					controller: 'TodoCtrl'

		.state 'app.playlists',
			url: '/playlists'
			views:
				'menuContent':
					templateUrl: 'client/views/playlists.ng.html'
					controller: 'PlaylistsCtrl'

		.state 'app.single',
			url: '/playlists/:playlistId'
			views:
				'menuContent':
					templateUrl: 'client/views/playlist.ng.html'
					controller: 'PlaylistCtrl'
		return
]


