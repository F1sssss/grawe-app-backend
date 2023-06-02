FROM node:19

WORKDIR /usr/src/app

COPY package.json package.json
COPY package-lock.json package-lock.json




RUN npm install

COPY . .

CMD [ "./node_modules/.bin/nodemon", "server.js" ]