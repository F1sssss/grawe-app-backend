FROM node:19-alpine

WORKDIR /usr/src/app


COPY package*.json ./


RUN npm install -g nodemon && \
    npm install


CMD [ "npm", "start" ]