onReady = ->
	angular.bootstrap document, [ 'app.example' ]
	return

angular.module('app.example', [
	'angular-meteor'
	'ui.router'
	'ionic'
	'ngCordova.plugins.datePicker'
	'formlyIonic'
])
if Meteor.isCordova
	angular.element(document).on 'deviceready', onReady
else
	angular.element(document).ready onReady