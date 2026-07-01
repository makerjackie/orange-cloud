const APP_CALLBACK = "onecfcloud://oauth/callback";

export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname !== "/oauth/callback") {
      return new Response("OneCFCloud OAuth callback", {
        headers: { "content-type": "text/plain; charset=utf-8" },
      });
    }

    const callback = new URL(APP_CALLBACK);
    for (const key of ["code", "state", "error", "error_description"]) {
      const value = url.searchParams.get(key);
      if (value) callback.searchParams.set(key, value);
    }

    if (!callback.searchParams.has("code") && !callback.searchParams.has("error")) {
      callback.searchParams.set("error", "invalid_response");
    }

    return Response.redirect(callback.toString(), 302);
  },
};
