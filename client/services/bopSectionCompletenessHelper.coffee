angular.module('app.example').factory "bopSectionCompletenessHelper", [
	"$q"
	($q)->
		class SectionCompletenessHelper
			constructor:->
				#need to manually keep this up to date to keep in sync with number of fields in the section forms
				@fieldTotalsMap =
					cageLocation:1
					depth:1
					condition:1
					oysterGrowth:10
					mobileOrganisms:1 #for now making it look for at least one organism
					sessileOrganisms:1 #TODO replace with actual number
					weather:5
					rainfall:2
					tide:3
					water:5
					land:5
					waterQuality:10 # total indicators - at least one for each, regardless of method used
					sediment:3

			# Gets completeness of a section as a percentage, 0-1
			getSectionCompleteness:(id, machineName) ->
				section = ProtocolSection.findOne(id)
				fieldCount = 0
				switch machineName
					when 'cageLocation'
						fieldCount++ if section.location?

					when 'depth'
						fieldCount++ if section.submergedDepth?

					when 'condition'
						fieldCount++ if section.bioaccumulation?

					when 'oysterGrowth'
						if section.substrateShells?
							for shell in section.substrateShells
								fieldCount++ if shell.totals.live? and shell.totals.dead?

					when 'mobileOrganisms'
						if section.organisms?
#							fieldCount++ for org of section.organisms
							fieldCount = 1 if _.keys(section.organisms).length > 0

					when 'sessileOrganisms'
						console.log 'TODO: getSectionCompleteness() for sessileOrganisms'

					when 'weather'
						fieldCount++ if section.windSpeed?
						fieldCount++ if section.windDirection?
						fieldCount++ if section.temperatureF?
						fieldCount++ if section.humidityPct?
						fieldCount++ if section.weatherCondition?

					when 'rainfall'
						#they'll be true or false once section is saved, initially they're undefined so we know user has saved that form despite the fields' checked state.
						fieldCount++ if section.recentRain72h?
						fieldCount++ if section.recentRain7d?

					when 'tide'
						fieldCount++ if section.estimate?
						fieldCount++ if section.speed?
						fieldCount++ if section.direction?

					when 'water'
						fieldCount++ if section.waterColour?
						fieldCount++ if section.oilSheen?
						fieldCount++ if section.garbageDescription? and section.garbageDescription.length > 0
						fieldCount++ if section.pollutionDrainLocations?
						fieldCount++ if section.sewerDrainLocations?

					when 'land'
						fieldCount++ if section.shorelineTypes? and section.shorelineTypes.length > 0
						fieldCount++ if section.adjacentShoreline?.pavedPct?
						fieldCount++ if section.adjacentShoreline?.vegetatedPct?
						fieldCount++ if section.adjacentShoreline?.porousPct?
						fieldCount++ if section.garbageDescription? and section.garbageDescription.length > 0

					when 'waterQuality'
						if section.indicators?
							fieldCount++ if section.indicators.temperature?.totalSamples > 0
							fieldCount++ if section.indicators.DO?.totalSamples > 0
							fieldCount++ if section.indicators.turbidity?.totalSamples > 0
							fieldCount++ if section.indicators.salinity?.totalSamples > 0
							fieldCount++ if section.indicators.pH?.totalSamples > 0
							fieldCount++ if section.indicators.nitrates?.totalSamples > 0
							fieldCount++ if section.indicators.phosphates?.totalSamples > 0
							fieldCount++ if section.indicators.ammonia?.totalSamples > 0

					when 'sediment'
						fieldCount++ if section.volume?
						fieldCount++ if section.daysCollected?
						fieldCount++ if section.sedimentDescription? and section.sedimentDescription.length > 0

					else
						console.warn "Unknown section, '#{machineName}'"

#					when 'rainfall'
#					when 'tide'
#					when 'water'
#					when 'land'

				#return completeness
				fieldCount / @fieldTotalsMap[machineName]


		helper = new SectionCompletenessHelper()

		helper
]
