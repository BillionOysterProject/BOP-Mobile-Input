angular.module('app.example').controller 'ExpeditionCtrl', [
	'$scope'
	'$stateParams'
	'$q'
	'$ionicHistory'
	'$timeout'
	'$meteor'
	'bopLocationHelper'
	'$ionicPlatform'
	'$interval'
	($scope, $stateParams, $q, $ionicHistory, $timeout, $meteor, bopLocationHelper, $ionicPlatform, $interval) ->
		$scope.cameFromExpeditions = ->
			return $ionicHistory.backView()?.stateId is 'app.expeditions'

		#TODO I don't think this fn is needed in this controller anymore (there's another version of it in CageLocationCtrl).
		$scope.setLocationUsingGPS = ->
			$ionicPlatform.ready ->
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
					#TODO Could this be built up automatically in a loop from the MetaProtocols collection documents?
					#create protocol section documents ------ start
					sections = [
						#protocol 1.1
						owner: Meteor.userId()
						machineName:'cageLocation'
					,
						#protocol 1.2
						owner: Meteor.userId()
						machineName:'depth'
					,
						#protocol 1.3
						owner: Meteor.userId()
						machineName:'condition'
					,
						#protocol 1.4
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
						#protocol 4.6
						owner: Meteor.userId()
						machineName:'otherObservations'
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
						toastr.success 'Expedition Created', null, timeOut:4000
						$scope.changeExpedition(insertedID)
					.catch (err)->
						console.error(err)

				else
					#update existing expedition
					exp = $scope.formIntermediary.expedition
					Expeditions.update exp._id,
						$set:
							alias:exp.alias
							site:$scope.formIntermediary.selectedSite._id
							date:exp.date
							#TODO for teachers:
#							class:$scope.formIntermediary.selectedClass._id

					$scope.showSaveDone()
#					$ionicHistory.goBack()

			else
				console.log 'do nothing, overviewForm invalid'


		$scope.changeExpedition = (id)->
			$scope.setCurrentExpeditionByID(id)
			toastr.success 'Switched Expeditions', null, timeOut:4000
			$scope.navigateHome()

		$scope.formIntermediary = {}
		$scope.formIntermediary.selectedSite = {}

		$scope.sites = $meteor.collection(Sites)

#		inBounds = (point, bounds) ->
#			console.log 'inBounds'
#			eastBound = point.longitude < bounds.NE.longitude
#			westBound = point.longitude > bounds.SW.longitude
#			inLong = undefined
#			if bounds.NE.longitude < bounds.SW.longitude
#				inLong = eastBound or westBound
#			else
#				inLong = eastBound and westBound
#			inLat = point.latitude > bounds.SW.latitude and point.latitude < bounds.NE.latitude
#			inLat and inLong


#		defineMap = ->
#			console.log 'defineMap'
#			bounds =
#				'NE':
#					latitude: '41.20'
#					longitude: '-73.30'
#				'SW':
#					latitude: '40.27'
#					longitude: '-74.74'
#
#			if inBounds(location, bounds)
#				scaleCenter =
#					'scale': '200000'
#					'center': location
#			else
#				scaleCenter =
#					'scale': '130000'
#					'center':
#						latitude: '40.67'
#						longitude: '-74.10'
#
#			#setup map
#			$scope.map =
#				scope: 'nyc_harbor'
#				options:
#					height: $(window).height()
#					staticGeoData: true
#					legendHeight: 0
#				geographyConfig:
#					dataUrl: '/data/map.topo.json'
#					popupOnHover: false
#					highlightOnHover: false
#				bubblesConfig:
#					radius: 10
#					borderWidth: 1.5
#					borderColor: '#353535'
#					popupOnHover: false
#					popupTemplate: (geography, data) ->
#						'<div class="hoverinfo">Site: ' + data.name + '<br />Latitude: ' + data.latitude + '<br />Longitude: ' + data.longitude + '</div>'
#					fillOpacity: 1
#					highlightOnHover: true
#					highlightFillColor: '#E96057'
#					highlightBorderColor: 'rgba(0, 0, 0, 0.2)'
#					highlightBorderWidth: 1
#					highlightFillOpacity: 0.85
#				fills:
#					defaultFill: '#AAC06C'
#					unselectedSite: '#75A3F0'
#					selectedSite: '#E96057'
#				dataType: 'json'
#				setProjection: (element) ->
#					projection = d3.geo.mercator().center([
#						scaleCenter.center.longitude
#						scaleCenter.center.latitude
#					]).scale(scaleCenter.scale).translate([
#						element.offsetWidth / 2
#						element.offsetHeight / 2
#					])
#					path = d3.geo.path().projection(projection)
#					{
#						path: path
#						projection: projection
#					}
#			$scope.mapPlugins = bubbles: null
#
#
#		$scope.updateBubbles = ->
#			console.log 'updateBubbles'
#			siteBubbles = []
#			siteName = ''
#			i = 0
#			angular.forEach $scope.sites, (site, key) ->
#				bubbleFillKey = if site._id == $scope.formIntermediary.selectedSite._id then 'selectedSite' else 'unselectedSite'
#				if site._id == $scope.formIntermediary.selectedSite._id
#					siteName = site.label
#				siteBubbles[i] =
#					'id': site._id
#					'name': site.label
#					'latitude': site.lat
#					'longitude': site.lng
#					'fillKey': bubbleFillKey
#				i++
#				return
#			$scope.mapPluginData = bubbles: siteBubbles
#			if siteName != ''
#				toastr.remove()
#				toastr.success siteName, null, timeOut: 4000
#				toastr.warning 'Click Create to Continue', null, timeOut: 4000
#			addClickHandlers()
#			return
#
#		addClickHandlers = ->
#			console.log 'addClickHandlers'
#			$('.datamaps-bubble').off 'click'
#			$('.datamaps-bubble').on 'click', ->
#				console.log 'clicked'
#				$scope.formIntermediary.selectedSite = '_id': $(this).data('info')['id']
#				$scope.updateBubbles()
#				$scope.$apply()
#				return
#			return
#
#		#set initial bubble data
#		$scope.updateBubbles()
#		bubblesReady = $interval((->
#			if $('.datamaps-bubble')
#				addClickHandlers()
#				$interval.cancel bubblesReady
#			return
#		), 100)

		#get current location
#		location = null
#		$ionicPlatform.ready ->
#			bopLocationHelper.getGPSPosition()
#			.then (position)->
#				console.log 'getGPSPosition result: ' + JSON.stringify(position.coords)
#				location = position.coords
#			.then defineMap

#			.catch (error)->
#				console.error 'error: ' + JSON.stringify(error)
#				$scope.alert JSON.stringify(error), 'error'


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