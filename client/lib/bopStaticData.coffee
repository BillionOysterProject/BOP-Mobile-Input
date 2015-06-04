angular.module('app.example').constant "bopStaticData", {
	protocolsMetadata: [
		num: 1
		title: 'Oyster Measurements'
		sections: [
			{machineName: 'cageLocation', title: 'Location of oyster cage'}
			{machineName: 'depthCondition', title: 'Depth and condition of the oyster cage'}
			{machineName: 'oysterGrowth', title: 'Measuring oyster growth'}
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