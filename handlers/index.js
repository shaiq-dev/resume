const AWS = require('aws-sdk')

const handler = async (event, context) => {
  try {

    const allowedOrigins = process.env.ALLOWED_ORIGINS.split(",") || []
    const origin = event.headers.Origin || event.headers.origin;
    
    if (!allowedOrigins.includes(origin)) {
      return {
        statusCode: 401,
        body: JSON.stringify({
          message: 'Access Denied',
        }),
      }
    }

    const s3 = new AWS.S3()
    const bucket = process.env.BUCKET

    const params = {
      Bucket: bucket,
      Prefix: "resumes/"
    }

    const data = await s3.listObjects(params).promise()

    // Sort the contents based on date
    const contents = data.Contents.sort((a, b) => {
      const dA = a.LastModified.getTime()
      const dB = b.LastModified.getTime()
      return dA > dB ? -1 : 1
    })

    const artifact = contents[0]
    const version = artifact.Key.split('-')[1].slice(0, -4)
    const file = s3.getSignedUrl('getObject', {
      Bucket: bucket,
      Key: artifact.Key,
      Expires: 60 * 10,
    })

    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": origin, 
        "Access-Control-Allow-Credentials": true,
      },
      body: JSON.stringify({
        message: 'SUCCESS',
        version,
        artifact: file,
      }),
    }
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'ERROR',
      }),
    }
  }
}

exports.handler = handler
