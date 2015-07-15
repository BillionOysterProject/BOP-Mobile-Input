angular.module('app.example').directive 'samsungMax', ->
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

				modelCtrl.$setValidity 'max', Number(transformedVal) <= attrs.samsungMax

			Number(transformedVal)

		modelCtrl.$formatters.push (modelValue)->
			return modelValue.toString()

		modelCtrl.$validators.max = (modelValue, viewValue) ->
			Number(modelValue) <= Number(attrs.samsungMax)

		return

	}