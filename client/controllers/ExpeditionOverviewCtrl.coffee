angular.module('app.example').controller 'ExpeditionOverviewCtrl', ($scope,
                                                                    $stateParams,
                                                                    $meteor
																	) ->
	if !Meteor.userId()
		location.href = '/'
		return

	$scope.expedition = $meteor.object(Expeditions, $stateParams.expeditionID);

	$scope.data = {}
#	$scope.formFields = [
#		{
#			key: 'title'
#			type: 'input'
#			templateOptions:
#				type: 'text'
#				placeholder: 'Name of site (or water body)'
#		}
#		{
#			key: 'text'
#			type: 'input'
#			templateOptions:
#				type: 'text'
#				placeholder: 'Name of site (or water body)'
#		}
#		{
#			key: 'story'
#			type: 'textarea'
#			templateOptions:
#				placeholder: 'It allows you to build and maintain your forms with the ease of JavaScript :-)'
#		}
#		{
#			key: 'toggle'
#			type: 'toggle'
#			templateOptions:
#				label: 'Remember Me?'
#				toggleClass: 'assertive'
#		}
#		{
#			key: 'slider'
#			type: 'range'
#			templateOptions:
#				label: 'Scale'
#				rangeClass: 'calm'
#				min: '0'
#				max: '100'
#				step: '5'
#				value: '25'
#				minIcon: 'ion-volume-low'
#				maxIcon: 'ion-volume-high'
#		}
#	]

#	$scope.submit = (data)->
#		console.log JSON.stringify(data)

	$scope.changeExpedition = ->
		$scope.setCurrentExpeditionID $scope.expedition._id
		$scope.navigateHome()

