const { defineConfig } = require("@vue/cli-service");
const dotenv = require('dotenv-webpack');
module.exports = defineConfig({
  transpileDependencies: true,
  css: {
    extract: {
      filename: "[name].css",
      chunkFilename: "[name].css",
    },
  },
  configureWebpack: {
    output: {
      filename: "[name].js",
      chunkFilename: "[name].js",
    },
    plugins: [
      new dotenv()
    ]
  },
  devServer: {
    proxy: {
      "/fhir": {
        target: "http://localhost:52773",
        changeOrigin: true,
        pathRewrite: {
          "^/fhir": "/fhir",
        },
      },
    },
  },
});
