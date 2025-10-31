# Build stage
FROM node:20-alpine AS build

# ✅ Apply security patches and ensure pcre2 is fixed
RUN apk --no-cache upgrade \
 && apk add --no-cache 'pcre2>=10.46-r0'

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# ✅ Apply security patches to Nginx image as well
RUN apk --no-cache upgrade \
 && apk add --no-cache 'pcre2>=10.46-r0'

COPY --from=build /app/dist /usr/share/nginx/html

# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
