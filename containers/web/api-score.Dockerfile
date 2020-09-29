FROM oraclelinux:7-slim

ARG release=19
ARG update=8

RUN  yum -y install oracle-release-el7 && \
     yum -y install curl 

RUN  curl -sL https://rpm.nodesource.com/setup_14.x | bash && \
     yum -y install nodejs && \
     rm -rf /var/cache/yum

# Create app directory
WORKDIR /root/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY apis/score/* ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
# COPY . .

EXPOSE 8081
CMD [ "node", "server.js" ]
