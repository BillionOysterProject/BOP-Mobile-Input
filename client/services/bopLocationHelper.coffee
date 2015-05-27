angular.module('app.example').factory "bopLocationHelper", [
	"$q"
	"$cordovaGeolocation"
	($q, $cordovaGeolocation)->
		class bopLocationHelper
			constructor:->

			#gets lat lng coords
			getGPSPosition:->
#				console.log 'bopLocationHelper#getGPSPosition'

				posOptions =
					timeout: 10000

					enableHighAccuracy: false
					#need true for android emulator to be able to return GPS
#					enableHighAccuracy: true

				if window.cordova?
					promise = $cordovaGeolocation.getCurrentPosition(posOptions)
				else
					promise = $q (resolve, reject)->
						#hardcoded Vancouver location for browser testing
						position =
							coords:
								latitude: 49.263002,
								longitude: -123.108446
						resolve(position)

				promise

		locationHelper = new bopLocationHelper()

		locationHelper
]
