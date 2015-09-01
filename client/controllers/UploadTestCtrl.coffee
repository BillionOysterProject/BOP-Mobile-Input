angular.module('app.example').controller 'UploadTestCtrl', [
	'$scope'
	'$meteor'
	'$timeout'
	'bopOfflineImageHelper'
	($scope, $meteor, $timeout, bopOfflineImageHelper) ->
		updateImages = ->
			imageCursor = LocalOnlyImages.find();
			imageCursor.forEach (imageMeta)->
				do (imageMeta)->
					#find all images in collection that aren't yet in the data url array (on startup, helps add images as they become known since collection isn't necessarily full initially)
					if !_.findWhere($scope.images, {_id:imageMeta._id})
						localPathToImage = bopOfflineImageHelper.getLocalPathForImageID(imageMeta._id)
						bopOfflineImageHelper.getDataURI(localPathToImage)
						.then (uri)->
							$scope.images.push({_id:imageMeta._id, uri:uri})

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

		$scope.images = []

		#TODO if we can ever find a way to know when the collection has finished repopulating from disk we could avoid this hack
		if LocalOnlyImages.find().count() > 0
			updateImages()
		else
			$timeout ->
				updateImages()
			, 1000
	]