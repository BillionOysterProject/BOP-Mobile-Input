angular.module('app.example').controller 'ExpeditionOverviewCtrl', ($scope,
                                                                    $stateParams,
                                                                    $meteor
																	) ->
	if !Meteor.userId()
		location.href = '/'
		return

	$scope.expedition = $meteor.object(Expeditions, $stateParams.expeditionID);
