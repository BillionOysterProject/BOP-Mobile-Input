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
						@_getDataURIForLocalFilepath(@_getLocalPathForImageID(insertedID))
						.then (dataURI)->
							console.log '@_getDataURIForLocalFilepath success, dataURI: ' + dataURI
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

			_getLocalPathForImageID:(id)->
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
			_getDataURIForLocalFilepath:(localPathToImage)->
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

			# An abstracted URL getter for given image id
			# If id is in LocalOnlyImages collection, URL is a data url generated from an asset on the device' local filesystem
			# Otherwise, URL is an absolute URL to the asset on S3
			#
			# If given id is a single id string then promise resolves with a single data url string
			#
			# or
			#
			# If given id is an array of id strings then promise resolves with an array of data url strings
			#
			# @param id String id or array of string ids
			getURLForID:(singleOrMultipleID)->
				# multiple ids
				if singleOrMultipleID instanceof Array
					idList = singleOrMultipleID

					promises = []

					for id in idList
						if @_fileExistsLocally(id)
							promises.push @_getDataURIByID(id)
						else
							console.log 'id ' + id + ' doesn\'t exist locally, getting remote url for it...'
							remoteURLPromise = $q (resolve, reject)->
								resolve("http://bop-upload-test.s3.amazonaws.com/#{id}.jpg")
							promises.push remoteURLPromise

					console.log 'getURLForID returning a batch of ' + promises.length + ' promises'
					return $q.all(promises)

				# single id
				else
					id = singleOrMultipleID
					if @_fileExistsLocally(id)
						return @_getDataURIByID(id)
					else
						return $q (resolve, reject)-> resolve("https://bop-upload-test.s3.amazonaws.com/#{id}.jpg")

			# Gets data urls that contain jpg binary data as base64 string
			# that can be assigned directly to <img src="myURL"> (or ngSrc)
			# These urls are derived from jpg data stored on the local filesystem
			#
			# @see getURLForID
			_getDataURIByID:(id)->
				if typeof id is "string"
					promise = $q (resolve, reject)=>
						query =
							_id:id
							owner:Meteor.userId()
						if @_fileExistsLocally(id)
							#the image exists, get it
							imageMeta = LocalOnlyImages.findOne(query)
							localPathToImage = @_getLocalPathForImageID(imageMeta._id)
							@_getDataURIForLocalFilepath(localPathToImage)
							.then (uri)->
								resolve(uri)
						else
							reject('no local data for given id, ' + id)

				else
					promise = $q (resolve, reject)->
						reject('_getDataURIByID() failed: id not a string id or array of ids')

				return promise

			# Gets whether or not the image exists locally (based on whether or not if it's find in the local-only collection)
			# It is assumed that the corresponding file is also not present on the filesystem.
			_fileExistsLocally:(id)->
				LocalOnlyImages.find({_id: id}, {limit:1}).count() > 0

			#delete a picture, whether it's local or remote
			removePic:(id)->
				$q (resolve, reject)=>
					console.log 'bopOfflineImageHelper#removePic id: ' + id
					@_removeFileData(id)
					.then =>
						if @_fileExistsLocally(id)
							LocalOnlyImages.remove(id)
							console.log 'deleted file record from local collection'

						resolve()
					.catch (err)->
						reject(err)

			#remove the pics from the device, leaving any copies that may exist on S3
			removeAllLocalPics: ->
				promises = []
				idList = @getAllLocalImageIDsForUser()
				promises.push(@removePic(id)) for id in idList
				$q.all(promises)


			_removeFileData:(id)->
				console.log 'bopOfflineImageHelper#_removeFileData'
				if @_fileExistsLocally(id)
					if cordova?
						return $cordovaFile.removeFile(cordova.file.dataDirectory, id + '.jpg')
					else #for testing on desktop only
						return $q (resolve, reject)->
							resolve()
				else
					console.log 'file doesn\'t exist locally...'
					return $q (resolve, reject)->
						console.log ' calling deleteRemoteImage with id: ' + id
						Meteor.call "deleteRemoteImage", id, (err, data)->
							if err
								console.error err
								reject(err)
							else
								console.log 'data: ', data
								resolve(data)


			uploadAllLocalPicsToRemote:(progressCB)->
				promises = []
				imageCursor = LocalOnlyImages.find({owner:Meteor.userId()})
				imageCursor.forEach (imageMeta)=>
					promises.push @_uploadPic(imageMeta._id, progressCB)

				$q.all(promises)

			_uploadPic:(id, progressCB)->
				$q (resolve, reject)=>
					if cordova?
						basePath = cordova.file.dataDirectory
						filename = id + '.jpg'
						sourceFilepath = basePath + filename
						console.log '_uploadPic sourceFilepath: ' + sourceFilepath
						@_getSignedAWSPolicy(filename)
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

							$cordovaFileTransfer.upload(s3URL, sourceFilepath, options).then (result) ->
								console.log 'SUCCESS: ' + JSON.stringify(result)
								resolve()

							, (err) ->
								console.error JSON.stringify(err)

							, (progress) ->
								# constant progress updates
								$timeout ->
									progressCB( progress.loaded / progress.total, id )
					else #desktop testing only
						reject("can't upload pics when testing on desktop version")

			getTotalLocalImages:->
				LocalOnlyImages.find({owner:Meteor.userId()}).count()

			_getSignedAWSPolicy:(filename)->
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
