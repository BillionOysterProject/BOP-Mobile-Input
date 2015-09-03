angular.module('app.example').factory "bopOfflineImageHelper", [
	"$q"
	"$ionicPlatform"
	"$cordovaCamera"
	"$cordovaFile"
	"$cordovaFileTransfer"
	"$timeout"
	($q, $ionicPlatform, $cordovaCamera, $cordovaFile, $cordovaFileTransfer, $timeout)->
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


			uploadPic:(id, progressCB)->
				$q (resolve, reject)=>
					basePath = cordova.file.dataDirectory
					filename = id + '.jpg'
					sourceFilepath = basePath + filename
					console.log 'uploadPic sourceFilepath: ' + sourceFilepath
					@getSignedAWSPolicy(filename)
					.then (data)->
						s3URL = "https://#{data.bucket}.s3.amazonaws.com/"
						acl = 'public-read'

						options =
							fileKey: 'file'
							fileName: filename
							mimeType: 'image/jpeg'
							chunkedMode: false
							params:
								key: filename
								AWSAccessKeyId: data.accessKeyId
								acl: acl
								policy: data.policy
								signature: data.signature
								'Content-Type': 'image/jpeg'

						$cordovaFileTransfer.upload(s3URL, sourceFilepath, options).then ((result) ->
							console.log 'SUCCESS: ' + JSON.stringify(result.response)

						), ((err) ->
							console.error JSON.stringify(err)

						), (progress) ->
							# constant progress updates
							$timeout ->
								progressCB( progress.loaded / progress.total )



			getSignedAWSPolicy:(filename)->
				$q (resolve, reject)->
					Meteor.call "sign", filename, (err, data)->
						if err
							console.error err
							reject(err)
						else
							console.log 'data: ', data
							resolve(data)

			#snip ---------- start
#			$scope.uploadFile = ->
#				basePath = cordova.file.dataDirectory
#				filename = id + '.jpg'
#				uploadEndpointURL = "https://#{data.bucket}.s3.amazonaws.com/"
#				sourceFilepath = basePath + filename
#
#
#				$cordovaFileTransfer.upload(uploadEndpointURL, sourceFilepath, options).then ((result) ->
#					console.log 'SUCCESS: ' + JSON.stringify(result.response)
#					alert 'success'
#					alert JSON.stringify(result.response)
#
#				), ((err) ->
#					console.log 'ERROR: ' + JSON.stringify(err)
#					alert JSON.stringify(err)
#
#				), (progress) ->
#					# constant progress updates
#					$timeout ->
#						$scope.downloadProgress = progress.loaded / progress.total * 100
			#snip ---------- end

		locationHelper = new bopOfflineImageHelper()

		locationHelper
]
