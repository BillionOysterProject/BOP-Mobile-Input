angular.module('app.example').controller 'PlaylistCtrl', ($scope, $stateParams) ->
	console.log 'playlistId: ' + $stateParams.playlistId

	console.log JSON.stringify($scope.playlists)
	for playlist in $scope.playlists
		if playlist.id is Number($stateParams.playlistId)
			$scope.playlist = playlist
			break
	return