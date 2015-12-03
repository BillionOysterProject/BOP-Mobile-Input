crypto = Npm.require('crypto')
Future = Npm.require('fibers/future');

awsConfig = null

Assets.getText 'awsConfig.json', (err, result) ->
	awsConfig = JSON.parse(result) #keep this global var around for use in signing client-side requests (See sign() method below)
	AWS.config.update(awsConfig)

awsBucket = "bop-upload-test"
#awsBucket = "bop-images"


temporaryFiles = new FileCollection('temporaryFiles',
	resumable: false
	http: [
		{
			method: 'get'
			path: '/:_id'
			lookup: (params) ->
				# uses express style url params
				{ _id: params._id }
				# a query mapping url to myFiles

		}
		{
			method: 'post'
			path: '/:_id'
			lookup: (params) ->
				{ _id: params._id }

		}
	])

temporaryFiles.allow
	insert: (userId, file) ->
		true
	remove: (userId, file) ->
		true
	read: (userId, file) ->
		true
	write: (userId, file, fields) ->
		true

convertLabel = (value) ->
	if typeof value isnt 'object'
		if !isNaN(value)
			return Number(value) + 1
		else
			return value
	else
		return value

convertData = (value) ->
	if typeof value == 'string' and (value == '0' or value == '1')
		return 'No' if value == '0'
		return 'Yes' if value == '1'
	else
		return value


