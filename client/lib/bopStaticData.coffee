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
		title: 'Sessile Organisms'
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
		icon:'icon-water-temperature'
		methods:[
			{machineName:'thermometer', label:'Thermometer', units:'ºC'}
			{machineName:'atlasProbe', label:'Atlas Scientific probe', units:'ºC'}
		]
	,
		machineName:'DO'
		title:'Dissolved Oxygen (DO)'
		icon:'icon-dissolved-oxygen'
		methods:[
			{machineName:'winkler', label:'Winkler Method', units:'mg/L'}
			{machineName:'atlasProbe', label:'Atlas Scientific probe', units:'%'}
			{machineName:'chemets', label:'CHEMets Colorimetric', units:'PPM'}
		]
	,
		machineName:'turbidity'
		title:'Turbidity'
		icon:'icon-turbidity'
		methods:[
			{machineName:'turbidityTube', label:'Turbidity tube', units:'JTU'}
		]
	,
		machineName:'oxiReducPot'
		title:'Oxidation Reduction Potential'
		icon:'icon-oxidation-reduction-potential'
		methods:[
			{machineName:'atlasProbe', label:'Atlas Scientific probe', units:'ORP'}
		]
	,
		machineName:'salinity'
		title:'Salinity'
		icon:'icon-salinity'
		methods:[
			{machineName:'atlasProbe', label:'Atlas Scientific probe', units:'PPT'}
			{machineName:'refractometer', label:'Refractometer', units:'PPT'}
		]
	,
		machineName:'pH'
		title:'pH'
		icon:'icon-ph'
		methods:[
			{machineName:'atlasProbe', label:'Atlas Scientific probe', units:'pH'}
			{machineName:'phMeter', label:'pH Meter', units:'pH'}
			{machineName:'phStrips', label:'pH Test Strips', units:'pH'}
		]
	,
		machineName:'nitrates'
		title:'Nitrates'
		icon:'icon-ph'
		methods:[
			{machineName:'aquaStrips', label:'Aquacheck test strips', units:'PPM'}
		]
	,
		machineName:'phosphates'
		title:'Phosphates'
		icon:'icon-phosphates'
		methods:[
			{machineName:'aquaStrips', label:'Aquacheck test strips', units:'PPM'}
		]
	,
		machineName:'ammonia'
		title:'Ammonia'
		icon:'icon-ammonia'
		methods:[
			{machineName:'aquaStrips', label:'Aquacheck test strips', units:'PPM'}
		]
	,
		machineName:'fecal'
		title:'Fecal Coliform'
		icon:'icon-fecal-coliform'
		methods:[
			{machineName:'colilert', label:'Colilert', units:'MPN'}
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