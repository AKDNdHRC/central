FROM odk-client:latest as intermediate
RUN whoami

FROM nginx:latest
EXPOSE 80
# RUN apt-get update; apt-get install -y netcat nginx-extras lua-zlib

# COPY files/nginx/default /etc/nginx/sites-enabled/default
COPY files/nginx/odk-nossl.conf.template /etc/nginx/conf.d/default.conf
COPY files/nginx/odk-setup-nossl.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh
RUN rm -rf /usr/share/nginx/html/*
COPY --from=intermediate client/dist/ /usr/share/nginx/html
COPY --from=intermediate /tmp/version.txt /usr/share/nginx/html/

ENTRYPOINT [ "/custom-entrypoint.sh" ]