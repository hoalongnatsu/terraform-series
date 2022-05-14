exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  // Look for cookie
  if (headers.cookie) {
    for (let i = 0; i < headers.cookie.length; i++) {
      if (headers.cookie[i].value.indexOf("X-Redirect-Flag") >= 0) {
        console.log("Source cookie found. Forwarding request as-is");
        // Forward request as-is
        callback(null, request);
        return;
      }
    }
  }

  // Add Source cookie
  const cookie = Math.random() < 0.6 ? "X-Redirect-Flag=Pro" : "X-Redirect-Flag=Pre-Pro";
  headers.cookie = headers.cookie || [];
  headers.cookie.push({ key: "Cookie", value: cookie });

  // Forwarding request
  callback(null, request);
};
