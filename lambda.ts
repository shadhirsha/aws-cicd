const serverless = require("serverless-http");
const lambdaApp = require("./app");

const handler = serverless(lambdaApp);
module.exports.handler = handler;
