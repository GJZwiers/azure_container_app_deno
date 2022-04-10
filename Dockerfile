FROM denoland/deno:1.20.5

EXPOSE 8080

WORKDIR /app

USER deno

ADD src/ .

RUN deno cache mod.ts

CMD [ "run", "mod.ts" ]
