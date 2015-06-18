angular.module('app.example').controller 'DepthConditionCtrl', [
	'$scope'
	'$controller'
	'bopLocationHelper'
	($scope, $controller, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.section.bioaccumulation ?= 0

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.save().then ->
					console.log 'saved section form to db'
					$scope.showSaveDone()
					$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]