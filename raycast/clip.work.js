/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

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

    // Common headers for all responses
    const headers = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    if (request.method === "GET") {
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
              headers,
            }
          );
        }

        const content = await env.CLIPBOARD_STORAGE.get("content");
        return new Response(
          JSON.stringify({
            success: true,
            content: content || "",
          }),
          { headers }
        );
      } catch (error) {
        return new Response(
          JSON.stringify({
            success: false,
            error: "Failed to fetch content",
          }),
          {
            status: 500,
            headers,
          }
        );
      }
    }

    if (request.method === "POST") {
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
              headers,
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
              headers,
            }
          );
        }

        // Store the content
        await env.CLIPBOARD_STORAGE.put("content", content);

        return new Response(
          JSON.stringify({
            success: true,
            message: "Content stored successfully",
          }),
          { headers }
        );
      } catch (error) {
        return new Response(
          JSON.stringify({
            success: false,
            error: "Invalid JSON payload",
          }),
          {
            status: 400,
            headers,
          }
        );
      }
    }

    return new Response(
      JSON.stringify({
        success: false,
        error: "Method not allowed",
      }),
      {
        status: 405,
        headers,
      }
    );
  },
};
