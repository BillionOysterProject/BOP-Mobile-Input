angular.module('app.example').controller 'HomeCtrl', ($scope) ->
	$scope.authenticated = ->
		Meteor.userId()