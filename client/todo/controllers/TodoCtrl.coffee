angular.module('app.example').controller 'TodoCtrl', [
	'$scope'
	'$meteorCollection'
	'$ionicModal'
	'$rootScope'
	'$ionicSideMenuDelegate'
	'$ionicPopup'
	'$cordovaDatePicker'
	($scope, $meteorCollection, $ionicModal, $rootScope, $ionicSideMenuDelegate, $ionicPopup, $cordovaDatePicker) ->
		$scope.Projects = $meteorCollection(Projects).subscribe('Projects')
		$scope.Tasks = $meteorCollection(Tasks).subscribe('Tasks')
#		$scope.Images = $meteorCollection(Images).subscribe('Images')
		$scope.Images = $meteorCollection(Images).subscribe('Images') #TODO collection shouldn't be Tasks. get it to work with Images
		# A utility function for creating a new project
		# with the given projectTitle

		#TODO placeholder to test image uploader
		$scope.uploaderData =
			userID:'abcd123'

		createProject = (projectTitle) ->
			newProject =
				title: projectTitle
				active: false
			$scope.Projects.save(newProject).then (res) ->
				if res
					$scope.selectProject newProject, $scope.Projects.length - 1
				return
			return

		# Called to create a new project

		$scope.newProject = ->
			$ionicPopup.prompt(
				title: 'New Project'
				subTitle: 'Name:').then (res) ->
					if res
						createProject res
					return
			return

		# Grab the last active, or the first project

		$scope.activeProject = ->
			activeProject = $scope.Projects[0]
			angular.forEach $scope.Projects, (v, k) ->
				if v.active
					activeProject = v
				return
			activeProject

		# Called to select the given project

		$scope.selectProject = (project, index) ->
			selectedProject = $scope.Projects[index]
			angular.forEach $scope.Projects, (v, k) ->
				v.active = false
				return
			selectedProject.active = true
			$ionicSideMenuDelegate.toggleLeft()
			return

		# Create our modal
		$ionicModal.fromTemplateUrl 'client/todo/views/new-task.ng.html', ((modal) ->
					$scope.taskModal = modal
					return
				),
			scope: $scope
			animation: 'slide-in-up'
		#Cleanup the modal when we are done with it!
		$scope.$on '$destroy', ->
			$scope.taskModal.remove()
			return

		$scope.createTask = (task) ->
			activeProject = $scope.activeProject()
			if !activeProject or !task.title
				return
			$scope.Tasks.save
				project: activeProject._id
				title: task.title
			$scope.taskModal.hide()
			task.title = ''
			return

		$scope.deleteTask = (task) ->
			$scope.Tasks.delete task
			return

		$scope.newTask = ->
			$scope.task = {}
			$scope.taskModal.show()
			return

		$scope.closeNewTask = ->
			$scope.taskModal.hide()
			return

		$scope.toggleProjects = ->
			$ionicSideMenuDelegate.toggleLeft()
			return

		$scope.pickDate = (task) ->
			options =
				date: new Date
				mode: 'date'
			#var options = {date: new Date(), mode: 'time'}; for time
			$cordovaDatePicker.show(options).then (date) ->
				task.date = date
				return
			return

		return
]