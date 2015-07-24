angular.module('app.example').controller 'AuthCtrl', [
	'$scope'
	($scope) ->
		if !$scope.startupStarted
			location.href = '/'
			return

		$scope.user = {}

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

		Accounts.onLoginFailure ->
			$scope.alert('There was a problem logging in, please try again', 'Sorry')

	]