angular.module('app.example').controller 'SedimentCtrl', [
	'$scope'
	'$controller'
	'$meteor'
	($scope, $controller, $meteor) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		#an object to bind certain things to that we don't want directly bound to the meteor model.
		# We can take what we need from this right before save.
		$scope.formIntermediary = {}

		$scope.sedimentOptions = $scope.$meteorCollection(MetaSedimentOptions)

		#populate sedimentOptions object with all the select options for smells, colors, textures, organisms etc
		if $scope.sedimentOptions?
			for option in $scope.sedimentOptions
				$scope.sedimentOptions[option.machineName] = option


		if $scope.section.smell?
			for option in $scope.sedimentOptions.smells.options
				if $scope.section.smell is option.machineName
					$scope.formIntermediary.smell = option
					break
		if $scope.section.color?
			for option in $scope.sedimentOptions.colors.options
				if $scope.section.color is option.machineName
					$scope.formIntermediary.color = option
					break
		if $scope.section.texture?
			for option in $scope.sedimentOptions.textures.options
				if $scope.section.texture is option.machineName
					$scope.formIntermediary.texture = option
					break

		$scope.formIntermediary.organisms = {}
		$scope.section.organisms ?= []
		for option in $scope.section.organisms
			$scope.formIntermediary.organisms[option] = true


#		if $scope.section.organism?

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				if $scope.formIntermediary.smell?
					$scope.section.smell = $scope.formIntermediary.smell.machineName
				if $scope.formIntermediary.color?
					$scope.section.color = $scope.formIntermediary.color.machineName
				if $scope.formIntermediary.texture?
					$scope.section.texture = $scope.formIntermediary.texture.machineName

				organisms = []
				for organismID, isChecked of $scope.formIntermediary.organisms
					organisms.push(organismID) if isChecked
				$scope.section.organisms = organisms
				if !$scope.formIntermediary.organisms.other
					$scope.section.organismsDescOther = null

				$scope.saveSection ['smell', 'color', 'texture', 'organisms', 'organismsDescOther', 'notes']
				$scope.showSaveDone()
				$scope.back()

			else
				console.log 'do nothing, sectionForm invalid'
	]