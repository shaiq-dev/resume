export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url)

    // Handle CORS preflight requests
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        status: 204,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, If-None-Match',
          'Access-Control-Max-Age': '86400',
        },
      })
    }

    if (url.pathname === '/' || url.pathname === '') {
      return handleResumeRequest(env, request)
    }

    return new Response('Not Found', { status: 404 })
  },
}

const handleResumeRequest = async (env, request) => {
  try {
    const obj = await env.RESUME_BUCKET.get('latest-resume.pdf')

    if (!obj) {
      return new Response('Resume not found', {
        status: 404,
        headers: CORS_HEADERS,
      })
    }

    // Check if client sent If-None-Match header for caching
    const etag = obj.etag
    const clientEtag = request.headers.get('If-None-Match')

    if (clientEtag === etag) {
      return new Response(null, {
        status: 304,
        headers: CORS_HEADERS,
      })
    }

    const headers = {
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'inline;',
      'Cache-Control': 'public, max-age=3600, must-revalidate',
      ETag: etag,
      'Last-Modified': object.uploaded.toUTCString(),
      ...CORS_HEADERS,
    }

    return new Response(object.body, { headers })
  } catch (error) {
    console.error('Error retrieving resume:', error)

    return new Response('Internal Server Error', {
      status: 500,
      headers: CORS_HEADERS,
    })
  }
}

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, If-None-Match',
}
