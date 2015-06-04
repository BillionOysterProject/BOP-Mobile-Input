angular.module('app.example').controller 'MobileOrganismsCtrl', [
	'$scope'
	'$controller'
	'$meteor'
	($scope, $controller, $meteor) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				console.log 'TODO save'
#				$scope.section.save().then ->
#					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'

		$scope.organisms = $meteor.collection(MobileOrganisms).subscribe('MobileOrganisms')
	]