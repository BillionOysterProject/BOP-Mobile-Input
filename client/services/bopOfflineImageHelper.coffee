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
						@getDataURIForLocalFilepath(@getLocalPathForImageID(insertedID))
						.then (dataURI)->
							console.log '@getDataURIForLocalFilepath success, dataURI: ' + dataURI
							resolve({_id:insertedID, uri:dataURI})

					.catch (error)->
						console.log 'takePic error: ', error
						reject(error)

			_captureCamera:->
				console.log 'bopOfflineImageHelper#takePic'
				$q (resolve, reject)=>
					if cordova?
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
					else #for testing in desktop browser.
						resolve('bop-dummy-desktop')

			_storePicLocally:(fromURI)=>
				console.log '_storePicLocally fromURL: ' + fromURI
				$q (resolve, reject)=>
					imageID = Random.id() #we want to know the ID of the new image before we insert a record for it

					if fromURI isnt 'bop-dummy-desktop' #bop-dummy-desktop is for desktop browser testing only
						originFilename = fromURI.replace(///^.*(\\|\/|\:)///, '');
						originBasePath = fromURI.match(new RegExp("(.*)" + originFilename))?[1]
						targetFilename = imageID + '.jpg'

#						console.log '_storePicLocally originFilename: ' + originFilename
#						console.log '_storePicLocally originBasePath: ' + originBasePath
	#					console.log '_storePicLocally target storage dir: ' + cordova.file.dataDirectory
	#					console.log '_storePicLocally target filename: ' + targetFilename

						$cordovaFile.moveFile(originBasePath, originFilename, cordova.file.dataDirectory, targetFilename)
						.then (success) =>
							# success
							console.log 'move file success'

							@_createLocalImageRecordForID(imageID)
							resolve( imageID )

						, (error) ->
							console.log 'move file error'
							# error
							reject(error)
					else
						@_createLocalImageRecordForID(imageID)
						resolve( imageID )

			_createLocalImageRecordForID: (imageID)->
				#create a client-side-only record for the stored image.
				LocalOnlyImages.insert(
					_id:imageID
					owner:Meteor.userId()
				)
#				console.log 'inserted obj: ', LocalOnlyImages.findOne(imageID)

			getLocalPathForImageID:(id)->
				if cordova?
					obj =
						basePath:cordova.file.dataDirectory
						filename:id + '.jpg'
				else #for desktop testing only
					obj =
						basePath:'bop-dummy-desktop'
						filename:id + '.jpg'
				obj

			# @param localPathToImage i.e. filesystem path (not a URL) like: /foo/bar/foobar.jpg
			getDataURIForLocalFilepath:(localPathToImage)->
				if cordova?
					return $cordovaFile.readAsDataURL(localPathToImage.basePath, localPathToImage.filename)
				else
					return $q (resolve, reject)=>
						resolve(@_createDummyImageDataURL(localPathToImage.filename))

			getAllLocalImageIDsForUser:->
				idList = []
				imageCursor = LocalOnlyImages.find({owner:Meteor.userId()})
				imageCursor.forEach (imageMeta)->
					idList.push imageMeta._id
				idList

			# Gets data urls that contain jpg binary data as base64 string that can be assigned directly to <img src="myURL"> (or ngSrc)
			#
			# If given id is a single id string then promise resolves with a single data url string
			#
			# or
			#
			# If given id is an array of id strings then promise resolves with an array of data url strings
			#
			# @param id String id or array of string ids
			getDataURIByID:(id)->

				if id instanceof Array #if multiple
					idList = id
					promiseList = []
					query =
						owner:Meteor.userId()
						_id:{$in:idList}

					imageCursor = LocalOnlyImages.find(query)
					imageCursor.forEach (imageMeta)=>
						localPathToImage = @getLocalPathForImageID(imageMeta._id)

						# adding promises in the forEach works with the assumption that cursor.forEach()
						# is synchronous which it seems to be.
						promiseList.push @getDataURIForLocalFilepath(localPathToImage)

					promise = $q.all(promiseList)

				else if typeof id is "string"
					promise = $q (resolve, reject)=>
						query =
							_id:id
							owner:Meteor.userId()
						if @fileExistsLocally(id)
							#the image exists, get it
							imageMeta = LocalOnlyImages.findOne(query)
							localPathToImage = @getLocalPathForImageID(imageMeta._id)
							@getDataURIForLocalFilepath(localPathToImage)
							.then (uri)->
								resolve(uri)
						else
							#the id was a valid string but not found in the database so just return an empty result
							resolve()

				else
					promise = $q (resolve, reject)->
						reject('getDataURIByID() failed: id not a string id or array of ids')

				return promise

			# Gets whether or not the image exists locally (based on whether or not if it's find in the local-only collection)
			# It is assumed that the corresponding file is also not present on the filesystem.
			fileExistsLocally:(id)->
				LocalOnlyImages.find({_id: id}, {limit:1}).count() > 0

			removePic:(id)->
				if cordova?
					console.log 'removePic at ' + cordova.file.dataDirectory + id + '.jpg'
					$cordovaFile.removeFile(cordova.file.dataDirectory, id + '.jpg')
					.then ->
						console.log 'successfully deleted file from local filesystem'
						LocalOnlyImages.remove(id)
						console.log 'deleted file record from local collection'
				else #for desktop testing only
					LocalOnlyImages.remove(id)
					console.log 'deleted file record from local collection'

			uploadAllLocalPicsToS3:->
				imageCursor = LocalOnlyImages.find({owner:Meteor.userId()})
#				imageCursor.forEach (imageMeta)->
				#TODO

			uploadPic:(id, progressCB)->
				$q (resolve, reject)=>
					if cordova?
						basePath = cordova.file.dataDirectory
						filename = id + '.jpg'
						sourceFilepath = basePath + filename
						console.log 'uploadPic sourceFilepath: ' + sourceFilepath
						@getSignedAWSPolicy(filename)
						.then (data)->
							s3URL = "https://#{data.bucket}.s3.amazonaws.com/"
	#						acl = 'public-read'

							options =
								fileKey: 'file'
								fileName: filename
								mimeType: 'image/jpeg'
								chunkedMode: false
								params:
									key: filename
									AWSAccessKeyId: data.accessKeyId
	#								acl: acl
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
					else #desktop testing only
						reject("can't upload pics when testing on desktop version")

			getTotalLocalImages:->
				LocalOnlyImages.find({owner:Meteor.userId()}).count()

			getSignedAWSPolicy:(filename)->
				$q (resolve, reject)->
					Meteor.call "sign", filename, (err, data)->
						if err
							console.error err
							reject(err)
						else
							console.log 'data: ', data
							resolve(data)

			_createDummyImageDataURL:(label)->
				canvas = document.createElement('canvas')
				context = canvas.getContext("2d");
				canvas.width = 1080
				canvas.height = 1920

				context.rect(0,0,1080,1920);
				context.fillStyle = "blue";
				context.fill();

				context.fillStyle = "white";
				context.font = "bold 250px Arial";
				context.fillText('Dummy', 10, 250);
				context.font = "bold 150px Arial";
				context.fillText(label, 10, 550);
				canvas.toDataURL("image/jpg")

		locationHelper = new bopOfflineImageHelper()

		locationHelper
]
