FROM denoland/deno:alpine

EXPOSE 8080

WORKDIR /app

USER deno

ADD src/ .

RUN deno cache mod.ts

CMD [ "run", "--allow-net", "--allow-env=PORT", "--allow-read=./" , "mod.ts" ]
