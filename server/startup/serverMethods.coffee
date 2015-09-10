crypto = Npm.require('crypto')
Future = Npm.require('fibers/future');

awsConfig = null

Assets.getText 'awsConfig.json', (err, result) ->
	awsConfig = JSON.parse(result) #keep this global var around for use in signing client-side requests (See sign() method below)
	AWS.config.update(awsConfig)

awsBucket = "bop-upload-test"
#awsBucket = "bop-images"

Meteor.methods

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
