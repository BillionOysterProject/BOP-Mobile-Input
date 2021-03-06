angular.module('app.example').controller 'MobileOrganismsCtrl', [
	'$scope'
	'$controller'
	'$meteor'
	'$ionicModal'
	'$ionicScrollDelegate'
	($scope, $controller, $meteor, $ionicModal, $ionicScrollDelegate) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#prepares the organism data for UI.
		$scope.organisms = $scope.$meteorCollection ->
			Organisms.find({mobile:true})

		#organismCategories = _.unique((org.category for org in $scope.organisms), true)
		#TODO Figure out why I am needing to run _.unique twice!
		#$scope.organismCategories = _.unique(organismCategories)

		#Decided to manually set up this array because we needed to define the order
		#and it didn't seem worth adding another DB collection to handle defining the order
		#Will revisit later if needed
		$scope.organismCategories = ['fish', 'crustaceans', 'molluscs', 'worms', 'sponges', 'tunicates', 'cnidarians', 'bryozoans']

		#svg files for filter icons need to be named as filter-category-organism.svg
		$scope.organismCategoriesFileName = (cat)->
			'/images/protocol3/mobileOrganisms/filterIcons/filter-' + cat.toLowerCase().replace(' ', '-') + '.svg'

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
			return 0 if !$scope.section.organisms.hasOwnProperty(id)

			org = $scope.section.organisms[id]
			if org.cont isnt undefined
				if isNaN(org.count)
					org.count = parseInt(org?.count) || 0

		$scope.onTapSave = ->
			#prune to keep db smaller: only keep organisms where count is > 0
			for id, org of $scope.section.organisms
				if !(org.count > 0) #works for null or invalid strings too
					delete $scope.section.organisms[id]

			$scope.saveSection(['organisms'])
			$scope.showSaveDone()
			$scope.back()

		$scope.filters =
			category:undefined

		$scope.onChangeCategory = (cat)->
			$scope.filters.category = cat
			$ionicScrollDelegate.scrollTop(false)

		#dirty if section data has changed – emulates ngForm.dirty
		$scope.isDirty = ->
			angular.toJson($scope.section) != $scope.sectionBeforeChanged

		#intercepting back button ------- start

		# userTappedBack is broadcast from AppCtrl
		$scope.$on 'bop.userTappedBack', ->
			$scope.setSectionFormState($scope.isDirty(), false, false)

		#user taps save in back button prompt so we submit the form
		$scope.$on 'bop.userChoseSaveAndGoBack', ->
			$scope.onTapSave()
		#intercepting back button ------- end

		#initial values
		$scope.section.organisms ?= {}
		for org in $scope.organisms
			orgID = org._id
			$scope.section.organisms[orgID] ?= {}
#			$scope.section.organisms[orgID].count ?= 0

		$scope.sectionBeforeChanged = angular.toJson($scope.section)

	]