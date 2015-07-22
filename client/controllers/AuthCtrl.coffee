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
				Accounts.createUser {email: $scope.user.email, password: $scope.user.password}

				#Note, see onLogin in AppCtrl
				Meteor.loginWithPassword $scope.user.email, $scope.user.password

		Accounts.onLoginFailure ->
			$scope.alert('There was a problem logging in, please try again', 'Sorry')

	]