angular.module('app.example').factory "sessileOrganismsHelper", [
	->
		class SessileOrganismsHelper
			constructor:->

			cellIsComplete: (section, tileIndex, cellIndex)->
				cell = section.settlementTiles[tileIndex].cells[cellIndex]
				cell.dominantOrgID and cell.coDominantOrgID

			tileIsComplete: (section, tileIndex)->
				tile = section.settlementTiles[tileIndex]
				totalCells = tile.cells.length

				completedCells = 0
				for cell, cellIndex in tile.cells
					completedCells++ if @cellIsComplete(section, tileIndex, cellIndex)

				tile.photoID and completedCells == totalCells

		helper = new SessileOrganismsHelper()

		helper
]
