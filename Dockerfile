FROM node:16.15.1-alpine3.16 as builder

# set the working dir for container
WORKDIR /frontend

# Copy Project files
COPY package*.json ./
# Install Dependencies
RUN yarn

COPY . .
#Compile for Production
RUN yarn build

# Nginx Configuration

FROM nginx:1.22
COPY --from=builder /frontend/build /usr/share/nginx/html
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
