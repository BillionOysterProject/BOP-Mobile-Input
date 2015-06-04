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

		$scope.increment = (id)->
			if isNaN($scope.section[id].count)
				$scope.section[id].count = 0

			$scope.section[id].count++

		$scope.decrement = (id)->
			if isNaN($scope.section[id].count)
				$scope.section[id].count = 0
				return

			$scope.section[id].count = Math.max($scope.section[id].count - 1, 0)

		$scope.enforceNumber = (id)->
			if isNaN($scope.section[id].count)
				$scope.section[id].count = parseInt($scope.section[id].count) || 0

		$scope.onTapSave = ->
			console.log 'onTapSave'
			$scope.section.save().then ->
				console.log 'saved section form to db'

		$scope.organisms = $meteor.collection(MobileOrganisms).subscribe('MobileOrganisms')

		#initial values
		for org in $scope.organisms
			orgID = org._id.toHexString()
			$scope.section[orgID] ?= {}
			$scope.section[orgID].count ?= 0
	]