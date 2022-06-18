import { opine } from "https://deno.land/x/opine@2.2.0/mod.ts";

const app = opine();

// deno-lint-ignore require-await
app.get("/", async function (req, res) {
  console.log(req);
  
  res.send("Hello World");
});

app.listen(
  8080,
  () => console.log("server has started on http://localhost:8080 🚀"),
);
