angular.module('app.example').controller 'ExpeditionOverviewCtrl', [
	'$scope'
	'$stateParams'
	'$q'
	'$ionicHistory'
	'$timeout'
	'$meteor'
	'bopLocationHelper'
	'$ionicPlatform'
	($scope, $stateParams, $q, $ionicHistory, $timeout, $meteor, bopLocationHelper, $ionicPlatform) ->
		if !$scope.startupComplete
			location.href = '/'
			return


		$scope.cameFromExpeditions = ->
			return $ionicHistory.backView()?.stateId is 'app.expeditions'

		$scope.setLocationUsingGPS = ->
			$ionicPlatform.ready =>
				bopLocationHelper.getGPSPosition()
				.then (position)->
#					console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
					$scope.formIntermediary.expedition.location = "#{position.coords.latitude},#{position.coords.longitude}"
				.catch (error)->
					console.error 'error: ' + JSON.stringify(error)
					$scope.alert JSON.stringify(error), 'error'

		$scope.onTapSave = (form) ->
			if form.$valid
				if isNew
					#create protocol section documents ------ start
					sections = [
						#protocol 1.1
						owner: Meteor.userId()
						machineName:'cageLocation'
					,
						#protocol 1.2
						owner: Meteor.userId()
						machineName:'depthCondition'
					,
						#protocol 1.3
						owner: Meteor.userId()
						machineName:'oysterGrowth'
					,
						#protocol 2.1
						owner: Meteor.userId()
						machineName:'mobileOrganisms'
					,
						#protocol 3.1
						owner: Meteor.userId()
						machineName:'sessileOrganisms'
					,
						#protocol 4.1
						owner: Meteor.userId()
						machineName:'weather'
					,
						#protocol 4.2
						owner: Meteor.userId()
						machineName:'rainfall'
					,
						#protocol 4.3
						owner: Meteor.userId()
						machineName:'tide'
					,
						#protocol 4.4
						owner: Meteor.userId()
						machineName:'water'
					,
						#protocol 4.5
						owner: Meteor.userId()
						machineName:'land'
					,
						#protocol 5.1
						owner: Meteor.userId()
						machineName:'waterQuality'
					,
						#protocol 5.2
						owner: Meteor.userId()
						machineName:'sediment'
					]
					#create protocol section documents ------ end

					saveProtocolSections = (sections)->
						promises = (for section in sections
							$q (resolve, reject)->
								insertID = ProtocolSection.insert(section)
								resolve(insertID)
						)

						$q.all(promises)

					handleSaveSectionsResults = (insertedIDs)->
						console.log 'saveProtocolSections insert ok'
						$q (resolve, reject)->
							idMap = {}
							query =
								_id:{$in:insertedIDs}

							ProtocolSection.find(query).forEach (section, index, cursor)->
								idMap[section.machineName] = section._id

							resolve(idMap)

					saveExpedition = (sectionIDMap)->
						console.log 'saveExpedition'
						$q (resolve, reject)->
							#create expedition
							$scope.formIntermediary.expedition.owner = Meteor.userId()
							$scope.formIntermediary.expedition.date = new Date()
							$scope.formIntermediary.expedition.sections = sectionIDMap
							$scope.formIntermediary.expedition.site = $scope.formIntermediary.selectedSite._id

							insertID = Expeditions.insert($scope.formIntermediary.expedition)
							resolve insertID

					saveProtocolSections(sections)
					.then handleSaveSectionsResults
					.then saveExpedition
					.then (insertedID)->
						console.log 'insertedID: ' + insertedID
						toastr.success("Expedition Created", null, {timeOut:'4000'})
						$scope.changeExpedition(insertedID)
					.catch (err)->
						console.error(err)

				else
					#update existing expedition
					exp = $scope.formIntermediary.expedition
					Expeditions.update exp._id,
						$set:
							title:exp.title
							site:$scope.formIntermediary.selectedSite._id
							location:exp.location

					$scope.showSaveDone()
					$ionicHistory.goBack()

			else
				console.log 'do nothing, overviewForm invalid'

		$scope.changeExpedition = (id)->
			$scope.setCurrentExpeditionByID(id)
			toastr.success("Switched Expeditions", null, {timeOut:'4000'})
			$scope.navigateHome()
		
			
		$scope.formIntermediary = {}
		
		$scope.sites = $meteor.collection(Sites)

		if $stateParams.expeditionID
			$scope.formIntermediary.expedition = $meteor.object(Expeditions, $stateParams.expeditionID, false);
			for site in $scope.sites
				if site._id is $scope.formIntermediary.expedition.site
					$scope.formIntermediary.selectedSite = site
					break
		else
			$scope.formIntermediary.expedition = {}
			$scope.formIntermediary.selectedSite = {}

		isNew = !$scope.formIntermediary.expedition.hasOwnProperty('_id')

		$scope.protocolSections = $meteor.collection(ProtocolSection, false).subscribe('ProtocolSection')
	]