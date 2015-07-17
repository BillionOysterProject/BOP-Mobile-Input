#note, works like min validator directive. Updates 'min' not 'samsungMin' in ngMessages
angular.module('app.example').directive 'samsungMin', ->
	{
	restrict:'A'
	require:'ngModel'

	link: (scope, element, attrs, modelCtrl) ->
		modelCtrl.$parsers.push (inputValue)->
			if inputValue is undefined or inputValue is NaN
				return ''

			#if it's a string, parse it, if not, assume it's already been parsed and is a valid number
			transformedVal = if typeof inputValue is "string" then inputValue.match(///[-]?([0-9]*\.[0-9]+|[0-9]+)///)?[0] else inputValue
			if transformedVal != inputValue
				modelCtrl.$setViewValue(transformedVal)
				modelCtrl.$render()

				#Note, updates 'min' not 'samsungMin' in ngMessages
				modelCtrl.$setValidity 'min', Number(transformedVal) >= attrs.samsungMin

			Number(transformedVal)

		modelCtrl.$formatters.push (modelValue)->
			return modelValue.toString()

		modelCtrl.$validators.min = (modelValue, viewValue) ->
#			console.log 'modelValue: %s, viewValue: %s', modelValue, viewValue
			Number(modelValue) >= Number(attrs.samsungMin)

		return

	}