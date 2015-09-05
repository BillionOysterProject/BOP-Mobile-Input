angular.module('app.example').controller 'UploadTestCtrl', [
	'$scope'
	'$meteor'
	'$timeout'
	'bopOfflineImageHelper'
	($scope, $meteor, $timeout, bopOfflineImageHelper) ->
		updateImages = ->
			idList = bopOfflineImageHelper.getAllLocalImageIDsForUser()

			bopOfflineImageHelper.getURLForID(idList)
			.then (dataURLs)->
				for id, index in idList
					# Find all images in collection that aren't yet in the data url* array (on startup, helps
					# add images as they become known since collection isn't necessarily full initially – takes time for collection to fill up)
					# *Note by 'data url' I mean the url that contains the full data of the image as base64
					if !_.findWhere($scope.images, {_id:id})
						$scope.images.push({_id:id, uri:dataURLs[index]})

		$scope.addImages = (files)->
			console.log 'saving picFile...'
			console.log 'addImages files: ', files

		$scope.onImgLoad = (event)->
			console.log 'onImgLoad'

		$scope.takePic = ->
			console.log 'UploadTestCtrl#takePic'
			bopOfflineImageHelper.takePic()
			.then (pic)->
				console.log 'takePic complete'
				$scope.images.push(pic)

		$scope.removePic = (pic)->
			_.pull($scope.images, pic)
			bopOfflineImageHelper.removePic(pic._id)

#		$scope.uploadPic = (pic)->
#			#updated repeatedly while upload takes place
#			# @param p 0 - 1
#			progressCB = (p, id)->
#				console.log 'uploading ' + id + '\t' + 'p: ' + Math.floor(p * 100)
#
#			bopOfflineImageHelper._uploadPic(pic._id, progressCB)
#			.then ->
#				console.log 'UploadTestCtrl#uploadPic complete'
#			.catch (err)->
#				console.error 'UploadTestCtrl#uploadPic error: ', err

		$scope.totalToUpload = ->
			bopOfflineImageHelper.getTotalLocalImages()

		$scope.uploadAll = ->
			localIDList = bopOfflineImageHelper.getAllLocalImageIDsForUser()
			initProgressMap = ->
				$scope.progressMap = {}
				$scope.progressMap[id] = 0 for id in localIDList

			initProgressMap()

			$scope.combinedUploadProgress = 0

			#updated repeatedly while upload takes place
			# @param p 0 - 1
			progressCB = (p, id)->
				$scope.progressMap[id] = p

				progressSum = 0
				(progressSum += $scope.progressMap[id]) for id in localIDList

				$timeout ->
					$scope.combinedUploadProgress = progressSum / localIDList.length

			processRemoteURLs = (remoteURLs)->
				console.log 'remoteURLs: ' + remoteURLs
				picObjects = []
				for id, index in uploadedIDs
					picObjects.push {_id:id, uri:remoteURLs[index]}

				$scope.images = picObjects

			uploadedIDs = localIDList #reuse id list – makes more sense semantically below

			bopOfflineImageHelper.uploadAllLocalPicsToRemote(progressCB)
			.then ->
				console.log 'uploadAllLocalPicsToRemote complete. Removing all local pics...'
				bopOfflineImageHelper.removeAllLocalPics()

			.then ->
				console.log 'uploadedIDs: ' + uploadedIDs
				bopOfflineImageHelper.getURLForID(uploadedIDs)

			.then processRemoteURLs
			.then ->
				console.log 'UploadTestCtrl#uploadAll complete'
				$scope.combinedUploadProgress = 1

			.catch (err)->
				console.error 'UploadTestCtrl#uploadAll error: ', err

			.finally ->
				$scope.combinedUploadProgress = 0
				initProgressMap()

		$scope.images = []

		#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
		if bopOfflineImageHelper.getTotalLocalImages() > 0
			updateImages()
		else
			$timeout ->
				updateImages()
			, 2000
	]
