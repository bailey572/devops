FROM ubuntu
RUN apt update
RUN apt install -y nginx
COPY index.nginx-debian.html /var/www/html
CMD nginx -g 'daemon off;'
EXPOSE 80
