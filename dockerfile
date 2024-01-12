FROM node:19




WORKDIR /usr/src/app

COPY package*.json ./


WORKDIR /usr/src/app
RUN npm install -g nodemon


WORKDIR /usr/src/app
RUN npm install @types/node

WORKDIR /usr/src/app
RUN npm install @sendgrid/mail

WORKDIR /usr/src/app
RUN npm install


COPY . .

CMD [ "npm", "start" ]
