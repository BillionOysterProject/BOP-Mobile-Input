angular.module('app.example').config [
	'$urlRouterProvider'
	'$stateProvider'
	($urlRouterProvider, $stateProvider) ->
#		$urlRouterProvider.otherwise '/tabs'
#
#		$stateProvider.state 'tabs',
#			url: '/tabs'
#			templateUrl: 'client/todo/views/index.ng.html'
#			controller: 'TodoCtrl'
		$stateProvider.state 'app',
			url: '/app'
			abstract: true
			templateUrl: 'client/todo/views/menu.ng.html'
			controller: 'AppCtrl'
#		.state('app.search',
#			url: '/search'
#			views:
#				'menuContent':
#					templateUrl: 'templates/search.html')
		.state 'app.todos',
			url: '/todos'
			views:
				'menuContent':
					templateUrl: 'client/todo/views/todos.ng.html'
					controller: 'TodoCtrl'
		.state 'app.playlists',
			url: '/playlists'
			views:
				'menuContent':
					templateUrl: 'client/todo/views/playlists.ng.html'
					controller: 'PlaylistsCtrl'
		.state 'app.single',
			url: '/playlists/:playlistId'
			views:
				'menuContent':
					templateUrl: 'client/todo/views/playlist.ng.html'
					controller: 'PlaylistCtrl'
		# if none of the above states are matched, use this as the fallback
		$urlRouterProvider.otherwise '/app/playlists'

		# if none of the above states are matched, use this as the fallback
	#	$urlRouterProvider.otherwise "/home"
#		$urlRouterProvider.otherwise "/"
		return
]


