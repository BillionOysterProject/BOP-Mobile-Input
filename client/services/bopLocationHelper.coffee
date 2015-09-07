angular.module('app.example').factory "bopLocationHelper", [
	"$q"
	"$ionicPlatform"
	"$cordovaGeolocation"
	($q, $ionicPlatform, $cordovaGeolocation)->
		class bopLocationHelper
			constructor:->

			#gets lat lng coords
			getGPSPosition:->
				console.log 'bopLocationHelper#getGPSPosition'

				posOptions =
					timeout: 15000
					maximumAge: 5 * 60 * 1000 #5 minutes

					enableHighAccuracy: true
					#need true for android emulator to be able to return GPS
#					enableHighAccuracy: true

				promise = null
				if window.cordova?
					$ionicPlatform.ready ->
						console.log 'geolocation, platform ready'
#						GeolocationFG.get ->
#							console.log 'GeolocationFG.get(GeolocationCallback); arguments: '
#							console.log arguments
						promise = $cordovaGeolocation.getCurrentPosition(posOptions)
				else
					promise = $q (resolve, reject)->
						#hardcoded Governor's island location for browser testing
						position =
							coords:
								latitude: 40.68,
								longitude: -74.02
						resolve(position)
				#console.log promise
				promise

		locationHelper = new bopLocationHelper()

		locationHelper
]
