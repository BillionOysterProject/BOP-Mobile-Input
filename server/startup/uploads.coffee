UploadServer.init
	tmpDir: process.env.PWD + '/.uploads/tmp'
	uploadDir: process.env.PWD + '/.uploads/'
	checkCreateDirectories: true
	getDirectory: (fileInfo, formData) ->
		# create a sub-directory in the uploadDir based on the content type (e.g. 'images')
		"#{formData.userID}/images"

	finished: (fileInfo, formFields) ->
		# perform a disk operation
		return
	cacheTime: 100
	mimeTypes:
		'xml': 'application/xml'
		'vcf': 'text/x-vcard'