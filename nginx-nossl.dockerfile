FROM node:12.6.0 as intermediate

COPY ./ ./
RUN files/prebuild/write-version.sh
RUN files/prebuild/build-frontend.sh


FROM nginx
EXPOSE 80
RUN apt-get update; apt-get install -y netcat nginx-extras lua-zlib

COPY files/nginx/odk-setup-nossl.sh /scripts/odk-setup-nossl.sh
COPY files/nginx/default /etc/nginx/sites-enabled/
COPY files/nginx/inflate_body.lua /usr/share/nginx
COPY files/nginx/odk-nossl.conf.template /usr/share/nginx
COPY --from=intermediate client/dist/ /usr/share/nginx/html
COPY --from=intermediate /tmp/version.txt /usr/share/nginx/html/


ENTRYPOINT [ "/bin/bash", "/scripts/odk-setup-nossl.sh" ]