Meteor.methods

	downloadExcelFile: (expeditionId) ->

		Future = Npm.require('fibers/future')
		futureResponse = new Future
		excel = new Excel('xlsx')
		workbook = excel.createWorkbook()

		sectionResults = {}
		expSections = Expeditions.findOne({'_id' : expeditionId}).sections
		for prop of expSections
			#console.log prop + " = " + expSections[prop] if expSections.hasOwnProperty(prop)
			sectionResults[prop] = ProtocolSection.findOne({'_id' : expSections[prop]}) if expSections.hasOwnProperty(prop)

		for section of sectionResults
			if sectionResults.hasOwnProperty(section)
				worksheet = excel.createWorksheet()
				#worksheet.writeToCell 0, 0, ''
				#worksheet.mergeCells 0, 0, 0, 1
				worksheet.setColumnProperties [
					{ wch: 20 }
					{ wch: 30 }
					{ wch: 30 }
				]
				# Example : writing multple rows to file
				row = 0

				if sectionResults[section]['machineName'] is 'oysterGrowth'
					worksheet.writeToCell row, 0, 'Shell #'
					worksheet.writeToCell row, 1, 'Oyster Measurements (mm)'
					row++

				if sectionResults[section]['machineName'] is 'mobileOrganisms'
					worksheet.writeToCell row, 0, 'Common Name'
					worksheet.writeToCell row, 1, 'Count'
					row++

				if sectionResults[section]['machineName'] is 'sessileOrganisms'
					worksheet.writeToCell row, 0, 'Tile #'
					worksheet.writeToCell row, 1, 'Dominant'
					worksheet.writeToCell row, 2, 'Co-dominant'
					row++

				for prop of sectionResults[section]
					if sectionResults[section].hasOwnProperty(prop)
						machineName = sectionResults[section][prop] if prop is 'machineName'

						if prop isnt '_id' and prop isnt 'owner' and prop isnt 'machineName'
							#console.log prop + " :: " + sectionResults[section][prop]
							if typeof sectionResults[section][prop] isnt 'object'
								worksheet.writeToCell row, 0, prop
								worksheet.writeToCell row, 1, convertData(sectionResults[section][prop])
								row++
							else
								for subprop of sectionResults[section][prop]
									if machineName is 'mobileOrganisms'
										itemLabel = Organisms.findOne({'_id' : subprop}).common
									else if machineName is 'oysterGrowth' or machineName is 'sessileOrganisms' or machineName is 'waterQuality'
										itemLabel = subprop
									else
										itemLabel = prop

									# for arrays with value and label pairs, like the land section
									if subprop == 'value'
										continue

									if machineName isnt 'oysterGrowth' or !isNaN(itemLabel)
										worksheet.writeToCell row, 0, convertLabel(itemLabel)
										skipValue = false
									else
										skipValue = true

									if machineName is 'sessileOrganisms'
										for cells of sectionResults[section][prop][subprop]
											for cell of sectionResults[section][prop][subprop][cells]
												col = 1
												for item of sectionResults[section][prop][subprop][cells][cell]
													if sectionResults[section][prop][subprop][cells][cell][item] isnt null
														worksheet.writeToCell row, col, Organisms.findOne({'_id' : sectionResults[section][prop][subprop][cells][cell][item]}).common
														col++
												row++

									else if machineName is 'oysterGrowth' and typeof sectionResults[section][prop][subprop] is 'object'
										col=1
										for shells of sectionResults[section][prop][subprop]
											if typeof sectionResults[section][prop][subprop][shells] is 'object'
												for shell of sectionResults[section][prop][subprop][shells]
													for oyster of sectionResults[section][prop][subprop][shells][shell]
														if oyster is 'sizeMM' and !isNaN(sectionResults[section][prop][subprop][shells][shell][oyster])
															row++
															worksheet.writeToCell row, col, sectionResults[section][prop][subprop][shells][shell][oyster]
										row++

									else if machineName is 'waterQuality'
										for subsubprop of sectionResults[section][prop][subprop]
											for methods of sectionResults[section][prop][subprop][subsubprop]
												for samples of sectionResults[section][prop][subprop][subsubprop][methods]
													for sample of sectionResults[section][prop][subprop][subsubprop][methods][samples]
														worksheet.writeToCell row, 1, sectionResults[section][prop][subprop][subsubprop][methods][samples][sample]
														row++

									else if typeof sectionResults[section][prop][subprop] is 'object'
										for subsubprop of sectionResults[section][prop][subprop]
											worksheet.writeToCell row, 1, convertData(sectionResults[section][prop][subprop][subsubprop])
											row++

									else if skipValue = false
										worksheet.writeToCell row, 1, convertData(sectionResults[section][prop][subprop])
										row++

				workbook.addSheet machineName, worksheet



		mkdirp 'tmp', Meteor.bindEnvironment((err) ->
			if err
				console.log 'Error creating tmp dir', err
				futureResponse.throw err
			else
				uuid = UUID.v4()
				filePath = './tmp/' + uuid
				#console.log filePath
				workbook.writeToFile filePath
				temporaryFiles.importFile filePath, {
					filename: uuid
					contentType: 'application/octet-stream'
				}, (err, file) ->
					if err
						futureResponse.throw err
					else
						futureResponse.return '/gridfs/temporaryFiles/' + file._id
					return
			return
		)
		futureResponse.wait()


	dataFromApi: (url) ->
		@unblock()
		return Meteor.http.call 'GET', url

	# this method is used for signing AWS S3 requests that the client makes directly to S3 – those client requests do not use the AWS S3 SDK, FYI
	sign:(filename)->

		fiveMinutesFromNowMS = new Date().getTime() + 1000 * 60 * 5
		expiration = new Date(fiveMinutesFromNowMS).toISOString()

		policy =
			'expiration': expiration
			'conditions': [
				{'bucket': awsBucket}
				{'key': filename}
#				{'acl': 'public-read'}
				['starts-with', '$Content-Type', '']
				['content-length-range', 0, 524288000]
			]
		policyBase64 = new Buffer(JSON.stringify(policy), 'utf8').toString('base64')
		signature = crypto.createHmac('sha1', awsConfig.secretAccessKey).update(policyBase64).digest('base64')
#		signature = CryptoJS.HmacSHA1(policyBase64, awsConfig.secretAccessKey).toString(CryptoJS.enc.Base64);
		console.log 'Signature using npm crypto: ' + signature

		return {
			bucket: awsBucket
			accessKeyId: awsConfig.accessKeyId
			policy: policyBase64
			signature: signature
		}

	# using Future class here like a promise to make Meteor methods which are normally synchronous, asynchronous – or at least blocking until inner async call has completed.
	# I'm not exactly sure how they work just that they seemed to do the tricks. Currently documentation for this is sparse and fragmented online.
	# ref on how to do async methods in Meteor: https://gist.github.com/possibilities/3443021
	deleteRemoteImage:(id)->
		future = new Future()

		# S3 Docs http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Config.html#constructor-property
		s3 = new AWS.S3()

		params =
			Bucket:awsBucket
			Key:id + '.jpg'

		s3.deleteObject params, (err, data)->
			if err
				future.throw err
			else
				future.return data

		return future.wait()
