import { shortenUrl } from "../services/urlShortenerService.js";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

function response(statusCode, body) {
  return {
    statusCode,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    body: JSON.stringify(body),
  };
}

function errorResponse(statusCode, code, message) {
  return response(statusCode, { error: { code, message } });
}

function log(level, message, requestId, extra = {}) {
  console.log(
    JSON.stringify({
      level,
      message,
      requestId,
      timestamp: new Date().toISOString(),
      ...extra,
    }),
  );
}

export async function handler(event, context) {
  const requestId = context.awsRequestId;

  if (event.httpMethod === "OPTIONS") {
    return { statusCode: 200, headers: CORS_HEADERS, body: "" };
  }

  let url;
  try {
    const body =
      typeof event.body === "string" ? JSON.parse(event.body) : event.body;
    url = body?.url;
  } catch {
    return errorResponse(400, "INVALID_URL", "The provided URL is invalid");
  }

  if (!url) {
    return errorResponse(400, "INVALID_URL", "The provided URL is invalid");
  }

  try {
    const code = await shortenUrl(url);
    const shortUrl = `https://${process.env.BASE_DOMAIN}/${code}`;
    log("INFO", "URL shortened", requestId, { code });
    return response(200, { shortUrl, code });
  } catch (err) {
    if (err.errorCode === "INVALID_URL") {
      log("WARN", "URL validation failed", requestId, {
        errorCode: err.errorCode,
        errorMessage: err.message,
      });
      return errorResponse(400, "INVALID_URL", "The provided URL is invalid");
    }
    log("ERROR", "Unexpected error during URL shortening", requestId, {
      errorCode: err.errorCode ?? "UNKNOWN",
      errorMessage: err.message,
    });
    return errorResponse(500, "INTERNAL_ERROR", "Unexpected error occurred");
  }
}
