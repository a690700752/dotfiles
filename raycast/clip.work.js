/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

const COMMON_HEADERS = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*",
};

const ROUTES = [
  {
    path: "/",
    method: "GET",
    handler: handleHome,
  },
  {
    path: "/api/clip",
    method: "GET",
    handler: handleGetClip,
  },
  {
    path: "/api/clip",
    method: "POST",
    handler: handlePostClip,
  },
];

function getHtmlContent(apiKey) {
  return `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clipboard Manager</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 20px auto;
            padding: 0 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        button {
            background-color: #007AFF;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px 0;
            transition: background-color 0.2s;
        }
        button:hover {
            background-color: #0056b3;
        }
        button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        #status {
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Clipboard Manager</h1>
        <button onclick="putClipboard()">Upload Clipboard</button>
        <button onclick="getClipboard()">Download Clipboard</button>
        <div id="status"></div>
    </div>

    <script>
        const API_KEY = "${apiKey}";
        const API_URL = "/api/clip";

        async function putClipboard() {
            const button = document.querySelector('button');
            button.disabled = true;
            
            try {
                const text = await navigator.clipboard.readText();
                const response = await fetch(API_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        key: API_KEY,
                        content: text
                    })
                });
                
                const data = await response.json();
                showStatus(data.success ? 'Clipboard uploaded successfully' : data.error, data.success);
            } catch (error) {
                if (error.name === 'NotAllowedError') {
                    showStatus('Clipboard access denied. Please allow access in your browser settings.', false);
                } else {
                    showStatus('Failed to read or upload clipboard: ' + error.message, false);
                }
            } finally {
                button.disabled = false;
            }
        }

        async function getClipboard() {
            const button = document.querySelector('button:nth-child(2)');
            button.disabled = true;

            try {
                const response = await fetch(API_URL + '?key=' + API_KEY);
                const data = await response.json();
                
                if (data.success) {
                    await navigator.clipboard.writeText(data.content);
                    showStatus('Clipboard downloaded successfully', true);
                } else {
                    showStatus(data.error, false);
                }
            } catch (error) {
                if (error.name === 'NotAllowedError') {
                    showStatus('Clipboard access denied. Please allow access in your browser settings.', false);
                } else {
                    showStatus('Failed to fetch or write clipboard: ' + error.message, false);
                }
            } finally {
                button.disabled = false;
            }
        }

        function showStatus(message, success) {
            const status = document.getElementById('status');
            status.textContent = message;
            status.className = success ? 'success' : 'error';
        }
    </script>
</body>
</html>`;
}

async function handleHome(request, env) {
  try {
    const url = new URL(request.url);
    const key = url.searchParams.get("key");

    if (!key || key !== env.key) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Invalid or missing key",
        }),
        {
          status: 401,
          headers: COMMON_HEADERS,
        }
      );
    }

    return new Response(getHtmlContent(key), {
      headers: {
        "Content-Type": "text/html;charset=UTF-8",
      },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: "Failed to generate page",
      }),
      {
        status: 500,
        headers: COMMON_HEADERS,
      }
    );
  }
}

async function handleGetClip(request, env) {
  try {
    const url = new URL(request.url);
    const key = url.searchParams.get("key");

    if (!key || key !== env.key) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Invalid or missing key",
        }),
        {
          status: 401,
          headers: COMMON_HEADERS,
        }
      );
    }

    const content = await env.CLIPBOARD_STORAGE.get("content");
    return new Response(
      JSON.stringify({
        success: true,
        content: content || "",
      }),
      { headers: COMMON_HEADERS }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: "Failed to fetch content",
      }),
      {
        status: 500,
        headers: COMMON_HEADERS,
      }
    );
  }
}

async function handlePostClip(request, env) {
  try {
    const { key, content } = await request.json();

    if (!key || !content) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Missing required fields",
        }),
        {
          status: 400,
          headers: COMMON_HEADERS,
        }
      );
    }

    if (key !== env.key) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Invalid key",
        }),
        {
          status: 401,
          headers: COMMON_HEADERS,
        }
      );
    }

    await env.CLIPBOARD_STORAGE.put("content", content);

    return new Response(
      JSON.stringify({
        success: true,
        message: "Content stored successfully",
      }),
      { headers: COMMON_HEADERS }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: "Invalid JSON payload",
      }),
      {
        status: 400,
        headers: COMMON_HEADERS,
      }
    );
  }
}

export default {
  async fetch(request, env) {
    // Handle CORS preflight requests
    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST",
          "Access-Control-Allow-Headers": "Content-Type",
        },
      });
    }

    const url = new URL(request.url);

    // Find matching route
    const route = ROUTES.find(
      (r) => r.path === url.pathname && r.method === request.method
    );

    if (route) {
      return route.handler(request, env);
    }

    // If no matching route found, check if path exists with different method
    const pathExists = ROUTES.some((r) => r.path === url.pathname);
    if (pathExists) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Method not allowed",
        }),
        {
          status: 405,
          headers: COMMON_HEADERS,
        }
      );
    }

    // Handle 404 for unknown paths
    return new Response(
      JSON.stringify({
        success: false,
        error: "Not found",
      }),
      {
        status: 404,
        headers: COMMON_HEADERS,
      }
    );
  },
};
