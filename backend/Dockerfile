# Use the official Node.js image as the base image
FROM node:23-alpine

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN yarn install

# Copy the application files
COPY backend.js .

# Expose the port
EXPOSE 8090

# Start the application
CMD [ "node", "backend.js" ]
