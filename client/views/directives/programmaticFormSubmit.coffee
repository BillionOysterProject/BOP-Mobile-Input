angular.module('app.example').directive 'form', ($parse) ->
	{
	require: 'form'
	restrict: 'E'
	link: (scope, element, attrs, formController) ->
		formController.submitProgrammatically = ->
			formController.$setSubmitted();
			scope.$eval(attrs.ngSubmit);
		return
	}