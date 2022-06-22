import { opine } from "https://deno.land/x/opine@2.2.0/mod.ts";

const app = opine();

const port = Deno.env.get("PORT") ?? "8080";

// deno-lint-ignore require-await
app.get("/", async (_req, res) => {
  res.send("Hello World");
});

app.get("/health", (_req, res) => {
  // TODO: add a health check
  res.sendStatus(200);
});

app.listen(
  parseInt(port),
  () => console.log(`Server listening on port ${port}.`),
);
