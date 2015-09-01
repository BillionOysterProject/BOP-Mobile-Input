angular.module('app.example').factory "bopOfflineImageHelper", [
	"$q"
	"$ionicPlatform"
	"$cordovaCamera"
	"$cordovaFile"
	($q, $ionicPlatform, $cordovaCamera, $cordovaFile)->
		class bopOfflineImageHelper
			constructor:->

			takePic:->
				$q (resolve, reject)=>
					@_captureCamera()
					.then @_storePicLocally
					.then (insertedID)=>
						@getDataURI(@getLocalPathForImageID(insertedID))
						.then (dataURI)->
							console.log '@getDataURI success, dataURI: ' + dataURI
							resolve({_id:insertedID, uri:dataURI})

					.catch (error)->
						console.log 'takePic error: ', error
						reject(error)

			_captureCamera:->
				console.log 'bopOfflineImageHelper#takePic'
				$q (resolve, reject)->
					# CameraPopoverOptions docs: https://github.com/apache/cordova-plugin-camera#camerapopoveroptions
		#			CameraPopoverOptions = new CameraPopoverOptions(300, 300, 100, 100, Camera.PopoverArrowDirection.ARROW_ANY)
					CameraPopoverOptions = null

					options =
						quality: 50
						destinationType: Camera.DestinationType.FILE_URI
						sourceType: Camera.PictureSourceType.CAMERA
						allowEdit: true
						encodingType: Camera.EncodingType.JPEG
						popoverOptions: CameraPopoverOptions
						saveToPhotoAlbum: false

					$ionicPlatform.ready ->
						$cordovaCamera.getPicture(options)
						.then (uri) ->
							resolve(uri)

						.catch (error)->
							console.log 'getPicture failed. error: ', error
							reject(error)

			_storePicLocally:(fromURI)->
				console.log '_storePicLocally fromURL: ' + fromURI
				$q (resolve, reject)=>
					originFilename = fromURI.replace(///^.*(\\|\/|\:)///, '');
					originBasePath = fromURI.match(new RegExp("(.*)" + originFilename))?[1]
					console.log '_storePicLocally filename: ' + originFilename
					console.log '_storePicLocally basePath: ' + originBasePath


					imageID = Random.id()
					targetFilename = imageID + '.jpg'

					console.log '_storePicLocally target storage dir: ' + cordova.file.dataDirectory
					console.log '_storePicLocally target filename: ' + targetFilename

					$cordovaFile.moveFile(originBasePath, originFilename, cordova.file.dataDirectory, targetFilename)
					.then (success) ->
						# success
						console.log 'move file success'

						#create a client-side-only record for the stored image.
						LocalOnlyImages.insert(_id:imageID)
						console.log 'inserted obj: ', LocalOnlyImages.findOne(imageID)

						resolve( imageID )

					, (error) ->
						console.log 'move file error'
						# error
						reject(error)

			getLocalPathForImageID:(id)->
				obj =
					basePath:cordova.file.dataDirectory
					filename:id + '.jpg'
				obj

			getDataURI:(file)->
#				console.log 'getDataURI file: ' + JSON.stringify(file)
				$cordovaFile.readAsDataURL(file.basePath, file.filename)

			removePic:(id)->
				console.log 'removePic at ' + cordova.file.dataDirectory + id + '.jpg'
				$cordovaFile.removeFile(cordova.file.dataDirectory, id + '.jpg')
				.then ->
					console.log 'successfully deleted file from local filesystem'
					LocalOnlyImages.remove(id)
					console.log 'deleted file record from local collection'


		locationHelper = new bopOfflineImageHelper()

		locationHelper
]
