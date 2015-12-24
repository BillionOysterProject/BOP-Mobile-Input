angular.module('app.example').controller 'AuthCtrl', [
	'$scope'
	'$meteor'
	'$ionicHistory'
	'$ionicSideMenuDelegate'
	'$ionicPopup'
	'$state'
	'$q'
	'$interval'
	($scope, $meteor, $ionicHistory, $ionicSideMenuDelegate, $ionicPopup, $state, $q, $interval) ->

		getMessages = ->
			$q (resolve, reject)->
				Meteor.subscribe 'Messages'

				#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
				#TODO update: there's a fix: https://github.com/GroundMeteor/db/pull/141
				stop = $interval ->
					if Messages.find().count() > 0
						$interval.cancel(stop)
						resolve()
				, 100

		$scope.$on '$ionicView.beforeEnter', -> #doesn't work without wrapping in beforeEnter handler
			#disable swipe (content fg) to reveal main menu. Disables for all future views (unless they call this again with true)
			$ionicSideMenuDelegate.canDragContent(false)


		$scope.onTapLogin = (formIsValid)->
			$scope.userAccessFailureMessage = 'There was a problem logging in, please try again.'
			if formIsValid
				#Note, see onLogin in AppCtrl
				Meteor.loginWithPassword $scope.user.email, $scope.user.password

		$scope.onTapCreateAccount = (formIsValid)->
			$scope.userAccessFailureMessage = 'There was a problem creating a new account. If you already have an account, tap back and choose Sign In.'
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

		$scope.getMessage = (tplKey)->
			Messages.findOne({tplKey:tplKey}).tpl

		$scope.alert = (message, title = 'Whoops!')->
			promise = $ionicPopup.alert
				title: title
				template: message
				okType: 'button-calm'
			return promise

		$scope.setFormScope = (authForm)->
			console.log 'AuthCtrl#setFormScope'
			$scope.authFormRef = authForm

		Accounts.onLoginFailure ->
			$scope.alert($scope.userAccessFailureMessage, 'Sorry')

		Accounts.onLogin ->
			$scope.user = {}
			$scope.authFormRef.$setPristine()

			if Expeditions.find().count() > 0
				$state.go('app.home')
			else
				$state.go('app.expeditions')

			$ionicHistory.clearHistory()

		getMessages()
		.then ->
			$scope.user = {}

	]