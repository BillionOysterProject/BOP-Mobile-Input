angular.module('app.example').controller 'UploadTestCtrl', [
	'$scope'
	'$meteor'
	'$timeout'
	'bopOfflineImageHelper'
	($scope, $meteor, $timeout, bopOfflineImageHelper) ->
		updateImages = ->
			idList = bopOfflineImageHelper.getAllLocalImageIDsForUser()

			bopOfflineImageHelper.getDataURIByID(idList)
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

		$scope.uploadPic = (pic)->
			$scope.uploadingID = pic._id

			#updated repeatedly while upload takes place
			# @param p 0 - 1
			progressCB = (p)->
				$scope.uploadProgress = p

			bopOfflineImageHelper.uploadPic(pic._id, progressCB)
			.then ->
				console.log 'UploadTestCtrl#uploadPic complete'
			.catch (err)->
				console.error 'UploadTestCtrl#uploadPic error: ', err
			.finally ->
				$scope.uploadingID = null

		$scope.images = []

		#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
		if bopOfflineImageHelper.getTotalLocalImages() > 0
			updateImages()
		else
			$timeout ->
				updateImages()
			, 2000
	]