angular.module('app.example').factory "bopProtocolSectionHelper", [
	"$q"
	($q)->
		class bopProtocolSectionHelper
			constructor:->

			addSectionNum
			for section, index in $scope.protocol.sections
						console.log 'section.title: ' + section.title
						console.log "section.machineName: #{section.machineName}, $stateParams.sectionMachineName: #{$stateParams.sectionMachineName}"
						if section.machineName is $stateParams.sectionMachineName
							console.log 'parsed'
							$scope.sectionNum = index + 1
							$scope.section = section
							break

		sectionHelper = new bopProtocolSectionHelper()

		sectionHelper
]
