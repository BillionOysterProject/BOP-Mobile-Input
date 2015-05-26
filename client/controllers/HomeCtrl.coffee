angular.module('app.example').controller 'HomeCtrl', ($scope
													) ->
	if !Meteor.userId()
		location.href = '/'
		return