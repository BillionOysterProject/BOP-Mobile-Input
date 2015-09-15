angular.module('app.example').factory "sessileOrganismsHelper", [
	->
		class SessileOrganismsHelper
			constructor:->
				@_totalTiles = 4
				@_totalCellsPerTile = 9;
				@_totalCells = @_totalCellsPerTile * @_totalTiles;

			cellIsComplete: (section, tileIndex, cellIndex)->
				cell = section.settlementTiles[tileIndex].cells[cellIndex]
				cell.dominantOrgID and cell.coDominantOrgID

			tileIsComplete: (section, tileIndex)->
				tile = section.settlementTiles[tileIndex]

				completedCells = 0
				for cell, cellIndex in tile.cells
					completedCells++ if @cellIsComplete(section, tileIndex, cellIndex)

				tile.photoID and completedCells == @_totalCellsPerTile

			allTilesAreComplete: (section)->
				complete = true
				for tile, tileIndex in section.settlementTiles
					if !@tileIsComplete(section, tileIndex)
						complete = false
						break
				complete

			getStatsForTile:(section, tileIndex)->
				orgCountMap = @_getCountMapForTile(section, tileIndex)
				@_getStatsForOrgCountMap(orgCountMap)

			getOverallStats: (section)->
				aggregateOrgCountMap = {}
				countMaps = (@_getCountMapForTile(section, tileIndex) for tile, tileIndex in section.settlementTiles)

				for map in countMaps
					for orgID, orgCount of map
						aggregateOrgCountMap[orgID] ?= 0
						aggregateOrgCountMap[orgID] += orgCount

				@_getStatsForOrgCountMap(aggregateOrgCountMap, true)

			_getCountMapForTile:(section, tileIndex)->
				tile = section.settlementTiles[tileIndex]
				orgCountMap = {}

				for cell in tile.cells
					if cell.dominantOrgID isnt 'none'
						orgCountMap[cell.dominantOrgID] ?= 0

						if cell.coDominantOrgID isnt 'none'
							#when there's both a dominant and co-dominant organism, each gets a count of 1/2
							orgCountMap[cell.dominantOrgID] += .5

							orgCountMap[cell.coDominantOrgID] ?= 0
							orgCountMap[cell.coDominantOrgID] += .5

						else
							#when there's only a dominant organism, the count gets a score of 1
							orgCountMap[cell.dominantOrgID]++
				orgCountMap

			_getStatsForOrgCountMap:(orgCountMap, overall = false)->
				stats = for orgID, orgCount of orgCountMap
					total = if overall then @_totalCells else @_totalCellsPerTile
					{
						percent: Math.round(orgCount / total * 100)
						organism: Organisms.findOne( _id:orgID, settlement:true )
					}

				stats

			#for dev – quickly populate the data with some preset use cases instead of clicking a silly amount of times
			_mockData:(section, useCase)->
				starTunicate = '556ff488210ecc1ee84131e6'

				switch useCase
					when 0 #erase data for sessile organisms
						delete section.settlementTiles
						console.log 'settlementTiles erased for this expedition'

					when 1 #tile 1 is complete
						tile = section.settlementTiles[0]
						for cell in tile.cells
							cell.dominantOrgID = starTunicate
							cell.coDominantOrgID = 'none'

						console.log 'tile one is complete. Dominant organism is amphipodID. no co-dominant'

					when 2 #tile 1 is almost complete
						tile = section.settlementTiles[0]
						for cell, cellIndex in tile.cells
							break if cellIndex > @_totalCellsPerTile - 3
							cell.dominantOrgID = starTunicate
							cell.coDominantOrgID = 'none'

						console.log 'tile one is nearly complete. Dominant organism is amphipodID. no co-dominant'

					when 3 #tiles 1,2,3 are complete, 4 is not
						for tile, tileIndex in section.settlementTiles
							break if tileIndex is 3
							for cell, cellIndex in tile.cells
								cell.dominantOrgID = starTunicate
								cell.coDominantOrgID = 'none'

					when 4 # all tiles completed
						for tile in section.settlementTiles
							tile.photoID = 'foo'
							for cell, cellIndex in tile.cells
								cell.dominantOrgID = starTunicate
								cell.coDominantOrgID = 'none'

						console.log 'all tiles are complete'

				section.save()

		helper = new SessileOrganismsHelper()

		helper
]