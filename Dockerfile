# Etapa de Producción
FROM nginx:1.25-alpine

LABEL maintainer="Tu Nombre <tu_email@example.com>"

# Eliminar configuración por defecto y asegurar permisos
RUN rm /etc/nginx/conf.d/default.conf && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/app.conf

# Copiar el contenido de la aplicación web
COPY app/ /usr/share/nginx/html

# Exponer el puerto configurado
EXPOSE 8080

# Cambiar a usuario no-root
USER nginx

# Chequeo de salud
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Comando de inicio
CMD ["nginx", "-g", "daemon off;"]