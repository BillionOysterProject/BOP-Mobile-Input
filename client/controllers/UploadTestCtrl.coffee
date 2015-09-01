angular.module('app.example').controller 'UploadTestCtrl', [
	'$scope'
	'$meteor'
	'$interval'
	'bopOfflineImageHelper'
	($scope, $meteor, $interval, bopOfflineImageHelper) ->
		$scope.localOnlyImages = $meteor.collection(LocalOnlyImages)

		initImages = ->
			console.log ''
			console.log 'localOnlyImages changed length --------- start'
			console.log 'length is ' + $scope.localOnlyImages.length
			for imageMeta in $scope.localOnlyImages
				do (imageMeta)->
					localPathToImage = bopOfflineImageHelper.getLocalPathForImageID(imageMeta._id)
					console.log 'localPathToImage: ' + JSON.stringify(localPathToImage)
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

		stop = $interval ->
			if LocalOnlyImages.find().count() > 0
				$interval.cancel(stop)
				initImages()
		, 100
	]