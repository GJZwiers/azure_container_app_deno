FROM denoland/deno:1.23.0

EXPOSE 8080

WORKDIR /app

USER deno

ADD src/ .

RUN deno cache mod.ts

CMD [ "run", "--allow-net", "--allow-read=./" ,"mod.ts" ]
