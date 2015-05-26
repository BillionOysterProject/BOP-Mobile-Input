angular.module('app.example').config [
	'$urlRouterProvider'
	'$stateProvider'
	($urlRouterProvider, $stateProvider) ->
		# if none of the below states are matched, use this as the fallback
		$urlRouterProvider.otherwise '/app/home'

		$stateProvider.state 'app',
			url: '/app'
			abstract: true
			templateUrl: 'client/views/menu.ng.html'
			controller: 'AppCtrl'

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


