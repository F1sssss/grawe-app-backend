FROM node:19

WORKDIR /usr/src/app

#COPY package.json package.json
#COPY package-lock.json package-lock.json

COPY package*.json ./

WORKDIR /usr/src/app
RUN npm install @types/node

WORKDIR /usr/src/app
RUN npm install @sendgrid/mail

WORKDIR /usr/src/app
RUN npm install



COPY . .

CMD [ "./node_modules/.bin/nodemon", "server.js" ]