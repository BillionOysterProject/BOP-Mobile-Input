angular.module('app.example').factory "bopRoutesDynamic", [
	"$stateProvider"
	"$meteor"
	($stateProvider, $meteor)->
		class RoutesDynamic
			init: ->
				protocolsMetadata = $meteor.collection(MetaProtocols).subscribe('MetaProtocols')
		#		protocolsMetadata = MetaProtocols.find()

					#dynamically create all the protocol section states.
				for protocolMetadata in protocolsMetadata
					for section in protocolMetadata.sections
						$stateProvider.state 'app.' + section.machineName,
							cache: false
				#			url: '/protocol/:protocolNum'
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
		#			url: '/protocol/:protocolNum'
					#shorthand default values
					params:
						protocolNum: undefined
						sectionMachineName: undefined
						indicatorMachineName: undefined

					views:
						'menuContent':
							templateUrl: "client/protocol5/waterQualityIndicator.ng.html"
							controller: 'WaterQualityIndicatorCtrl'

		bopRoutesDynamic = new RoutesDynamic()

		return bopRoutesDynamic
]


