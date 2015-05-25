fs = Npm.require('fs')

uploadDir = process.env.PWD + '/.uploads/'

UploadServer.init
	tmpDir: process.env.PWD + '/.uploads/tmp'
	uploadDir: uploadDir
	checkCreateDirectories: true
#	imageTypes: /.(gif|jpe?g|png)$/i
#	imageVersions:
#		thumbnailBig:
#			width: 400
#			height: 300
#		thumbnailSmall:
#			width: 200
#			height: 100
	cacheTime: 100
	mimeTypes:
#		'xml': 'application/xml'
#		'vcf': 'text/x-vcard'
#		'jpg': 'image/jpeg'
		'jpg': 'image/jpeg'
	getDirectory: (fileInfo, formData) ->
		# create a sub-directory in the uploadDir based on the content type (e.g. 'images')
		"#{formData.userID}/images"

	finished: (fileInfo, formFields) ->
		# perform a disk operation

		console.log JSON.stringify fileInfo

		Images.insert {ready:false}, (err, id)->
			console.log 'inserted image ' + id
			moveFileToS3(id, fileInfo)

		return


Assets.getText 'awsConfig.json', (err, result) ->
	AWS.config.update(JSON.parse(result))

moveFileToS3 = (id, fileInfo)->
	fileMimeType = 'image/jpeg'

#	Assets.getBinary fileInfo.path, (err, result) ->
#		s3 = new (AWS.S3)
#		filename = id + ".jpg"
#		params =
#			Bucket: 'bop-images'
#			Key: filename
#			ContentType: fileMimeType
##			Body: new Buffer(result)
#			Body: result
##			ACL: 'public-read'
#
#		s3.putObject params, (err, data) ->
#			if err
#				console.log err
#			else
#				console.log 'Successfully uploaded data to bop-images/' + filename
#				UploadServer.delete(fileInfo.path)
#			return
	console.log 'file path: ' + uploadDir + fileInfo.path
	fs.readFile uploadDir + fileInfo.path, Meteor.bindEnvironment((err, data)->
		throw err if (err)

#	Assets.getBinary fileInfo.path, (err, data) ->
		s3 = new (AWS.S3)
		filename = id + ".jpg"
		params =
			Bucket: 'bop-images'
			Key: filename
			ContentType: fileMimeType
			Body: data
#			ACL: 'public-read'

		s3.putObject params, Meteor.bindEnvironment((err, data) ->
			if err
				console.log err
			else
				console.log 'Successfully uploaded data to bop-images/' + filename
				Images.update(_id:id, {$set:{ready:true}})
				UploadServer.delete(fileInfo.path)
			return
		)
	)

