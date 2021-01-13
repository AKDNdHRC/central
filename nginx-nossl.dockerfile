FROM node:12.6.0 as intermediate

COPY ./ ./
RUN files/prebuild/write-version.sh
RUN files/prebuild/build-frontend.sh


FROM nginx:latest
EXPOSE 80
RUN apt-get update; apt-get install -y netcat nginx-extras lua-zlib

COPY files/nginx/odk-nossl.conf.template /etc/nginx/conf.d/default.conf
COPY file/nginx/odk-setup-nossl.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh
COPY --from=intermediate client/dist/ /usr/share/nginx/html
COPY --from=intermediate /tmp/version.txt /usr/share/nginx/html/

ENTRYPOINT [ "/custom-entrypoint.sh" ]