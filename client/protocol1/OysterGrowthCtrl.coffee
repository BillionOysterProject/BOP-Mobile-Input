angular.module('app.example').controller 'OysterGrowthCtrl', [
	'$scope'
	'$controller'
	'bopLocationHelper'
	($scope, $controller, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#init with some basic structure that will be populated via bindings in the template
		$scope.initSection = ->
			#set up initial shells array if empty, to support ng-repeat in the template. Gets populated.
			$scope.section.shells ?= new Array(10)

			$scope.section.totalsMM ?=
				min: null
				max: null
				avg: null

			$scope.section.totalsMortality ?=
				live: null
				dead: null

		$scope.maxSpatSizeMM = 50

		#dummy array to enable ng-repeat for n times (maxed at 12). Array does not get populated.
		$scope.getTotalLiveOystersArr = (index)->
			new Array(Math.min($scope.section.shells[index]?.totals.live or 0, 12))

		$scope.onTapSave = (form)->
			if form.$valid
				console.log 'TODO save sectionForm'
				$scope.section.save().then ->
					console.log 'saved section form to db'
			else
				console.log 'do nothing, sectionForm invalid'

		$scope.initSection()
	]