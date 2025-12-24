FROM node:18-slim AS builder

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

COPY package.json .

RUN pnpm install

COPY pnpm-lock.yaml package.json ./

COPY . .

RUN pnpm run build

USER root

FROM amazon/aws-lambda-nodejs

ENV PORT=5000

COPY --from=builder /app/ ${LAMBDA_TASK_ROOT}
COPY --from=builder /app/node_modules ${LAMBDA_TASK_ROOT}/node_modules
COPY --from=builder /app/package.json ${LAMBDA_TASK_ROOT}
COPY --from=builder /app/pnpm-lock.yaml ${LAMBDA_TASK_ROOT}

EXPOSE 5000

CMD [ "dist/lambda.handler" ]

