awsConfig = null

Assets.getText 'awsConfig.json', (err, result) ->
	awsConfig = JSON.parse(result)
	AWS.config.update(awsConfig)

Meteor.methods
	# this method is used for signing AWS S3 requests that the client makes directly to S3 – those client requests do not use the AWS S3 SDK, FYI
	sign:(filename)->
		bucket = "bop-upload-test"

		fiveMinutesFromNowMS = new Date().getTime() + 1000 * 60 * 5
		expiration = new Date(fiveMinutesFromNowMS).toISOString()

		policy =
			'expiration': expiration
			'conditions': [
				{'bucket': bucket}
				{'key': filename}
				{'acl': 'public-read'}
				['starts-with', '$Content-Type', '']
				['content-length-range', 0, 524288000]
			]
		policyBase64 = new Buffer(JSON.stringify(policy), 'utf8').toString('base64')
#		signature = crypto.createHmac('sha1', awsConfig.secretAccessKey).update(policyBase64).digest('base64')
		signature = CryptoJS.HmacSHA1(policyBase64, awsConfig.secretAccessKey).toString();

		return {
			bucket: bucket
			accessKeyId: awsConfig.accessKeyId
			policy: policyBase64
			signature: signature
		}