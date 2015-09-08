angular.module('app.example').controller 'CageLocationCtrl', [
	'$scope'
	'$controller'
	'$ionicPlatform'
	'bopLocationHelper'
	($scope, $controller, $ionicPlatform, bopLocationHelper) ->
		#inherit from common protocol-section controller
		$controller 'ProtocolSectionBaseCtrl', {$scope: $scope}

		defineMap = ->
			bopLocationHelper.getGPSPosition()
			.then (position)->
#					console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
				$scope.section.location = "#{position.coords.latitude},#{position.coords.longitude}"

				#setup map
				$scope.cageLocationMap =
					scope: 'nyc_harbor'
					options:
						height: $(window).height()
						staticGeoData: true
						legendHeight: 0
					geographyConfig:
						dataUrl: '/data/map.topo.json'
						popupOnHover: false
						highlightOnHover: false
					bubblesConfig:
						radius: 10
						borderWidth: 1.5
						borderColor: '#353535'
						popupOnHover: false
						fillOpacity: 1
						highlightOnHover: false
					fills:
						defaultFill: '#AAC06C'
						station: '#E96057'
					dataType: 'json'
					setProjection: (element) ->
						projection = d3.geo.mercator().center([
							position.coords.longitude
							position.coords.latitude
						]).scale(1000000).translate([
							element.offsetWidth / 2
							element.offsetHeight / 2
						])
						path = d3.geo.path().projection(projection)
						{
							path: path
							projection: projection
						}
				$scope.mapPlugins = bubbles: null

				$scope.mapPluginData = bubbles:[{
					name: 'Station'
					latitude: position.coords.latitude
					longitude: position.coords.longitude
					fillKey: 'station'
				}]

			.catch (error)->
				console.error 'error: ' + JSON.stringify(error)
				$scope.alert JSON.stringify(error), 'error'


		$ionicPlatform.ready =>
			if $scope.section.location
				defineMap()

		$scope.setLocationUsingGPS = ->
			console.log 'setLocationUsingGPS'
			$scope.sectionFormRef.$setDirty()
			defineMap()

		$scope.onTapSave = (formIsValid)->
			if formIsValid
				$scope.section.save().then ->
					console.log 'saved section form to db'
					$scope.showSaveDone()
					$scope.back()
			else
				console.log 'do nothing, sectionForm invalid'
	]