#TODO cleanup - I don't think I got this to work and decided against it for alignment considerations in UI anyway.

angular.module('app.example').directive 'abcdsuffix', ->
	{
	require: 'ngModel'
	link: (scope, element, attrs, ngModelController) ->
#		ngModelController.$parsers.push (data) ->
#			console.log 'suffix parser data: ', data
#			#convert data from view format to model format
##			output = data
##			if data
#			#strip the suffix
##			if data then data[0...-2] else data

			#converted
#			data or 0

		ngModelController.$formatters.push (data) ->
			console.log 'suffix formatter data: ', data
			#convert data from model format to view format

			#add suffix
#			output = ''
#			if data
#				output = data + 'mm'
#			output

			#converted
			data + 'mm'

		return

	}
