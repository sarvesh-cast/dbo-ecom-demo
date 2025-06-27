FROM node:18-alpine

RUN apk update && apk add --no-cache \
    curl \
    jq \
    postgresql15-client \
    && rm -rf /var/cache/apk/*

WORKDIR /app
RUN npm install -g npm@9
COPY package*.json .

# Copy your media.
COPY media ./media

COPY bootstrap .

COPY .env .

# Run npm install.
RUN npm install

# Build assets.
RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "start:debug"]

