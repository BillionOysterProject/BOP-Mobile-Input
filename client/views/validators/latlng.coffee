# Validator for lat,lng value.
# Ref: http://stackoverflow.com/a/18690202/756177
#
#Matches
#
#+90.0, -127.554334
#45, 180
#-90, -180
#-90.000, -180.0000
#+90, +180
#47.1231231, 179.99999999
#Doesn't Match
#
#-90., -180.
#+90.1, -100.111
#-91, 123.456
#045, 180
angular.module('app.example').directive 'latlng', [
	->
		{
		require: 'ngModel'
		link: (scope, elem, attr, ngModel) ->
			latlngRegex = ///^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$///

			#For DOM -> model validation
			ngModel.$parsers.unshift (value) ->
				if attr.hasOwnProperty('required')
					valid = latlngRegex.test(value)
				else
					valid = if !value? then true else latlngRegex.test(value)

				ngModel.$setValidity 'latlng', valid
				if valid then value else undefined

			#For model -> DOM validation
			ngModel.$formatters.unshift (value) ->
				if attr.hasOwnProperty('required')
					valid = latlngRegex.test(value)
				else
					valid = if !value? then true else latlngRegex.test(value)

				ngModel.$setValidity 'latlng', valid
				value
			return

		}
]