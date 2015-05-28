angular.module('app.example').constant "bopStaticData", {
	protocols: [
		num: 1
		title: 'Oyster Measurements'
		sections: [
			{machineName: 'cageLocation', title: 'Location of oyster cage'}
			{machineName: 'depthCondition', title: 'Depth and condition of the oyster cage'}
			{machineName: 'measuring', title: 'Measuring oyster growth'}
		]
	,
		num: 2
		title: 'Mobile Organisms'
		sections: [
			{machineName: 'mobileOrganisms', title: 'Mobile organisms observed'}
		]
	,
		num: 3
		title: 'Sessile Organisms/Settlement plates'
		sections: [
			{machineName: 'sessileObserved', title: 'Sessile organisms observed'}
		]
	,
		num: 4
		title: 'Site conditions'
		sections: [
			{machineName: 'weather', title: 'Meteorological conditions'}
			{machineName: 'rainfall', title: 'Recent rainfall'}
			{machineName: 'tide', title: 'Tide conditions'}
			{machineName: 'water', title: 'Water conditions'}
			{machineName: 'sea', title: 'State of the sea (degree)'}
			{machineName: 'land', title: 'Land conditions'}
		]
	,
		num: 5
		title: 'Water Quality'
		sections: [
			{machineName: 'waterQuality', title: 'Water quality measurements'}
			{machineName: 'sediment', title: 'Sedimentation'}
		]
	]
}

angular.module('app.example').config [
	'$urlRouterProvider'
	'$stateProvider'
	'bopStaticData'
	($urlRouterProvider, $stateProvider, bopStaticData) ->
		# if none of the below states are matched, use this as the fallback
		$urlRouterProvider.otherwise '/'

		$stateProvider.state 'app',
#			url: '/app'
			abstract: true
			templateUrl: 'client/views/menu.ng.html'
			controller: 'AppCtrl'

		.state 'app.startup',
			url: '/'
			views:
				'menuContent':
					templateUrl: 'client/views/startup.ng.html'
					controller: 'StartupCtrl'

		.state 'app.auth',
#			cache:false
			url: '/auth'
			views:
				'menuContent':
					templateUrl: 'client/views/auth.ng.html'
					controller: 'AuthCtrl'

		.state 'app.expeditions',
#			cache:false
			url: '/expeditions'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditions.ng.html'
					controller: 'ExpeditionsCtrl'

		.state 'app.expeditionOverview',
			cache:false
			url: '/expeditionOverview/:expeditionID'
			views:
				'menuContent':
					templateUrl: 'client/views/expeditionOverview.ng.html'
					controller: 'ExpeditionOverviewCtrl'

		.state 'app.home',
			cache:false
			url: '/home'
			views:
				'menuContent':
					templateUrl: 'client/views/home.ng.html'
					controller: 'HomeCtrl'

		.state 'app.protocol',
			cache:false
#			url: '/protocol/:protocolNum'
			#shorthand default values
			params:
		        protocolNum: 1
#		        param2: "param2Default"
			views:
				'menuContent':
					templateUrl: 'client/views/protocol.ng.html'
					controller: 'ProtocolCtrl'

		#TODO deprecated, was part of getting started
		.state 'app.todos',
			url: '/todos'
			views:
				'menuContent':
					templateUrl: 'client/views/todos.ng.html'
					controller: 'TodoCtrl'

#		.state 'app.protocolSection',
#			cache: false
##			url: '/protocol/:protocolNum'
#			#shorthand default values
#			abstract:true
#			params:
#				protocolNum2: undefined
#				sectionMachineName: undefined
#
#			views:
#				'menuContent':
##					templateUrl: 'client/views/protocolSection.ng.html'
#					controller: 'ProtocolSectionCtrl'
#
		#dynamically create all the protocol section states.
		for protocol in bopStaticData.protocols
			for section in protocol.sections
				$stateProvider.state 'app.' + section.machineName,
					cache: false
		#			url: '/protocol/:protocolNum'
					#shorthand default values
					params:
						protocolNum: undefined
						sectionMachineName: undefined

					views:
						'menuContent':
							templateUrl: "client/protocol#{protocol.num}/#{section.machineName}.ng.html"
							controller: _.capitalize(section.machineName) + 'Ctrl'

		return
]


