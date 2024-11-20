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
  // Common headers for all responses
  get commonHeaders() {
    return {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };
  },

  // Route definitions
  get routes() {
    return [
      {
        path: "/api/clip",
        method: "GET",
        handler: this.handleGetClip.bind(this),
      },
      {
        path: "/api/clip",
        method: "POST",
        handler: this.handlePostClip.bind(this),
      },
    ];
  },

  async handleGetClip(request, env) {
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
            headers: this.commonHeaders,
          }
        );
      }

      const content = await env.CLIPBOARD_STORAGE.get("content");
      return new Response(
        JSON.stringify({
          success: true,
          content: content || "",
        }),
        { headers: this.commonHeaders }
      );
    } catch (error) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Failed to fetch content",
        }),
        {
          status: 500,
          headers: this.commonHeaders,
        }
      );
    }
  },

  async handlePostClip(request, env) {
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
            headers: this.commonHeaders,
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
            headers: this.commonHeaders,
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
        { headers: this.commonHeaders }
      );
    } catch (error) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Invalid JSON payload",
        }),
        {
          status: 400,
          headers: this.commonHeaders,
        }
      );
    }
  },

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
    const route = this.routes.find(
      (r) => r.path === url.pathname && r.method === request.method
    );

    if (route) {
      return route.handler(request, env);
    }

    // If no matching route found, check if path exists with different method
    const pathExists = this.routes.some((r) => r.path === url.pathname);
    if (pathExists) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Method not allowed",
        }),
        {
          status: 405,
          headers: this.commonHeaders,
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
        headers: this.commonHeaders,
      }
    );
  },
};
