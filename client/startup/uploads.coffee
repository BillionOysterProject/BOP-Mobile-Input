Meteor.startup ->
	# Cordova needs absolute URL
	# TODO I assume 'upload' is not the right path, fix.
	Uploader.uploadUrl = Meteor.absoluteUrl('upload')
	return