import { opine } from "https://deno.land/x/opine@2.2.0/mod.ts";

const app = opine();

// deno-lint-ignore require-await
app.get("/", async (req, res) => {
  res.send("Hello World");
});

app.get("/point", (req, res) => {
  const time = performance.timeOrigin + performance.now();
  res.send(time);
});

app.get("/health", (req, res) => {
  res.sendStatus(200);
});

app.listen(
  8080,
  () => console.log("server has started on http://localhost:8080 🚀"),
);
