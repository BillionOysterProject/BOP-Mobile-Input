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

	waterQualitySectionIndicators: [
		machineName:'temperature'
		title:'Water Temperature'
		units:'ºC'
		icon:'foo-icon'
		methods:[
			{machineName:'thermometer', label:'Thermometer'}
			{machineName:'atlasProbe', label:'Atlas Scientific probe'}
		]
	,
		machineName:'DO'
		title:'Dissolved Oxygen (DO)'
		units:'%'
		icon:'foo-icon'
		methods:[
			{machineName:'winkler', label:'Winkler Method'}
			{machineName:'atlasProbe', label:'Atlas Scientific probe'}
			{machineName:'chemets', label:'CHEMets Colorimetric'}
		]
	,
		machineName:'turbidity'
		title:'Turbidity'
		units:'%'
		icon:'foo-icon'
		methods:[
			{machineName:'turbidityTube', label:'Turbidity tube'}
		]
	,
		machineName:'oxiReducPot'
		title:'Oxidation Reduction Potential'
		units:'%'
		icon:'foo-icon'
		methods:[
			{machineName:'atlasProbe', label:'Atlas Scientific probe'}
		]
	,
		machineName:'salinity'
		title:'Salinity'
		units:'ppt'
		icon:'foo-icon'
		methods:[
			{machineName:'atlasProbe', label:'Atlas Scientific probe'}
			{machineName:'refractometer', label:'Refractometer'}
		]
	,
		machineName:'pH'
		title:'pH'
		units:'ppt'
		icon:'foo-icon'
		methods:[
			{machineName:'atlasProbe', label:'Atlas Scientific probe'}
			{machineName:'phMeter', label:'pH Meter'}
			{machineName:'phStrips', label:'pH Test Strips'}
		]
	,
		machineName:'nitrates'
		title:'Nitrates'
		units:'mg/L'
		icon:'foo-icon'
		methods:[
			{machineName:'aquaStrips', label:'Aquacheck test strips'}
		]
	,
		machineName:'phosphates'
		title:'Phosphates'
		units:'mg/L'
		icon:'foo-icon'
		methods:[
			{machineName:'aquaStrips', label:'Aquacheck test strips'}
		]
	,
		machineName:'ammonia'
		title:'Ammonia'
		units:'mg/L'
		icon:'foo-icon'
		methods:[
			{machineName:'aquaStrips', label:'Aquacheck test strips'}
		]
	,
		machineName:'fecal'
		title:'Fecal Coliform'
		units:'MPN'
		icon:'foo-icon'
		methods:[
			{machineName:'colilert', label:'Colilert'}
		]
	]

	weatherConditions:[
		{id:'partly-sunny', label:'Partly Sunny'}
		{id:'scattered-thunderstorms', label:'Scattered Thunderstorms'}
		{id:'showers', label:'Showers'}
		{id:'scattered-showers', label:'Scattered Showers'}
		{id:'rain-and-snow', label:'Rain and Snow'}
		{id:'overcast', label:'Overcast'}
		{id:'light-snow', label:'Light Snow'}
		{id:'freezing-drizzle', label:'Freezing Drizzle'}
		{id:'chance-of-rain', label:'Chance of Rain'}
		{id:'sunny', label:'Sunny'}
		{id:'clear', label:'Clear'}
		{id:'mostly-sunny', label:'Mostly Sunny'}
		{id:'partly-cloudy', label:'Partly Cloudy'}
		{id:'mostly-cloudy', label:'Mostly Cloudy'}
		{id:'chance-of-storm', label:'Chance of Storm'}
		{id:'rain', label:'Rain'}
		{id:'chance-of-snow', label:'Chance of Snow'}
		{id:'cloudy', label:'Cloudy'}
		{id:'mist', label:'Mist'}
		{id:'storm', label:'Storm'}
		{id:'thunderstorm', label:'Thunderstorm'}
		{id:'chance-of-tstorm', label:'Chance of TStorm'}
		{id:'sleet', label:'Sleet'}
		{id:'snow', label:'Snow'}
		{id:'icy', label:'Icy'}
		{id:'dust', label:'Dust'}
		{id:'fog', label:'Fog'}
		{id:'smoke', label:'Smoke'}
		{id:'haze', label:'Haze'}
		{id:'flurries', label:'Flurries'}
		{id:'light-rain', label:'Light Rain'}
		{id:'snow-showers', label:'Snow Showers'}
		{id:'hail', label:'Hail'}
	]
}