FROM node:14.17.0-alpine

WORKDIR /server

COPY package*.json /server/

RUN npm install --only=prod

COPY . /server/

EXPOSE 3003

CMD [ "npm", "start" ]

# docker build -t towhidk2/nodeapp:v2.0 .
# docker run -p 3003:3003 --name hellov2 towhidk2/nodeapp:v2.0
# docker login
# docker push towhidk2/nodeapp:v2.0
