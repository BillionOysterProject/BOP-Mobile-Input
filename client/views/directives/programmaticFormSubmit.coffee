angular.module('app.example').directive 'form', [
	'$parse'
	($parse) ->
		{
		require: 'form'
		restrict: 'E'
		link: (scope, element, attrs, formController) ->
			console.log 'programmatic submit directive called form'
			formController.submitProgrammatically = ->
				formController.$setSubmitted();
				scope.$eval(attrs.ngSubmit);
			return
		}
	]