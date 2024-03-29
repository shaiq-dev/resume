import { S3Client, ListObjectsCommand, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

export const handler = async (event, context) => {
  try {

    const s3 = new S3Client();
    const bucket = process.env.BUCKET

    const data = await s3.send(new ListObjectsCommand({
      Bucket: bucket,
      Prefix: "resume/"
    }))

    // Sort the contents based on date
    const contents = data.Contents.sort((a, b) => {
      return a.LastModified.getTime() > b.LastModified.getTime() ? -1 : 1
    })

    const artifact = contents[0]
    const version = artifact.Key.split('-')[1].slice(0, -4)

    const url = await getSignedUrl(s3, new GetObjectCommand({
      Bucket: bucket,
      Key: artifact.Key,
      Expires: 600,
    }));

    return {
      statusCode: 302,
      headers: {
        "Location": url,
        "Access-Control-Allow-Origin": "*", 
        "Access-Control-Allow-Credentials": true,
      },
      body: JSON.stringify({
        status: 'OK',
        version,
        url,
      }),
    }
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        status: 'ERROR',
      }),
    }
  }
}
