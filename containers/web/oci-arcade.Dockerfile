FROM node:latest
LABEL "version"="0.0.1" \
      "description"="OCI Arcade Demo"

EXPOSE 8080

COPY games/pacman /root/games/pacman
COPY games/racer /root/games/racer-rc
COPY games/spaceinvaders /root/games/spaceinvaders
COPY games/package.json /root/games

WORKDIR /root/games

RUN npm install

CMD ["npm", "run", "serve"]
