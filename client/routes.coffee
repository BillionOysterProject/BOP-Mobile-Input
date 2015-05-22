angular.module('app.example').config [
	'$urlRouterProvider'
	'$stateProvider'
	($urlRouterProvider, $stateProvider) ->
		$urlRouterProvider.otherwise '/tabs'
		$stateProvider.state 'tabs',
			url: '/tabs'
			templateUrl: 'index.ng.html'
			controller: 'TodoCtrl'
		return
]