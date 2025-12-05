# Etapa 1: Build Angular
FROM node:20 AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa 2: Servir com NGINX
FROM nginx:1.25

# Copia nossa config NGINX personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia o Angular buildado (somente a versão browser)
COPY --from=build /app/dist/prj-integrador/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
