FROM node:19

# Install Python
RUN apt-get update && apt-get install -y python3 python3-pip

# Install Superset dependencies
RUN pip3 install apache-superset

# Install Superset
RUN pip3 install superset

# Initialize the database
RUN pip3 install pymssql


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
