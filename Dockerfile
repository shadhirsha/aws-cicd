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

COPY --from=builder /app/ ${LAMBDA_TASK_ROOT}

EXPOSE 5000

CMD [ "dist/lambda.handler" ]

