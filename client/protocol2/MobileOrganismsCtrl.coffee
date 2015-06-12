angular.module('app.example').controller 'MobileOrganismsCtrl', [
	'$scope'
	'$controller'
	'$meteor'
	'$ionicModal'
	'$ionicScrollDelegate'
	($scope, $controller, $meteor, $ionicModal, $ionicScrollDelegate) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		$scope.increment = (id)->
			org = $scope.section.organisms[id]
			if !org.count or isNaN(org.count)
				org.count = 0

			org.count++

		$scope.decrement = (id)->
			org = $scope.section.organisms[id]
			if !org.count or isNaN(org.count)
				org.count = 0
				return

			org.count = Math.max(org.count - 1, 0)

		$scope.enforceNumber = (id)->
			org = $scope.section.organisms[id]
			if !org.count or isNaN(org.count)
				org.count = parseInt(org.count) || 0

		$scope.onTapSave = ->
			console.log 'onTapSave'

			#prune to keep db smaller: only keep organisms where count is > 0
			for id, org of $scope.section.organisms
				if !(org.count > 0) #works for null or invalid strings too
					delete $scope.section.organisms[id]

			$scope.section.save().then ->
				console.log 'saved section form to db'

		$scope.organisms = $meteor.collection(MobileOrganisms).subscribe('MobileOrganisms')

		$scope.orgCategories = _.unique((org.category for org in $scope.organisms), true)
		$scope.filters =
			category:undefined

		$scope.categoryMap =
			Crustaceans:"filter-crustaceans.svg"
			Fish:"filter-fish.svg"
			Molluscs:"filter-molluscs.svg"
			Sponges:"filter-sponges.svg"
			Tunicates:"filter-tunicates.svg"
			Worms:"filter-worms.svg"

		$scope.onChangeCategory = (cat)->
			$scope.filters.category = cat
			$ionicScrollDelegate.scrollTop(false)

		#initial values
		$scope.section.organisms ?= {}
		for org in $scope.organisms
			orgID = org._id.toHexString()
			$scope.section.organisms[orgID] ?= {}
#			$scope.section.organisms[orgID].count ?= 0
	]