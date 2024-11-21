# Usar Debian como imagen base
FROM debian:latest

# Configurar variables de entorno
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar repositorios y herramientas esenciales
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    gnupg \
    build-essential \
    && apt-get clean

# Instalar Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @angular/cli

# Crear directorios de trabajo
WORKDIR /var/www/angular-app

# Construir la aplicación Angular 
COPY . .

# Construir aplicación Angular
RUN npm install && ng build --prod

# Configurar Apache para servir la aplicación
RUN cp -r dist/* /var/www/html/ \
    && chown -R www-data:www-data /var/www/html

# Exponer el puerto 80
EXPOSE 80

# Comando de inicio de Apache
CMD ["apachectl", "-D", "FOREGROUND"]
