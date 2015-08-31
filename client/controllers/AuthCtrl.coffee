angular.module('app.example').controller 'AuthCtrl', [
	'$scope'
	'$meteor'
	'$ionicHistory'
	'$ionicSideMenuDelegate'
	'$state'
	($scope, $meteor, $ionicHistory, $ionicSideMenuDelegate, $state) ->
		$scope.user = {}
		Meteor.subscribe 'Messages'

		$scope.$on '$ionicView.beforeEnter', -> #doesn't work without wrapping in beforeEnter handler
			#disable swipe (content fg) to reveal main menu. Disables for all future views (unless they call this again with true)
			$ionicSideMenuDelegate.canDragContent(false)


		$scope.onTapLogin = (formIsValid)->
			if formIsValid
				#Note, see onLogin in AppCtrl
				Meteor.loginWithPassword $scope.user.email, $scope.user.password

		$scope.onTapCreateAccount = (formIsValid)->
			if formIsValid

				# ref: http://docs.meteor.com/#/full/accounts_createuser
				userOptions =
					email: $scope.user.email,       #meteor-reserved key
					password: $scope.user.password  #meteor-reserved key
					profile:                        #meteor-reserved key
						#contents of profile are arbitrary for developer
						roles: [
							'citizenScientist'
						]

						name:$scope.user.name

				Accounts.createUser userOptions

		$scope.alert = (message, title = 'Whoops!')->
			promise = $ionicPopup.alert
				title: title
				template: message
				okType: 'button-calm'
			return promise

		Accounts.onLoginFailure ->
			$scope.alert('There was a problem logging in, please try again', 'Sorry')

		Accounts.onLogin ->
			if Expeditions.find().count() > 0
				$state.go('app.home')
			else
				$state.go('app.expeditions')

			$ionicHistory.clearHistory()

	]