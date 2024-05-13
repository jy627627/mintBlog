#!/bin/bash
# STAGE 1 e

FROM node:12-alpine AS build
WORKDIR /app
COPY package.json ./
RUN yarn config set registry https://registry.npm.taobao.org/
RUN yarn  install
COPY . /app
RUN yarn build

# 设置基础镜像
# FROM nginx:stable-alpine
FROM amd64/nginx
COPY --from=build /app/dist /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 443

RUN echo 'docker image success !'
