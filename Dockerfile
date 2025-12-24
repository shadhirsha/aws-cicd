FROM node:18-slim AS builder

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

COPY pnpm-lock.yaml package.json ./

RUN pnpm install

COPY . .

RUN pnpm run build

USER root

FROM amazon/aws-lambda-nodejs

ENV PORT=5000

WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=builder /app/ .

EXPOSE 5000

CMD [ "dist/lambda.handler" ]

