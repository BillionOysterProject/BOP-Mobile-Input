awsConfig = null
Assets.getText 'awsConfig.json', (err, result) ->
	awsConfig = JSON.parse(result)

Meteor.methods
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