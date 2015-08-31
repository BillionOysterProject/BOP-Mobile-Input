angular.module('app.example').controller 'UploadTestCtrl', [
	'$scope'
	'$meteor'
	'$cordovaCamera'
	'$cordovaFile'
	($scope, $meteor, $cordovaCamera, $cordovaFile) ->
#		if !$scope.startupComplete
#			location.href = '/'
#			return

#		$scope.dataImages = $meteor.collectionFS(DataImages, false, DataImages).subscribe('dataImages');

#		$scope.$watch 'picFile', ->
#			console.log 'picFile changed: ', $scope.picFile[0]
#			if $scope.picFile?[0]?
#				console.log 'saving picFile...'
#				$scope.dataImages.save($scope.picFile[0])
#				.then ->
#					console.log 'save complete'
#				.catch (err)->
#					console.log 'save failed. ', err

		$scope.addImages = (files)->
			console.log 'saving picFile...'
			console.log 'addImages files: ', files
#			if files.length > 0
	#			$scope.picFile = files[0]
#				$scope.dataImages.save(files[0])
#				.then ->
#					console.log 'save complete, args: ', arguments
#				.catch (err)->
#					console.log 'save failed. ', err

#				DataImages.insert files[0], (err, fileObj)->
#					if err
#						console.log 'error: ', err
#					else
#						console.log 'inserted ', fileObj._id

		$scope.onImgLoad = (event)->
			console.log 'onImgLoad'

		document.addEventListener "deviceready", ->
			console.log 'deviceready'

			$scope.takePic = ->
				console.log 'takePic'
	#			CameraPopoverOptions = new CameraPopoverOptions(300, 300, 100, 100, Camera.PopoverArrowDirection.ARROW_ANY)
				CameraPopoverOptions = null

				options =
					quality: 50
#					destinationType: Camera.DestinationType.FILE_URI
					destinationType: Camera.DestinationType.DATA_URL
					sourceType: Camera.PictureSourceType.CAMERA
					allowEdit: true
					encodingType: Camera.EncodingType.JPEG
					popoverOptions: CameraPopoverOptions
					saveToPhotoAlbum: false
				$cordovaCamera.getPicture(options)
				.then (imageData) ->
					console.log 'Got image data. Len: ' + imageData.length
#					console.log 'captured at: ' + uri

#					fileName = uri.replace(///^.*(\\|\/|\:)///, '');
#					basePath = uri.match(new RegExp("(.*)" + fileName))?[1]
#					console.log "basePath: " + basePath
#					console.log "fileName: " + fileName

					$scope.uri = 'data:image/jpeg;base64,' + imageData
#					console.log 'Trying to serve file from: ' + $scope.uri

					#snip --- start
#					gotFS = (fileSystem)->
#						console.log 'requestFileSystem success'
##						rootToURL = fileSystem.root.toURL()
#						window.resolveLocalFileSystemURL(movedFilePath, (fileEntry) ->
#							console.log 'new local uri: ' + fileEntry.toInternalURL()
#
#							$scope.uri = fileEntry.toInternalURL()
#						, (error) ->
#							console.error 'resolveLocalFileSystemURL error: ' + error
#						)
#
#					fail = (error)->
#						console.error 'requestFileSystem fail: ' + error
#
#					window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, gotFS, fail)
					#snip --- END


#					console.log 'moving file...'
#					$cordovaFile.moveFile(basePath, fileName, cordova.file.documentsDirectory)
#					.then (success) ->
#						# success
#						movedFilePath = cordova.file.documentsDirectory + fileName
#
#
#						return
#					, (error) ->
#						# error
#						console.error 'error moving file: ', error
#						return
				.catch (error)->
					console.log 'getPicture failed. error: ' + error
	]