#
# For additional routes which are dependent on some metadata being loaded from DB.
# config-time dependencies can be injected here at .provider() declaration
#
# @see routes.coffee For routes that are known before startup time
# ref: http://stackoverflow.com/a/25872852/756177
#
angular.module('app.example').provider 'bopRoutesDynamic', ($stateProvider) ->

	# runtime dependencies for the service can be injected here, at the provider.$get() function.
	@$get = ($meteor) ->
		return {
			init: ->
				protocolsMetadata = $meteor.collection(MetaProtocols).subscribe('MetaProtocols')

				#dynamically create all the protocol section states.
				for protocolMetadata in protocolsMetadata
					for section in protocolMetadata.sections
						$stateProvider.state 'app.' + section.machineName,
							cache: false
							#shorthand default values
							params:
								protocolNum: undefined
								sectionMachineName: undefined

							views:
								'menuContent':
									templateUrl: "client/protocol#{protocolMetadata.num}/#{section.machineName}.ng.html"
									controller: _.capitalize(section.machineName) + 'Ctrl'

				#special case: create route for protocol 5's waterQuality indicator subsection
				$stateProvider.state 'app.waterQualityIndicator',
					cache: false
					#shorthand default values
					params:
						protocolNum: undefined
						sectionMachineName: undefined
						indicatorMachineName: undefined

					views:
						'menuContent':
							templateUrl: "client/protocol5/waterQualityIndicator.ng.html"
							controller: 'WaterQualityIndicatorCtrl'
		}

	return