import { serve } from "https://deno.land/std@0.134.0/http/server.ts";

function handler(_req: Request): Response {
    return new Response("Hello, World!");
  }

serve(handler, { port: 8080 });

console.log("Request handled.");
