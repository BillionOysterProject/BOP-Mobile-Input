#Here's how you'd use it in your markup:
#
# <select ng-model="foo" ng-options="x.name for x in items"
#   options-class="{ 'is-eligible' : eligible, 'not-eligible': !eligible }"></select>
#
# It works like ng-class does, with the exception that it's on a per-item-in-the-collection basis.
# ref: http://stackoverflow.com/a/15278483/756177
#
angular.module('app.example').directive 'optionsClass', ($parse) ->
	{
	require: 'select'
	link: (scope, elem, attrs, ngSelect) ->
		# get the source for the items array that populates the select.
		optionsSourceStr = attrs.ngOptions.split(' ').pop()
		getOptionsClass = $parse(attrs.optionsClass)
		scope.$watch optionsSourceStr, (items) ->
			# when the options source changes loop through its items.
			angular.forEach items, (item, index) ->
				# evaluate against the item to get a mapping object for
				# for your classes.
				classes = getOptionsClass(item)
				option = elem.find('option[value=' + index + ']')
				# now loop through the key/value pairs in the mapping object
				# and apply the classes that evaluated to be truthy.
				angular.forEach classes, (add, className) ->
					if add
						angular.element(option).addClass className
					return
				return
			return
		return

	}