import { serve } from "https://deno.land/std@0.143.0/http/server.ts";
import * as log from "https://deno.land/std@0.143.0/log/mod.ts";

function handler(_req: Request): Response {
  log.info("Received request.");
  return new Response("Hello, World!");
}

serve(handler, { port: 8080 });

log.info("Server running on port 8080.");
